FROM elixir:1.15.7-otp-25-alpine

RUN apk add --update git build-base nodejs npm yarn

RUN mkdir app
WORKDIR app/

RUN mix do local.hex --force, local.rebar --force

ENV MIX_ENV=dev

COPY mix.* ./
RUN mix deps.get

COPY config/ ./config/

COPY ./ ./

EXPOSE 4000
