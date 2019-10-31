# VIP PetCare

Rails API Gateway

Please review the [documentation repo](https://github.com/vippetcare/docs); specifically the process documents:
- [Development from Start to Deploy](https://github.com/vippetcare/docs/blob/master/process/development-from-start-to-deploy.md)
- [Change Management](https://github.com/vippetcare/docs/blob/master/process/change-management.md)

## Install development environment on Mac OSX

- System dependencies
  - `rvm`, `rbenv` or `asdf` for Ruby Version management
    - `.ruby-version` file should auto load correct ruby version
      - `asdf` may need additional [configuration](https://github.com/asdf-vm/asdf-ruby#migrating-from-another-ruby-version-manager)
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
- GATEWAY_USERNAME
  - All environments
  - Username to auth gateway to generate tokens
- GATEWAY_PASSWORD
  - All environments
  - Password to auth gateway to generate tokens
- JWT_TOKEN_EXPIRATION_IN_HOURS
  - All environments
- REDIS_URL
  - All environments
  - Automatically added in staging and production with Heroku Redis Addon
  - optionally set in local env files
    - `echo "REDIS_URL=redis://127.0.0.1:6379/1" >> .env.development.local`
    - `echo "REDIS_URL=redis://127.0.0.1:6379/0" >> .env.test.local`
- WELLNESS_VCP_PASSWORD
  - All environments
  - optionally set in local env files
    - `echo "WELLNESS_VCP_PASSWORD=XXXX" >> .env.development.local`
    - `echo "WELLNESS_VCP_PASSWORD=XXXX" >> .env.test.local`
    - where `XXXX` is demo password
- WELLNESS_VCP_USERNAME
  - All environments
  - optionally set in local env files
    - `echo "WELLNESS_VCP_USERNAME=XXXX" >> .env.development.local`
    - `echo "WELLNESS_VCP_USERNAME=XXXX" >> .env.test.local`
    - where `XXXX` is demo username
