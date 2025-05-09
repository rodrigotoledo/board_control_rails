ARG RUBY_VERSION=3.3.4
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    sqlite3 \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

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
    sqlite3 \
    watchman \
    libsqlite3-dev \
    sudo \
    libpq-dev \
    postgresql-client \
    imagemagick \
    libmagickwand-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

    # Copia os arquivos necessários para instalar as gems
COPY Gemfile Gemfile.lock ./

# Configura o bundler para modo produção
RUN bundle config set deployment 'true' && \
    bundle config set without 'development test' && \
    bundle install --jobs=$(nproc) --retry=3 && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete

# Copia o restante da aplicação
COPY . .

# Precompila os bootsnap e os assets
RUN bundle exec bootsnap precompile --gemfile && \
    SECRET_KEY_BASE=dummy RAILS_ENV=production bundle exec rails assets:precompile

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
