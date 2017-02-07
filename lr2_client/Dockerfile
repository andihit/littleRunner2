FROM ubuntu:16.04
MAINTAINER Andreas Gerstmayr <andreas.gerstmayr@gmail.com>

RUN apt-get update && apt-get install -y \
    nodejs-legacy \
    npm
RUN npm install -g brunch

COPY . /web/littleRunner2
WORKDIR /web/littleRunner2

CMD npm install && brunch build
