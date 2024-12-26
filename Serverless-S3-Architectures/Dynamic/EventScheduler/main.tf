resource "aws_cloudwatch_event_rule" "trigger_rule" {
  name        = "ap-aws-dev-${var.region_prefix}-${var.suffix}"
  description = var.description
  state = var.state 
  schedule_expression = var.rate
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.trigger_rule.name
  target_id = var.target_id 
  arn       = var.target_arn
  
  //pass input from child module as a variable after POC
#   input = <<JSON
# {
#     "queryStringParameters": {
#         "flightno": "EK234"
#     },
#     "resource": "/getflightno",
#     "path": "/getflightno",
#     "httpMethod": "GET"
# }
# JSON
}