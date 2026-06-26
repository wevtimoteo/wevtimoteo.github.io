---
title: Criando seu primeiro Resource no Ash Framework
date: 2025-09-15 09:00:00
tags: ash, ashframework, elixir, phoenix, ptbr
---

Nos posts anteriores, falei sobre o problema que o [Ash Framework](https://ash-hq.org/) tenta resolver e comparei Ash com o caminho mais comum em Phoenix: Contexts com [Ecto](https://hexdocs.pm/ecto/Ecto.html).

Agora dá para descer um nível e olhar para a peça mais importante do Ash: o Resource.

Um Resource é a forma como Ash modela um conceito do domínio. Pode ser `Product`, `Customer`, `Invoice`, `Task`, `Post`, `Organization`, `Subscription`. O nome não importa tanto quanto a ideia: um Resource não é apenas uma tabela ou uma struct. Ele descreve atributos, relacionamentos, ações, validações e outras regras ligadas àquele conceito.

Se você vem de Ecto, a tentação é pensar: "Resource é o schema do Ash". Essa comparação ajuda no começo, mas fica incompleta rápido. Um schema Ecto descreve dados e parte da validação de entrada. Um Resource Ash também descreve quais operações existem para aquele dado.

É essa diferença que faz o Resource ser interessante.

## Um exemplo simples: Product

Vamos imaginar um catálogo simples de produtos. Em uma aplicação Phoenix tradicional, você provavelmente teria um schema `Product`, um changeset e funções no contexto `Catalog`.

Com Ash, começamos declarando um Resource:

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

    attribute :description, :string do
      public? true
    end

    attribute :status, :atom do
      constraints one_of: [:draft, :active, :archived]
      default :draft
      public? true
    end
  end

  actions do
    defaults [:read, :destroy, create: [:name, :description], update: [:name, :description, :status]]
  end
end
```

Esse exemplo é pequeno de propósito. Ele não inclui banco, policies, relacionamentos ou multi-tenancy. A intenção é mostrar a estrutura básica: o Resource tem atributos e ações no mesmo lugar.

O `uuid_primary_key :id` declara a chave primária. Os atributos `:name`, `:description` e `:status` descrevem dados do produto. O bloco `actions` define operações básicas disponíveis para esse Resource.

A partir daí, o domínio começa a ter um contrato mais explícito.

## Attributes não são apenas colunas

Em uma aplicação com AshPostgres, muitos attributes vão virar colunas no banco. Mesmo assim, vale evitar pensar neles apenas como colunas.

Um attribute define parte da interface do Resource. Quando você marca um campo como público, está dizendo que ele pode aparecer em interfaces e chamadas externas controladas pelo Ash. Quando coloca `allow_nil? false`, está deixando clara uma regra mínima do domínio.

No exemplo, `name` não pode ser `nil`. Isso parece pequeno, mas é uma regra que deixa de ficar escondida em uma função específica. Quem lê o Resource entende rapidamente que produto sem nome não faz sentido.

O `status` também diz algo importante. Não é qualquer string perdida no banco; é um conjunto conhecido de estados: `:draft`, `:active`, `:archived`. Mesmo antes de escrever regras mais avançadas, o Resource já comunica uma intenção.

## Actions são a API do Resource

O bloco `actions` talvez seja a parte mais importante para quem está conhecendo Ash.

Em muitos códigos Phoenix, a API do domínio é um conjunto de funções no context. Isso funciona, mas depende da equipe manter nomes e contratos coerentes. Em Ash, as ações fazem parte do Resource.

No exemplo acima, usamos `defaults` para criar operações básicas: read, create, update e destroy. Isso é útil para começar, mas em aplicações reais você provavelmente vai criar ações com nomes mais próximos do negócio.

Por exemplo:

```elixir
actions do
  defaults [:read, :destroy]

  create :create do
    accept [:name, :description]
  end

  update :publish do
    accept []
  end

  update :archive do
    accept []
  end
end
```

Esse segundo exemplo já muda a conversa. `publish` e `archive` são operações do domínio. Elas não são apenas updates genéricos. Mesmo antes de adicionar mudanças automáticas, validações ou policies, o Resource passa a mostrar quais verbos fazem sentido para um produto.

É uma forma de evitar que todo update vire "altera qualquer coisa se o mapa de parâmetros deixar".

## Domain: onde os Resources se agrupam

No exemplo, o Resource usa `domain: MyApp.Catalog`.

Um [Domain](https://hexdocs.pm/ash/domains.html) agrupa Resources relacionados. Se você já usa Phoenix Contexts, dá para pensar no Domain como a fronteira de uma área da aplicação: `Catalog`, `Accounts`, `Billing`, `Support`.

Mas o Domain em Ash não é apenas um módulo com funções soltas. Ele conhece os Resources daquela área. Isso permite que o Ash organize operações e, dependendo da configuração, exponha uma interface de código para chamar ações do domínio.

Um domínio de catálogo poderia agrupar `Product`, `Category`, `PriceList` e `InventoryItem`. Um domínio de contas poderia agrupar `User`, `Organization`, `Membership` e `Invitation`.

Essa organização ajuda a manter o mapa mental da aplicação. Recursos relacionados ficam próximos, sem transformar um único módulo em uma gaveta de funções.

## O que ainda não apareceu

Um Resource real pode ter muito mais coisa:

- relacionamentos;
- identities;
- validations;
- changes;
- policies;
- calculations;
- aggregates;
- data layer;
- multi-tenancy.

Não é necessário usar tudo no primeiro dia. Na prática, é melhor começar pequeno. Declare os atributos, defina ações básicas e só adicione complexidade quando a regra realmente existir.

Essa é uma armadilha comum com frameworks declarativos: como a ferramenta oferece muitos blocos, dá vontade de preencher todos. Normalmente, isso só torna o Resource difícil de ler.

O Resource deve explicar o domínio, não virar um inventário de recursos do framework.

## Comparando com Ecto Schema

Um schema Ecto costuma responder: "qual é a forma deste dado?".

Um Resource Ash tenta responder também: "o que pode ser feito com este dado?".

Essa diferença fica clara quando pensamos em `archive`. Em Ecto puro, você poderia ter uma função no context:

```elixir
def archive_product(product) do
  product
  |> Product.changeset(%{status: :archived})
  |> Repo.update()
end
```

Isso é simples e correto. Com Ash, a ideia é que `archive` possa ser uma action do Resource. Assim, autorização, validação e outros comportamentos podem se ligar a essa operação nomeada.

Não é que uma abordagem seja sempre melhor. A diferença é onde o contrato aparece.

## Fechando

Criar um Resource no Ash é começar a desenhar o domínio de forma declarativa.

O exemplo de `Product` mostra só o básico, mas já apresenta a mudança de perspectiva: atributos e ações ficam próximos, e o Resource passa a mostrar quais operações existem para aquele conceito.

Quando a aplicação é pequena, isso pode parecer apenas outra forma de escrever o que você já faria com Ecto. Quando o domínio cresce, porém, ter esse contrato explícito ajuda bastante.

No próximo post, vou entrar em actions, changesets e queries com mais detalhe, porque é ali que o Resource deixa de ser apenas uma descrição e começa a virar a API real do domínio.
