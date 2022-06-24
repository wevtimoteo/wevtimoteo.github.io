---
title: Mais de 10 coisas para fazer antes de solicitar revisão do seu Pull Request
date: 2022-06-22 20:30:00
tags: code-review
---

_Publicado originalmente em inglês no blog da [SourceLevel.io](https://sourcelevel.io/blog/10-items-to-check-before-assigning-a-pull-request-to-someone-plus-a-bonus)._

Se você está trabalhando em um time, abrir um Pull/Merge Request é muito comum. No entanto, você já pensou em abrir um Pull/Merge Request quando está trabalhando sozinho?

Isso pode parecer sem sentido, mas eu acho que é uma excelente prática! Você pode se beneficiar de diversas formas ao revisar seu próprio Pull/Merge Request.

É sempre bom contar com os colegas para revisar seu código e encontrar trechos que passaram batido por você ou seu pair, além de compartilhar conhecimento com você. Não importa se você trabalha sozinho ou com um time, eu recomendo seguir esse checklist:

### 1. Utilize o branch alvo correto

Vamos começar pelo mais fácil e rápido: verifique se o branch alvo que seu PR vai ser mergeado, está correto.

Se você sempre se perde na hora de abrir o PR pela interface web no GitHub, eu recomendo dar uma olhada no [GitHub CLI](https://github.com/cli/cli) ou no [Hub](https://github.com/github/hub).
Ambos permitem você abrir o PR direto no seu terminal, especificando o branch base (que será o seu alvo):

```bash
$ hub pull-request -b meu-branch-alvo
```

Esse comando vai abrir o editor definido na variável ambiente `$EDITOR`, você só precisará definir o título do PR e a descrição.

Ou se preferir, utilizando [a ferramenta mais recente do GitHub (GitHub CLI `gh`)](https://github.com/cli/cli):

```bash
$ gh pr create -b meu-branch-alvo
```

Esse comando vai te perguntar direto no terminal quais são os metadados do PR.

### 2. Mostre seu rascunho

Eu já vi diversas pessoas desenvolvedoras abrindo PRs apenas quando o trabalho está quase pronto (ou até só quando está pronto). Eu recomendo [abrir os PRs em `Draft`](https://docs.github.com/pt/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests#draft-pull-requests) logo depois de fazer o primeiro commit. Isso permite acompanhar seu progresso e alimentar ferramentas de métricas de código (como a [SourceLevel](https://sourcelevel.io)), além de obter feedback do seu time antes da sua solução estar pronta.

Quando for escrever uma descrição, faça uma pequena checklist para deixar explícito o quanto você avançou naquela solução. Eu gosto bastante dessa ideia porque ela deixa muito mais claro o que você precisa fazer como próximo passo e seus colegas também podem te apoiar caso já tenham feito algo parecido em um passo que esteja pendente.

Você também pode utilizar o `hub` para abrir PRs direto em Draft com a opção `-d`:

```bash
$ hub pull-request -b meu-branch-alvo -d
```

E no `gh`:

```bash
$ gh pr create -b meu-branch-alvo -d
```

### 3. Vamos falar de código!

Vamos assumir que você abriu um PR em rascunho, mas e o código? O que você deve revisar antes de pedir para o seu time revisar?

Eu recomendo começar com os mais fáceis sempre:

- Erros de digitação
- Notações `TODO` ou `NOTE`
- Comentários no código
- Chamadas `print`/`puts`
- Linhas duplas em branco
- Espaços em branco no final de linhas ou de arquivos

Você pode configurar seu editor para evitar esse último item, procure por [`remove trailing spaces in <seu editor favorito>`](https://letmegooglethat.com/?q=remove+trailing+spaces+in+vim). **Acredite em mim:** isso economiza muito tempo ao salvar um arquivo e já remover esses espaços automaticamente.

### 4. Dê nomes apropriados

Algumas pessoas desenvolvedoras investem muito tempo nomeando módulos, classes, variáveis e assim por diante. Normalmente, eu começo com um nome que parece bom e no final do ciclo de desenvolvimento eu o reviso, sempre aparecem melhores opções. Então não se esqueça de revisitar seu código e nomeá-los devidamente.

Quando nomear as coisas, imagine que você é a "coisa" e se o nome que você escolheu corresponde com a semântica do que você está fazendo.

### 5. Peça ajuda de ferramentas

Seus colegas de trabalho não estão disponíveis o tempo todo para você ou até se você trabalha sozinho, você deveria se beneficiar de **Linters**! Eles podem ser muito mais úteis que você imagina!

Linters são ferramentas que analisam seu código para identificar erros, warnings, convenções de estilo e questões de complexidade de código. Por exemplo, no [Ruby](https://www.ruby-lang.org/), existe o [Rubocop](https://github.com/rubocop-hq/rubocop); no [Elixir](https://elixir-lang.org/), existe o [Credo](https://github.com/rrrene/credo).

Usar linters é uma forma excelente de [reduzir e prevenir o débito técnico na sua base de código](https://sourcelevel.io/blog/6-practices-to-use-linters-to-reduce-and-prevent-technical-debt). Comece com algumas regras e vá adicionando conforme sentir necessidade no arquivo de configuração do linter.

No entanto, sempre lembre de discutir essas regras com seu time antes de se comprometer com elas. Evite falar sobre regras de linters em um Pull Request (a não ser que seja um PR dedicado a isso). **Mova essa discussão** para um lugar (como as issues) onde você possa coletar feedback de mais membros do time e garantir que todos estão na mesma página e estão de acordo com aquela regra.

### 6. Remova o ruído

Quando estamos desenvolvendo, é comum encontrar algum código para refatorar, fazer aquele trabalho de jardinagem, utilizar o estilo de codificação da base de código, ou remover aquele parênteses desnecessário. Para esses casos, eu recomendo evitar fazer essa mudança se estiver fora do contexto do que você está modificando.

Eu sei que muitas vezes é difícil de evitar corrigir ou ajustar (já que aquele código está logo ali), mas tenha em mente que você sempre pode abrir um Pull Request separado para essas mudanças. E nele, explicar as razões e prover informações adicionais porque aquela mudança é necessária.

Por que fazer isso? Porque ao adicionar código não-relacionado vai aumentar a complexidade para a pessoa revisora. Mais informações fazem com que o processo seja mais detalhado e **menos código não-relacionado** faz com que o processo de revisão seja mais preciso e mais focado no contexto exigido.

Se você encontrar alguma modificação que fez durante o desenvolvimento e não queria descartar na hora de commitar, você deveria dar uma olhada no comando [`git stash`](https://git-scm.com/docs/git-stash).

### 7. Traga apenas o necessário do banco de dados

Se suas mudanças envolvem trazer dados do banco de dados, você deveria especificar apenas as colunas que você precisa. Pode ser caro sempre trazer dados que são irrelevantes para o seu uso do banco de dados. Tenha em mente que isso vai obrigar utilizar mais recursos na linguagem de programação utilizada também, como maior retenção de objetos/estruturas de dados, aumentando o consumo de memória da aplicação.

### 8. Entenda "Mergeabilidade"

Alguns PRs são mais fáceis de mergear (integrar ao branch alvo) que os outros. Como definir se um PR é aceitável para ser mergeado?

Vários times obrigam que os Pull Requests passem um conjuntos de verificações para saber se eles estão elegíveis para serem mergeados. Isso é interessante para aumentar a confiabilidade da mudança que está sendo integrada e que não vai quebrar no branch alvo.

As verificações normalmente incluem:

- Branches protegidos
- Obrigar revisão de código
- Assinatura de commits via chaves GPG
- Histórico linear de alterações
- Incluir status checks específicos, como build de testes

O último item poderia ser obrigatório: o commit status checks indicam se a ferramenta integrada (como o GitHub Actions ou alguma revisão de código automatizada) passou a cada push . Você pode [configurar seu repositório para obrigar cada um deles](https://docs.github.com/pt/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule). Assim apenas push "verdes" estão bons para serem integrados no branch alvo!

## Terminou?

Bom trabalho se você chegou até aqui no seu checklist e seguiu todas as instruções. Agora é hora dos últimos e não menos importantes: melhorias nos metadados do Pull Request.

### 9. Passe a mensagem correta

Tudo que é essencial deve ir para descrição do seu PR. Pense que essa descrição deve guiar os revisores sobre o contexto das mudanças, dê o seu melhor para explicar porquê elas estão lá.

Você deve verificar todos os itens se você abriu seu PR como `Draft`. Considere até [transformar em um modelo para futuros Pull Requests](https://docs.github.com/pt/communities/using-templates-to-encourage-useful-issues-and-pull-requests/creating-a-pull-request-template-for-your-repository). Se você precisa de um modelo bem simples, recomendo utilizar o da [SourceLevel](https://github.com/sourcelevel/guidelines/blob/main/.github/pull_request_template.md).

Algumas outras coisas interessantes que você pode incluir na descrição do PR:

- Instruções sobre "Como testar" aquelas mudanças
- O que não é parte daquele PR (qualquer coisa não relacionada com o trabalho que você gostaria que todos soubessem)
- O que pode ser melhorado no futuro (considere até criar uma issue e referenciá-la no seu PR)
- Documentações e referências (lembre-se que PR também é documentação e pode ser muito útil para você e seu time no futuro)
- Lista de referências para issues existentes ou outros PRs (caso você queira enriquecer ainda mais o contexto e deixar a base de PRs e issues cada vez mais rica com informações)
- [Snippets de código de outros branches](https://docs.github.com/pt/get-started/writing-on-github/working-with-advanced-formatting/creating-a-permanent-link-to-a-code-snippet)

### 10. Adicione screenshots

Screenshots são ótimas para mostrar como aquela mudança afeta o visual de uma página ou componente. Se você possui mais de uma screenshot, considere utilizar uma seção com a tag `<details>`:

```ruby
<details>
<summary>Screenshot oculta</summary>

![alt text](https://example.com/image.png)
</details>
```

Isso vai fazer com que a imagem fique escondida dessa maneira:

<img src="%media:/images/pull-request-screenshot.png" alt="Exemplo de imagem dentro da tag details">

Sinta-se à vontade para usar a tag `<details>` para um GIF ou um vídeo.

### 11. Encontre seu PR no futuro

Pessoas tendem a esquecer que elas podem consultar o histórico de PRs para tirar dúvidas sobre como aquela funcionalidade ou bugfix foi construída e porquê. Se você nunca olha um PR antigo em uma hora dessas, **talvez você esteja perdendo informações úteis**.

Já teve algum problema encontrando um PR específico? Então utilize `labels` melhores para classificá-los. Precisa de sugestão de algumas? Tente essas:

- dependency
- documentation
- expedite
- feature
- good first patch
- ready for test, in test, test done
- security
- tech debt
- unplanned

Use sua criatividade para identificar labels atrativas que podem ajudar você e seu time encontrar issues e PRs com elas.

### 12. Utilize comentários inline nas suas próprias mudanças

Comente na linha ou trecho de código qualquer fato interessante que você sinta necessidade de compartilhar. Por exemplo, você pode mencionar sobre aquele método da API da linguagem de programação que você acabou de descobrir, isso pode fazer várias discussões interessantes surgirem, talvez até sugestões melhores.

## É isso aí!

Parabéns 🎉! Fez alguma mudança no PR desde que você tinha considerado ele como "Pronto" depois desse checklist?

Agora é hora de fazer um **rebase** e garantir que está tudo atualizado e então, finalmente, **pronto para pedir revisão do seu time**!

Obrigado pela leitura ;)

Você aprendeu algo novo revisando o seu próprio código? [Compartilhe comigo](https://www.twitter.com/wevtimoteo)!
