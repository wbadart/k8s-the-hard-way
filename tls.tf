# ==========
# Certificate Authority
# ==========

resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.ca.private_key_pem}"

  subject {
    common_name         = "Kubernetes"
    organization        = "Kubernetes"
    organizational_unit = "CA"
    country             = "US"
    locality            = "Washington"
  }

  allowed_uses          = ["cert_signing", "key_encipherment", "server_auth", "client_auth"]
  is_ca_certificate     = true
  validity_period_hours = 8760
}

# ==========
# Primary Admin
# ==========

resource "tls_private_key" "admin" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "admin" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.admin.private_key_pem}"
  subject {
    common_name         = "admin"
    country             = "US"
    locality            = "Washington"
    organization        = "system:masters"
    organizational_unit = "Kubernetes the Hard Way"
  }
}

resource "tls_locally_signed_cert" "admin" {
  cert_request_pem      = "${tls_cert_request.admin.cert_request_pem}"
  ca_key_algorithm      = "RSA"
  ca_private_key_pem    = "${tls_private_key.ca.private_key_pem}"
  ca_cert_pem           = "${tls_self_signed_cert.ca.cert_pem}"
  allowed_uses          = ["cert_signing", "key_encipherment", "server_auth", "client_auth"]
  validity_period_hours = 8760
}
