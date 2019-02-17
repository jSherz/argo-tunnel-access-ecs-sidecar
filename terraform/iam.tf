data "aws_iam_policy_document" "task_execution_assume" {
  statement {
    sid     = "AllowECSToAssume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_execution" {
  name               = "grafana-task-execution-role"
  assume_role_policy = "${data.aws_iam_policy_document.task_execution_assume.json}"
}

resource "aws_iam_role_policy_attachment" "task_execution" {
  role       = "${aws_iam_role.task_execution.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Deploying this tf? Replace this with a policy locked down to parameters for the service
resource "aws_iam_role_policy_attachment" "task_execution_ssm" {
  role       = "${aws_iam_role.task_execution.id}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}
