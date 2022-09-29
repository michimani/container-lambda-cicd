package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"time"

	runtime "github.com/aws/aws-lambda-go/lambda"
)

type Response struct {
	Message    string `json:"message"`
	StatusCode int    `json:"statusCode"`
}

const message = "Hello Container Lambda!"

func handleRequest(ctx context.Context) (Response, error) {
	log.Println("start handler")
	defer log.Println("end handler")

	return Response{
		Message:    fmt.Sprintf("[%s] %s", time.Now().Format(time.RFC3339), message),
		StatusCode: http.StatusOK,
	}, nil
}

func init() {
	log.Println("cold start")
}

func main() {
	runtime.Start(handleRequest)
}
