resource "google_compute_network" "quest_vpc" {
  name = "quest-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private_subnet" {
  name = "quest-private-subnet"
  ip_cidr_range = "10.0.0.0/24"
  network = google_compute_network.quest_vpc.id

  private_ip_google_access = true

  secondary_ip_range {
    range_name = "pod-range"
    ip_cidr_range = "172.16.0.0/24"
  }

  secondary_ip_range {
    range_name = "service-range"
    ip_cidr_range = "172.17.0.0/24"
  }
}

resource "google_compute_router" "nat_router" {
  name = "quest-nat-router"
  network = google_compute_network.quest_vpc.id
}

resource "google_compute_router_nat" "nat_gw" {
  name = "quest-nat"
  router = google_compute_router.nat_router.name
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
