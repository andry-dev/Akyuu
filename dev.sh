#!/bin/sh

mix deps.get
mix deps.compile

cd assets
yarn

cd ..

mix phx.server
