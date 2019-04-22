---
title: Configurando ruby correto dentro de plugins do vim
date: 2014-10-06 23:10:00
tags: vim, ruby, vim plugins
---

Primeiro post de 2015 e primeiro post na plataforma Pelican depois da migração do [Octopress](http://octopress.org/) para o [Pelican](http://blog.getpelican.com/). Depois escrevo sobre como foi essa migração.

Já tinha lido muitos artigos a respeito de [Cyclomatic Complexity](http://en.wikipedia.org/wiki/Cyclomatic_complexity), mas nunca tentei colocar algum script para avaliar meu código.

Antes tarde que nunca, encontrei o plugin [vim-flog](https://github.com/fousa/vim-flog) que é um fork do [vim-ruby-complexity](https://github.com/skammer/vim-ruby-complexity); que como o nome já diz, serve para avaliar a Complexidade Ciclomática dentro de scripts .rb.

Acontece que esse plugin executa código ruby dentro do arquivo `.vim` (caso queira saber mais: [Scripting Vim with Ruby](http://mattmargolis.net/scripting_vim_with_ruby.pdf)).

Até então, isso não deveria ser um problema. Acontece que quando o script rodava:

```ruby
ruby << EOF

require 'rubygems'
require 'flog'

class Flog
```

Ocorria um erro na linha `require 'flog'` que não encontrava a `gem`, apesar de eu já ter instalado no meu `ruby` local usando `gem install flog`.

Tentei entender o problema olhando o `$GEM_PATH`, `$GEM_ROOT` e `$GEM_HOME` dentro do código do plugin, no entanto, ambos estavam vazios.

Parti para outro caminho e olhei o path do ruby executado adicionando:

```ruby
puts $:

require 'rubygems'
require 'flog'
```

O `$:` serve para imprimir o path de onde o `ruby` é procurado (tente rodar isso dentro do `irb`).

Nesse comando, percebi que o `ruby` que estava sendo executado era o que vem juntamente do OS X Yosemite (2.x) e não o meu `ruby` do `rbenv` (alternativa ao `rvm`).

Como eu sempre fiz upgrade nos releases do `OS X` e nunca um clean install.
Achei um report do bug no [path_helper](https://github.com/dotphiles/dotzsh#mac-os-x), para resolver isso, basta:

```
sudo chmod ugo-x /usr/libexec/path_helper
```

Segue trecho do link acima caso o link se torne obsoleto:

```
path_helper is intended to make it easier for installers to add new paths to the environment without having to edit shell configuration files by adding a file with a path to the /etc/paths.d directory.

Unfortunately, path_helper always reads paths from /etc/paths set by Apple then paths from /etc/paths.d set by third party installers, and lastly paths from the PATH environment variable set by the parent process, which ultimately is set by the user with export PATH=... Thus, it reorders path priorities, and user /bin directories meant to override system /bin directories end up at the tail of the array.
```

