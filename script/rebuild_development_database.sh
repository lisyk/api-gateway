set -e # exit on error

echo 'BEGIN'
bundle exec rails db:drop
bundle exec rails db:create
bundle exec rails railties:install:migrations
bundle exec rails db_service:install:migrations
bundle exec rails db:migrate
bundle exec rails db:seed
echo 'DONE'
