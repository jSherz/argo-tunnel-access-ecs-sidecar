provider "aws" {
  region  = "eu-west-1"
  version = "~> 1.59"
}

provider "template" {
  version = "~> 2.0"
}

resource "aws_ecr_repository" "app" {
  name = "grafana-app"
}

resource "aws_ecr_repository" "sidecar" {
  name = "grafana-tunnel-sidecar"
}

data "template_file" "task_definition" {
  template = "${file("task-definition.json")}"

  vars {
    aws_account_id = "${var.aws_account_id}"
  }
}

resource "aws_ecs_task_definition" "service" {
  family                   = "grafana"
  container_definitions    = "${data.template_file.task_definition.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = 1024
  memory = 2048

  execution_role_arn = "${aws_iam_role.task_execution.arn}"
}

resource "aws_ecs_cluster" "main" {
  name = "main"
}

resource "aws_ecs_service" "service" {
  cluster         = "${aws_ecs_cluster.main.arn}"
  name            = "grafana"
  task_definition = "${aws_ecs_task_definition.service.arn}"
  launch_type     = "FARGATE"
  desired_count   = 1

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"

  network_configuration {
    assign_public_ip = true
    subnets          = ["${var.subnet_ids}"]
  }
}
