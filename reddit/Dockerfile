FROM alpine:3.13.2

RUN apk --update add --no-cache \
    build-base \
    ruby-dev \
    ruby-full \
    && gem install bundler:1.17.2 --no-document \
    && rm -rf /var/cache/apk/*

ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . $APP_HOME

RUN rm Gemfile.lock \
    && bundle install \
    && chmod 0777 /start.sh

EXPOSE 9292
CMD ["/start.sh"]
