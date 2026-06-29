---
title: Calculations e Aggregates no Ash: modelando dados derivados
date: 2025-10-27 09:00:00
tags: ash, ashframework, elixir, phoenix, ptbr
---

No [post anterior da série](/posts/2025-10-20-ash-authentication-na-pratica-login-usuario-sessao.html), falei sobre Ash Authentication na prática: login, usuário e sessão.

Nem todo dado importante nasce como coluna no banco.

Um nome completo pode vir de `first_name` e `last_name`. O total de um pedido pode vir da soma dos itens. O status de uma assinatura pode depender de datas, pagamentos e cancelamentos. A quantidade de comentários de um post pode vir de um relacionamento.

Esses dados derivados aparecem em quase toda aplicação. A pergunta é onde colocar a regra.

No [Ash](https://ash-hq.org/), calculations e aggregates ajudam a modelar esse tipo de informação dentro do domínio. Em vez de espalhar cálculos entre templates, serializers, contexts e queries, você pode declarar parte desses dados no Resource.

## Dados derivados também são domínio

É comum tratar dado derivado como detalhe de apresentação.

Por exemplo:

```elixir
user.first_name <> " " <> user.last_name
```

Se isso aparece uma vez em uma template, tudo bem. Mas logo aparece em e-mail, API, exportação CSV, busca, componente LiveView e relatório. A regra deixa de ser "um detalhe visual" e passa a ser parte do contrato do usuário.

O mesmo vale para totais e contagens. `orders_count`, `total_spent`, `items_total`, `open_tasks_count`, `display_status`. Esses valores aparecem em telas, filtros e decisões de negócio.

Quando a regra importa para mais de um lugar, ela merece um nome e um dono.

## Calculations

Calculations representam valores derivados de um Resource.

Pense em um `Customer` com `first_name` e `last_name`. O nome completo pode ser uma calculation chamada `full_name`. Um `Subscription` pode ter uma calculation `expired?`. Um `Task` pode ter `overdue?`.

O valor pode ser simples ou mais elaborado. O importante é que ele passa a fazer parte do Resource. Quem consome o domínio não precisa repetir a regra toda vez.

Conceitualmente:

```elixir
calculate :full_name, :string
```

O exemplo acima é intencionalmente incompleto. A implementação exata depende da forma como você quer calcular: em Elixir, em expressão, usando argumentos ou dependendo de dados carregados. O ponto é a modelagem: `full_name` deixa de ser uma concatenação informal e vira um campo derivado com nome.

Isso melhora a leitura do código. Em vez de procurar onde cada tela monta o nome completo, você procura a calculation do Resource.

## Aggregates

Aggregates são dados derivados de relacionamentos.

Exemplos:

- total de pedidos de um cliente;
- soma dos itens de um pedido;
- quantidade de comentários em um post;
- data da última compra;
- média de avaliação de um produto;
- total de tarefas abertas em um projeto.

Esses valores geralmente dependem de uma query. Se cada tela calcula sozinha, você ganha duplicação e inconsistência.

Um relatório pode contar apenas pedidos pagos. Uma dashboard pode contar todos os pedidos. Uma API pode esquecer de filtrar cancelados. Depois alguém pergunta por que os números não batem.

Ao declarar aggregates no domínio, você dá nome para a regra. `paid_orders_count` é diferente de `orders_count`. `total_revenue` é diferente de `gross_total`. O nome força uma decisão.

## Evitando lógica em templates

Templates deveriam apresentar dados, não descobrir regras de negócio.

Quando uma template começa a fazer muita conta, algo está vazando:

```elixir
Enum.sum(Enum.map(@order.items, & &1.price))
```

Isso pode parecer inofensivo, mas levanta perguntas:

- preço considera desconto?
- item cancelado entra na soma?
- imposto está incluído?
- moeda importa?
- arredondamento é feito onde?

Se essas perguntas são relevantes, a regra não deveria viver na template.

Com calculations e aggregates, a UI pode receber algo como `order.total` ou `customer.paid_orders_count`. A regra continua no domínio e a interface fica mais simples.

## Dados derivados em APIs

O mesmo problema aparece em APIs.

Se uma API retorna `full_name`, `orders_count` ou `total_spent`, esses campos passam a fazer parte de um contrato externo. Mudar a regra sem perceber pode quebrar consumidores.

Quando o campo derivado é declarado no Resource, fica mais claro que ele existe oficialmente. Também fica mais fácil reaproveitar o mesmo valor em JSON, GraphQL, LiveView e relatórios.

Isso não significa expor tudo. Alguns cálculos são internos. Outros são públicos. A decisão continua sendo de design de API.

O ponto é evitar que cada camada crie sua própria versão de um campo que deveria ter significado único.

## Performance importa

Dados derivados podem ficar caros.

Calcular nome completo é barato. Somar milhares de itens em tempo real talvez não seja. Contar relacionamentos em uma lista paginada pode virar problema de N+1. Agregar dados de billing pode exigir cuidado com índices e cache.

Ash não elimina essas decisões. Calculations e aggregates organizam a regra, mas você ainda precisa pensar em performance.

Algumas perguntas úteis:

- esse valor precisa ser calculado sempre?
- ele pode ser carregado sob demanda?
- precisa ser persistido?
- pode ser cacheado?
- depende de dados externos?
- será usado em filtros ou ordenação?

Modelar no domínio não quer dizer ignorar o banco.

## Nomear é metade do trabalho

Uma vantagem prática de calculations e aggregates é obrigar você a nomear conceitos.

`total` é vago. `items_total`, `paid_total`, `gross_total`, `net_total` e `refunded_total` dizem coisas diferentes.

`status` pode ser uma coluna simples ou um estado calculado a partir de várias condições. Se for calculado, talvez `display_status` seja mais honesto. Se for persistido, talvez precise de uma action explícita para mudar.

Nome ruim em dado derivado cria bug sutil. Todo mundo usa o campo achando que significa uma coisa, mas ele representa outra.

Ash não resolve nome ruim, mas cria um lugar onde essa decisão fica visível.

## Quando usar

Eu pensaria em calculation ou aggregate quando:

- o valor é usado em mais de uma interface;
- a regra tem nome de domínio;
- existe risco de duplicação;
- a regra depende de relacionamento;
- a API precisa expor o valor;
- a UI está fazendo conta demais;
- relatórios precisam usar o mesmo significado.

Eu evitaria quando o valor é puramente visual e usado em um único lugar. Nem toda concatenação precisa virar calculation. Nem toda contagem temporária precisa virar aggregate.

O critério é o mesmo de outras partes do Ash: se faz parte do contrato do domínio, vale modelar.

## Concluindo

Calculations e aggregates ajudam a tratar dados derivados como cidadãos de primeira classe.

Em vez de espalhar soma, contagem e formatação semântica por templates, APIs e contexts, você coloca a regra perto do Resource. Isso melhora consistência e torna o domínio mais legível.

O ganho não é só conveniência. É clareza. Quando `full_name`, `orders_count` ou `total_spent` têm um dono, fica mais fácil entender o que a aplicação quer dizer com esses valores.

No [próximo post da série](/posts/2025-11-03-vale-a-pena-usar-ash-em-producao.html), vou fechar com uma pergunta prática: vale a pena usar Ash em produção?
