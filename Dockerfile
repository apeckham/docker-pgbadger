FROM phusion/baseimage:0.9.17

RUN apt-get update && \
    apt-get install python-pip unzip jq && \
    pip install awscli
                     
ADD https://github.com/dalibo/pgbadger/archive/v7.1.zip /tmp/pgbadger.zip
RUN unzip -d /tmp pgbadger.zip && \
    mv /tmppgbadger-7.1/pgbadger /usr/local/bin

RUN echo us-east-1 > /etc/container_environment/AWS_DEFAULT_REGION
            
ADD run.sh /
CMD /run.sh