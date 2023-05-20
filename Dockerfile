#Build latest x-ui from source
FROM golang:1.20.4-alpine AS builder
WORKDIR /app
ARG TARGETARCH 
RUN apk --no-cache --update add build-base gcc wget unzip
COPY . .
RUN env CGO_ENABLED=1 go build -o build/x-ui main.go
RUN arch=`arch` &&  platform=`[ $arch = "aarch64" ] && echo "arm64" || echo "amd64"` && ./DockerInit.sh $platform


#Build app image using latest x-ui
FROM alpine
ENV TZ=Asia/Tehran
WORKDIR /app

RUN apk add ca-certificates tzdata

COPY --from=builder  /app/build/ /app/
VOLUME [ "/etc/x-ui" ]
ENTRYPOINT [ "/app/x-ui" ]
