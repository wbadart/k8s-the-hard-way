.resources[]
  | select(.type == "tls_\($class)" and .name == $name)
    .instances[]
    .attributes
    ["\($pem)_pem"]

