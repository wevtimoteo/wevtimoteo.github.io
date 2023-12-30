---
title: Defining active menu item in Phoenix Framework through Short-circuit Evaluation
date: 2023-12-29 22:30:00
tags: phoenixframework, elixir, en-US
---

- [Ler versão em pt-BR](https://wevtimoteo.github.io/posts/2023-12-29-definindo-item-ativo-no-menu-no-phoenix-framework.html)

When developing web applications, marking menu items, tabs, or other parts of the user interface as active is a common need. In the [Phoenix Framework](https://phoenixframework.org/), doing this quickly might lead you to something like this:

```elixir
<.link
  href={~p"/stores/#{@store}/products"}
  class={"tab" <> if @active == :products, do: " tab-active", else: ""}
>
  Products
</.link>
```

In this approach, we use ternary expressions and string concatenation to conditionally define CSS classes. It works, but as conditional logic increases, it can become challenging to read and maintain.

## Introducing Short-circuit Evaluation

In Elixir, **lazy evaluation** and **short-circuit evaluation** are often used interchangeably. However, there's a slight difference. Lazy evaluation is usually associated with more complex data structures, while short-circuit is **more common in boolean expressions**. And that's what we're going to use.

Let's look at some examples using `iex`:

```elixir
list = ["plataformatec", nil, "sourcelevel", false, "dashbit"]
#=> ["plataformatec", nil, "sourcelevel", false, "dashbit"]

# Using short-circuit evaluation on the list
list = ["plataformatec", nil && "sourcelevel", false && "dashbit"]
#=> ["plataformatec", nil, false]
```

In the second definition of the list, we are using a short-circuit operation, where the last value of the expression prevails when the previous one is true; otherwise, the previous value is retained.

In simple terms, it's like telling [Elixir](https://elixir-lang.org/): "stop thinking as soon as you know the answer."

## Applying Short-circuit to the CSS Class List

In a [Phoenix Framework issue #276](https://github.com/phoenixframework/phoenix_html/issues/276#issuecomment-584911356), an approach using lazy evaluation for the class syntax was discussed. [In this comment](https://github.com/phoenixframework/phoenix_html/issues/276#issuecomment-742375950), it was clarified that if the list item is `false` or `nil`, it will be removed. We can apply this solution to our example:

```elixir
<.link
  href={~p"/stores/#{@store}/products"}
  class={["tab", @active == :products && "tab-active"]}
>
  Products
</.link>
```

If `@active` is `:products`, the string `"tab-active"` will be added to the list (resulting in `tab tab-active`), otherwise, it will be omitted (resulting in just `tab`). This approach is cleaner, more readable, and efficient:

1. **Code Conciseness**: The lazy evaluation syntax is more concise, resulting in cleaner code.
2. **Efficiency**: Lazy evaluation halts evaluation as soon as the result is known, avoiding unnecessary evaluations.
3. **Readability**: The class list is easy to understand and maintain, improving code readability.
4. **Ease of Maintenance**: The simplified syntax makes code maintenance easier over time.

When developing applications in Elixir, it's not just about using the functional paradigm, but also about writing concise and easily understandable code. This approach not only simplifies our code but also makes maintenance more straightforward and direct. 😎✨
