FROM python:3.6.0-alpine

WORKDIR /app
COPY . /app

RUN apk --no-cache --update add build-base=0.4-r1 && \
    pip install --upgrade pip && \
    pip --no-cache-dir install -r /app/requirements.txt && \
    apk del build-base

ENV POST_DATABASE_HOST=post_db \
    POST_DATABASE=posts

ENTRYPOINT ["python3", "post_app.py"]
