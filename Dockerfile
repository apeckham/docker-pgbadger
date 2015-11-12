FROM alpine:3.2

RUN apk add --update python py-pip build-base bash jq groff less perl && \
  pip install awscli && \
  rm -rf /var/cache/apk/*
                     
ADD https://github.com/dalibo/pgbadger/archive/v7.1.zip /tmp/pgbadger.zip
RUN unzip -d /tmp /tmp/pgbadger.zip && \
    mv /tmp/pgbadger-7.1/pgbadger /usr/local/bin && \
    rm -rf /tmp/pgbadger-7.1
    
ADD http://www.ivarch.com/programs/sources/pv-1.6.0.tar.gz /tmp/pv-1.6.0.tar.gz
RUN cd /tmp && tar xvfz pv-1.6.0.tar.gz && cd pv-1.6.0 && ./configure && make && make install && rm -rf /tmp/pv-1.6.0

ADD run.sh /
CMD ["/run.sh"]