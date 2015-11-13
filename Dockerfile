FROM clojure

ADD https://github.com/dalibo/pgbadger/archive/v7.1.zip /tmp/pgbadger.zip
RUN unzip -d /tmp /tmp/pgbadger.zip && \
    mv /tmp/pgbadger-7.1/pgbadger /usr/local/bin && \
    rm -rf /tmp/pgbadger-7.1

ENV AWS_REGION us-east-1

RUN mkdir -p /tmp
ADD app/project.clj /tmp
RUN cd /tmp && lein deps

ADD app /app
WORKDIR /app

CMD ["lein", "run"]
