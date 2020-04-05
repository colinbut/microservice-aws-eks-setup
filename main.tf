provider "aws" {
    region = "eu-west-2"
}

module "cluster" {
  source = "./cluster"
  
}

module "worker_node_group" {
  source = "./worker-node-group"
  
  cluster = module.cluster.cluster_name
}

