resource "google_container_cluster" "gke_cluster" {
  name = "quest-gke-cluster"
  location = "us-east1-b"
  network = google_compute_network.quest_vpc.id
  subnetwork = google_compute_subnetwork.private_subnet.id

  remove_default_node_pool = true
  initial_node_count = 1

  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = false
    master_ipv4_cidr_block = "172.18.0.0/28"
  }

  ip_allocation_policy {
    cluster_secondary_range_name = "pod-range"
    services_secondary_range_name = "service-range"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "0.0.0.0/0"
      display_name = "all"
    }
  }
}

resource "google_container_node_pool" "gke_node_pool" {
  name = "quest-gke-node-pool"
  location = "us-east1-b"
  cluster = google_container_cluster.gke_cluster.name
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    # service_account = google_service_account.gke_sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# resource "google_service_account" "gke_sa"{
#   account_id = "quest-gke-sa"
#   display_name = "GKE Service account"
# }

# resource "google_project_iam_member" "gke_sa_role" {
#   project = var.project_id
#   role = "roles/container.nodeServiceAgent"
#   member = "serviceAccount:${google_service_account.gke_sa.email}"
# }

# resource "google_project_iam_member" "gke_sa_artifact_role" {
#   project = var.project_id
#   role    = "roles/artifactregistry.reader"
#   member  = "serviceAccount:${google_service_account.gke_sa.email}"
# }