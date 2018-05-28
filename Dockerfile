FROM alpine:3.5

ADD ./bin/api /

ENTRYPOINT ["set -e", "exec \"$@\""]

CMD ["/api"]