---
title: Vale a pena usar Ash em produção? Prós, contras e curva de aprendizado
date: 2025-11-03 09:00:00
tags: ash, ashframework, elixir, phoenix, ptbr
---

Depois de falar sobre Resources, actions, policies, LiveView, multi-tenancy, autenticação, calculations e aggregates, sobra a pergunta mais importante:

Vale a pena usar [Ash Framework](https://ash-hq.org/) em produção?

A resposta honesta é: depende do tipo de aplicação, da equipe e do tamanho do domínio.

Eu não colocaria Ash na categoria de "use sempre". Também não colocaria na categoria de "complexidade desnecessária". Ele resolve problemas reais, mas cobra um preço real: curva de aprendizado, mudança de mentalidade e mais uma camada para entender.

## O que Ash faz muito bem

O maior mérito do Ash é tornar o domínio mais explícito.

Em aplicações Phoenix tradicionais, muita coisa depende de convenção: contexts bem nomeados, changesets bem separados, queries reutilizadas, autorização aplicada nos lugares certos, filtros de tenant lembrados em toda chamada.

Isso funciona quando a equipe é disciplinada e o domínio ainda está pequeno. Mas conforme o sistema cresce, regras importantes começam a se espalhar.

Ash oferece um modelo para concentrar essas regras em Resources e actions. O Resource diz quais atributos existem. As actions dizem quais operações fazem sentido. Policies declaram autorização. Calculations e aggregates dão nome para dados derivados. Multi-tenancy deixa de ser apenas um filtro manual.

Esse conjunto cria um contrato mais visível.

## Produtividade

Ash pode aumentar produtividade, mas não necessariamente no primeiro dia.

No começo, você vai gastar tempo entendendo a DSL, lendo documentação, errando modelagem e descobrindo onde cada regra deve viver. Esse investimento é real.

O ganho aparece quando o domínio começa a repetir padrões:

- formulários baseados em actions;
- APIs que respeitam o mesmo contrato;
- autorização reaproveitada;
- multi-tenancy consistente;
- operações de negócio nomeadas;
- menos código duplicado entre LiveView, API e workers.

Quando isso acontece, Ash deixa de ser "mais uma coisa" e vira uma base comum.

Mas se a aplicação tem três tabelas, CRUD simples e uma única interface administrativa, talvez você nunca recupere o custo inicial.

## Curva de aprendizado

Ash exige aprender conceitos próprios.

Você precisa entender Resources, Domains, actions, changes, validations, preparations, policies, data layers, actors, tenants e extensões. Mesmo para quem já conhece Elixir e Phoenix, não é só "mais uma lib".

Também existe uma mudança de estilo. Parte da lógica deixa de aparecer como funções comuns e passa a aparecer como declaração. Isso pode ser ótimo para padronização, mas pode incomodar quem prefere fluxo explícito em código Elixir puro.

O risco não é só individual. É de equipe.

Se apenas uma pessoa entende Ash, a aplicação fica vulnerável. Se a equipe inteira entende a abordagem, o ganho aparece. Por isso, eu teria cuidado ao adotar Ash em uma equipe que ainda está aprendendo Elixir, Phoenix e Ecto ao mesmo tempo.

## Documentação e ecossistema

Ash tem documentação extensa e um ecossistema ativo, mas a quantidade de conceitos pode assustar.

Esse é um ponto ambíguo. Documentação grande é boa porque cobre muitos cenários. Ao mesmo tempo, para quem está começando, pode ser difícil saber qual parte ler primeiro.

Além do pacote principal, existem integrações como AshPostgres, AshPhoenix, AshAuthentication e outras extensões. Isso é poderoso, mas também significa que você precisa entender a fronteira entre elas.

Em produção, esse ponto importa. Quando algo quebra, a equipe precisa saber se o problema está no Resource, na action, no data layer, na policy, na integração Phoenix ou na forma como a chamada foi feita.

Não é impeditivo. Mas não dá para adotar fingindo que a abstração não existe.

## Riscos de adoção

O primeiro risco é supermodelar.

Como Ash oferece muitos blocos, é tentador usar todos desde o começo. Resource pequeno vira arquivo grande. Action simples ganha validações, changes, policies e calculations antes da hora. A aplicação fica "correta", mas difícil de ler.

O segundo risco é tratar Ash como gerador de aplicação.

Ash ajuda a reduzir boilerplate, mas não decide produto. Você ainda precisa desenhar fluxos, escolher nomes, pensar em UX, escrever testes e entender o banco.

O terceiro risco é adoção parcial sem clareza.

Se metade do domínio passa pelo Ash e metade ignora as actions, a equipe pode acabar com dois modelos mentais competindo. Isso pode ser necessário durante uma migração, mas precisa ser uma escolha consciente.

## Onde eu consideraria usar

Eu consideraria Ash em produção quando a aplicação tem pelo menos alguns destes sinais:

- domínio rico, com operações além de CRUD;
- várias interfaces consumindo a mesma regra;
- autorização não trivial;
- multi-tenancy;
- necessidade de API pública ou GraphQL;
- muitos formulários parecidos;
- actions diferentes para o mesmo Resource;
- workers executando regras do domínio;
- equipe disposta a aprender a abordagem.

Em SaaS, especialmente, Ash fica interessante. Tenant, actor, policies e actions nomeadas aparecem naturalmente nesse tipo de produto.

Também consideraria Ash em sistemas internos grandes, onde consistência e velocidade de evolução importam mais do que evitar qualquer abstração.

## Onde eu evitaria

Eu evitaria Ash quando:

- a aplicação é pequena;
- o domínio é basicamente CRUD;
- a equipe ainda está aprendendo Phoenix e Ecto;
- o sistema depende de SQL muito específico em quase tudo;
- a equipe não quer uma DSL declarativa;
- o prazo não permite absorver a curva;
- só uma pessoa teria conhecimento para manter.

Nesses casos, Phoenix Contexts com Ecto continuam sendo uma escolha excelente. Simples, explícita e bem compreendida.

Não existe mérito em usar uma ferramenta mais poderosa se o problema não precisa dela.

## Testes continuam essenciais

Ash centraliza regras, mas não dispensa testes.

Na verdade, actions e policies pedem testes claros:

- quem pode executar a action;
- quais campos são aceitos;
- quais validações bloqueiam;
- como tenant é aplicado;
- quais calculations e aggregates retornam;
- quais efeitos colaterais acontecem.

O lado bom é que essas regras têm nomes. Testar `:publish`, `:archive` ou `:invite` costuma ser mais legível do que testar uma sequência de funções genéricas.

Se a equipe usar Ash em produção sem testes de actions e policies, está abrindo mão de uma das principais vantagens do framework.

## Minha conclusão

Eu usaria Ash em produção, mas não como reflexo automático.

Usaria quando o domínio justificar: SaaS, autorização, multi-tenancy, APIs, múltiplas interfaces e operações com nomes reais de negócio. Nesses cenários, a estrutura declarativa pode reduzir bastante ambiguidade.

Não usaria só para seguir tendência. Em aplicação pequena, Ecto e Phoenix Contexts são mais diretos e provavelmente mais baratos.

Ash muda a pergunta principal. Em vez de "como eu salvo isso no banco?", você começa a perguntar "qual operação do domínio representa isso?".

Quando essa pergunta é importante para o produto, Ash merece espaço. Quando ela ainda é simples demais, talvez seja melhor ficar com as ferramentas mais básicas.

Para mim, esse é o equilíbrio: Ash é uma boa aposta para domínios que precisam de contrato forte. Não é uma obrigação para todo projeto Elixir.
