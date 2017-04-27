# Turaco
[![Code Climate](https://codeclimate.com/github/AwesomeIT/turaco.png)](https://codeclimate.com/github/AwesomeIT/turaco) ![CircleCI](https://circleci.com/gh/AwesomeIT/turaco.svg?style=shield&circle-token=e69669e5ebd800aeeb50f55612d1a49e77120a57)

The TalkBirdy speech analytics platform, powered by [grape, grape-roar](https://github.com/ruby-grape), [Elasticsearch](https://www.elastic.co/), and [Rails 5](https://github.com/rails/rails).

## Getting Started

### Requirements

These packages can be found on `apt`, `brew`, `dnf`, and the Arch AUR available. If you use Windows, we highly recommend Ubuntu on Windows ([WSL](https://msdn.microsoft.com/en-us/commandline/wsl/about)). Hooray!

- MRI `2.4.0` or greater
  - Rubinius also seems to work but you will hate everything getting `pg` to build properly. Not officially supported.
- `rbenv` or `rvm` are recommended for managing your Ruby.
- Elasticsearch
- PostgreSQL


### Setting up a local environment

#### Database

All database maintenance is performed from [our model gem](https://github.com/awesomeit/kagu). For more detailed documentation on database setup please look at the other README, and the one linked for `standalone_migrations`.

Ensure your database is started:
```bash
systemctl start postgresql
brew services postgresql start
```

Clone and prepare database:

Edit `db/config.yml` with your local database's hostname, username, and password.

```bash
git clone git@github.com:AwesomeIT/kagu.git
cd kagu
bundle
bundle exec rake db:reset
```

#### API

Clone and install dependencies:

Edit `config/database.yml` with your local database's hostname, username, and password (psst: use the one from earlier).

```bash
git clone git@github.com:AwesomeIT/turaco.git
cd turaco
bundle
bundle exec rake db:seed
```

#### Search

When a record is modified, the API sends a Kafka message to update the Elasticsearch record. In order to make things easier locally, we do not require that you run the [workers](https://github.com/awesomeit/myna) or `kafka` to make changes. Create some records by doing CRUD operations. You can run any of these operations while the API is running, as a separate process. If ES is down, the search endpoints (should) fall back on SQL. You will not be able to see changes without updating ElasticSearch when querying `/v3/:resources` with filters.

To set up the ES indicies:
```bash
bundle exec elasticsearch:force_reindex
```

To update after making changes to the local SQL database:
```bash
bundle exec elasticsearch:update_all
```

#### Running everything

Start `postgresql` (skip if you did this earlier):
```bash
systemctl start postgresql
brew services postgresql start
```


Start `elasticsearch` and bind it to `localhost:9200`. Generally, all you need to do for this is:

```bash
systemctl start elasticsearch
brew services elasticsearch start
```

Finally: `rails s`

## API

We use [HAL hypermedia](http://stateless.co/hal_specification.html) JSON data representation. Each resource has links to its relations and self. As a result, you should be able to use [one of these popular HAL libraries](https://github.com/mikekelly/hal_specification/wiki/Libraries) instead of plain HTTP adapters. Of course, you can also use a regular REST client.

The API server is also responsible for rendering the OAuth dialogs and user sign in and sign out forms. We want application consumers to not worry about authorization and make their integrations as stateless as possible.

- Documentation
  - `/` (the root route is a `swagger-ui` instance)
- Resources
  - `/v3/:resources/:id`
  - `/v3/:resources`
- [OAuth](https://en.wikipedia.org/wiki/OAuth)
  - Authorization for applications and users
  - `authorization_code` grant only.
  - `/oauth/authorize`
  - `/oauth/token`

## Credits & License

- David Stancu
- Paulina Levit

Copyright (c) 2017 Awesome IT LLC.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
