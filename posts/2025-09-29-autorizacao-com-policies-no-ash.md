---
title: Autorização com Policies no Ash: menos if espalhado, mais regra declarativa
date: 2025-09-29 09:00:00
tags: ash, ashframework, elixir, phoenix, ptbr
---

Autorização é uma daquelas partes da aplicação que parecem simples no começo e viram dívida rápido.

O primeiro `if current_user.admin?` parece inofensivo. Depois aparece um `if user_id == record.user_id` em uma LiveView. Depois uma API precisa repetir a regra. Depois um worker roda sem usuário, mas precisa executar uma ação administrativa. Depois alguém adiciona multi-tenancy e toda query precisa lembrar do `organization_id`.

O problema não é usar `if`. O problema é autorização virar uma coleção de decisões espalhadas.

No [Ash Framework](https://ash-hq.org/), policies tentam trazer essas decisões para perto do domínio. Em vez de cada interface decidir sozinha quem pode fazer o quê, o Resource declara regras de autorização que se aplicam às actions.

## Autorização não pertence só ao controller

Em aplicações Phoenix, é comum ver autorização em controllers:

```elixir
def update(conn, %{"id" => id, "product" => params}) do
  product = Catalog.get_product!(id)

  if can_edit_product?(conn.assigns.current_user, product) do
    Catalog.update_product(product, params)
  else
    {:error, :forbidden}
  end
end
```

Isso é direto e fácil de entender. O problema é que quase nenhuma aplicação moderna tem apenas controller.

Você pode ter LiveView, API JSON, GraphQL, jobs, imports, webhooks, tarefas administrativas e scripts internos. Se a regra mora somente na interface, cada nova entrada precisa lembrar de reaplicá-la.

E autorização esquecida raramente falha de forma barulhenta. Muitas vezes, ela só vaza dado.

## Policies como contrato do domínio

Ash trata autorização como parte do contrato do Resource. As [policies](https://hexdocs.pm/ash/policies.html) são declaradas perto das actions e podem levar em conta o actor, a action, o registro e o contexto.

Em vez de pensar "essa tela permite isso?", a pergunta vira:

"Este actor pode executar esta action neste Resource?"

Essa mudança é importante porque a resposta deixa de depender da interface.

Um admin pode editar produtos pelo painel. Um usuário comum talvez só possa ver produtos ativos. Um membro de uma organização só pode acessar registros daquela organização. Um sistema interno pode ter permissões diferentes, mas ainda assim explícitas.

O valor está em centralizar a regra no domínio, não em esconder a complexidade.

## Exemplos de regras comuns

Policies ficam interessantes quando o sistema começa a ter regras como:

- administradores podem executar qualquer action;
- usuários autenticados podem ler dados públicos;
- o dono de um registro pode editar alguns campos;
- membros de uma organização só veem dados daquela organização;
- contas suspensas não podem criar registros novos;
- ações destrutivas exigem papel específico;
- workers internos podem executar ações sem passar pela interface web.

Todas essas regras podem ser escritas manualmente com funções e condicionais. Ash não inventa autorização. Ele oferece um lugar e um modelo para declarar autorização.

Isso ajuda a manter consistência quando o mesmo domínio é consumido por mais de uma interface.

## Menos autorização acidental

Um problema comum em aplicações com contexts é a diferença entre "função pública" e "função segura".

Você tem `Catalog.update_product/2`. Essa função aplica autorização? Depende. Talvez ela espere que o controller já tenha verificado. Talvez exista outra função `update_product_as_admin/3`. Talvez um worker use direto porque "é interno".

Com o tempo, a equipe precisa decorar quais funções são seguras em quais contextos.

Ash tenta reduzir esse espaço de erro ao fazer a action passar por um fluxo conhecido. Se a action tem policies, a autorização acompanha a operação. A chamada precisa informar o actor ou deixar claro que está rodando em um contexto especial.

Isso não garante segurança automaticamente. Você ainda precisa escrever regras corretas, testar cenários e evitar atalhos perigosos. Mas reduz a chance de cada interface inventar sua própria interpretação da regra.

## Actor e contexto

O actor é a entidade que está tentando executar uma action. Em muitos sistemas, será um usuário. Em outros, pode ser uma conta de serviço, um token de API, uma integração ou um processo interno.

Pensar em actor ajuda a separar autenticação de autorização.

Autenticação responde: "quem é você?".

Autorização responde: "o que você pode fazer?".

Policies vivem no segundo mundo. Elas podem usar informações do actor para decidir se a action deve continuar. Um actor com papel `:admin` pode passar em uma regra. Um actor pertencente à mesma organização do registro pode passar em outra. Um actor sem autenticação pode ter acesso apenas a leituras públicas.

Essa distinção evita um erro comum: achar que, porque alguém está logado, pode executar qualquer operação que a interface mostra.

## Regras de leitura também importam

Quando se fala em autorização, muita gente pensa primeiro em create, update e destroy. Mas leitura costuma ser a parte mais sensível.

Quem pode listar registros? Quem pode ver detalhes? Uma query administrativa pode retornar dados de outras organizações? Um endpoint público pode carregar relacionamentos privados? Uma página de busca respeita os mesmos filtros da tela principal?

Policies em Ash também ajudam nessa área, porque read actions fazem parte do Resource. A leitura `:active`, `:visible_to_customer` ou `:for_admin` pode ter regras próprias.

Isso é especialmente importante em multi-tenancy. Esquecer um filtro em uma query pode expor dados de outro tenant. Quando a regra fica no domínio, ela deixa de depender de cada chamada lembrar do filtro manualmente.

## Cuidado com regras mágicas

Policies não devem virar uma caixa preta.

Se ninguém consegue entender por que uma action foi permitida ou negada, a equipe só trocou `if` espalhado por confusão centralizada. O objetivo é clareza, não mistério.

Algumas práticas ajudam:

- manter policies próximas das actions;
- usar nomes de actions que expliquem a intenção;
- evitar regras genéricas demais;
- escrever testes para casos permitidos e negados;
- documentar exceções reais, não exceções convenientes.

Autorização é regra de negócio. Ela merece o mesmo cuidado que cálculo de preço, cobrança ou envio de convite.

## Quando policies fazem mais diferença

Para um blog simples com área administrativa pequena, talvez policies pareçam excesso. Um context bem escrito e algumas verificações claras podem ser suficientes.

Policies começam a fazer diferença quando a aplicação tem:

- múltiplos papéis de usuário;
- organização, conta, workspace ou tenant;
- painel administrativo e API pública;
- workers que executam ações do domínio;
- dados sensíveis;
- regras diferentes por action;
- necessidade de auditar quem fez o quê.

Nesses cenários, autorização deixa de ser detalhe de interface e vira parte central do sistema.

## Fechando

Policies no Ash não removem a necessidade de pensar em segurança. Elas apenas colocam a conversa no lugar certo: o domínio.

Em vez de espalhar `if current_user.admin?` por controllers, LiveViews e services, você declara quem pode executar quais actions nos Resources. Isso torna a regra mais visível, mais reaproveitável e mais difícil de esquecer.

O ganho real não é escrever menos código. É reduzir autorização acidental e transformar permissões em parte explícita do contrato da aplicação.
