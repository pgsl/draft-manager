FROM ruby:2.6.5

RUN apt-get update -qq && apt-get install -y build-essential default-mysql-client pv netcat optipng
RUN curl -sL https://deb.nodesource.com/setup_12.x | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=true bash -
RUN apt-get update -qq && apt-get install -y nodejs
RUN npm install yarn -g
RUN gem install bundler -v 2.0.2
ENV BUNDLER_VERSION=2.0.2

RUN curl -sSL https://sdk.cloud.google.com > /tmp/gcl && bash /tmp/gcl --disable-prompts

RUN mkdir /app
WORKDIR /app

COPY Gemfile      /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

ADD . /app

COPY ./docker/docker-entrypoint.sh /usr/local/bin

ENTRYPOINT ["docker-entrypoint.sh"]
