# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.0
FROM quay.io/evl.ms/fullstaq-ruby:${RUBY_VERSION}-jemalloc-slim AS base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
  BUNDLE_DEPLOYMENT="1" \
  BUNDLE_PATH="/usr/local/bundle" \
  BUNDLE_WITHOUT="development,test" \
  PYTHONUNBUFFERED=1 \
  PYTHONDONTWRITEBYTECODE=1 \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  POETRY_HOME="/opt/poetry" \
  POETRY_VIRTUALENVS_IN_PROJECT=true \
  POETRY_NO_INTERACTION=1 \
  PYSETUP_PATH="/opt/pysetup" \
  VENV_PATH="/opt/pysetup/.venv" \
  POETRY_VERSION=1.7.1

ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config automake libtool libffi-dev libssl-dev libgmp-dev python3-dev python-is-python3 curl python3-distutils postgresql-client libyaml-dev python-is-python3

RUN curl -sSL https://install.python-poetry.org | python3 -

WORKDIR $PYSETUP_PATH
COPY rails_app/poetry.lock rails_app/pyproject.toml ./
RUN poetry install --no-dev && \
  chmod -R 777 $PYSETUP_PATH

# Install application gems
COPY rails_app/Gemfile rails_app/Gemfile.lock /rails/rails_app/
COPY infra/Gemfile.test infra/Gemfile infra/Gemfile.lock infra/infra.gemspec /rails/infra/

WORKDIR /rails/rails_app
RUN bundle install && \
  rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
  bundle exec bootsnap precompile --gemfile

WORKDIR /rails/
# Copy application code
COPY . .

WORKDIR /rails/rails_app
# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/


# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y curl libvips postgresql-client python3-dev python-is-python3 && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails
COPY --from=build $PYSETUP_PATH $PYSETUP_PATH

WORKDIR /rails/rails_app
# Run and own only the runtime files AS a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
  chown -R rails:rails db log storage tmp $PYSETUP_PATH
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/rails_app/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
