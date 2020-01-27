gem install brakeman
brakeman -v
mkdir ./tmp
brakeman \
  --add-engines-path components/wellness \
  --add-engines-path components/db_service \
  --index-libs \
  --format html \
  --output ./tmp/brakeman.html $*
