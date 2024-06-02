# allows us to expose certain values or information about our infrastructure that can be useful for other parts of our system or for external consumption.
# Here, we define only one output to retrieve the public IP address of the instance we will create.


output "gce_instance_ip" {
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}
