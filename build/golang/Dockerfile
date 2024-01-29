FROM golang:alpine3.19 as base

ARG USER_UID=10001
ARG USER_NAME=appuser

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${USER_UID}" \
    "${USER_NAME}"

WORKDIR /app
COPY go.mod .

FROM base as dev

ENV GO111MODULE=on
RUN go mod download && go mod verify

COPY --from=cosmtrek/air:v1.45.0 /go/bin/air /go/bin/air
ENTRYPOINT [ "air", "-c", "./build/golang/.air.toml" ]

FROM base as builder

COPY . .
RUN go get -d -v

ARG GOOS
ARG GOARCH
ARG CGO_ENABLED

RUN CGO_ENABLED=${CGO_ENABLED} GOOS=${GOOS} GOARCH=${GOARCH} go build \
    -ldflags='-w -s -extldflags "-static"' -a \
    -o main .

FROM scratch as prod
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder app/ .

USER ${USER_NAME}:${USER_NAME}

ENTRYPOINT [ "main" ]