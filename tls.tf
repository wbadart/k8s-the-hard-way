# ==========
# Certificate Authority
# ==========

resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.ca.private_key_pem

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
  private_key_pem = tls_private_key.admin.private_key_pem
  subject {
    common_name         = "admin"
    country             = "US"
    locality            = "Washington"
    organization        = "system:masters"
    organizational_unit = "Kubernetes the Hard Way"
  }
}

resource "tls_locally_signed_cert" "admin" {
  cert_request_pem      = tls_cert_request.admin.cert_request_pem
  ca_key_algorithm      = "RSA"
  ca_private_key_pem    = tls_private_key.ca.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.ca.cert_pem
  allowed_uses          = ["cert_signing", "key_encipherment", "server_auth", "client_auth"]
  validity_period_hours = 8760
}

# ==========
# Kubelets
# ==========

locals {
  workers = toset(["worker0", "worker1", "worker2"])
}

resource "tls_private_key" "kubelets" {
  for_each  = local.workers
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "kubelets" {
  for_each        = local.workers
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.kubelets[each.key].private_key_pem
  dns_names       = [each.key]
  subject {
    common_name         = "system:node:${each.key}"
    country             = "US"
    locality            = "Washington"
    organization        = "system:nodes"
    organizational_unit = "Kubernetes the Hard Way"
  }
}

resource "tls_locally_signed_cert" "kubelets" {
  for_each              = local.workers
  cert_request_pem      = tls_cert_request.kubelets[each.key].cert_request_pem
  ca_key_algorithm      = "RSA"
  ca_private_key_pem    = tls_private_key.ca.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.ca.cert_pem
  allowed_uses          = ["cert_signing", "key_encipherment", "server_auth", "client_auth"]
  validity_period_hours = 8760
}

# ==========
# Controller Manager
# ==========

resource "tls_private_key" "controller_manager" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "controller_manager" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.controller_manager.private_key_pem
  subject {
    common_name         = "system:kube-controller-manager"
    country             = "US"
    locality            = "Washington"
    organization        = "system:kube-controller-manager"
    organizational_unit = "Kubernetes the Hard Way"
  }
}

resource "tls_locally_signed_cert" "controller_manager" {
  cert_request_pem      = tls_cert_request.controller_manager.cert_request_pem
  ca_key_algorithm      = "RSA"
  ca_private_key_pem    = tls_private_key.ca.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.ca.cert_pem
  allowed_uses          = ["cert_signing", "key_encipherment", "server_auth", "client_auth"]
  validity_period_hours = 8760
}

# ==========
# Proxy
# ==========

resource "tls_private_key" "proxy" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "proxy" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.proxy.private_key_pem
  subject {
    common_name         = "system:kube-proxy"
    country             = "US"
    locality            = "Washington"
    organization        = "system:kube-proxy"
    organizational_unit = "Kubernetes the Hard Way"
  }
}

resource "tls_locally_signed_cert" "proxy" {
  cert_request_pem      = tls_cert_request.proxy.cert_request_pem
  ca_key_algorithm      = "RSA"
  ca_private_key_pem    = tls_private_key.ca.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.ca.cert_pem
  allowed_uses          = ["cert_signing", "key_encipherment", "server_auth", "client_auth"]
  validity_period_hours = 8760
}

# ==========
# Scheduler
# ==========

resource "tls_private_key" "scheduler" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "scheduler" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.scheduler.private_key_pem
  subject {
    common_name         = "system:kube-scheduler"
    country             = "US"
    locality            = "Washington"
    organization        = "system:kube-scheduler"
    organizational_unit = "Kubernetes the Hard Way"
  }
}

resource "tls_locally_signed_cert" "scheduler" {
  cert_request_pem      = tls_cert_request.scheduler.cert_request_pem
  ca_key_algorithm      = "RSA"
  ca_private_key_pem    = tls_private_key.ca.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.ca.cert_pem
  allowed_uses          = ["cert_signing", "key_encipherment", "server_auth", "client_auth"]
  validity_period_hours = 8760
}
