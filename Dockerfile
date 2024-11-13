FROM ubuntu:24.04

COPY beanstalk/ /beanstalk/

COPY entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]