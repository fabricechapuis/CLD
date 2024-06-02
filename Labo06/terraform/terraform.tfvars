# This file contains variables to be used by the others configuration files.
# Here, we define the IDs, paths and names required to create our vm instance and firewall.

gcp_project_id = "labgce-424214"
gce_instance_name = "terraform-lab"
gce_instance_user = "alt"
gce_ssh_pub_key_file_path = "../credentials/labgce-ssh-key.pub"
gcp_service_account_key_file_path = "../credentials/labgce-service-account-key.json"