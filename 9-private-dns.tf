resource "aws_route53_zone" "internal" {
  name = "andimsum.internal"

  vpc {
    vpc_id = aws_vpc.andimsum.id
  }
}

resource "aws_route53_record" "edge1" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "edge1"
  type    = "A"
  ttl     = 300
  records = [aws_instance.edge1.private_ip]
}

resource "aws_route53_record" "private_workloads" {
  for_each = aws_instance.private_workloads

  zone_id = aws_route53_zone.internal.zone_id
  name    = each.key
  type    = "A"
  ttl     = 300
  records = [each.value.private_ip]
}
