FROM hexpm/elixir:1.10.4-erlang-23.1.1-alpine-3.12.0

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN apk update && \
    apk add inotify-tools nodejs alpine-sdk && \
    mix local.hex --force && \
    mix archive.install hex phx_new 1.5.5 --force && \
    mix local.rebar --force

CMD ["mix", "phx.server"]

