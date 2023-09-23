---
title: Tomando notas como desenvolvedor de software
date: 2023-09-23 00:50:00
tags: notes
---

Me arrependo profundamente de não tomar notas mais cedo. As notas até existiam, mas geralmente eram coisas pontuais para executar uma tarefa ou algo interessante que encontrei que meses depois eram só anotações "sem utilidade".
Fico pensando se eu tivesse um mapa de tudo que eu aprendi e experienciei na vida transcrito de uma maneira organizada que eu possa consumir para gerar novas ideias e, finalmente, eu tenho.

Recentemente li o livro [Criando um Segundo Cérebro](https://amzn.to/3PMEizK) do Tiago Forte e me ajudou bastante a tirar essa ideia de organização perfeita e simplesmente começar a anotar. Meu processo de começar a tomar notas para valer se deu nas seguintes etapas:

- Qual melhor app/software para tomar notas?
- O que anotar?
- Como organizar minhas notas?
- Como anotar rápido?

Só depois que "resolvi" esses pontos que senti que estava pronto para escrever para valer e aí a coisa começou a andar.

## Qual o melhor app/software para tomar notas?

Como tudo: depende. E depende para cada pessoa. Cada solução terão vantagens e desvantagens, antes precisei escrever o que era mais importante para mim para poder decidir:

- Um app leve (não necessariamente nativo, um [electron](https://github.com/electron/electron) resolveria)
- Suporte a Backlinks (lista onde a nota em questão foi citada)
- Queria estrutura de pastas (para organização que eu estava pensando fazia sentido)
- De graça
- Os arquivos são meus (não estão em uma cloud ou requere alguma funcionalidade de exportação para acessá-los)
- Possibilidade de estender e customizar (caso eu queira desenvolver um plugin para atender um fluxo específico meu)
- Arquivos de anexos centralizados (não queria guardar em uma cloud à parte)
- Não tinha necessidade de colaborar (editar a nota ao mesmo tempo que alguém)

### [Notion](https://notion.so/)

- Requisito de estar sempre conectado
- Fácil de se tornar algo mais complexo com funcionalidades de tabelas, banco de dados, fórmulas
- Não possui suporte para backlinks
- Acho o sistema de anexos muito lento para renderizar arquivos estáticos
- Tenho a sensação do app ser muito pesado o que dificultava minha navegação

### [Logseq](https://logseq.com/)

- App super leve
- Open Source (esse item pesa bastante)
- Tudo é um bullet point (uma `<li>` dentro de uma `<ul>` para desenvolvedores web)
- Não existe organização por diretórios, apenas um "All notes"
- Bem fácil para anotar no formato diário (Journaling)

### [Roam](https://roamresearch.com/)

- App/Serviço Pago
  - Porém existe localização de preço para brasileiros (é necessário entrar em contato)

### [Obsidian](https://obsidian.md/)

- Comunidade bem forte
- Diversos plugins
- App leve
- Fácil de customizar e extender
- Fácil de gerir arquivos estáticos (attachments/anexos)
- Visão de grafo é interessante mas não muito útil

---

Dentre esses acabei optando pelo Obsidian, inclusive esse blog post está sendo escrito nele. Gosto bastante de como é possível configurá-lo para ficar no fluxo de edição mais favorável ao que estou acostumado, inclusive com Vi keys para quem curte o editor [Vim](https://www.vim.org/) (quando digo editor Vim, já me refiro ao [Neovim](https://neovim.io/)).

## O que anotar?

Como você deve ter imaginado, isso não existe. O importante é:

- anote de uma maneira que você entenda o contexto rapidamente
- a nota tem que ter alguma utilidade para você: se anotar quantos PRs (Pull Requests) você abriu no dia é importante, é melhor usar a [SourceLevel](https://sourcelevel.io/) ao invés de ficar metrificando coisas manualmente.

Falando da rotina de uma pessoa desenvolvedora de software eu gosto de anotar:

### Reuniões

É muito comum, durante a daily diversas pessoas citarem ferramentas, tecnologias, nomes e/ou empresas que você nunca ouviu falar. Não precisa ser algo bem preciso, principalmente se for uma reunião presencial, mas é legal transcrever pontos importantes daquela reunião para depois você saber de onde conheceu uma determinada tecnologia ou uma empresa.

Acho também interessante para reuniões de 1:1s ou de Performance, para saber o que já foi dito em reuniões passadas e até para fazer o follow up da sugestão e até dos elogios.

### Sessão de Debugging

Durante um debugging eu gosto de transcrever o problema que estou tendo e já não estou conseguindo resolver, como por exemplo, uma exception.

Então sempre que eu tenho um problema, verifico primeiro no meu sistema de notas. Esses dias precisei adicionar uma variável ambiente em um cluster [Kubernetes](https://kubernetes.io/). Utilizando o `kubectl` eu não lembrava qual o comando para fazê-lo, mas bastou uma busca rápida no meu sistema de notas e ali estava um tutorial de como fazer isso (para quem ficou interessado o comando é `kubectl set env deployment/<seu-deployment> MY_ENV_CONFIG=<valor da config>`).

Esse tipo de coisa, não só cataloga os problemas que estou tendo, mas pode ajudar um colega de time quando tem algum problema parecido. Bastaria copiar o [Markdown](https://www.markdownguide.org/) e colar o conteúdo para a pessoa. Outro ponto interessante é que pode me levar a escrever um blog post de maneira muito rápida, só pegando partes das minhas notas.

### Discovery/Aprendizado

Comecei recentemente a estudar o [Pulumi](https://www.pulumi.com/) como alternativa ao [Terraform](https://www.terraform.io/), então fui detalhando tudo que descobri em poucos itens de forma resumida. Como por exemplo, formatos disponíveis para descrever a infraestrutura (NodeJS, Python, etc), precificação e como o modelo de créditos funciona.

Esse tipo de nota me ajuda muito a ajudar também outras pessoas que estão nessa etapa de aprendizado e até para conversar em uma reunião sobre determinada ferramenta e ir levantando potenciais dúvidas para serem resolvidas.

### Consumo de conteúdo

Agora quando eu leio algum blog post, cadastro no sistema de notas e transcrevo algumas partes importantes dele. Com a leitura do livro _Criando um Segundo Cérebro_, que citei no início do texto, aprendi a utilizar <strong>bold/negrito</strong> nos textos e também dar highlight no resumo do resumo. Isso também se aplica aos vídeos do YouTube, você pode clicar nas reticências (`...`) -> `Mostrar transcrição`. Tudo bem que é uma transcrição gerada, mas já ajuda a salvar trechos do vídeo para serem buscados no futuro.

## Como organizar as notas?

Primeira coisa que aprendi para destravar essa pergunta foi: **não existe organização de diretórios e tags perfeitos**. Sendo assim, pensei em como reduzir o meu estrago, para isso acabei adotando o sistema proposto pelo Tiago Forte, chamado **PARA**:

- **Projetos:** Algo que você está trabalhando no momento, existe início e uma data de fim
- **Áreas:** Algo que você está trabalhando continuamente, por exemplo, um cuidado de uma doença genética ou um almoço com um familiar que você tem o planejamento de sempre conhecer um lugar diferente
- **Recursos:** Aqui vai todo o restante, eu penso nele como um "banco de dados" das minhas notas e ultimamente ela tem virado meio que uma Wiki pessoal. Lá consigo ter listagem de jogos que já joguei, séries que já assisti, etc.
- **Arquivo:** Tudo que teve um término (independente do que era originalmente), se foi encerrado, ele vem para esse diretório.

Se você utilizar Logseq, recomendo dar uma olhada [na extensão](https://github.com/georgeguimaraes/logseq-plugin-add-PARA-properties) que o [George Guimarães](https://twitter.com/georgeguimaraes) desenvolveu que utiliza o sistema PARA.

O Tiago Forte recomenda inclusive enumerar cada um deles para facilitar o mention e acesso. Então ficaria:

1. Projetos
2. Áreas
3. Recursos
4. Arquivo

Se você não tem uma organização em mente, recomendo fortemente ir por essa e depois deixar seu sistema de gestão de conhecimento pessoal tomar forma organicamente.

## Como anotar rápido?

Pense em não perder as ideias, não tem problema ter algum erro de digitação ou não ter muito detalhamento enquanto você está anotando algo (por exemplo, durante uma reuniã
