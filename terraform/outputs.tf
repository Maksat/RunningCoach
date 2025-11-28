output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "rds_endpoint" {
  value = aws_db_instance.default.endpoint
}

output "redis_endpoint" {
  value = aws_elasticache_cluster.redis.cache_nodes.0.address
}

output "s3_bucket_name" {
  value = aws_s3_bucket.assets.id
}
