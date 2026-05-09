FROM golang:1.19 AS build

WORKDIR /go/src/tasky

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -trimpath \
    -ldflags="-s -w" \
    -o /go/src/tasky/tasky


FROM gcr.io/distroless/static-debian12:nonroot AS release

WORKDIR /app

COPY --from=build /go/src/tasky/tasky /app/tasky
COPY --from=build --chown=nonroot:nonroot /go/src/tasky/assets /app/assets
COPY --from=build --chown=nonroot:nonroot /go/src/tasky/wizexercise.txt /app/wizexercise.txt

USER nonroot:nonroot

EXPOSE 8080

ENTRYPOINT ["/app/tasky"]