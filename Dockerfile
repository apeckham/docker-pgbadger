FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y python-pip unzip jq pv groff less && \
    pip install awscli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
                     
ADD https://github.com/dalibo/pgbadger/archive/v7.1.zip /tmp/pgbadger.zip
RUN unzip -d /tmp /tmp/pgbadger.zip && \
    mv /tmp/pgbadger-7.1/pgbadger /usr/local/bin

ADD run.sh /
CMD ["/run.sh"]