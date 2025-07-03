# Use official Elixir image
FROM elixir:1.16-alpine

# Install Hex + Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Install Node.js for assets if needed and git for mix deps
RUN apk add --no-cache nodejs npm git

# Install build dependencies
RUN apk add --no-cache build-base

# Set working directory
WORKDIR /app

# Cache deps
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get
RUN mix deps.compile

# Copy assets and compile
COPY assets assets
RUN cd assets && npm install
RUN MIX_ENV=prod mix assets.deploy

# Copy source
COPY lib lib
COPY priv priv

# Compile the project
RUN MIX_ENV=prod mix compile

# Expose port
EXPOSE 4000

# Run migrations and start server
CMD ["sh", "-c", "mix ecto.migrate && mix phx.server"]
