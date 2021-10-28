//////////////////////////////////////
// 1. ECS
//////////////////////////////////////

resource "aws_ecs_cluster" "this" {
  name = local.cluster
  tags = {
    "Name"      = local.name_prefix
    Environment = var.tags.Environment
  }
}

