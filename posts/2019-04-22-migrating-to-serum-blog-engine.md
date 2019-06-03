---
title: Migrating to Serum blog engine
date: 2019-04-22 10:55:00
tags: blogging
---

Some years ago I've been involving myself into learning more about [Elixir](https://elixir-lang.org) programing language and I've decided to use more tools in the same ecosystem, starting by my own blog engine.

I've started this blog using [Jekyll](https://jekyllrb.com) which is built using my favorite programing language: [Ruby](https://www.ruby-lang.org).

Then I started exploring some Data Science content, which most of its tools are written using [Python](https://www.python.org) (a cool language but not included in my favorite list 😜), so I've found [Pelican](https://blog.getpelican.com)!

Pelican has a nice documentation and a [lot of themes](https://github.com/getpelican/pelican-themes), must-have features for developers such as code syntax highlighting and modular plugin system (with its own [plugins repo](https://github.com/getpelican/pelican-plugins)).

So backing to Elixir, I've found this [Awesome Elixir list](https://github.com/h4cc/awesome-elixir#static-page-generation), containing [Serum](https://dalgona.github.io/Serum). Checking other tools, I've decided to give it a try, you're reading a blog post written using it :)

## Can we compare each one?

All of them are categorized as Static Site Generator. Jekyll and Pelican have a lot more features than Serum, no doubt about it.

I've picked Serum as my blog engine to follow its evolution and I plan to contribute developing some [Plugins](https://dalgona.github.io/Serum/docs/plugin.html) for it.

If you want to take a look at some other engines, check this [Awesome Static Generators list](https://github.com/myles/awesome-static-generators#blogs).

Serum is well-documented and to start a new blog using it is simple:

```
$ mix archive.install hex serum_new
$ mix serum.new /path/to/project
$ cd /path/to/project
$ mix do deps.get, deps.compile
```

That is it! Check [Getting Started](https://dalgona.github.io/Serum/getting-started.html) in Serum docs for more details.

I plan to write some blog posts explaining how parsing templates differ in each language and provide some RSS feed URL for future posts :)
