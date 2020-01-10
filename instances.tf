resource "aws_instance" "web-1" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t3a.small"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.web.id}"]
    subnet_id = "${aws_subnet.public.id}"
    associate_public_ip_address = true
    source_dest_check = false


    tags = {
        Name = "Web Server 1"
    }
}
