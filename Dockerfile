# ──────────────── Stage 1: Build ────────────────
FROM elixir:1.18-alpine AS build

# Install build deps
RUN apk add --no-cache \
  build-base \
  git \
  npm \
  nodejs \
  inotify-tools

# Set work dir
WORKDIR /app

# Install Elixir tools
RUN mix local.hex --force && mix local.rebar --force

# Copy and install dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get

# Copy rest of app and compile
COPY . .

WORKDIR /app
RUN mix deps.compile && mix compile && mix phx.digest

# ──────────────── Stage 2: Release ────────────────
FROM elixir:1.18-alpine

# Only runtime deps
RUN apk add --no-cache \
  bash \
  openssl \
  ncurses-libs \
  libstdc++

# Set working dir
WORKDIR /app

# Copy build from previous stage
COPY --from=build /app/_build ./_build
COPY --from=build /app/config ./config
COPY --from=build /app/lib ./lib
COPY --from=build /app/priv ./priv
COPY --from=build /app/mix.exs ./mix.exs
COPY --from=build /app/mix.lock ./mix.lock

# Start server
CMD [ "mix", "phx.server"]
