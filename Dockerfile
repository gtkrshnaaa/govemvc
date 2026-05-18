# Stage 1: Build
FROM golang:1.22-alpine AS builder

# Install build dependencies for CGO (SQLite requires gcc)
RUN apk add --no-cache gcc musl-dev

WORKDIR /app

# Copy dependency files
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Compile binary into a single, self-contained file
RUN CGO_ENABLED=1 go build -ldflags="-w -s" -o main cmd/app/main.go

# Stage 2: Final
FROM alpine:3.19

WORKDIR /app

# Copy the compiled binary and necessary static/view files from builder
COPY --from=builder /app/main .
COPY --from=builder /app/views ./views

EXPOSE 8080

CMD ["./main"]
