FROM crystallang/crystal:latest-alpine

RUN crystal -v 

RUN apk add --update docker openrc
RUN rc-update add docker boot
RUN apk add git

WORKDIR /app

RUN mkdir /app/scripts/  
COPY spec/assets/*.sh /app/scripts/
COPY src ./src
COPY shard.yml ./shard.yml

# install crystal deps
RUN shards install && crystal build --release src/api.cr -o ./app

COPY spec/assets/minion.yml ./minion.yml
ENV MINION_CONFIG_FILE ./minion.yml

EXPOSE 3000

CMD ./app