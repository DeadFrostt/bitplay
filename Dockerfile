# Use an official Golang image as the base image for building
FROM --platform=linux/arm64 golang:1.20 AS builder

# Set environment variables for Go
ENV CGO_ENABLED=0 GOOS=linux GOARCH=arm64

# Set the working directory
WORKDIR /app

# Copy Go module files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN go build -o bitplay

# Use a minimal base image for the final image
FROM --platform=linux/arm64 alpine:latest

# Set the working directory
WORKDIR /root/

# Copy the binary from the builder
COPY --from=builder /app/bitplay .

# Expose the port your application will run on
EXPOSE 8080

# Run the application
CMD ["./bitplay"]
