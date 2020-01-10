resource "aws_db_subnet_group" "main" {
    name = "main"
    subnet_ids = ["${aws_subnet.private.id}"]
}

resource "aws_rds_cluster" "db-1" {
    engine_mode = "serverless"
    db_subnet_group_name = "${aws_db_subnet_group.main.name}"
    vpc_security_group_ids = ["${aws_security_group.db.id}"]

    tags = {
        Name = "BoardtimeDB"
    }
}
