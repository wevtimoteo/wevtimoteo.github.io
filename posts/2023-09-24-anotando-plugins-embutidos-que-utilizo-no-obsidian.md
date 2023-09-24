---
title: Anotando: Plugins embutidos que utilizo no Obsidian
date: 2023-09-24 03:00:00
tags: notes
---

Na [postagem passada](https://wevtimoteo.github.io/posts/2023-09-23-tomando-notas-como-desenvolvedor-de-software.html) eu expliquei como iniciei minha jornada em tomar notas, mas não falei muito do app ([Obsidian](https://obsidian.md)) e quais minhas configurações e plugins.

Vamos começar falando sobre os plugins embutidos nele (conhecidos como `Core plugins` na seção de configurações).

## Audio recorder

Sem dúvida, uma das funcionalidades mais amadas pelos brasileiros: um WhatsApp nas suas notas! :D só que aqui aqui você salva os **seus áudios** para você mesmo ouvir! Quero ver se você vai continuar gravando um podcast para cada áudio que envia para um contato depois dessa experiência.

Aqui a ideia é guardar a informação de forma rápida para depois usar alguma ferramenta de transcrição ou simplesmente sintetizar os pontos mais importantes do texto.

O formato utilizado é `.webm`, que garante uma ótima qualidade de gravação com um boa troca pelo tamanho do arquivo. A única desvantagem é que se você apagar a ocorrência de onde você linkou o áudio gravado, o Obsidian não vai te perguntar se quer também remover o anexo. Mapear esses anexos que nunca foram mencionados acaba sendo um tanto trabalhoso, então fica por sua conta.

Se fosse comparar o formato `.webm` com outros populares, seria mais ou menos isso:

| Critério            | .webm                  | .mp3                   | .ogg                   | .opus                 |
| ------------------- | ---------------------- | ---------------------- | ---------------------- | --------------------- |
| Bitrate (kbps)      | Variável, 256-320      | Variável, 320          | Variável, 192-500      | Variável, 6-510       |
| Tamanho Médio (10s) | Aproximadamente 320 KB | Aproximadamente 400 KB | Aproximadamente 250 KB | Aproximadamente 80 KB |
| Aplicativos         | Obsidian               | Músicas                | Telegram               | WhatsApp              |

## Backlinks

É uma das principais funcionalidades que me motivou a utilizar Obsidian, mandatória para seu sistema de notas. Ela vai indicar onde aquela nota foi linkada/citada.

Assim, se você mencionar aquela função ou snippet, ao acessar a nota da linguagem da programação, você vai conseguir ver onde ela foi citada, como se fosse um agregador de ocorrências.

## Command Palette

O famoso `Cmd + Shift + P` do [Visual Studio Code](https://code.visualstudio.com/), porém no Obsidian é só `Cmd + P`, esse comando vai te mostrar todas as funções existentes no app, desde esconder as sidebars da esquerda ou da direita, como uma opção para mudar temas, apagar o arquivo, renomear e etc.

## Daily Notes

Esse plugin é opcional, se você não utiliza a funcionalidade de Journal (Diário), você pode pular essa. Com ela você consegue derivar notas diárias em um determinado diretório, eu uso `_Journal`. Vale ressaltar que o sistema PARA, que eu mencionei no blog post anterior, não menciona nada sobre melhor organização para esse tipo de notas. Se você não quer colocar em uma pasta raiz, caberia muito bem no `3 Resources`.

Dicas:

- **Utilize o formato de data `YYYY-MM-DD`**, não é tão intuitivo para nós por não estarmos acostumados, mas é o melhor para ordenação das notas. Dessa maneira você não terá uma bagunça na ordenação por ordem alfabética, como `01-10-2022` e depois um `01-10-2023`.
- **Selecione um template** para gerar suas notas diárias com um pouco mais de metadados, eu utilizo as seguintes properties:

```
---
created at: {{date:DD/MM/YYYY}} {{time:HH:mm}}
weekday: {{date:dddd}}
tags:
---
```

Com isso você saberá qual dia da semana gerou aquela nota e em qual data no formato mais convencional de leitura.

Eu utilizo campo `tags` para especificar quais as atividades daquele dia que anotei, exemplo: utilizo `#ffxiv` quando quero anotar algo do [Final Fantasy XIV](https://na.finalfantasyxiv.com/) e `#sourcelevel` quando tem algo do trabalho para lembrar.

Ressaltando que **não adianta nada ter anotado algo se você não consegue encontrar depois**.

## Note composer

Algumas vezes você começa uma seção de aprendizado sobre determinada ferramenta e quando vai ver já escreveu muitos detalhes sobre algo muito específico dela, por exemplo, como a cobrança funciona.

Nesse caso o plugin Note composer ajuda demais porque basta selecionar o texto específico e utilizar a opção no `Command palette`: `Note composer: Extract current selection...`. Esse comando irá criar uma nova nota com a seleção e linkar a nota criada na nota anterior que você estava editando.

Assim você garante um sistema de notas mais organizado e sem aquele monte de ruído que, muitas vezes, não te interessa quando está lendo as notas gerais.

### Linkando notas

Vale lembrar que, para linkar uma nota, utilize a sintaxe `[[Nome da nota]]`, mesmo que seja para caminhos mais complexos como `[[3 Resources/Caminho/para/Nota]]`. Se você quiser usar um atalho/alias de exibição, basta utilizar pipe (`|`) no final do link: `[3 Resources/Caminho/muito/longo/Como escrever melhor|Como escrever melhor]]`.

Caso você precise referenciar essa nota várias vezes, basta utilizar a property `aliases`. Com ela você consegue dar "apelidos" para mencionar a nota, então ao abrir os colchetes duplos, o próprio Obsidian já vai autocompletar os apelidos disponíveis.

## Outline

Muito útil para entender a estrutura da nota e incentiva você a escrever os `headings` (`h1`, `h2`, `h3` e assim em diante) nas suas notas. Essa visualização fica presente na sidebar da direita ao abrir uma nota e facilita demais na navegação, edição e na leitura.

## Page preview

Essa é bacana quando você não quer acessar a nota que foi mencionada na nota que está editando, basta segurar `Ctrl`/`Cmd` e passar o mouse sob a menção (hover), um prompt será exibido com o preview da nota.

## Properties preview

Sem dúvida uma das funcionalidades que fizeram alguns usuários de outros apps de notas migrarem para o Obsidian. Foi lançada recentemente na [versão v1.4, do final de Agosto, 2023](https://obsidian.md/changelog/2023-08-31-desktop-v1.4.5/), ela exibe uma interface mais atrativa para usuários menos técnicos visualizarem e editarem as propriedades de uma nota:

![Properties view do Obsidian](https://github.com/obsidianmd/obsidian-api/assets/693981/aea72173-5663-459d-83de-6ff888f6bdd5)

## Quick switcher

Seguindo com a analogia com o VSCode, seria o equivalente ao `Ctrl + P`, uma busca "fuzzy" (que significa algo embaçado ou não muito nítido) das suas notas. Essa é **uma maneira inteligente de pesquisar algo, mesmo quando você não lembra muito bem o nome**, só digita algumas letras e ali está o que você estava procurando.

Através do `Quick switcher` também é possível criar novas notas, só fique atento que se você incluir caracteres especiais, como `:` no título da nota, o mesmo falhará e se você estava pensando em um título para o blog post (como eu para esse), será perdido! Então coloque um nome rápido e depois renomeie a nota, utilizando o plugin apenas para criar no local correto.

Ela não funciona muito bem para criar novas notas em estruturas de diretórios aninhadas, por exemplo: `3 Resources/Ideias/Postagens/Minha ideia de blog post`, você teria que digitar pasta por pasta. O que deixa você suscetível a erro, mas espero que o time do Obsidian resolva isso logo ou mesmo a própria comunidade - _como última saída, também posso esperar essa dor aumentar para eu mesmo resolvê-la um dia! :)_

## Tags view

Uma das extensões bem bacanas para você avaliar o estado geral das suas notas, serve mais para curiosidade que para algo de fato "útil". Com ela é possível ver todas as tags (etiquetas) que utilizou em todo seu sistema.

Vale ressaltar que é possível criar tags aninhadas, seguindo exemplo do FFXIV, se eu quero anotar relacionado a jardinagem no jogo, não vou utilizar apenas `#gardening` e sim `#ffxiv/gardening`. **Dicas:**

- utilize hífens para separar palavras, não vá acabar com um `#codequality`, use `#code-quality`
- só utilize tags aninhadas para desambiguação das tags (como o exemplo da jardinagem acima)

## Word count

Muito útil para quem escreve conteúdo, com esse plugin você sabe quantas palavras foram utilizadas e com isso pode escrever um conteúdo com uma chance melhor de engajamento.

Algo que aprendi na [SourceLevel](https://sourcelevel.io) ao escrever postagens com maior frequência foi que, segundo um [estudo de 2019 do pessoal da Backlinko](https://backlinko.com/content-study) (uma das referências em SEO, conteúdo e marketing), o **"sweet spot" para maximizar os shares nas redes sociais**, como Facebook, Twitter, Reddit e Pinterest, é algo **em torno de 1.000 - 2.000 palavras**.

Blog posts nesse intervalo de conteúdo tem, em média, **56.1% de mais compartilhamentos que conteúdos com menos de 1.000 palavras**.

---

E como esse blog post já está com ~1.400 até aqui, acho que é hora de parar e deixar o detalhamento sobre plugins da comunidade para uma nova postagem. Espero ter colaborado em como "tunar" seu Obsidian ou a selecionar configurações equivalentes para usar no seu sistema de notas atual.
