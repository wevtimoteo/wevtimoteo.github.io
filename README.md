# wevtimoteo's Personal Blog

[Personal blog](https://wevtimoteo.github.io) that uses [Serum](https://dalgona.github.io/Serum) blog engine written in [Elixir](https://elixir-lang.org/).

## Develop

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
