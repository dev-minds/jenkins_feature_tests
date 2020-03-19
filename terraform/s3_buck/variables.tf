variable "bucket_name" {
  description = "Specify unique bucket name. If ommitted, a random name will be generated"
  type        = string
  default     = ""
}

variable "region" {
   description = "Specify Region"
   default    = ""
}