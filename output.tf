output "client_peer_vpc_id" {
  value = module.vpc.vpc_id
}

output "consul_root_token" {
  value     = hcp_consul_cluster_root_token.token
  sensitive = true
}

output "consul_url" {
  value = hcp_consul_cluster.main_consul_cluster.public_endpoint ? (
    hcp_consul_cluster.main_consul_cluster.consul_public_endpoint_url
    ) : (
    hcp_consul_cluster.main_consul_cluster.consul_private_endpoint_url
  )
}
