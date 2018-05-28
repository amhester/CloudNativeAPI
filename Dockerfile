FROM alpine:3.5

ADD ./bin/api /

CMD ["/api"]