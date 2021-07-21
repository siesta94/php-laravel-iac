#########################################
#Importing certificate from local to ACM#
#########################################

resource "aws_acm_certificate" "pm4_cert" {
  private_key      = file("${path.module}/cert/privatekey.pem")
  certificate_body = file("${path.module}/cert/public.crt")
}
