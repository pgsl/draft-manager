FROM ruby:2.4.5

RUN apt-get update -qq && apt-get install -y build-essential mysql-client netcat
RUN curl -sL https://deb.nodesource.com/setup_8.x | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=true bash -
RUN apt-get update -qq && apt-get install -y nodejs
RUN npm install yarn -g
RUN gem install bundler

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

ADD . /app

COPY ./docker/docker-entrypoint.sh /usr/local/bin

ENTRYPOINT ["docker-entrypoint.sh"]
