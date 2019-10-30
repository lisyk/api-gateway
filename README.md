# VIP PetCare

Rails API Gateway

Please review the [documentation repo](https://github.com/vippetcare/docs); specifically the process documents:
- [Development from Start to Deploy](https://github.com/vippetcare/docs/blob/master/process/development-from-start-to-deploy.md)
- [Change Management](https://github.com/vippetcare/docs/blob/master/process/change-management.md)

## Install development environment on Mac OSX

- System dependencies
  - `rvm` or `rbenv` for Ruby Version management
    - `.ruby-version` file should auto load correct ruby version
  - Install Redis:
    - `brew install redis`
    - `brew services start redis` or `redis-server`

## Setup

- Clone this repository: `git clone git@github.com:vippetcare/api-gateway.git; cd ./api-gateway`
- Create `.env.development.local` in root directory with the following values (see Environment Variables section below)
- Setup
  - `bundle`
  - Start the application: `rails s`

## Development

- Running the application
  - Start the application: `bundle exec rails s`
  - TODO: link to swagger docs interface?
- Running tests and tooling
  - ruby specs: `rspec spec`
  - ruby lint: `rubocop`

NOTE: depending on your environment you may need to prefix your rails commands with `bundle exec` or use `bin/rails`

### Pre-Commit Hook
Before making changes, copy `pre-commit.sh` to the repo `.git/hooks` folder using:
```
ln -s ../../pre-commit.sh .git/hooks/pre-commit
```

### Pairing

While pairing you may want to use `git pair` for your commits, it requires installing the gem
- `gem install pivotal_git_scripts`
- See: [https://github.com/pivotal/git_scripts](https://github.com/pivotal/git_scripts)

### Rails Dates

- Use `Time.current` (alias of `Time.zone.now`) instead of `Time.now`
- Use `Date.current` instead of `Date.today`

## Deployment

- Heroku pipelines are used for staging, deployments are automatic
- Heroku application is used for production, manually deployed using the UI

### Environment Variables

- AIRBRAKE_PROJECT_ID
  - All non development environments (for exception notification)
- AIRBRAKE_PROJECT_KEY
  - All non development environments (for exception notification)
- TODO: all other ENV
