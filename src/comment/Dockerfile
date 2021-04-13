FROM alpine:3.13.2

RUN apk --update add --no-cache \
    build-base \
    ruby-dev \
    ruby-full \
    && gem install bundler:1.17.2 --no-document \
    && rm -rf /var/cache/apk/*

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/
RUN bundle install
COPY . $APP_HOME

ENV COMMENT_DATABASE_HOST=comment_db \
    COMMENT_DATABASE=comments

CMD ["puma"]
