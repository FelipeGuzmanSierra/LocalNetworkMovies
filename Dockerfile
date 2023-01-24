ARG ELIXIR_VERSION=1.14.2

# Image for mode dev of podnation
FROM elixir:$ELIXIR_VERSION-alpine AS base

# Alpine image packages download, for the correct functioning of phoenix dependencies
RUN apk add --update alpine-sdk && apk add wget && apk add inotify-tools postgresql-client

# We prepare the app directory for the project base
WORKDIR /app
COPY . .

# Install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# Prepare the phoenix umbrella-like project dependencies to serve as cache in the alpine image
RUN mix deps.get && mix deps.compile

# Migrations, index setup in elasticserach and execution of phoenix project
CMD mix ecto.create && mix ecto.migrate && cd ../../ && mix phx.server
