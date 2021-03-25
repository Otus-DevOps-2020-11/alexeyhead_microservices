# alexeyhead_microservices
alexeyhead microservices repository

### HW No. 13 (Lecture No. 17)

- The practical task of the methodical manual is performed
- the application is divided into three parts: post, comment and ui
- Created `post-py/Dockerfile`, `comment/Dockerfile` and `ui/Dockerfile`
- create images - NB! ui-image start from second step because first step docker already have in cache (a similar step contained in comment-image)

```
docker pull mongo:latest
docker build -t oleksiihead/post:1.0 ./post-py
docker build -t oleksiihead/comment:1.0 ./comment
docker build -t oleksiihead/ui:1.0 ./ui
```
- run containers to test the application

```
docker network create reddit
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/app/db mongo:latest
docker run -d --network=reddit --network-alias=post oleksiihead/post:1.0
docker run -d --network=reddit --network-alias=comment oleksiihead/comment:1.0
docker run -d --network=reddit -p 9292:9292 oleksiihead/ui:3.0
```
- run containers with new env vars, we have twwo ways: 1 - changed */Dockerfile (in this case we should build all images), 2 - using cli:

```
docker run -d --network=reddit --network-alias=app_post_db --network-alias=app_comment_db mongo:latest
docker run -d --network=reddit --network-alias=app_post --env POST_DATABASE_HOST=app_post_db oleksiihead/post:1.0
docker run -d --network=reddit --network-alias=app_comment --env COMMENT_DATABASE_HOST=app_comment_db oleksiihead/comment:1.0
docker run -d --network=reddit -p 9292:9292 --env POST_SERVICE_HOST=app_post --env COMMENT_SERVICE_HOST=app_comment oleksiihead/ui:1.0
```

- use different methods to reduce the size of the image

`src/ui/Dockerfile.1`:

````
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

ENV POST_SERVICE_HOST=post \
    POST_SERVICE_PORT=5000 \
    COMMENT_SERVICE_HOST=comment \
    COMMENT_SERVICE_PORT=9292

CMD ["puma"]

````
- after relaunch containers we have no data in app. To avoid this, use a volume for data storage. In mine case I use option from cli.

```
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/app/db mongo:latest
```
