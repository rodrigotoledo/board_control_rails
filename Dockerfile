ARG RUBY_VERSION=3.2.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends ca-certificates gnupg && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9 6ED0E7B82643E131 && \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    sqlite3 \
    libsqlite3-dev \ && \
    rm -rf /var/lib/apt/lists/*

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Throw-away build stage to reduce size of final image
FROM base as build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    nodejs \
    libyaml-dev \
    libgmp-dev \
    libreadline-dev \
    libjemalloc2 \
    watchman \
    sudo \
    libpq-dev \
    postgresql-client \
    imagemagick \
    libmagickwand-dev
    build-essential \
    pkg-config \
    git

    # Copia os arquivos necessários para instalar as gems
COPY Gemfile Gemfile.lock ./

# Configura o bundler para modo produção
RUN bundle config set deployment 'true' && \
    bundle config set without 'development test' && \
    bundle install --jobs=$(nproc) --retry=3

# Copia o restante da aplicação
COPY . .

RUN bundle exec bootsnap precompile app/ lib/

RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]
