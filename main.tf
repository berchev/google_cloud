variable "gcp_credentials_file_path" {
  default = "/path/to/cred/file"
}

variable "gcp_project_id" {
  default = "sup-eng-eu"
}

provider "google" {
  version = "~> 2.11.0"

  credentials = file(var.gcp_credentials_file_path)

  # Should be able to parse project from credentials file but cannot.
  # Cannot convert string to map and cannot interpolate within variables.
  project = var.gcp_project_id

}

resource "google_logging_metric" "logging_metric" {
  name   = "mass-foo-bar"
  filter = "resource.type=gae_app AND severity>=ERROR"
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    labels {
      key         = "priority"
      value_type  = "STRING"
      description = "queue priority label"
    }
    labels {
      key         = "outcome"
      value_type  = "STRING"
      description = "failure categories"
    }
  }

  label_extractors = {
    "priority" = "EXTRACT(jsonPayload.priority)"
    "outcome"  = "EXTRACT(jsonPayload.outcome)"
  }
}
