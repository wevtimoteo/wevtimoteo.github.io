---
title: Ash Authentication na prática: login, usuário e sessão em Phoenix
date: 2025-10-20 09:00:00
tags: ash, ashframework, elixir, phoenix, authentication, ptbr
---

Autenticação é uma parte estranha das aplicações web. Todo produto precisa, quase todo framework oferece algum caminho, e mesmo assim é fácil errar detalhes.

Usuário, senha, hash, confirmação de e-mail, reset de senha, sessão, token, login social, API key, expiração, revogação. Nada disso é exatamente regra de negócio do produto, mas tudo isso sustenta o acesso ao produto.

No ecossistema Ash, [Ash Authentication](https://ash-authentication.hexdocs.pm/) tenta trazer autenticação para o mesmo modelo declarativo dos Resources. A ideia é declarar como um Resource representa um usuário autenticável e quais estratégias de autenticação existem.

Não é simplicidade mágica. Ainda há decisões importantes. Mas a abordagem ajuda a padronizar uma área que costuma ficar cheia de exceções.

## Autenticação vs autorização

Antes de falar de Ash Authentication, vale separar dois conceitos.

Autenticação responde: "quem é essa pessoa ou sistema?".

Autorização responde: "o que essa pessoa ou sistema pode fazer?".

Login, senha e sessão estão no primeiro grupo. Policies, roles e permissões estão no segundo.

Essa separação importa porque é comum misturar tudo em uma função só. Você autentica o usuário e já decide se ele pode acessar determinada tela. Em sistemas pequenos, isso passa. Em sistemas maiores, vira acoplamento.

Ash Authentication cuida principalmente da identidade: como um usuário prova quem é. Ash Policies cuidam das permissões sobre Resources e actions.

## O usuário como Resource

Em uma aplicação Ash, o usuário normalmente também é um Resource.

Isso é interessante porque o usuário deixa de ser um schema especial perdido em outra parte do sistema. Ele participa do mesmo modelo de domínio: attributes, actions, validations, identities e policies.

Um Resource `User` pode ter campos como:

- e-mail;
- senha com hash;
- status;
- timestamps;
- informações de confirmação;
- dados de perfil.

A parte de autenticação define como esse Resource pode autenticar alguém. Por exemplo, com estratégia de senha, token mágico ou integração externa.

O ganho é que autenticação fica declarada no mesmo estilo do restante do domínio.

## Login com senha

O caso mais conhecido é login com e-mail e senha.

Em um sistema manual, você precisa implementar:

- cadastro;
- hash de senha;
- validação de credenciais;
- busca por e-mail;
- criação de sessão;
- logout;
- reset de senha;
- confirmação de e-mail, se existir;
- tratamento de erros.

Phoenix já oferece bons geradores para autenticação tradicional. Para muitas aplicações, eles são suficientes.

Ash Authentication fica mais interessante quando você quer que o fluxo de autenticação se integre ao modelo Ash, usando Resources, actions e estratégias declarativas.

Em vez de espalhar partes do fluxo entre controller, context e schema, você declara no Resource como aquele usuário autentica.

## Sessão em Phoenix

No fim do dia, uma aplicação Phoenix ainda precisa saber quem está logado em uma request ou LiveView.

Isso normalmente envolve sessão, cookies, plugs e assigns. Ash Authentication não remove essa camada. Ele se integra com Phoenix para transformar uma autenticação bem-sucedida em algo que a aplicação consegue usar, como o usuário atual.

Em uma aplicação web, o fluxo conceitual é:

1. usuário envia credenciais;
2. estratégia de autenticação valida os dados;
3. o sistema encontra ou cria a identidade autenticada;
4. Phoenix persiste a sessão;
5. requests futuras carregam o usuário atual;
6. actions do domínio recebem esse usuário como actor.

O último passo é importante. O usuário autenticado vira actor para autorização. Ou seja, login não é o fim do fluxo. Ele é a base para policies decidirem o que pode acontecer depois.

## Tokens e APIs

Nem toda autenticação é sessão de navegador.

APIs, clientes mobile, integrações e workers podem precisar de tokens. Alguns tokens representam usuários. Outros representam sistemas. Alguns expiram rápido. Outros precisam ser revogados.

Ash Authentication tem suporte para estratégias e tokens dentro do ecossistema Ash, mas a decisão de produto continua sua: qual token usar, quanto tempo dura, como revogar, como auditar, como tratar vazamento.

Para mim, o principal ganho de uma abordagem declarativa é padronizar onde essas decisões aparecem. Em vez de cada endpoint ter uma interpretação própria de token, o fluxo de autenticação pode ser descrito de forma mais consistente.

Isso também facilita a conversa com autorização. Depois que o token identifica um actor, as actions do domínio ainda precisam decidir se aquele actor pode executar a operação.

## LiveView e usuário atual

Em Phoenix LiveView, autenticação costuma aparecer no `mount`, nos hooks ou em plugs que preparam a sessão.

O objetivo é que a LiveView saiba quem é o usuário atual e passe essa informação para operações do domínio.

Com Ash, isso geralmente significa chamar actions com actor. A LiveView não deveria duplicar regras de permissão. Ela pode esconder botões e melhorar mensagens, mas a action precisa continuar protegida.

Esse modelo evita uma armadilha comum: a tela parece segura porque não mostra determinada ação, mas uma chamada direta ainda conseguiria executá-la.

Autenticação identifica. Policies autorizam. LiveView apresenta.

## O que não fica automático

Mesmo usando Ash Authentication, você ainda precisa tomar decisões.

Algumas delas:

- qual estratégia de login usar;
- se e-mail precisa ser confirmado;
- como reset de senha funciona;
- quanto tempo uma sessão dura;
- como lidar com logout em múltiplos dispositivos;
- como auditar login;
- como tratar contas bloqueadas;
- quais fluxos precisam de MFA;
- como tokens de API são emitidos e revogados.

Framework nenhum deveria decidir tudo isso sozinho. Essas escolhas dependem do produto, do risco e dos usuários.

O papel do Ash Authentication é oferecer estrutura para implementar essas decisões com menos código solto.

## Quando eu usaria

Eu consideraria Ash Authentication quando a aplicação já usa Ash para o domínio principal.

Nesse cenário, faz sentido que `User` também seja um Resource, que autenticação se integre ao actor usado por policies e que o fluxo siga as mesmas convenções do restante da aplicação.

Se a aplicação é Phoenix simples, com poucos requisitos e sem Ash no domínio, talvez o gerador padrão de autenticação do Phoenix seja mais direto.

Como quase sempre, a resposta depende do custo de adoção. Ash Authentication brilha quando ele reduz divergência e encaixa em uma arquitetura Ash já existente.

## Fechando

Ash Authentication não transforma autenticação em um detalhe irrelevante. Login, sessão e token continuam sendo partes sensíveis da aplicação.

O que ele oferece é uma forma de declarar autenticação junto ao domínio Ash, conectando usuário, estratégia, sessão e actor de maneira mais padronizada.

Para aplicações Phoenix que já apostam em Ash, isso pode reduzir bastante código repetido e deixar mais clara a linha entre identidade e permissão.
