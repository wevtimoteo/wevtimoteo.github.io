---
title: Anotando: Plugins da comunidade que utilizo no Obsidian
date: 2023-10-09 12:00:00
tags: notes
---

Na [postagem passada](Anotando%20-%20Plugins%20embutidos%20que%20utilizo%20no%20Obsidian.md), eu mostrei quais plugins embutidos do [Obsidian](https://obsidian.md) eu deixo ligado e porquê. Agora é a hora de começar a montar o restante do fluxo de anotações utilizando os plugins da [comunidade](https://obsidian.md/community).
Todos que eu vou mostrar nessa lista estão disponíveis no GitHub. Para instalar qualquer um deles, basta abrir as preferências do Obsidian (Cmd + ,) > `Community Plugins` e clicar no botão `Browse`.
Você também pode utilizar essa página para descobrir alternativas aos que eu vou mostrar aqui.

### [Advanced tables](https://github.com/tgrosinger/advanced-tables-obsidian)

Adiciona diversas melhorias para **navegar e manipular tabelas**. É possível criar tabelas em [Markdown](https://www.markdownguide.org/) utilizando a seguinte estrutura:

```
| Nome     | Descrição  |
| -------- | ---------- |
| Weverton | Autor      |
| Fulano   | Leitor     |
```

Como você pode perceber, é muito comum aparecer um valor com um texto mais longo que alguma célula existente, se isso acontecer, **todas as colunas precisariam ser ajustadas** (o mesmo aconteceria se alguma coluna precisasse ser adicionada ou renomeada).
Com esse plugin é possível:

- formatar alinhamento do texto
- mover células (cima, baixo, direita e esquerda)
- adicionar linhas ou colunas
- ordenar por ordem alfabética ou uma função personalizada
- exportar para CSV

#### Exemplo de uso:

![Demo do Advanced Tables](https://raw.githubusercontent.com/tgrosinger/advanced-tables-obsidian/main/resources/screenshots/basic-functionality.gif)
Por mim, só de não precisar ficar editando manualmente esses espaços, já vale o uso da extensão!

### [Advanced URI](https://github.com/Vinzent03/obsidian-advanced-uri)

Permite você controlar várias funcionalidades do Obsidian apenas abrindo algumas URIs, como tudo é texto você não precisa ficar utilizando o mouse ou atalhos de teclado.
Acho ótimo para automatizar o workflow, como:

- abrir, editar ou criar arquivos
- abrir workspaces
- navegar para títulos dentro do arquivo (como um sumário ou uma página index para determinada categoria)
  A lista completa de ações está disponível [aqui](https://vinzent03.github.io/obsidian-advanced-uri/actions).

### [cMenu](https://github.com/chetachiezikeuzor/cMenu-Plugin)

Algumas vezes você só quer selecionar o texto e formatar de maneira rápida, mas, para quem está começando com o Markdown, pode ser desafiador memorizar todos os marcadores de formatação. Eu mesmo, dificilmente, vou lembrar como fazer algo como 2<sup>2</sup> no dia-a-dia.
Só de utilizar a barra de ferramentas do plugin consigo ver que se trata de um `2<sup>2</sup>`, por exemplo.
![Demo cMenu](https://raw.githubusercontent.com/chetachiezikeuzor/cMenu-Plugin/master/assets/cMenu.gif)

### [Dataview](https://github.com/blacksmithgu/obsidian-dataview)

Uso para organizar algumas notas como se fosse um "banco de dados", por exemplo, para listar todas as notas de determinada pasta para formar minha página "Wishlist do Nintendo Switch".
É ótimo para organizar também tasks e notas com algumas tags específicas, no `README` do projeto existem diversos exemplos com diversas aplicações.

### [Find orphaned files and broken links](https://github.com/Vinzent03/find-unlinked-files)

Eu sou do tipo de pessoa que gosta de linkar tudo. Assim consigo ter um backlink super completo das notas que eu visito. Então, sempre que sobra um tempinho ou quando revisito uma nota antiga, acabo dando uma olhada se não existe nenhum arquivo vazio ou sem link para ele.

### [Highlightr](https://github.com/chetachiezikeuzor/Highlightr-Plugin)

Utilizando a técnica que eu descrevi no [primeiro blog post](Tomando%20notas%20como%20desenvolvedor%20de%20software.md) dessa série, quando eu compilo alguma leitura ou algum texto que preciso sintetizar, utilizo o **negrito** para as partes mais importantes e utilizo esse plugin para marcar com uma espécie de marca texto o destaque do destaque. Assim consigo obter aquele ideal de abrir uma nota e em até 30 segundos extrair toda info necessária dela (via dica do livro [Criando um Segundo Cérebro)](https://amzn.to/3LIXoEk).

### [Icon Folder](https://github.com/FlorianWoelki/obsidian-iconize)

Apenas para dar uma melhorada na aparência da minha sidebar, com esse plugin consigo adicionar ícones para os ítens do topo da árvore de diretórios. Não utilizo para subitems para evitar que eu gere muita poluição visual ao navegar pelas subpastas e me perder na semântica de cada uma delas.
![Ícones Obsidian](/assets/images/obsidian_left_sidebar_with_icons.jpg)

### [Image Toolkit](https://github.com/sissilab/obsidian-image-toolkit)

Infelizmente, ao abrir ou linkar uma imagem no Obsidian, não é possível dar zoom nela. Esse plugin não só adiciona um lightbox para toda imagem linkada, como também dá a opção de redimensionar, editar, aplicar filtros e até girar a imagem. Recomendo seu uso, principalmente se você adiciona muitas imagens e excedem a largura do que é considerado legível, assim você redimensiona a imagem e se precisar ver mais detalhes basta clicar nela.
Para diminuir o tamanho de uma imagem no Markdown, você pode utilizar essa sintaxe:

```
![|500](link_para_imagem.jpg)
```

O `|500` dentro da "descrição" da imagem, indica para o Markdown, limitar a imagem para 500px de largura.

### [Obsidian Memos](https://github.com/Quorafind/Obsidian-Memos)

Esse plugin cobriu muito bem a função de Journaling para mim. Acho muito prático para já adicionar timestamps nas minhas anotações daquele dia sem precisar abrir o dia atual e fazê-lo manualmente.
Além disso, sou incentivado a anotar na estrutura de bullet points, parecido com o [Logseq](https://logseq.com/). Acho bacana porque de brinde acabo ganhando a feature de azulejos verdes do GitHub:
![](/assets/images/github_wall_like.jpg)

### [Obsidian TODOs | Text-based GTD](https://github.com/larslockefeer/obsidian-plugin-todo)

Indo na contramão da recomendação, tenho alguns "TODOs" no meu sistema de notas, mas geralmente esses TODOs são coisas que eu gostaria de fazer um dia e que não me impactam caso eu não os faça. Como, por exemplo, ideias de blog posts para escrever.
O plugin permite ter um rastreamento de todos os TODOs que eu possuo no meu sistema de notas. O que é bacana porque eu também ganho uma área na sidebar da direita para visualizar todas as tarefas que citei na nota que eu estou editando/visualizando.

### [Remotely-save](https://github.com/remotely-save/remotely-save)

Citei esse plugin no primeiro blog post também: com ele você consegue sincronizar suas notas utilizando o S3, Dropbox, OneDrive e etc. É uma ótima alternativa se você não quer pagar pelo serviço [Obsidian Sync](https://obsidian.md/sync).
Algumas pessoas relataram que utilizam Git para armazenar suas notas em algum repo, acho bem vantajoso pelo controle que conseguimos ter no versionamento das notas. Não tomei esse caminho porque não gostaria de adicionar um overhead para manter meu sistema de notas precisando fazer um commit para cada anotação que eu faço. Caso contrário, perderia a praticidade de simplesmente anotar e deixar o sync acontecer tanto no Desktop quanto no mobile.

### [Super Simple Time Tracker](https://github.com/Ellpeck/ObsidianSimpleTimeTracker)

Para algumas tarefas, consigo ter mais foco quando coloco um timer, ter isso no sistema de notas, não só documenta no que eu trabalhei no dia (bem útil para freelancers) como também me permite gerir melhor as pausas, caso eu queira utilizar alguma técnica como o [Pomodoro](https://pt.wikipedia.org/wiki/T%C3%A9cnica_pomodoro).
Recomendo utilizar esse plugin caso você precise desse tipo de rastreamento nas atividades durante o dia, costumo usar combinado com o plugin `Obsidian memos` porque consigo manter os timers dentro das notas diárias onde fiz aquela tarefa.

## Próximos passos

- Existem duas iniciativas da comunidade do Obsidian, voltadas para criação/divulgação de plugins, uma delas é o [Plugin Stats](https://obsidian-plugin-stats.vercel.app/), que permite visualizar os plugins em trending, mais baixados, com tags específicas e etc.
- E existe o vault (que é um dos cofres de notas) chamado [Obsidian Hub](https://publish.obsidian.md/hub/02+-+Community+Expansions/02.01+Plugins+by+Category/%F0%9F%97%82%EF%B8%8F+02.01+Plugins+by+Category), voltado para listar os plugins por categoria.
- Um outro caminho para encontrar novos plugins, é explorar o `Browse` da aba `Community plugins` na janela de configurações do Obsidian (que eu citei no início do post).
