# DOCKER-VERSION 0.9.0

FROM quill_base

MAINTAINER Quinn Shanahan q.shanahan@gmail.com

EXPOSE 3000
ADD . /app
RUN cd /app; bundle install
