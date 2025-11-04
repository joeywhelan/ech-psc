data "ec_stack" "elastic_latest" {
  version_regex = "latest"
  region        = "gcp-${var.region}"
}

resource "ec_deployment" "primary" {
  region                 = "gcp-${var.region}"
  name                   = "primary_cluster"
  version                = data.ec_stack.elastic_latest.version
  deployment_template_id = var.deployment_template_id

  elasticsearch = {
    hot = {
      autoscaling = {}
    }
  }

  kibana = {}
}

provider "elasticstack" {
  elasticsearch {
    endpoints = ["${ec_deployment.primary.elasticsearch.https_endpoint}"]
    username  = ec_deployment.primary.elasticsearch_username
    password  = ec_deployment.primary.elasticsearch_password
  }
  alias = "primary"
}

resource "elasticstack_elasticsearch_index" "test_index" {
  provider = elasticstack.primary
  name = "test-index"

  mappings = jsonencode({
    properties = {
      field_1 = { type = "text" }
      field_2 = { type = "text" }
      field_3 = { type = "text" }
      field_4 = { type = "text" }
      field_5 = { type = "text" }
      field_6 = { type = "text" }
      field_7 = { type = "text" }
      field_8 = { type = "text" }
      field_9 = { type = "text" }
      field_10 = { type = "text" }
    }
  })

  deletion_protection = false
  number_of_shards   = 1
  number_of_replicas = 1
  search_idle_after  = "20s"
}

