FROM elixir:1.14.0-alpine

WORKDIR /app
COPY . /app

ENV MIX_ENV dev

RUN mix local.hex --force
RUN mix local.rebar --force
RUN cd /app && \
    mix do deps.get, compile

EXPOSE 4000