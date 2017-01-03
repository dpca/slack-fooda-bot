FROM ruby:2.4-alpine

RUN apk add --update --no-cache build-base openssl libxml2-dev libxslt-dev

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
RUN bundle config build.nokogiri --use-system-libraries

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app
COPY Gemfile.lock /usr/src/app
RUN bundle install

COPY cron /var/spool/cron/crontabs/root
COPY . /usr/src/app

CMD ["crond", "-f"]
