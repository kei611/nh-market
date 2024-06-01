# FROM ... ベースとなるイメージを指定する
FROM python:3.9-alpine3.13
# LABEL ... イメージにベンダ名、作者名、バージョン情報等のメタデータを設定する
LABEL maintainer="naturalhighmarket.com"
# ENV ... 環境変数を指定する
ENV PYTHONUNBUFFERED 1

# COPY ... ホストからコンテナイメージにファイルやディレクトリをコピーする
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
# WORKDIR ... RUN, CMD, ENTRYPOINT, COPY, ADD, docker run, exec で実行するコンテナプロセスのワークディレクトリを指定する
WORKDIR /app
# EXPOSE ... 指定したポート番号をコンテナが公開することをDockerに伝える
EXPOSE 8000

# ARG ... Dockerfile内でのみ使用できる変数を指定する
ARG DEV=false
# RUN ... ビルド時に実行するコマンドを指定する
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

# RUN, CMD, ENTRYPOINT, docker run, exec で実行するコンテナプロセスの実行ユーザをユーザIDまたはユーザ名で指定
USER django-user
