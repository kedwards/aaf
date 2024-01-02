package main

import (
 "context"
 "fmt"

 "github.com/aws/aws-lambda-go/events"
 "github.com/aws/aws-lambda-go/lambda"
)

func main() {
 lambda.Start(ListenAndProcessSQSMessage)
}

// listens event from SQS(whenver any new message is placed in SQS Queue)
func ListenAndProcessSQSMessage(c context.Context, sqsEvent events.SQSEvent) {
 fmt.Println("Lambda is triggered by SQS")

 fmt.Println("sqsEvent : ", sqsEvent)

 data := make(map[string]interface{})

 for _, item := range sqsEvent.Records {
  for k, v := range item.MessageAttributes {
   data[k] = *v.StringValue
  }
 }

 fmt.Println("data : ", data) // map[ProductId:1 Quantity:2]
}
