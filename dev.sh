#!/bin/sh

mix deps.get
mix deps.compile

cd assets
npm install

cd ..

mix phx.server
