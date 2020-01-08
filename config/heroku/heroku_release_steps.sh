# fail release on staging and production
# workaround for review apps
echo '------------------------------'
echo $HEROKU_APP_NAME
echo '------------------------------'

if [ "$HEROKU_APP_NAME" == "staging-vip-api-gateway" ] || [ "$HEROKU_APP_NAME" == "production-vip-api-gateway" ]; then
  echo 'exit on error.....';
  set -e;
fi

echo '============================='
echo 'START: custom release steps'

echo '-----------------------------'
echo 'RELEASE STEP: db:migrate'
echo 'NOTE: this will fail 1st time on Preview Apps'
bundle exec rails db:migrate
echo '-----------------------------'

echo '-----------------------------'
echo 'RELEASE STEP: db:seed'
echo 'NOTE: this will fail 1st time on Preview Apps'
bundle exec rails db:seed
echo '-----------------------------'

echo 'END: custom release steps'
echo '============================='
