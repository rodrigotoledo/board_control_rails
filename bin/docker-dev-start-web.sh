#!/usr/bin/env bash
set -xeuo pipefail


echo ">> Running RuboCop..."
bundle exec rubocop || true

echo ">> Running Brakeman..."
bundle exec brakeman --no-pager --quiet || true

if [[ -f ./tmp/pids/server.pid ]]; then
  rm ./tmp/pids/server.pid
fi

bundle

if ! [[ -f .db-created ]]; then
  bin/rails db:drop
  bin/rails db:drop:cache
  bin/rails db:drop:cable
  bin/rails db:drop:queue
  bin/rails db:create
  bin/rails db:create:cache
  bin/rails db:create:cable
  bin/rails db:create:queue
  touch .db-created
fi

bin/rails db:migrate

if ! [[ -f .db-seeded ]]; then
  bin/rails db:seed
  touch .db-seeded
fi


foreman start -f Procfile.dev
