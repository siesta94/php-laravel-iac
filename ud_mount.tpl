#!/bin/bash
sleep 5m
echo "ECS_CLUSTER=PM4-Client-ECS-Cluster" >> /etc/ecs/ecs.config
yum install -y amazon-efs-tools
mkdir -p /mnt/efs
echo "$efs_id:/ /mnt/efs efs _netdev 0 0" >> /etc/fstab
mount /mnt/efs
