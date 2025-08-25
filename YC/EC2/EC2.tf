module "compute_instance" {
  source = "git::https://github.com/terraform-yc-modules/terraform-yc-compute-instance.git?ref=1.0.2"
  for_each = local.config.instances

  labels                    = each.value.labels
  image_family              = each.value.image_family
  zone                      = each.value.zone
  name                      = each.key
  hostname                  = "${each.key}.internal"
  description               = "Инстанс для ${each.key}"
  memory                    = each.value.memory
  gpus                      = each.value.gpus
  cores                     = each.value.cores
  core_fraction             = each.value.core_fraction
  serial_port_enable        = each.value.serial_port_enable
  allow_stopping_for_update = each.value.allow_stopping_for_update
  monitoring                = each.value.monitoring
  backup                    = each.value.backup
  boot_disk = {
    size        = each.value.boot_disk.boot_disk_size
    block_size  = each.value.boot_disk.block_size
    type        = each.value.boot_disk.type
    image_id    = null
    snapshot_id = null
  }

  # Authentication - either use OS Login
  enable_oslogin_or_ssh_keys = {
    enable-oslogin = each.value.enable-oslogin
  }
  scheduling_policy_preemptible = each.value.preemptible

  network_interfaces = [
    {
      subnet_id = data.terraform_remote_state.vpc.outputs.vpc_private_subnets[local.config.subnets.private_subnets[0].v4_cidr_blocks[0]].subnet_id
      ipv4      = true
      nat       = true
      security_group_ids = [data.terraform_remote_state.vpc.outputs.sg_ids["${each.key}-sg"]]
    }
  ]
}