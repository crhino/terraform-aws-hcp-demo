resource "hcp_aws_network_peering" "default" {
  peering_id      = "${var.hvn.hvn_id}-peering"
  hvn_id          = var.hvn.hvn_id
  peer_vpc_id     = var.vpc_id
  peer_account_id = var.owner_id
  peer_vpc_region = var.vpc_region
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = hcp_aws_network_peering.default.provider_peering_id
  auto_accept               = true
}

resource "hcp_hvn_route" "peering_route" {
  depends_on       = [aws_vpc_peering_connection_accepter.peer]
  hvn_link         = var.hvn.self_link
  hvn_route_id     = "${var.hvn.hvn_id}-peering-route"
  destination_cidr = var.vpc_cidr_block
  target_link      = hcp_aws_network_peering.default.self_link
}

resource "aws_route" "peering" {
  count                     = var.number_of_route_table_ids
  route_table_id            = var.route_table_ids[count.index]
  destination_cidr_block    = var.hvn.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer.vpc_peering_connection_id
}
