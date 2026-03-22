resource "aws_security_group" "jenkins_sg" {
  name   = "jenkins-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "jenkins-sg" }
}

resource "aws_instance" "jenkins" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.medium"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  tags = { Name = "jenkins-server" }
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "jenkins-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  dimensions = {
    InstanceId = aws_instance.jenkins.id
  }
  alarm_description = "CPU utilization exceeded 80%"
}
