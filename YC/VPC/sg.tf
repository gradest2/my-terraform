resource "yandex_vpc_security_group" "dynamic-sg" {
  for_each = local.config.sg

  name = "${each.key}"
  labels = each.value.labels
  description = each.value.description
  network_id  = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = each.value.ingresses
    content {
      from_port      = ingress.value.from_port
      to_port        = ingress.value.to_port
      port           = ingress.value.port
      protocol       = ingress.value.protocol
      description    = ingress.value.description
      v4_cidr_blocks = ingress.value.v4_cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = each.value.egresses
    content {
      from_port      = egress.value.from_port
      to_port        = egress.value.to_port
      port           = egress.value.port
      protocol       = egress.value.protocol
      description    = egress.value.description
      v4_cidr_blocks = egress.value.v4_cidr_blocks
    }
  }
}