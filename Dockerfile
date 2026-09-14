FROM ruby:3.3-slim

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential libsqlite3-dev sqlite3 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
ENV RAILS_ENV=production BUNDLE_WITHOUT="development test"

COPY Gemfile Gemfile.lock* ./
RUN bundle install

COPY . .

# Propshaft digests assets into public/assets. SECRET_KEY_BASE isn't
# used at precompile time but Rails insists one exists.
RUN SECRET_KEY_BASE=dummy bin/rails assets:precompile

EXPOSE 3000
CMD ["bin/docker-entrypoint"]
