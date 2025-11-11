output "cloudfront_arn"{
    value = cloudfront_distribution.main.arn
}

output "cloudfront_domain_name"{
    value = cloudfront_distribution.main.domain_name
}