# k8s-hard-way

Following along the [_Kubernetes the Hard Way_][01] guide, implemented as a
Terraform project (to the extent possible).

Requires Terraform >= 0.12.

[01]: https://github.com/kelseyhightower/kubernetes-the-hard-way
[02]: https://stackoverflow.com/questions/44940901/terraform-conditionally-create-resource-based-on-external-data
[03]: https://apparently.me.uk/terraform-certificate-authority/

## 02 Installing the Client Tools

This section gets your laptop all setup to run the commands that will need to
be run in the following sections. I include the tools needed in `shell.nix`. If
you have `direnv` installed, all you need to do is `cd` into the project
directory and you'll be good to go.

Note: we don't need `cfssl` since we're using the Terraform TLS provider to
generate keys, CSRs, and certificates.

## 03 Provisioning Compute Resources

This section goes over the creation of some nodes and networks in GCP. We setup
a VPC and some firewall rules to make sure the boxes can talk to each other. In
our case, we just use Vagrant to spin up some VMs. The Vagrantfile specifies
hostnames and a static (private) IP address for each box.

## 04 Provisioning a CA and Generating TLS Certificates

Pretty much just follow `tls.tf`. Run `terraform plan -out tls.plan` (inspect
the output to see what will be created) then `terraform apply tls.plan`. It
should only take a moment to generate all the keys and certificates. The
provisioning scripts in the Vagrantfile will copy the appropriate files to the
controllers, a la the tutorial:

```sh
for instance in controller-0 controller-1 controller-2; do
  gcloud compute scp ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem \
    service-account-key.pem service-account.pem ${instance}:~/
done
```

And the workers:
    
```sh
for instance in worker-0 worker-1 worker-2; do
  gcloud compute scp ca.pem ${instance}-key.pem ${instance}.pem ${instance}:~/
done
```
