---
title: Ash vs Ecto Contexts: quando usar Ash em uma aplicação Phoenix
date: 2025-09-08 09:00:00
tags: ash, ashframework, elixir, phoenix, ecto, ptbr
---

Quando alguém começa a olhar para [Ash Framework](https://ash-hq.org/) vindo de [Phoenix](https://phoenixframework.org/) e [Ecto](https://hexdocs.pm/ecto/Ecto.html), uma pergunta aparece rápido: "isso substitui Phoenix Contexts?"

A resposta curta é: não exatamente.

Ash não é um substituto burro de Ecto, nem uma tentativa de apagar o padrão de contexts do Phoenix. Ele é uma camada declarativa de domínio. Isso muda bastante a comparação, porque Ecto e Ash não estão tentando resolver o mesmo problema no mesmo nível.

Ecto é excelente para falar com dados. Ele modela schemas, changesets, queries, migrations e integração com bancos relacionais. Phoenix Contexts são uma convenção para organizar uma área da aplicação e expor funções públicas para o restante do sistema.

Ash tenta responder outra pergunta: quais recursos existem no meu domínio, quais ações são permitidas, quais regras cada ação precisa respeitar e como essas regras podem ser reaproveitadas por diferentes interfaces?

## O modelo tradicional com Phoenix Contexts

Em Phoenix, um contexto como `Catalog` costuma agrupar funções relacionadas:

```elixir
defmodule MyApp.Catalog do
  alias MyApp.Repo
  alias MyApp.Catalog.Product

  def list_products do
    Repo.all(Product)
  end

  def create_product(attrs) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end
end
```

Esse estilo é direto. Você vê funções Elixir comuns, decide o que é público, chama `Repo`, usa changesets e escreve queries quando precisa.

Para muita aplicação, isso é o suficiente. Se o domínio é pequeno, se existem poucas regras de negócio e se quase tudo é chamado pela mesma interface web, não existe motivo forte para adicionar uma camada nova. Contexts bem escritos continuam sendo uma ótima base.

O problema aparece quando o contexto vira um arquivo grande demais, com muitas funções parecidas e pequenas diferenças de regra. `create_product/1`, `create_product_from_admin/2`, `import_product/2`, `sync_product/1`, `publish_product/2`, `archive_product/2`. Depois surgem versões para API, LiveView, worker e integração externa.

Nesse ponto, o context ainda funciona, mas o contrato do domínio começa a depender muito da disciplina da equipe.

## Onde Ecto brilha

Eu continuaria usando Ecto puro, com Phoenix Contexts, quando a aplicação tem características como:

- poucas entidades;
- regras de autorização simples;
- operações majoritariamente CRUD;
- uma ou duas interfaces consumindo o domínio;
- baixa necessidade de gerar APIs ou formulários a partir do modelo;
- equipe confortável com SQL e changesets explícitos;
- domínio que muda pouco.

Nesses casos, Ash pode parecer pesado. Não porque seja ruim, mas porque você passa a aprender uma DSL, entender actions, domains, policies, resources, preparations e extensions para resolver algo que talvez já estivesse simples.

O custo de uma abstração só vale quando ela compra algo real.

Com Ecto, também existe menos indireção. Uma query está ali. Um changeset está ali. Uma função pública chama outra função. Para investigar um bug, você segue código Elixir normal. Em aplicações pequenas, essa clareza é difícil de bater.

## Onde Ash começa a fazer sentido

Ash começa a ficar interessante quando o domínio deixa de ser apenas "persistir dados com validação".

Pense em uma aplicação SaaS com organizações, usuários, permissões, convites, assinaturas, planos, produtos, integrações, imports, webhooks e painel administrativo. Muitas regras não pertencem a uma tela específica. Elas pertencem ao domínio.

Exemplos:

- usuário só vê registros da própria organização;
- admin pode arquivar, mas não remover definitivamente;
- importação aceita campos diferentes do formulário web;
- API pública precisa respeitar a mesma autorização do painel;
- um worker precisa executar uma ação com contexto explícito;
- a leitura padrão deve esconder registros desativados;
- certos campos só podem mudar em ações específicas.

Com Phoenix Contexts, dá para implementar tudo isso. A questão é que cada decisão precisa ser costurada manualmente: qual função chama qual changeset, qual query aplica qual filtro, qual controller verifica qual permissão, qual LiveView reaproveita qual validação.

Ash tenta concentrar isso em Resources e Actions. Uma ação deixa de ser "uma função qualquer que alguém deve chamar" e passa a ser parte do contrato do recurso.

## Ash não elimina Ecto

Um ponto importante: Ash não significa abandonar Ecto.

Quando você usa Ash com Postgres, normalmente entra o [AshPostgres](https://hexdocs.pm/ash_postgres/) como data layer. Ecto continua existindo por baixo em boa parte da integração com banco. Migrations, tipos, constraints e SQL continuam relevantes.

A diferença é que Ecto deixa de ser a única camada onde o domínio aparece.

Em vez de espalhar regra entre schema, changeset, context e controller, você declara parte importante do comportamento no Resource. O Resource pode ter atributos, relacionamentos, actions, validações, policies, calculations e aggregates.

Isso não é "Ecto, só que mais mágico". É outra forma de organizar a aplicação.

## Comparando o formato mental

Com Phoenix Contexts, você tende a pensar assim:

"Tenho uma função pública no contexto. Ela recebe parâmetros, monta changeset/query, verifica o que precisa e chama o Repo."

Com Ash, a pergunta muda:

"Qual recurso do domínio está sendo usado? Qual ação representa essa operação? Quais atributos essa ação aceita? Quem pode executá-la? Como ela pode ser consultada por outras interfaces?"

Essa diferença parece pequena, mas muda o desenho da aplicação.

Em Ecto puro, a fronteira do domínio é uma convenção. Em Ash, essa fronteira vira uma estrutura declarativa. Ela fica mais visível para ferramentas, extensões e outras partes do código.

## O tradeoff da DSL

Ash tem DSL. Isso pode ser ótimo ou irritante, dependendo do problema.

O lado bom é que uma DSL bem pensada reduz repetição e torna certas intenções óbvias. Ao ler um Resource, você enxerga rapidamente quais ações existem, quais atributos são públicos, quais validações se aplicam e quais policies protegem a operação.

O lado ruim é que você precisa aprender as regras dessa DSL. Nem tudo é uma função Elixir comum olhando para você. Em alguns momentos, será necessário entender o ciclo de vida do Ash: como actions são preparadas, como changesets são montados, como policies filtram dados, como domains expõem código.

Se a equipe não compra essa forma de pensar, Ash pode virar uma camada que poucos entendem. E isso é pior do que um context grande, mas compreendido por todo mundo.

## Quando eu escolheria cada um

Eu escolheria Phoenix Contexts com Ecto quando o sistema é simples, o time quer máxima explicitude e o domínio não tem muita variação de operação.

Também escolheria Ecto puro quando a aplicação é muito específica em SQL, tem pouca necessidade de exposição de APIs e não ganha muito com uma representação declarativa do domínio.

Eu consideraria Ash quando a aplicação tem muitas regras transversais: autorização, multi-tenancy, APIs, formulários, workers, imports, actions diferentes para o mesmo recurso e necessidade de manter tudo isso consistente.

Ash também fica mais atraente quando o domínio precisa ser consumido por mais de uma interface. Uma LiveView, uma API JSON, GraphQL e um job interno podem chamar ações com o mesmo contrato, em vez de cada interface reconstruir a lógica do seu jeito.

## Fechando

A comparação mais justa não é "Ash ou Ecto?".

A comparação real é: "Phoenix Contexts com Ecto continuam dando conta do contrato do meu domínio, ou as regras já estão se espalhando demais?"

Se a resposta for "ainda está simples", fique com Ecto e Contexts. É uma escolha madura.

Se a resposta for "estou repetindo autorização, filtros, validações e operações em lugares diferentes", Ash merece uma avaliação séria. Não por hype, mas porque talvez o problema já tenha deixado de ser persistência e passado a ser modelagem de domínio.
