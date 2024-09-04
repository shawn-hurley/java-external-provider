# Build the manager binary
FROM golang:1.20 as builder

COPY / /analyzer-lsp

WORKDIR /java-provider

COPY external-providers/java-external-provider/go.mod go.mod
COPY external-providers/java-external-provider/go.sum go.sum


COPY external-providers/java-external-provider/main.go main.go
COPY external-providers/java-external-provider/pkg/ pkg/

RUN go mod edit -replace=github.com/konveyor/analyzer-lsp=/analyzer-lsp && go mod tidy

RUN go build -a -o java-external-provider main.go

FROM quay.io/konveyor/jdtls-server-base

COPY --from=builder /java-provider/java-external-provider /usr/local/bin/java-external-provider

EXPOSE 14651

ENTRYPOINT ["java-external-provider", "--port", "14651"]