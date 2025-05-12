ARG RUBY_VERSION=3.2.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg \
        curl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/apt/keyrings && \
curl -fsSL http://ftp.debian.org/debian/archive/2023/key.asc | gpg --dearmor -o /etc/apt/keyrings/debian-archive.gpg && \
echo "deb [signed-by=/etc/apt/keyrings/debian-archive.gpg] http://deb.debian.org/debian bullseye main" > /etc/apt/sources.list && \
echo "deb [signed-by=/etc/apt/keyrings/debian-archive.gpg] http://deb.debian.org/debian bullseye-updates main" >> /etc/apt/sources.list

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"


FROM base as build

RUN apt-get update -qq && \
    apt-get install -y -f --fix-broken && \
    apt-get install -y --no-install-recommends \
    libxcb1 \
    libxrender1 \
    libsqlite3-0 \
    sqlite3 \
    libsqlite3-dev \
    libjemalloc2 \
    libvips && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

COPY . .

RUN bundle exec bootsnap precompile app/ lib/

RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

FROM base

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]
