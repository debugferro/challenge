FROM bitwalker/alpine-elixir-phoenix:latest

WORKDIR /app
COPY . /app

ENV MIX_ENV dev
RUN cd /app && \
    mix do deps.get, compile

EXPOSE 4000