---
title: O que eu aprendi na RubyConf Brasil 2015
date: 2015-09-22 10:00:00
tags: ruby
---

Segue minhas anotações da RubyConf que eu acredito que pode ajudar muitas pessoas de vários níveis de conhecimento.

Para anotar conteúdo eu pensei em todos, me preocupando em anotar dicas para iniciantes também :)

## Criando aplicativos Rails de fácil manutenção

### Nando Vieira - [@fnando](https://twitter.com/fnando)

* [Slides](https://speakerdeck.com/fnando/criando-aplicacoes-mais-faceis-de-manter-com-ruby-on-rails)

Foco em mostrar como sair do padrão Rails-way e ir para uma abordagem de acordo com a necessidade dentro do framework.

Algumas dicas:

* Testar o suficiente para ganhar confiança no código que foi escrito
* Buscar equilíbrio nas arquiteturas, tomar cuidado com over engineering
* Sempre buscar gerar valor, sempre pensando em devolver o 'custo funcionário' para empresa, quando em dúvida sobre uma nova feature
* Independente da abordagem (monolítica ou microservices) prezar pela qualidade (escrever testes é essencial)
* App do Shopify tem alguns exemplos de como manter qualidade em uma app monolítica (https://github.com/Shopify)
* Fugir do Rails-Way sempre que possível (experimentar bastante), ganhando experiência sobre outras abordagens
* Adaptar estrutura do Rails para sua necessidade
* Ao criar uma pasta na estrutura do Rails, se preocupar se o pattern está corretamente implementado (presenters, seguir o pattern presenters mesmo)
* Evitar uso de callbacks para lógica de negócios, usar apenas para normalização de objeto/params
* Extrair lógica das views (usar helpers, presenters, etc)
* Controller não deve ter lógica de negócio, já a regra de negócio não deve ter conhecimento de coisas de controller
* Sempre tentar diminuir o número de dependências/gems, considerando até reimplementar como uma lib interna somente com as features utilizadas
* Não modificar arquivos de config do Rails diretamente no config e sim fazer isso reabrindo o objeto de config dentro de um initializer, facilitando upgrades de versão e diff com o que é realmente necessário.
* Refatorar é melhor que reescrever
* Não começar uma app com uma arquitetura complicada/complexa sem necessidade
* Sempre considerar sua experiência com patterns antes de decidir adotar algum que teoricamente resolveria seu problema
* Não tenha medo de experimentar
* Ter um bom design de código é mais importante que ter uma arquitetura bem elaborada

#### Links úteis:

* Lib de log Scroll [https://github.com/asenchi/scrolls](https://github.com/asenchi/scrolls)
* O Diego Eis também fez algumas anotações dessa palestra: [http://diegoeis.com/rubyconf2015-nando/](http://diegoeis.com/rubyconf2015-nando/)

## Don't Fear the GIL: What Ruby has in the box for concurrent programming

#### Renan Ranelli - [@renanranelli](https://twitter.com/renanranelli)

* [Slides](https://speakerdeck.com/rranelli/dont-fear-the-gil-what-ruby-has-in-the-box-for-concurrent-programming)
* [Blog](http://milhouseonsoftware.com/)

Foco em mostrar como funciona o GIL (Global Interpreter Lock) funciona e alguns modelos de concorrência que podem funcionar para uma abordagem concorrente.

Concorrência e paralelismo são coisas distintas.

Concorrência: 2 tarefas começam ao mesmo tempo em cores do processador distintos, podendo terminar em tempos diferentes

Paralelismo: 2 tarefas começam ao mesmo tempo no mesmo core de um processador, disputando pelo processamento

Assíncronismo: Rodar de forma independente, isolada.

#### Alguns modelos de concorrência:

* Multiprocesses
* Multithreading
* Coroutines [http://blog.ontoillogical.com/blog/2014/07/21/delimited-continuations-in-ruby-part-2/](http://blog.ontoillogical.com/blog/2014/07/21/delimited-continuations-in-ruby-part-2/)
* Fibers [http://ruby-doc.org/core-2.2.0/Fiber.html](http://ruby-doc.org/core-2.2.0/Fiber.html)
* Actors (Celluloid - https://celluloid.io/)
* CSP e Process Calculus [https://en.wikipedia.org/wiki/Process_calculus](https://en.wikipedia.org/wiki/Process_calculus)

*GIL:* Global Interpreter Lock previne execução de código Ruby paralela (espécie de semáforo).

Multithreading (https://github.com/ruby-concurrency/concurrent-ruby)

#### Algumas abstrações:

* Thread Pools
* Ivars
* Futures
* Promises
* Channels

OBS: Trap do `ruby` só funciona pro main processes. Para matar sub processes utilizar `throw`.

*Ivar:* "Safe to write", "Safe to read"
*Futures:*  Bom uso para chamadas de API
*Promises:* Igual Futures mas chainables (Monads)

#### Lições aprendidas com programação concorrente:

* Eliminar timeouts do código
* Cuidado com o pool do ActiveRecord
* Atualize suas dependências
* Testes bem
* Monitore: LEELA (Graph database em Haskell): https://github.com/locaweb/leela
* Não faça concurrent programming desnecessariamente
* Abordagem de variáveis imutáveis

## Ruby + Linux Pipes + Bancos de Grafos + Suor

### Ronie Uliana - [@ronie](https://twitter.com/ronie)
*Slides:* [https://github.com/ruliana/palestra-rubyconf2015](https://github.com/ruliana/palestra-rubyconf2015)

* A partir do Ruby 2.0 processos trabalham com estratégia Copy-on-write
* Sort do linux + rápido que sort do Ruby
* Livro - Flow based programming (http://www.jpaulmorrison.com/fbp/)
* Hadoop FTW :P

## Como escrever aplicações ricas embarcadas em Ruby

### Thiago Scalone - [@scalone](https://twitter.com/scalone)

Slides: Ainda não foi postado, mas existe uma palestra semelhante em [https://speakerdeck.com/scalone/mruby-change-the-embedded-development-way-1](https://speakerdeck.com/scalone/mruby-change-the-embedded-development-way-1)

Palestra focada em apresentar `mruby` (Ruby para dispositivos embarcados) e algumas soluções para IoT (Internet of Things/Internet das Coisas).

CEO da Cisco prevê um mercado de $ 19 trilhões para o mercado IoT.

#### MRuby:

* Static c/ Ruby Gems
* Pequeno
* Portátil
* Economia de recursos (60 Kb)
* ANSI C
* Artoo

#### Framework Ruby para Robótica
[http://artoo.io/](http://artoo.io/)

* API Ruby simples
* 15 plataformas
* CLI (Command Line Interface)
* Execução remota
* Similares: GoBot (http://gobot.io/) e Cylon (http://cylonjs.com/).

#### Arduino Due:

* 36g
* 500 Kb
* 3.3v
* USB Serial
* mruby-arduino (https://github.com/kyab/mruby-arduino)
* Raspberry Pi:
* $ 25
* ARM II 700 Mhz
* Ruby MRI
* 256 Mb (A/A+)
* Serial/Ethernet/USB
* Possível usar MRuby direto ao invés de Linux

#### Pebble:

[https://pebble.com/](https://pebble.com/)

* Smartwatch
* Somente bluetooth
* FreeRTOS (Free firmware)
* 42g
* $ 200
* 7 dias de bateria
* Cortex M4 100 Mhz

#### Desenvolvimento de software para embarcados:

Além dos princípios SOLID;

* Logging
* Remote Logging
* No file and memory saving
* Avoid File Extraction
* Testing
  * [https://github.com/iij/mruby-mtest](https://github.com/iij/mruby-mtest)
  * [https://github.com/iij/mruby-mock](https://github.com/iij/mruby-mock)
* Isolation/Runtime
* mirb
* Env/Deployment

#### Fluxo de desenvolvimento

Development.c -> Generate.o -> Sign -> Physically upload -> Test -> Massification -> Customer Feedback -> Repeat

Cloudwalk IO/Around the World - https://docs.cloudwalk.io/pt-BR/introduction
Atualização de código
I/O
Tests
Possível fazer espécie de continuous delivery para embarcados e quebra de paradigmas para desenvolvimento de embarcados.

#### Da Funk
Walk Framework API (https://github.com/cloudwalkio/da_funk)

* API for dev
* Notifications (Serf)
* GPRS, WiFi, Ethernet
* Device IoT
* Go (CGo) + MRuby
* MRuby, compilar código Go via CLI

## Ruby na Aviação: Construindo aviônicos em Ruby e lidando com suas restrições

### Eduardo Mourão - [@eduardordm](https://twitter.com/eduardordm)

* [Fontes](https://github.com/eduardordm/enginevib)
* [Vídeo](https://twitter.com/eduardordm/status/641296597985267712)
* Slides: Não encontrei

Palestra mostrando como é trabalhar com Ruby no ramo da aviação.

No ramo comercial é utilizado waterfall (DO-178), dogfood. Já no ramo militar é utilizado Agile/Scrum (BASP), dogfood gourmet :P

Um monte de certificações.

* Desenvolvimento utilizando ADA
* Considerado estável
* Bug que obriga ser rebootado a cada 248 dias por conta do i++ Loop of Death
* http://www.engadget.com/2015/05/01/boeing-787-dreamliner-software-bug/
* https://twitter.com/bengoldacre/status/594089242319552512

#### Por que Ruby?

* Real time
* Robustez
* Rastreabilidade
* DTrace (http://crypt.codemancers.com/posts/2013-04-16-profile-ruby-apps-dtrace-part1/)
* PMAP
* Conformidade
* Estrutura
* Soft ticker (RTOS)
* Controller Sensor Scheduler Output
* Uso de CPU não pode ultrapassar 0.2%, não tem cooler.

Ticker -> não pode passar do deadline (30ms)

Caso precise desligar motor a jato, verificar vibrações :P

Medição de Memory Leak

#### Rastreabilidade

* DTrace
* syscalls
* object-create
* array-create
* hash-create
* [c]method-entry
* I/O é difícil
* Simplicidade > Legibilidade
* Profilling

Introspecção altera o estado do programa, erros de alocação e perda de origem (qual .rb).

*Testes com Rubocop:* https://github.com/bbatsov/rubocop
Bikeshedding self-service

## fpm-cookery: package binaries without pain

### Marcelo Correia - [@salizzar](https://twitter.com/salizzar)

* [Slides](https://speakerdeck.com/salizzar/fpm-cookery-package-artefacts-without-pain)

Palestra com intuito de mostrar uma abstração para empacotamento cross platform.

* Chef etc
* Best way to deploy
* Tarball
* FTP/SSH

#### Gerações

* CFEngine (http://cfengine.com/)
* Chef, Puppet
* Ansible, SaltStack (http://saltstack.com/)

* Fácil rollback
* Pode se tornar um pesadelo de é necessário compilar algo
* Não deixar gcc instalado no servidor
* Tanto Debian quanto CentOS/RedHat possuem docs hard com alta curva de aprendizado

#### FPM-cookery
https://github.com/bernd/fpm-cookery

Desenvolvido Bernd Ahlers (https://github.com/bernd) trabalha como desenvolvedor no Graylog (https://www.graylog.org/).

Uso bem simples, basicamente definir uma classe herdando de FPM::Cookery::Recipe e implementar `#build` e `#install`.

##### Com fpm-cookery é possível

* Baixar tarball
* Baixar e compilar do source
* Resolver build de dependência
* Exportar para .rpm, .deb, .dmi, etc
* Usar helpers

#### Gordon
https://github.com/salizzar/gordon

* Agnostic packaging integra o fpm-cookery com foreman.
* Em beta
* Immutable infrastructure
* ToDo:
  * inittab
  * upstart
  * supervisord
* Supported languages:
  * Ruby
  * Java
* Empacotamento de n projetos com uma única receita

## Evolução e futuro do uso de paradigmas no JavaScript
### Jean Emer - [@jcemer](https://twitter.com/jcemer)

* [Blog](http://jcemer.com/)
* [Slides](http://www.slideshare.net/jeancarloemer/evoluo-e-futuro-do-uso-de-paradigmas-no-javascript)

Abordagem dos paradigmas trazidos pelo Backbone.js, Angular e React.

#### Javascript

* Permite programar de forma funcional por conta da característica FCF (first-class functions), permitindo passar funções como parâmetro para outras funções.
* Usar Underscore (http://underscorejs.org/) como uma lib funcional
* EcmaScript 5.1
* map
* reduce
* every
* find
* includes
* Funcional:
* Funções puras
* Ausência de estado compartilhado
* Não geram efeito colateral
* Foco em compor funções
* Trampolines (https://taylodl.wordpress.com/2013/06/07/functional-javascript-tail-call-optimization-and-trampolines/e http://raganwald.com/2013/03/28/trampolines-in-javascript.html)

JS não é uma linguagem funcional, mas tem características de.
"Programação funcional é sobre valores e suas funções"

* Promises resultado de uma operação assíncrona.
* Backbone-slide http://georgeosddev.github.io/backbone-slide.js/

* render só quando necessário
* Criar renders específicos
* Um dos problemas dessas libs é que eles abusam muito de render e mudar o DOM com tamanha frequência é ruim para o navegador

#### React.JS
https://facebook.github.io/react/

* Evita reescrever o DOM desnecessariamente
* Componentes recebem propriedades de ancestrais
* React marca como dirty e faz rerender somente quando necessário
* VirtualDOM
* Guarda as alterações e evita aplicar desnecessariamente
* EventStream
* Garante debounce dos requests
* Transformar request em uma promise

#### Event Stream

* Garante debounce dos requests
* Transformar request em uma promise
* Functional Reactive Programming (https://www.manning.com/books/functional-reactive-programming)
* BaconJS (https://baconjs.github.io/)

## Interfaces ricas com Rails e React.JS

### Rodrigo Urubatan - [@urubatan](https://twitter.com/urubatan)

* [Slides](http://www.slideshare.net/urubatan/interfaces-ricas-com-rails-e-reactjs-rubyconf-2015)

Palestra encheu bastante, com muitos interessados em React.JS.
O blog mais feio do mundo, feito em Rails + React.JS em um SPA (single page app).

Usando a gem `backbone-on-rails`  e `react-rails`.

A gem `react-rails` (https://github.com/reactjs/react-rails) integra automaticamente com o asset pipeline do Rails.

#### Componentes

* Extensão .js.jsx automaticamente compilado pelo asset pipeline.
* View com apenas <%= react_component. … %>
* Todos os controllers retornam collections em JSON
* Roteamento integrado para navegação assíncrona, via Backbone.router
* Verificar se é possível utilizar um JST para templates do React.JS, pois os templates são transformados em objetos pelo React

O código que foi gerado é ruim para rankeamento no SEO. Mesmo com plugins, o conteúdo não é apresentado de forma semântica.

React Router (https://github.com/rackt/react-router), suporta a sintaxa do ECMAScript 6 (com Gulp).

Flux (https://github.com/facebook/flux), arquitetura para construir interface de usuário.

## Como Trailblazer e Rails Engines podem salvar sua aplicação Rails monolítica

### Celso Fernandes - [@celsovjf](https://twitter.com/celsovjf)
* [Slides](https://speakerdeck.com/fernandes/how-trailblazer-and-rails-engines-can-save-your-rails-monolith-application)

Tópicos:

* Contract Pattern
* Representer
* Policy (que retorna boolean, ex.: current_user?)
* Fugir do CRUD

* `#setup!(params)`
* setup params
* build model
* Comment::Create

#### Operations em app monolítica
Micro Services

Component Based Rails Architectures
Post de exemplo: http://teotti.com/component-based-rails-architecture-primer/
mount API::Engine
Dispatcher Rails -> Ember ou Rails views

Clean Architecture: https://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html

TravisCI possui uma arquitetura de “componentes” (https://github.com/travis-ci/travis-listener).
Exemplo de entrega de app Ember com Rails: RailsBlocks (https://github.com/railsblocks/railsblocks)

## Ruby, Javascript e Elixir juntando forças para WebRTC
#### Ben Langfeld - [@benlangfeld](https://twitter.com/benlangfeld)

* [Slides](https://speakerdeck.com/benlangfeld/ruby-javascript-and-elixir-joining-forces-for-webrtc)

Palestra sobre WebRTC (tecnologia que permite utilizar câmera e microfone direto no navegador com uma conexão praticamente Peer2Peer).

WebRTC é utilizado pelo Google Hangouts e recentemente o Skype anunciou que também está indo para Web e extendendo essa solução para outras plataformas (como desktop e mobile).

#### Padrões para Interoperabilidade

* Opius
* SDP
* ICE
* DTLS

#### Fluxo de conexão

Usuário A quer conectar com usuário B, para isso navegador manda para um intermediador HTTP informações sobre o suporte do navegador e esses dados são enviados para o navegador do usuário B que responde com as mesmas informações dele. Daí em diante ambos estabelecem uma conexão para trafegar essas informações.

#### Suporte

##### Client-side

* Chrome
* Firefox
* Opera
* IE & Safari (através de plugins/addons)

##### Server-side

* FreeSwitch(1.4+) - https://freeswitch.org/
* Asterisk (1++) - http://www.asterisk.org/

#### Sites com WebRTC

* https://talkingstick.io/
* Modelo de comunicação em grupo
* Rails engine: gem `talking-stick`
* mount no router
* rake install
* e pronto :P
* https://cubeslam.com/
* Arkanoid com WebRTC

#### Por que adicionar Elixir na solução?

Lidar com concorrência e escalabilidade. Uso de SIP (Session Initiation Protocol - disponível no Elixir através da VM do Erlang: https://www.erlang-solutions.com/resources/collaterals/sip).

WebRTC for JS - http://sipjs.com/
MojoAuth to authenticate cross platform apps: https://github.com/mojolingo/mojo-auth

#### Takeaways:
* Standards are not evil

## Qualé dessa Programação Funcional?

### Andrew Rosa - [@_andrewhr](https://twitter.com/_andrewhr)
* [Slides](https://speakerdeck.com/andrewhr/quale-dessa-programacao-funcional)

* Lambda calculus
* Teoria das Categorias
* Monads
* Funções puras
* Function as data
* Conceito de closure do JS
* Pipeline Operator Elixir similar ao Unix
* Currying

## Outros slides de palestras que não assisti

* Arquiteturas Comuns de apps Rails -  https://speakerdeck.com/plataformatec/arquiteturas-comuns-de-apps-rails-at-rubyconf-br-2015
* Qual é dessa Programação Funcional: https://speakerdeck.com/andrewhr/quale-dessa-programacao-funcional
* Learn from my mystakes - https://speakerdeck.com/flaviafortes/learn-from-my-mistakes

## Anotações pessoais

* Site da Sandi Metz: http://www.sandimetz.com/
* Practical Object-Oriented Design in Ruby (http://www.amazon.com/gp/product/0321721330/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0321721330&linkCode=as2&tag=sandimetzcom-20&linkId=MEEIA2TTJVD6F5DO)
*
* The Cathedral & The Bazaar (http://www.amazon.com/The-Cathedral-Bazaar-Accidental-Revolutionary/dp/0596001088)
* Conferir novos cursos do Coursera
* Conferir EDX  (https://www.edx.org/)
* Functional programming in Haskell (http://www.amazon.com/Haskell-Functional-Programming-International-Computer/dp/0201882957)
* Nand2Tetris (http://www.nand2tetris.org/)
* Hardware Software Interface (https://pt.coursera.org/course/hwswinterface)
* Cloud Computing Coursera (https://pt.coursera.org/course/cloudcomputing)
* Consistent Hashing (http://www.tom-e-white.com/2007/11/consistent-hashing.html)
* RingPop (https://github.com/uber/ringpop-node)
* Serf (http://www.slideshare.net/CotapEng/tech-talk-service-discovery-with-serf)
* Big O (https://pt.khanacademy.org/computing/computer-science/algorithms/asymptotic-notation/a/big-o-notation)
* Ordem de Grandeza
* Sinais digitais - Eng. Eletrica
* Sensor com filtro de ruído
* Debian + Systemd
* Currying in JS
* Promise Pattern - https://www.promisejs.org/patterns/
* Monad - https://en.wikipedia.org/wiki/Monad_(functional_programming)
* Contract Pattern (http://hillside.net/plop/plop97/Proceedings/dechamplain.pdf)
* Component Based Architecture (http://teotti.com/component-based-rails-architecture-primer/)
* EmberJS - http://emberjs.com/


## Fotos da RubyConf

* [Facebook](https://www.facebook.com/media/set/?set=a.963241117052195.1073741866.206944852681829&type=3)
