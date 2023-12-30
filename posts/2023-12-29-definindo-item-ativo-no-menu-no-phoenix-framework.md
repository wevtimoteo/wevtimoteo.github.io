---
title: Definindo item ativo no menu no Phoenix Framework usando Short-circuit Evaluation
date: 2023-12-29 22:30:00
tags: phoenixframework, elixir, ptbr
---

- [Read en-US version](https://wevtimoteo.github.io/posts/2023-12-29-definindo-item-ativo-no-menu-no-phoenix-framework.html)

Ao desenvolver aplicações web, muitas vezes precisamos marcar itens de menu, abas ou outras partes da interface do usuário como ativos. No [Phoenix Framework](https://phoenixframework.org/), fazendo isso de forma rápida, pode ser que você chegue nesse resultado:

```elixir
<.link
  href={~p"/lojas/#{@store}/produtos"}
  class={"tab" <> if @active == :products, do: " tab-active", else: ""}
  href={~p"/lojas/#{@store}/produtos"}
>
  Produtos
</.link>
```

Nessa abordagem, usamos expressões ternárias e concatenação de strings para definir classes do CSS condicionalmente. Funciona, mas conforme a lógica condicional aumenta, isso pode ficar difícil de ler e manter.

## Apresentando o Short-circuit Evaluation

No Elixir, **lazy evaluation** e **short-circuit evaluation** muitas vezes são usadas de forma intercambiável. No entanto, há uma pequena diferença. A lazy evaluation geralmente é associada a estruturas de dados mais complexas, enquanto o short-circuit é **mais comum em expressões booleanas**. E é isso que iremos usar.

Vamos dar uma olhada em alguns exemplos usando o `iex`:

```elixir
list = ["plataformatec", nil, "sourcelevel", false, "dashbit"]
#=> ["plataformatec", nil, "sourcelevel", false, "dashbit"]

# Utilizando o short-circuit evaluation na lista
list = ["plataformatec", nil && "sourcelevel", false && "dashbit"]
#=> ["plataformatec", nil, false]
```

Na segunda definição da lista, estamos usando uma operação de short-circuit, onde o último valor da expressão prevalece quando o anterior é verdadeiro; caso contrário, o valor anterior é mantido.

Em termos simples, é como dizer ao [Elixir](https://elixir-lang.org/): "pare de pensar assim que souber a resposta".

## Aplicando short-circuit na lista de classes do CSS

Numa [issue do Phoenix Framework #276](https://github.com/phoenixframework/phoenix_html/issues/276#issuecomment-584911356), foi discutida uma abordagem usando a lazy evaluation para a sintaxe das classes. [Nesse comentário](https://github.com/phoenixframework/phoenix_html/issues/276#issuecomment-742375950), ficou claro que, se o item da lista for `false` ou `nil`, ele será removido. Podemos aplicar essa solução ao nosso exemplo:

```elixir
<.link
  href={~p"/lojas/#{@store}/produtos"}
  class={["tab", @active == :products && "tab-active"]}
>
  Produtos
</.link>
```

Se `@active` for `:products`, a string `"tab-active"` será adicionada à lista (ficando `tab tab-active`), caso contrário, ela será excluída (ficando apenas `tab`). Essa abordagem é mais limpa, legível e eficiente:

1. **Concisão de Código**: A sintaxe da lazy evaluation é mais concisa, resultando em código mais limpo.
2. **Eficiência**: A lazy evaluation interrompe a avaliação assim que o resultado é conhecido, evitando avaliações desnecessárias.
3. **Legibilidade**: A lista de classes é fácil de entender e manter, melhorando a legibilidade do código.
4. **Facilidade de Manutenção**: A sintaxe simplificada facilita a manutenção do código ao longo do tempo.

Ao desenvolver aplicações em Elixir, não basta usar o paradigma funcional, mas também escrever código conciso e fácil de entender. Essa abordagem não apenas simplifica nosso código, mas também torna a manutenção mais fácil e direta. 😎✨
