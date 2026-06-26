---
title: Actions, Changesets e Queries no Ash: a lógica de negócio como contrato
date: 2025-09-22 09:00:00
tags: ash, ashframework, elixir, phoenix, ptbr
---

Quando começamos a usar [Ash](https://ash-hq.org/), é comum prestar atenção primeiro nos Resources. Eles parecem a parte mais visível: atributos, relacionamentos, validações e configurações ficam todos ali.

Mas o ponto em que Ash realmente começa a mudar a modelagem da aplicação é nas actions.

Actions são a API explícita do domínio. Elas dizem o que pode ser feito com um Resource. Não apenas "existe um update", mas "existe uma operação chamada publicar", "existe uma leitura chamada ativos", "existe uma criação chamada importar do CSV".

Essa diferença é pequena na sintaxe e grande na manutenção.

## CRUD ainda existe

Ash não tenta fingir que CRUD não existe. Muitas entidades começam com operações básicas: criar, ler, atualizar e remover.

Um Resource pode expor ações padrão:

```elixir
actions do
  defaults [:read, :destroy, create: [:name], update: [:name, :status]]
end
```

Esse bloco já comunica algumas coisas:

- existe leitura padrão;
- existe destruição;
- a criação aceita `:name`;
- a atualização aceita `:name` e `:status`.

Em uma aplicação pequena, isso pode parecer só uma forma diferente de escrever changesets. A diferença aparece quando você começa a nomear operações que têm sentido no negócio.

## Actions com nome de domínio

Imagine um `Post` de blog dentro de um CMS. Ele pode ser criado como rascunho, publicado, arquivado e talvez revisado por outra pessoa.

Em uma abordagem tradicional, poderíamos ter funções assim em um context:

```elixir
create_post(attrs)
publish_post(post, user)
archive_post(post, user)
list_published_posts()
```

Isso é normal e funciona. Em Ash, a intenção é aproximar essas operações do Resource:

```elixir
actions do
  defaults [:read]

  create :draft do
    accept [:title, :body]
  end

  update :publish do
    accept []
  end

  update :archive do
    accept []
  end

  read :published
end
```

Esse exemplo é simplificado, mas mostra o ponto: `draft`, `publish`, `archive` e `published` são parte do contrato do Resource. A aplicação deixa de ter apenas um update genérico e passa a ter operações nomeadas.

Isso ajuda muito quando o mesmo Resource é usado por várias interfaces. Uma LiveView, uma API, um worker e um script interno podem chamar a mesma action, em vez de cada caminho decidir manualmente quais campos aceitar e quais regras aplicar.

## Changesets no Ash

Em Ecto, changeset é um conceito conhecido: você pega dados de entrada, faz cast, valida, aplica constraints e passa para o Repo.

Ash também tem changesets, mas eles vivem dentro do fluxo das actions. Um [Ash.Changeset](https://hexdocs.pm/ash/Ash.Changeset.html) representa uma tentativa de mudança em um Resource para uma action específica.

Em vez de pensar "vou montar qualquer changeset para Product", a pergunta vira: "vou montar um changeset para executar a action `:publish` em Product".

Um exemplo de chamada pode ter esta forma:

```elixir
MyApp.Catalog.Product
|> Ash.Changeset.for_create(:create, %{name: "Keyboard"})
|> Ash.create()
```

Para update, o ponto é parecido: existe uma mudança em um registro, mas essa mudança está ligada a uma action.

```elixir
product
|> Ash.Changeset.for_update(:archive, %{})
|> Ash.update()
```

O ganho é que a action passa a ser o contexto da alteração. Ela pode definir campos aceitos, validações, changes, autorização e efeitos colaterais. O changeset não é uma validação solta; ele é uma tentativa de executar uma operação do domínio.

## Changes e validations

Dentro de uma action, Ash permite adicionar validations e changes.

Uma validation responde: "essa entrada é permitida?". Uma change responde: "o que precisa ser alterado ou preparado durante essa ação?".

Por exemplo, uma action `:publish` pode validar que o post tem título e corpo. Também pode marcar status como publicado e preencher `published_at`. Uma action `:archive` pode mudar apenas o status e talvez registrar quem arquivou.

O detalhe importante é que essas regras ficam presas à operação.

Isso evita uma classe comum de bug: uma validação escrita para o fluxo de criação acaba sendo reaproveitada sem querer em importação, ou uma mudança automática feita para o painel administrativo aparece em uma sincronização externa.

Quando cada action tem nome e contrato, fica mais fácil decidir onde cada regra pertence.

## Queries no Ash

Leitura também faz parte do contrato.

Em Ecto, é comum escrever queries diretas:

```elixir
from p in Post,
  where: p.status == :published,
  order_by: [desc: p.published_at]
```

Isso continua sendo uma forma poderosa de pensar, especialmente quando você quer controle fino de SQL. Em Ash, uma [Ash.Query](https://hexdocs.pm/ash/Ash.Query.html) representa uma leitura de um Resource, normalmente ligada a uma read action.

Uma chamada pode ser algo assim:

```elixir
MyApp.CMS.Post
|> Ash.Query.for_read(:published)
|> Ash.read!()
```

O interessante é que `:published` não é só uma query perdida em algum módulo. É uma action de leitura. Ela pode carregar filtros padrão, preparações, autorização e regras de visibilidade.

Isso é útil quando "listar publicados" não significa apenas `status == :published`. Talvez precise respeitar tenant, esconder posts removidos, aplicar autorização por autor, ordenar de um jeito específico e carregar dados derivados.

Colocar isso em uma read action deixa a intenção mais clara.

## Operações nomeadas reduzem ambiguidade

Em muitos sistemas, o problema não é falta de função. É função demais.

Você procura por `update_user`, encontra cinco variações, lê cada uma e tenta descobrir qual é a correta para aquele fluxo. Uma recebe actor, outra não. Uma valida e-mail, outra pula. Uma dispara evento, outra foi criada para importação.

Ash não impede código confuso, mas força uma pergunta útil: qual action representa esta operação?

Se a resposta for `:register`, `:invite`, `:confirm_email`, `:disable`, `:promote_to_admin`, o domínio fica mais legível. Você passa a navegar por operações de negócio, não apenas por funções técnicas.

Esse modelo também ajuda em reviews. Quando alguém cria uma nova action, a discussão fica concreta: essa operação deveria existir? Ela aceita os campos certos? Precisa de autorização? Deveria ser uma action nova ou uma variação de uma action existente?

## O cuidado com actions demais

Existe um risco do outro lado: criar action para tudo.

Se cada pequena variação vira uma action, o Resource fica difícil de entender. A ideia não é transformar todo botão da interface em uma action separada. A ideia é nomear operações que têm significado no domínio.

Uma boa pergunta é: "essa operação teria o mesmo nome se eu explicasse o sistema para alguém fora da equipe técnica?"

Se sim, provavelmente vale uma action. Se não, talvez seja apenas um detalhe de interface ou uma preparação interna.

## Fechando

Actions, changesets e queries são o ponto em que Ash começa a mostrar seu valor além da estrutura.

Actions nomeiam operações. Changesets representam tentativas de executar essas operações. Queries colocam leituras importantes dentro do contrato do domínio.

Isso não elimina a necessidade de pensar em arquitetura. Mas ajuda a tirar regras importantes de lugares espalhados e trazê-las para uma API mais explícita.

No próximo post, vou falar sobre authorization policies, uma das partes em que essa abordagem declarativa fica ainda mais útil.
