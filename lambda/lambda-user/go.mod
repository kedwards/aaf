module github.com/kedwards/lambdaUser

go 1.21.1

require (
	github.com/aws/aws-lambda-go v1.42.0
	github.com/aws/aws-sdk-go v1.49.4
)

require github.com/jmespath/go-jmespath v0.4.0 // indirect

replace github.com/kedwards/lambdaUser/pkg => ./pkg

replace github.com/kedwards/lambdaUser/pkg/handlers => ../pkg/handlers

replace github.com/kedwards/lambdaUser/pkg/validators => ../validators

replace github.com/kedwards/lambdaUser/pkg/user => ./user
