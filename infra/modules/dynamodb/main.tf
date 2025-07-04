resource "aws_dynamodb_table" "crew" {
  name         = "crew"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "crew_id"

  attribute {
    name = "crew_id"
    type = "S"
  }

  tags = {
    Project = "mdapkr2"
    Purpose = "Crew Data"
  }
}

resource "aws_dynamodb_table" "missions" {
  name         = "missions"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "name"

  attribute {
    name = "name"
    type = "S"
  }

  tags = {
    Project = "mdapkr2"
    Purpose = "Mission Definitions"
  }
}

resource "aws_dynamodb_table" "availability" {
  name         = "availability"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "crew_id"

  attribute {
    name = "crew_id"
    type = "S"
  }

  tags = {
    Project = "mdapkr2"
    Purpose = "Crew Availability"
  }
}
