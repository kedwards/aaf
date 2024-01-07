package main

import (
	"context"
	"fmt"
	"os"
	"strconv"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sqs"
)

const (
	AWS_SQS_URL = "https://sqs.us-west-2.amazonaws.com/763822266720/queue1"
)

func main() {
	lambda.Start(Handler)
}

func Handler(ctx context.Context) (string, error) {
	fmt.Println("I'm going to push a message to the SQS queue")

	// SQS message-sending logic goes here
	AddMessageToQueue(2, 4)

	return "Message sent successfully", nil
}

func AddMessageToQueue(productId, quantity int) {
	awsSession, err := GetAWSSession()
	if err != nil {
		panic(err)
	}

	// prepare SQS client
	sqsClient := sqs.New(awsSession)

	// prepare message attributes to push into queue
	messageAttributes := map[string]*sqs.MessageAttributeValue{
		"ProductId": {
			DataType:    aws.String("String"),
			StringValue: aws.String(strconv.Itoa(productId)),
		},
		"Quantity": {
			DataType:    aws.String("String"),
			StringValue: aws.String(strconv.Itoa(quantity)),
		},
	}

	// send message to the queue
	_, err = sqsClient.SendMessage(&sqs.SendMessageInput{
		// MessageGroupId:         aws.String("productId" + fmt.Sprint(productId)),
		// MessageDeduplicationId: aws.String("productId" + fmt.Sprint(productId) + "_" + fmt.Sprint(quantity)),
		MessageAttributes:      messageAttributes,
		MessageBody:            aws.String("Going to process queue for item : " + fmt.Sprint(productId)),
		QueueUrl:               aws.String(AWS_SQS_URL),
	})

	if err != nil {
		panic(err)
	}
}

func GetAWSSession() (*session.Session, error) {
	region := os.Getenv("AWS_REGION")
	awsSession, err := session.NewSession(&aws.Config{
		Region: aws.String(region)},
	)
	if err != nil {
		return nil, err
	}

	return awsSession, nil
}
