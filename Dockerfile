# syntax = docker/dockerfile:1

# ----------------------------------------------------------------------------------------------------------------------------
# Base build stage for building gems

ARG RUBY_VERSION=3.3.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

ENV BUNDLE_PATH="/usr/local/bundle"

FROM base as build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    pkg-config \
    libpq-dev

COPY Gemfile Gemfile.lock ./
RUN bundle config set --local frozen false && \
    bundle install && \
    rm -rf ~/.bundle/ \
    "${BUNDLE_PATH}"/ruby/*/cache \
    "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY . .

# ----------------------------------------------------------------------------------------------------------------------------
# Final stage for app image
FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libpq-dev \
    postgresql-client \
    neovim \
    xz-utils && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Include FFMPEG (Video processing)
RUN curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz | tar -xJ && \
    mv ffmpeg-*-amd64-static/ffmpeg /usr/local/bin/ffmpeg && \
    mv ffmpeg-*-amd64-static/ffprobe /usr/local/bin/ffprobe && \
    rm -rf ffmpeg-*-amd64-static

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
