.resources[]
  | select(.type == "tls_\($class)")
    .instances[]
  | select(.index_key == $key)
    .attributes
    ["\($pem)_pem"]
