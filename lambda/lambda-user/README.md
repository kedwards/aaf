# lambdaUser

## Build

```bash
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o build/main cmd/main.go
```

## Zip

```bash
zip -rj build/main.zip build/main
```

## Package with resources

```bash
aws cloudformation package --template-file template.aws.yml --s3-bucket {s3_bucket} --s3-prefix lambdas --output-template-file lambda-user.aws.yml
```

## Deploy Lambda & Api Gateway

```bash
aws cloudformation deploy --template-file lambda-user.aws.yml --stack-name lambda-user --region {aws_region}
```

## Usage


### Postman

Import the provided postman collection and set the environment variables

### Manual

```bash
rest_api_id=$(aws apigateway get-rest-apis --query "items[?starts_with(name, 'qp-')].id" --output text)
endpoint=https://${rest_api_id}.execute-api.{aws_region}.amazonaws.com/v1/user

# Add user
curl --header "Content-Type: application/json" --request POST --data '{"email": "kedwards@kevinedwards.ca", "firstName": "Kevin", "lastName": "Edwards"}' $endpoint

# List users
curl -X GET $endpoint

# List user by email
curl -X GET $endpoint\?email\=kedwards@kevinedwards.ca

# Update user
curl --header "Content-Type: application/json" --request PUT --data '{"email": "kedwards@kevinedwards.ca", "firstName": "Kevin Great", "lastName": "Edwards"}' $endpoint

# Delete user
curl -X DELETE $endpoint\?email\=kedwards@kevinedwards.ca
```

# Authenticated 

```bash
-H ‘x-api-key: {your api key}’
```
