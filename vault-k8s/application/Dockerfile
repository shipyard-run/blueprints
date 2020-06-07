FROM golang:latest

WORKDIR /go/src/github.com/hashicorp/app

COPY . /go/src/github.com/hashicorp/app

RUN CGO_ENABLED=0 go build -o ./bin/app

FROM scratch

COPY --from=0 /go/src/github.com/hashicorp/app/bin/app /app

ENTRYPOINT [ "/app" ]