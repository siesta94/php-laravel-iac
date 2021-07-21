####################
#SQS QUEUE CREATE  #
####################

resource "aws_sqs_queue" "pm4-sqs-queue" {
  name       = "PM4-${var.pm4_client_name}-Queue"
  fifo_queue = false

  tags = {
    name = "PM4-${var.pm4_client_name}-Queue"
  }
}
