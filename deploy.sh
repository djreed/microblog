#!/bin/bash

export REL_PATH="_build/prod/rel/microblog/releases/0.0.1"

echo "Deploying App to Basset"

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod

scp ${REL_PATH}/microblog.tar.gz microblog@davidjreed.net:/home/microblog/microblog.tar.gz

ssh microblog@davidjreed.net -t "tar -xzvf microblog.tar.gz"
ssh microblog@davidjreed.net -t "export PORT=4000"
ssh microblog@davidjreed.net -t "./bin/microblog stop"
ssh microblog@davidjreed.net -t "./bin/microblog migrate"
ssh microblog@davidjreed.net -t "PORT=4000 ./bin/microblog start"
