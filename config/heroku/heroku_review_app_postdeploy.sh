set -e # exit on error

echo '============================='
echo 'START: review app postdeploy'

# NOTE: this script runs 1 time when heroku creates review app, not every deploy
# it runs after Procfile#release step
cp db/base_schema.rb db/schema.rb

bundle exec rails db:schema:load
bundle exec rails db:migrate
bundle exec rails db:seed

echo 'END: review app postdeploy'
echo '============================='
