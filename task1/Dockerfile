
# syntax=docker/dockerfile:1
FROM ubuntu:latest
WORKDIR /code

RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 --no-cache-dir install --upgrade pip \
  && pip3 install flask \
  && rm -rf /var/lib/apt/lists/*
ENV FLASK_APP=application1.py
ENV FLASK_ENV=development
ENV FLASK_RUN_PORT=5000
EXPOSE 8080
COPY . /code/
CMD ["flask", "run", "--host=0.0.0.0"]