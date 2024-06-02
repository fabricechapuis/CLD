# This file is used to define what kind a backend and its configuration. here, our backend is "local", which meins our state file is stored locally.
# The "backend" block is empty, meaning we only use the defaults settings.

terraform {
  backend "local" {
  }
}
