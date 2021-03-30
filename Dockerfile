FROM ruby:2.7.2

RUN apt-get update -qq && apt-get install -y build-essential default-mysql-client pv netcat optipng
RUN curl -sL https://deb.nodesource.com/setup_12.x | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=true bash -
RUN apt-get update -qq && apt-get install -y nodejs
RUN npm install yarn -g
RUN gem install bundler -v 2.2.6
ENV BUNDLER_VERSION=2.2.6

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile      /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle config set without 'development'
RUN bundle install

COPY package.json /app/package.json
COPY yarn.lock /app/yarn.lock
RUN yarn install --production=true

ADD . /app

COPY ./docker/docker-entrypoint.sh /usr/local/bin

ENTRYPOINT ["docker-entrypoint.sh"]
