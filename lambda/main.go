package main

import (
	"containerlambda/util"
	"context"
	"log"
	"net/http"
	"time"

	runtime "github.com/aws/aws-lambda-go/lambda"
)

type Response struct {
	Message    string `json:"message"`
	StatusCode int    `json:"statusCode"`
}

func handleRequest(ctx context.Context) (Response, error) {
	log.Println("start handler")
	defer log.Println("end handler")

	message := util.NewMessage(time.Now())

	return Response{
		Message:    message,
		StatusCode: http.StatusOK,
	}, nil
}

func init() {
	log.Println("cold start")
}

func main() {
	runtime.Start(handleRequest)
}
