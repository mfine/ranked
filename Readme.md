# RankeD

Track results, rank people.

### Installing

```bash
$ createdb ranked-dev
$ bundle exec sequel -m db/migrations postgres://localhost/ranked-dev
```

### Running

```bash
$ cp sample.env .env
$ foreman start
```
