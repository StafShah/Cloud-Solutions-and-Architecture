locals {
  http_method = {
    post = "POST"
    get = "GET"
    options = "OPTIONS"
  }
}

resource "aws_api_gateway_rest_api" "rest_api" {
  name = "${var.api_name}"
  description = var.description

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "root" {
  count = length(var.paths) > 0 ? length(var.paths) : 0
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part = element(var.paths, count.index)
}

//POST Componenets
//Method Request
resource "aws_api_gateway_method" "post_proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.root[0].id
  http_method = local.http_method["post"]
  authorization = var.auth_type
  authorizer_id = aws_api_gateway_authorizer.cognito.id
  request_validator_id = aws_api_gateway_request_validator.validate_body.id
  request_models = {
    "application/json" = aws_api_gateway_model.FlightModel.name
  }
}

resource "aws_api_gateway_request_validator" "validate_body" {
  name                        = "${var.api_name}"
  rest_api_id                 = aws_api_gateway_rest_api.rest_api.id
  validate_request_body       = true
  validate_request_parameters = false
}



resource "aws_api_gateway_model" "FlightModel" {
  rest_api_id  = aws_api_gateway_rest_api.rest_api.id
  name         = "FlightModelSchema"
  description  = "a JSON schema"
  content_type = "application/json"

#   Add relevant schema here
#   schema = <<EOF
#   {
#   "$schema" : "http://json-schema.org/draft-04/schema#",
#   "title" : "FlightModelReUsableRef",
#   "required" : ["FlightNo"],
#   "type" : "object",
#   "properties" : {
#     "FlightNo" : {
#       "type" : "string"
#     },
#     "Manufacturer" : {
#       "$ref": "#/definitions/Manufacturer"
#     },
#     "Type" : {
#         "$ref": "#/definitions/Type"
#     },
#     "Operator": {
#       "type": "string"
#     },
#     "Status": {
#         "$ref": "#/definitions/Status"
#     },
#     "Year": {
#       "$ref": "#/definitions/Year"
#     }
#   },
#   "definitions" : {
#       "Manufacturer": {
#         "type" : "string",
#         "enum": [ "Boeing", "AirBus", "Concorde", "Tupolev", "McDonnell Douglas", "Douglas", "GulfStream" ]
#       },
#       "Type": {
#         "type": "string"
#       },
#       "Status": {
#         "type" : "string",
#         "enum": [ "InService", "Retried", "Crashed", "Unknown" ]
#       },
#       "Year": {
#         "type": "number",
#         "minimum" : 1900,
#         "maximum" : 2025
#       }
#     }
#   }
# EOF
}


//Integration Request
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.root[0].id
  http_method = aws_api_gateway_method.post_proxy.http_method
  integration_http_method = local.http_method["post"]
  type = "AWS_PROXY"
  uri = var.lambda_invoke_arn
}

//Integration Response
resource "aws_api_gateway_integration_response" "post_proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.root[0].id
  http_method = aws_api_gateway_method.post_proxy.http_method
  status_code = aws_api_gateway_method_response.post_proxy.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.post_proxy,
    aws_api_gateway_integration.lambda_integration
  ]
}

//Method Response
resource "aws_api_gateway_method_response" "post_proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.root[0].id
  http_method = aws_api_gateway_method.post_proxy.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}


//GET
resource "aws_api_gateway_method" "get_proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.root[1].id
  http_method = local.http_method["get"]
  authorization = var.auth_type
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "lambda_getintegration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.root[1].id
  http_method = aws_api_gateway_method.get_proxy.http_method
  integration_http_method = local.http_method["get"]
  type = "AWS_PROXY"
  uri = var.lambda_invoke_arn
}

resource "aws_api_gateway_integration_response" "get_proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.root[1].id
  http_method = aws_api_gateway_method.get_proxy.http_method
  status_code = aws_api_gateway_method_response.get_proxy.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.get_proxy,
    aws_api_gateway_integration.lambda_getintegration
  ]
}

resource "aws_api_gateway_method_response" "get_proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.root[1].id
  http_method = aws_api_gateway_method.get_proxy.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
}
}


//COMMON RESOURCES
//Deploy Manually from console
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_method.get_proxy,
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration.lambda_getintegration
  ]

  rest_api_id = aws_api_gateway_rest_api.rest_api.id
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = var.stage_name 
}

resource "aws_api_gateway_method_settings" "example" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.example.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    data_trace_enabled = true
    logging_level   = "INFO"
  }
}


resource "aws_lambda_permission" "apigw_lambda" {
  count = length(var.paths) > 0 ? length(var.paths) : 0
  statement_id = element(var.lambdapermission_statements, count.index)
  action = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/${element(var.methods,count.index)}/${element(var.paths,count.index)}"
}

resource "aws_api_gateway_authorizer" "cognito" {
  name = "ap-aws-dev-${var.api_name}"
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  type = var.auth_type
  provider_arns = [var.cognito_user_pool_arn]
  identity_source = "method.request.header.Test-Cookie"
}