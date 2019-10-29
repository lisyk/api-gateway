# README

Rails API Gateway 

* Ruby version ruby-2.6.5

* rails api mode

* No database

* Database initialization

### Pre-Commit Hook
Before making changes, copy `pre-commit.sh` to the repo `.git/hooks` folder using:
```
ln -s ../../pre-commit.sh .git/hooks/pre-commit
```

### Starting Redis Server
Before using redis to cache tokens:
```
brew install redis
redis-server
```
### Swagger
API Documentation using swagger is mounted at http:localhost/vip-api-docs/index.html
New specs must be added to the /spec/integration/<engine> folder before they will be 
available
After new specs are added run the rake task rake rswag:specs:swaggerize
