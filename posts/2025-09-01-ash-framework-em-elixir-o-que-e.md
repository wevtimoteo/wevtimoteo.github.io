---
title: Ash Framework em Elixir: o que é e por que ele muda a forma de modelar aplicações
date: 2025-09-01 09:00:00
tags: ash, ashframework, elixir, phoenix, ptbr
---

Se você já trabalha com [Elixir](https://elixir-lang.org/), [Phoenix](https://phoenixframework.org/) e [Ecto](https://hexdocs.pm/ecto/Ecto.html), provavelmente conhece bem o caminho tradicional: schemas representam dados, changesets validam entrada, contexts agrupam operações, controllers ou LiveViews chamam essas operações, workers executam processos assíncronos e alguma camada de API expõe parte disso para fora.

Esse modelo funciona. Phoenix Contexts continuam sendo uma abordagem simples e explícita para uma grande quantidade de aplicações.

O problema começa quando o domínio cresce.

Uma regra que nasceu em um changeset aparece depois em uma LiveView. Uma autorização que estava em um controller passa a ser repetida em uma API. Uma função do context vira "a forma oficial" de criar um registro, mas outro worker chama o schema direto porque precisava de uma variação pequena. Aos poucos, a aplicação ainda funciona, mas o contrato real do domínio fica espalhado.

É nesse espaço que o [Ash Framework](https://ash-hq.org/) fica interessante.

## Ash não é só mais uma camada em cima do banco

Uma forma curta de explicar Ash é: ele é um framework declarativo para modelar o domínio de uma aplicação Elixir.

Isso quer dizer que, em vez de definir apenas tabelas, schemas e funções soltas, você descreve recursos, ações, validações, relacionamentos, autorização e integrações em torno de conceitos do seu domínio.

Um `Customer`, um `Product`, um `Invoice` ou um `Ticket` deixam de ser apenas structs persistidas em algum lugar. Eles passam a ser recursos com operações nomeadas:

```elixir
create :register
update :archive
read :active
destroy :remove
```

O ponto não é trocar todos os nomes por DSL. É tornar explícito quais operações existem e quais regras cada operação precisa respeitar.

Na documentação oficial, Ash descreve Resources e Actions como centrais. Um [Resource](https://hexdocs.pm/ash/resources.html) modela um conceito do domínio. Uma [Action](https://hexdocs.pm/ash/actions.html) descreve uma forma permitida de interagir com esse recurso. A partir disso, o ecossistema entende melhor o que a aplicação faz.

Essa é a mudança mental importante: Ash tenta modelar comportamento, não apenas armazenamento.

## O problema das regras espalhadas

Em uma aplicação Phoenix comum, é bem natural começar com algo assim:

```elixir
def create_product(attrs, current_user) do
  with :ok <- authorize_product_creation(current_user),
       {:ok, attrs} <- normalize_product_attrs(attrs),
       %Product{} = product <- %Product{},
       changeset <- Product.changeset(product, attrs),
       {:ok, product} <- Repo.insert(changeset) do
    {:ok, product}
  end
end
```

Isso é legível e direto. O problema é que a aplicação raramente tem apenas uma forma de criar produto. Talvez exista criação via painel administrativo, importação via CSV, sincronização externa, endpoint público, seed interno e job de migração.

Cada caminho pode ter pequenas diferenças: campos aceitos, validações, permissões, efeitos colaterais, filtros por tenant e regras de auditoria.

Com o tempo, a pergunta deixa de ser "onde está a função que cria produto?" e vira "qual desses caminhos é o caminho certo para criar produto neste caso?".

Ash tenta reduzir esse tipo de ambiguidade colocando as operações no próprio contrato do recurso. Em vez de uma função genérica que recebe qualquer coisa, você pode ter ações com nomes de domínio:

```elixir
create :create_from_admin
create :import_from_csv
update :publish
update :disable
read :visible_to_customer
```

Cada ação pode aceitar campos específicos, aplicar validações, preparar queries, executar mudanças e respeitar políticas de autorização.

O ganho não é só reduzir linhas de código. É diminuir a quantidade de lugares onde uma regra crítica pode se esconder.

## Resources como contrato do domínio

Em Ash, um Resource concentra boa parte do contrato de um conceito.

Um exemplo simplificado de `Product`:

```elixir
defmodule MyApp.Catalog.Product do
  use Ash.Resource,
    domain: MyApp.Catalog

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :status, :atom do
      constraints one_of: [:draft, :active, :archived]
      default :draft
      public? true
    end
  end

  actions do
    defaults [
      :read,
      :destroy,
      create: [:name],
      update: [:name, :status]
    ]
  end
end
```

Esse exemplo não tenta cobrir uma aplicação real inteira. Ele só mostra a ideia: atributos e ações aparecem juntos. Se amanhã existir uma ação `:archive`, ela pode ser uma operação nomeada, com regras próprias, e não apenas "um update que muda status em algum lugar".

Também existe o conceito de [Domain](https://hexdocs.pm/ash/domains.html), que agrupa recursos relacionados. Se você conhece Phoenix Contexts, dá para pensar no Domain como uma forma Ash de organizar uma área da aplicação, como `Catalog`, `Accounts`, `Billing` ou `Support`.

A diferença é que o Domain não é apenas um módulo com funções públicas. Ele registra recursos e pode expor uma interface de código para as ações do domínio. Isso ajuda a manter uma fronteira mais clara entre "o que o domínio permite" e "como a interface web chama isso".

## Autorização como parte do modelo

Autorização costuma ser uma das primeiras regras a se espalhar.

Um `if current_user.admin?` no controller parece inofensivo. Depois aparece uma variação em uma LiveView. Depois um worker precisa ignorar a regra. Depois uma API pública precisa aplicar uma versão diferente. Em algum momento, entender quem pode fazer o que exige buscar por condicionais em vários arquivos.

Ash oferece [Policies](https://hexdocs.pm/ash/policies.html) para declarar regras de autorização próximas do domínio. A ideia é que uma ação não seja apenas "executável", mas executável por alguém, em determinado contexto, sob determinadas condições.

Conceitualmente, regras como "administradores podem tudo", "usuários só leem os próprios registros" ou "membros só alteram dados da própria organização" podem viver no modelo declarativo.

Isso não elimina a necessidade de pensar em segurança. Pelo contrário: obriga a pensar nela em um lugar mais central.

## Ash, Phoenix e APIs

Ash não substitui Phoenix. Essa distinção é importante.

Phoenix continua sendo excelente para HTTP, routing, controllers, channels, LiveView, componentes e toda a camada de interface. Ash atua mais perto da aplicação e do domínio. Ele define o que existe, o que pode ser feito e quais regras precisam ser respeitadas.

Esse contrato pode ser consumido por uma LiveView, por um controller, por um job, por uma API JSON, por GraphQL ou por código interno.

Em vez de cada interface reconstruir validação, autorização e filtros, elas podem chamar ações do domínio. Extensões do ecossistema Ash também usam essa informação para integrar formulários Phoenix, JSON:API, GraphQL e autenticação.

Esse é um ponto forte, mas também um ponto que pede cuidado. Quando uma ferramenta consegue gerar muita coisa a partir de uma DSL, é fácil cair na tentação de aceitar tudo sem entender. Ash não remove a necessidade de desenho de domínio. Ele torna esse desenho mais explícito.

## Quando a abordagem começa a fazer sentido

Eu não olharia para Ash como algo obrigatório em todo projeto Elixir.

Para uma aplicação pequena, com poucas tabelas e regras simples, Phoenix Contexts com Ecto podem ser mais diretos. Você cria schemas, changesets, funções bem nomeadas e segue a vida.

Ash começa a ficar mais atrativo quando aparecem sinais como:

- múltiplas interfaces consumindo o mesmo domínio;
- regras de autorização crescendo;
- operações com nomes de negócio, não apenas CRUD;
- multi-tenancy;
- necessidade de expor API além da interface web;
- muita repetição em validations, filtros e changesets;
- contexts ficando grandes demais;
- dificuldade de saber qual função representa o fluxo correto.

Nesses casos, a pergunta não é "Ash escreve menos código?". Às vezes sim, às vezes não. A pergunta melhor é: "o contrato do domínio está claro o suficiente para continuar evoluindo?".

## O custo da escolha

Ash tem curva de aprendizado. Você precisa entender a DSL, o ciclo de vida das actions, a diferença entre changes e validations, como queries são preparadas, como policies são avaliadas, como domains organizam recursos e como as extensões se encaixam.

Para quem usa Phoenix e Ecto diretamente, isso pode parecer uma mudança grande. E é. O código deixa de ser apenas um conjunto de funções Elixir explícitas e passa a ter uma camada declarativa forte. Isso traz poder, mas também exige leitura de documentação, familiaridade com convenções e disciplina para não transformar o recurso em um arquivo difícil de navegar.

O ponto positivo é que Ash não tenta ser um mundo isolado. Ele conversa com o ecossistema Elixir: pode usar Ecto por baixo via AshPostgres, integrar com Phoenix, trabalhar com Oban, expor APIs e ainda permitir escapes quando uma parte do sistema precisa de algo mais manual.

Para mim, essa é a forma mais saudável de avaliar Ash: não como mágica, mas como uma tentativa de dar mais estrutura para a camada de aplicação em Elixir.

## Concluindo

Ash muda a forma de modelar aplicações porque desloca o centro do código.

Em vez de espalhar regras entre contexts, controllers, LiveViews, workers e APIs, ele incentiva a declarar recursos e ações como contrato do domínio.

Isso não torna Ecto obsoleto, não torna Phoenix menos importante e não elimina decisões difíceis. Mas oferece uma alternativa interessante para aplicações onde o domínio começou a ficar maior do que o padrão tradicional estava conseguindo expressar com clareza.

No [próximo post da série](/posts/2025-09-08-ash-vs-ecto-contexts-quando-usar.html), vou comparar Ash com Phoenix Contexts. Depois, sigo com um primeiro Resource e entro aos poucos em actions, policies, LiveView, multi-tenancy, autenticação, calculations e aggregates.
