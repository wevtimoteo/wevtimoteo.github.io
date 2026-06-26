---
title: Ash + Phoenix LiveView: formulários, validações e CRUD sem boilerplate
date: 2025-10-06 09:00:00
tags: ash, ashframework, elixir, phoenix, liveview, ptbr
---

[Phoenix LiveView](https://hexdocs.pm/phoenix_live_view/) mudou bastante a forma como muita gente escreve interface em Elixir. Em vez de separar tudo entre backend JSON e frontend JavaScript, dá para construir experiências interativas mantendo boa parte da lógica no servidor.

Isso combina bem com [Ash](https://ash-hq.org/), porque Ash também empurra uma parte importante da lógica para um contrato no servidor: Resources, actions, validações, policies e queries.

O ponto interessante não é "gerar CRUD mágico". É reduzir a repetição entre formulário, validação, mudança de estado e chamada do domínio.

## O problema do CRUD repetido

Em uma aplicação Phoenix comum, um CRUD simples costuma ter várias peças:

- schema;
- changeset;
- contexto;
- LiveView de listagem;
- LiveView ou componente de formulário;
- tratamento de erros;
- redirects ou patches;
- mensagens de feedback;
- autorização;
- testes.

Nada disso é errado. Phoenix é explícito e essa explicitude é uma das qualidades do framework. O problema aparece quando você repete o mesmo desenho para muitos recursos parecidos.

Um formulário de `Product` aceita alguns campos, chama `Catalog.create_product/1`, transforma erros em algo que o form entende e atualiza a tela. Um formulário de `Customer` faz quase a mesma coisa. Um formulário de `Category` também.

Ash tenta aproveitar o fato de que o Resource já sabe quais actions existem, quais campos são aceitos e quais validações se aplicam.

## AshPhoenix como ponte

O pacote [AshPhoenix](https://hexdocs.pm/ash_phoenix/) existe para aproximar Ash do ecossistema Phoenix. Uma parte importante disso é `AshPhoenix.Form`, que ajuda a montar formulários baseados em actions.

Em vez de criar um changeset Ecto manualmente para cada formulário, você pode partir de uma action do Ash.

Um exemplo simplificado:

```elixir
AshPhoenix.Form.for_create(MyApp.Catalog.Product, :create)
```

A ideia é: o formulário sabe que está tentando executar a action `:create` do Resource `Product`. Se a action aceita `:name` e `:description`, isso pode orientar o fluxo do formulário. Se a action valida algo, o erro volta dentro do mesmo contrato.

Na LiveView, isso não elimina o trabalho de desenhar a tela. Você ainda decide layout, eventos, navegação, estado e experiência do usuário. O que muda é que a lógica do domínio não precisa ser reescrita como uma segunda camada de regras no componente.

## Validação mais próxima do domínio

Um fluxo comum em LiveView é validar conforme o usuário digita:

```elixir
def handle_event("validate", %{"product" => params}, socket) do
  form =
    socket.assigns.form
    |> AshPhoenix.Form.validate(params)

  {:noreply, assign(socket, form: form)}
end
```

Esse tipo de chamada mantém a validação conectada à action. O formulário não está inventando uma regra só para a tela. Ele está perguntando ao domínio se aqueles dados fazem sentido para aquela operação.

Isso é especialmente útil quando a mesma action é chamada de mais de um lugar. Se amanhã o produto também puder ser criado via modal, página administrativa ou fluxo de onboarding, a validação principal continua morando no Resource.

Claro que ainda existem validações de interface. Máscara de campo, preview visual, estado local e microinterações pertencem à UI. Mas a regra de negócio não precisa depender da UI.

## Submit como execução de action

O envio também segue a mesma ideia:

```elixir
def handle_event("save", %{"product" => params}, socket) do
  case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
    {:ok, product} ->
      {:noreply, push_navigate(socket, to: ~p"/products/#{product.id}")}

    {:error, form} ->
      {:noreply, assign(socket, form: form)}
  end
end
```

O detalhe importante é que `submit` não significa apenas "salvar no banco". Ele tenta executar a action por trás do formulário.

Se a action tem validações, elas entram. Se tem policies, elas importam. Se tem mudanças específicas, elas fazem parte do fluxo. O formulário vira uma entrada para o domínio, não uma versão paralela dele.

Isso reduz boilerplate, mas principalmente reduz divergência.

## CRUD sem perder intenção

Muita gente ouve "CRUD sem boilerplate" e pensa em geradores que criam telas genéricas. Isso pode ser útil, mas também pode deixar a aplicação com cara de painel automático.

Ash com LiveView fica mais interessante quando você mantém intenção.

Uma action `:create` pode alimentar um formulário simples. Uma action `:publish` pode virar um botão em uma tela de edição. Uma action `:archive` pode aparecer em um menu administrativo. Uma read action `:active` pode alimentar uma listagem.

Ou seja: a interface continua desenhada para o fluxo do usuário, mas as operações continuam sendo as mesmas ações do domínio.

Você não precisa transformar tudo em CRUD genérico. Pode ter ações pequenas e bem nomeadas:

- criar rascunho;
- publicar;
- arquivar;
- convidar usuário;
- cancelar assinatura;
- reabrir ticket;
- aprovar revisão.

LiveView cuida da interação. Ash cuida do contrato da operação.

## Autorização no fluxo da UI

Uma vantagem prática é evitar que a tela vire a única barreira de autorização.

Em LiveView, é tentador esconder botões quando o usuário não pode executar uma ação. Isso melhora a experiência, mas não deve ser a única proteção. O usuário não ver o botão não significa que a action esteja protegida.

Quando a autorização está no Resource, a tentativa de executar a action também passa pela regra do domínio. A UI pode continuar escondendo botões e mostrando mensagens melhores, mas a proteção principal não depende só da renderização.

Esse ponto é importante em aplicações com LiveView, API e jobs internos ao mesmo tempo.

## Onde ainda existe trabalho manual

Ash não remove decisões de produto.

Você ainda precisa pensar em:

- como a tela deve ser organizada;
- quais estados de carregamento existem;
- quais mensagens ajudam o usuário;
- quando usar modal ou página;
- como tratar erros complexos;
- como navegar depois de uma ação;
- quais dados precisam ser carregados.

Também precisa entender AshPhoenix. Se a equipe tentar usar formulários Ash sem entender actions, actor, params e validações, a abstração vai parecer estranha.

O ganho vem quando o domínio está bem modelado. Se o Resource está confuso, o formulário também vai refletir essa confusão.

## Fechando

Ash e Phoenix LiveView se encaixam bem porque os dois valorizam lógica no servidor, mas em camadas diferentes.

LiveView resolve interação e atualização de interface. Ash resolve contrato de domínio. AshPhoenix ajuda a ligar essas duas partes, principalmente em formulários, validações e submissão de actions.

O resultado não é uma aplicação sem código. É uma aplicação com menos duplicação entre UI e domínio.

Para mim, esse é o ponto mais útil: o formulário deixa de ser o lugar onde a regra é recriada e passa a ser uma entrada bem comportada para actions que já existem.
