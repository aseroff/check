# Check

Rails webapp running Tokens: The Board Game Check-in App

## Getting Started

### Prerequisites

Check uses Ruby 2.6.5. Manage your Ruby versions with [RVM](https://rvm.io/rvm/install). You'll also need the appropriate version of Bundler to download the project's gems (which is covered in the first step of the Installing section below).

### Installing

Clone the repo locally. Install the gems used in Check. In the project's root directory:

```
gem install bundler
bundle
```

Check uses PostgreSQL. You will need to have postgres installed and running on your system.

To create the Check databases and tables locally, run:

```
rake db:setup
```

The application's secrets are encrypted in `config/credentials.yml.enc`. Currently, the application requires access to this file for AWS credentials, but this dependency should be removed from non-production environments or spoofed with a new file in the repository. The application also currently requires you to precompile assets (`rake assets:precompile`), which should also be fixed.

To start your local server:

```
rails s
```

View in your browser at localhost:3000.

## Namespaces

- /: Browser applications
- /api/: API for mobile applications

## Documentation

The repo includes yard-generated documentation in the `docs` directory. To generate fresh documentation, run `yard` or `rake yard` from the project's root directory (settings are loaded from `.yardopts` and `lib/tasks/generate_documentation.rake`, respectively).

### Data model

The repo also includes an [ERD](https://github.com/aseroff/check/blob/master/docs/erd.pdf) in the `docs` directory. Updates can be made by running `erd` from the project's root directory (settings are loaded from `.erdconfig`). The diagram also should be automatically updated when a db migration occurs via rake task (`lib/tasks/generate_diagram.rake`). This diagram excludes the id and timestamp fields in entities, see [rails-erd documentation](https://voormedia.github.io/rails-erd/customise.html) for more options.

## File Storage

### Images

Game images and user avatars are stored on AWS S3. Currently handled by Fog and Carrierwave, but should be replaced with ActionStorage.

## Running the tests

The automated test suite is kept in a 100% pass state on the master branch to assist in catching regressions. It can be run with the `rake` command from the project's root directory. All tests use a shared setup of fixtures defined as instance variables in the `test/test_helper.rb` file. 

### Test Coverage and Code Smell

Statement coverage metrics generated by [simplecov](https://github.com/colszowka/simplecov) can be viewed in `tmp/rubycritic/coverage/index.html`. This project has a few code smell gems that can all be run from the root directory in the command line. These include `rubocop` and `rubycritic`, which includes Reek, Flay, Flog, and Simplecov. Run with `rake rubycritic` or `rubycritic app lib`, view results at `tmp/rubycritic/overview.html`

## Deployment

TBD

## Components

- [Rails 6](https://github.com/rails/rails)
- [Devise](https://github.com/plataformatec/devise)
- [React-rails](https://github.com/reactjs/react-rails)
- [Bootstrap](https://github.com/twbs/bootstrap-rubygem)
- [FriendlyId](https://github.com/norman/friendly_id)
- [will-paginate](https://github.com/mislav/will_paginate)

## Contributing

Create [issues](https://github.com/aseroff/check/issues) or [pull requests](https://github.com/aseroff/check/pulls) on GitHub.

## Versioning

Releases can be found [here](https://github.com/aseroff/check/releases), and represent a production-deployed codebase.

## Authors

Project start through current version developed by [Andrew Seroff](https://github.com/aseroff).

## License

TBD

## Acknowledgments

TBD
