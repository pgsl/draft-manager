FROM ruby:2.4.2

RUN apt-get update -qq && apt-get install -y build-essential nodejs mysql-client netcat

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

ADD . /app

COPY ./docker/docker-entrypoint.sh /usr/local/bin

ENTRYPOINT ["docker-entrypoint.sh"]
