package main

import (
    "guku.io/devx/v1"
    "guku.io/devx/v1/traits"
)

stack: v1.#Stack & {
    $metadata: stack: "infra"
    components: {
        // Virtual private network
        network: {
            traits.#VPC
            vpc: {
                name: "tutorial"
                cidr: "10.0.0.0/16"
                subnets: {
                    private: ["10.0.1.0/24", "10.0.2.0/24"]
                    public: ["10.0.101.0/24", "10.0.102.0/24"]
                }
            }
        }

        // ECS cluster
        cluster: {
            traits.#ECS
            ecs: {
                name: "barmag-dev"
                capacityProviders: fargateSpot: enabled: true
                vpc: network.vpc
            }
        }

        // Application load balancer
        gateway: {
            traits.#Gateway
            gateway: {
                name:   "barmag-balancer"
                public: true
                // We want our gateway to listen on port 80 and 443
                listeners: {
                    http: {
                        port:     8081
                        protocol: "HTTP"
                    }
                    https: {
                        port:     5432
                        protocol: "HTTP"
                    }
                }
            }
        }
    }
}