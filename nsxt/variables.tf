variable "nsx_host" {
  description = "The NSX-T Manager host or IP address"
  type        = string
}

variable "nsx_username" {
  description = "The NSX-T Manager username"
  type        = string
}

variable "nsx_password" {
  description = "The NSX-T Manager password"
  type        = string
  sensitive   = true
}

variable "allow_unverified_ssl" {
  description = "Allow unverified SSL certificates"
  type        = bool
  default     = true
}
