FROM ubuntu:16.04
RUN apt-get update \
    && apt-get install --no-install-recommends -y ruby-full ruby-dev build-essential \
    && gem install bundler --no-ri --no-rdoc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/
RUN bundle install
COPY . $APP_HOME

ENV POST_SERVICE_HOST=post \
    POST_SERVICE_PORT=5000 \
    COMMENT_SERVICE_HOST=comment \
    COMMENT_SERVICE_PORT=9292

CMD ["puma"]