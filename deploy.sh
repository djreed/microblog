#!/bin/bash

export REL_PATH="_build/prod/rel/microblog/releases/0.0.1"

echo "Deploying App"

mix deps.get
(cd assets && sudo npm install)
(cd assets && sudo ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod

cp ${REL_PATH}/microblog.tar.gz ../microblog/microblog.tar.gz

cd ../microblog/

tar -xzvf microblog.tar.gz
./bin/microblog stop
PORT=4000 ./bin/microblog start
