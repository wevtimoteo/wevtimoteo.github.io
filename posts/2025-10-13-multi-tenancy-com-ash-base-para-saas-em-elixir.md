---
title: Multi-tenancy com Ash: base para SaaS em Elixir
date: 2025-10-13 09:00:00
tags: ash, ashframework, elixir, phoenix, multitenancy, saas, ptbr
---

No [post anterior da série](/posts/2025-10-06-ash-phoenix-liveview-formularios-validacoes-crud.html), conectei Ash com Phoenix LiveView em formulários, validações e CRUD.

Multi-tenancy é um daqueles temas que parecem simples até a aplicação começar a crescer.

No começo, "tenant" parece só um `organization_id` em algumas tabelas. Você adiciona o campo, coloca um filtro nas queries principais e segue. Depois aparecem convites, papéis, integrações, relatórios, webhooks, imports, painel administrativo e jobs. Aos poucos, a pergunta deixa de ser "tem organization_id?" e vira "todas as partes do sistema respeitam o tenant certo?".

Em aplicações SaaS, essa pergunta é central.

O [Ash Framework](https://ash-hq.org/) trata multi-tenancy como parte do domínio. Isso é importante porque separação de dados não deveria depender apenas da memória de quem escreveu a query.

## O que é multi-tenancy

Multi-tenancy é a capacidade de uma aplicação atender vários clientes, organizações, contas ou workspaces usando a mesma base de código.

Existem várias formas de implementar isso:

- um banco por tenant;
- um schema por tenant;
- uma coluna `tenant_id` em tabelas compartilhadas;
- combinações dessas estratégias.

O modelo mais comum em SaaS pequenos e médios é usar tabelas compartilhadas com uma coluna que identifica o tenant. Pode ser `organization_id`, `account_id`, `workspace_id`, `team_id`.

Esse modelo é prático, mas exige disciplina. Toda query sensível precisa filtrar pelo tenant. Toda criação precisa associar o registro ao tenant. Toda autorização precisa considerar se o actor pertence ao tenant.

O problema é que disciplina manual não escala muito bem.

## O risco dos filtros manuais

Imagine uma aplicação com `Organization`, `User`, `Project` e `Task`.

Em Phoenix com Ecto, é comum escrever:

```elixir
from t in Task,
  where: t.organization_id == ^organization.id
```

Isso funciona. O risco é esquecer o filtro em uma query nova:

```elixir
Repo.get!(Task, id)
```

Se `id` for global e alguém passar um identificador de outro tenant, você pode expor dados que não deveria. Talvez uma policy no controller impeça. Talvez não. Talvez a query esteja em um worker, uma API ou uma função interna que ninguém revisou com esse foco.

Multi-tenancy baseado em lembrança humana é frágil.

## Tenant como parte do Resource

Ash permite declarar multi-tenancy no Resource. A ideia é que o Resource saiba que seus dados pertencem a um tenant e que as actions sejam executadas dentro desse contexto.

Em vez de cada chamada decidir manualmente o filtro, o domínio carrega a informação de que aquele Resource é tenant-aware.

Isso muda o tipo de erro que você precisa evitar. Em vez de lembrar de adicionar `where organization_id == ...` em todo lugar, você precisa garantir que a action recebe o tenant correto e que o Resource está configurado para respeitá-lo.

Ainda exige cuidado, mas o cuidado fica mais centralizado.

## SaaS não é só filtro

Separar dados por organização é só uma parte do problema.

Em um SaaS real, tenant aparece em vários lugares:

- criação de registros;
- listagens;
- relatórios;
- permissões;
- integrações externas;
- billing;
- auditoria;
- webhooks;
- tarefas assíncronas;
- importação e exportação de dados.

Se o tenant é apenas um parâmetro solto em queries, cada uma dessas áreas precisa repetir a mesma regra. Quando o tenant faz parte do contrato do domínio, fica mais natural exigir essa informação em toda operação relevante.

Isso também conversa com policies. Não basta a query filtrar por organização; o actor também precisa ter permissão dentro daquela organização. Multi-tenancy responde "qual espaço de dados?". Autorização responde "quem pode fazer o que dentro desse espaço?".

As duas coisas se complementam.

## Actor, tenant e contexto

Em Ash, operações frequentemente carregam contexto: actor, tenant e outros dados necessários para executar a action corretamente.

Em um SaaS, o actor pode ser o usuário logado. O tenant pode ser a organização ativa. A action pode ser `:create_project`, `:archive_task` ou `:list_open_tickets`.

Essa combinação evita ambiguidades comuns:

- usuário pertence a mais de uma organização;
- admin interno acessa tenants diferentes;
- worker executa ação para uma organização específica;
- API token representa um tenant, não uma pessoa;
- uma tela precisa trocar de workspace.

Sem contexto explícito, é fácil uma função depender de estado global, sessão ou parâmetros implícitos. Isso deixa o código mais difícil de testar e mais arriscado em jobs assíncronos.

## Multi-tenancy e background jobs

Jobs são uma fonte comum de bugs em sistemas multi-tenant.

Na interface web, o tenant normalmente vem da sessão, do subdomínio, da URL ou do usuário logado. Em um worker, nada disso existe automaticamente.

Se um job precisa recalcular métricas de uma organização, enviar e-mails para membros ou sincronizar uma integração, ele precisa carregar o tenant de forma explícita.

Quando as actions do domínio esperam tenant, o job é forçado a passar essa informação. Isso é bom. Pode parecer mais burocrático, mas evita código que funciona no painel e falha silenciosamente no processamento assíncrono.

Em SaaS, o explícito costuma ser mais seguro.

## Escolhendo a estratégia

Ash ajuda a modelar multi-tenancy, mas não escolhe a arquitetura de dados por você.

Você ainda precisa decidir se vai usar coluna, schema, banco separado ou outra estratégia. Essa decisão depende de isolamento, custo operacional, volume de dados, requisitos de compliance e complexidade do produto.

Para muitos produtos, começar com coluna por tenant é suficiente. Para outros, especialmente com clientes grandes ou exigências fortes de isolamento, schemas ou bancos separados podem fazer sentido.

O ponto é que, qualquer que seja a estratégia, o domínio precisa saber que tenant existe.

Multi-tenancy não deve ser apenas um detalhe escondido no Repo.

## O que testar

Multi-tenancy merece testes específicos.

Eu testaria pelo menos:

- usuário de um tenant não lê dados de outro;
- criação associa registros ao tenant certo;
- update não atravessa tenant;
- jobs recebem tenant explicitamente;
- admin interno só ignora tenant quando isso é intencional;
- APIs respeitam o mesmo isolamento da interface web.

Esses testes não são burocracia. Eles protegem uma das promessas básicas de qualquer SaaS: dados de um cliente não aparecem para outro.

## Concluindo

Multi-tenancy com Ash é interessante porque traz o tenant para o contrato do domínio.

Em vez de depender de filtros manuais espalhados, você declara que certos Resources pertencem a um tenant e executa actions dentro desse contexto. Isso não remove a necessidade de boa modelagem, mas reduz uma fonte comum de erro.

Para SaaS em Elixir, esse é um dos pontos em que Ash pode pagar o custo da curva de aprendizado. Quando isolamento de dados vira regra central do produto, faz sentido que essa regra apareça no domínio, não só em queries soltas.

No [próximo post da série](/posts/2025-10-20-ash-authentication-na-pratica-login-usuario-sessao.html), vou falar sobre Ash Authentication na prática: login, usuário e sessão.
