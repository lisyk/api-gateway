set -e # exit on error

echo 'BEGIN'
bundle exec rails db:drop
bundle exec rails db:create
cp db/base_schema.rb db/schema.rb
bundle exec rails db:schema:load
bundle exec rails railties:install:migrations
bundle exec rails db_service:install:migrations
bundle exec rails db:migrate
bundle exec rails db:seed
bundle exec rails db:test:prepare
echo 'DONE'
