# wevtimoteo's Personal Blog

[Personal blog](https://wevtimoteo.github.io) that uses [Serum](https://dalgona.github.io/Serum) blog engine written in [Elixir](https://elixir-lang.org/).

## Contributing

Clone using Elixir directory naming patterns:

```
git clone git@github.com:wevtimoteo/wevtimoteo.github.io.git wevtimoteo_github_io
```

### Install Elixir and Erlang using [`asdf`](https://github.com/asdf-vm/asdf):

```
asdf install
```

This will install proper versions described in `.tool-versions` file.


### Serum Server

Install dependencies and run Serum server:

```
mix do deps.get, deps.compile
mix serum.server
```

Then access [http://localhost:8080](http://localhost:8080)

To quit, instead of pressing `Ctrl-c`, prefer to type `quit`

## Publish

Use `./publish`, it will run:

* `serum.build` task for `output` directory
* [`ghp-import`](https://github.com/davisp/ghp-import) Python tool: that will export specified content in a given directory for a given branch
* `push` it to remote repo
