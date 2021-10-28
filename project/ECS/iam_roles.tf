# CodeDeploy for ECS
# => (Managed) ELB, ASG, SNS, ECS, S3

# CodeBuild
# => (Managed) + Secrets-manager, S3, ECR, ..

# CodePipeline
# => (Managed)

# ECS Task Execution Role
# => (Managed) AmazonECSTaskExecutionRolePolicy, Trusted entities : ecs-tasks

# ECSServiceRole
# => (Managed), Trusted entities : ecs