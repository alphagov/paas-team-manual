---
title: Tenant Application Penetration and Load Testing
---

# Tenant Application Penetration and Load Testing


## Penetration testing

We no longer have to notify AWS of penetration testing, however it is useful for the team to know that this is taking place and that we have contact details of the testers if issues arise during the testing window.

| Name | Value |
|------|-------|
|# source_IP | Provided by penetration tester. The IPs that the test will originate from. |
|# phone_for_testing_team | Provided by penetration tester. Phone number of the testers. |
|# peak_bandwidth | Provided by penetration tester. The peak amount of bandwidth the tests will consume (Gbps). |
|# peak_rps | Provided by penetration tester. The peak number of requests-per-second the tests will perform. |
|# StartDate | Provided by penetration tester. When will the test start?  (eg. `2017-09-26T09:00:00Z` ) |
|# EndDate | Provided by penetration tester. When will the test end? (eg. `2017-09-26T18:00:00Z` ) |
|# can_you_stop | Provided by penetration tester. Once started, is it possible to stop the test immediately if there is an issue? |
|# emergency_contact | Provided by penetration tester. Email and phone number in case issues arise. |


## Load Testing


Before allowing a load test against applications running on PaaS we may have to notify AWS. Currently we are not sure on the scenarios when we do not have to notify AWS. We are erring on the side of caution and notifying for all load tests.

There are two methods to notify AWS: [a form which requires root account access](https://aws.amazon.com/forms/penetration-testing-request), or, by emailing `aws-security-cust-pen-test@amazon.com`. Both require providing the following information:

| Name | Value |
|------|-------|
|# AWS AccountId | Production account ID |
|# SubmitterName | Your name |
|# CompanyName | `Government Digital Service` |
|# EmailAddress | Team email address |
|# AdditionalEmail1 | Optional |
|# AdditionalEmail2 | Optional |
|# AdditionalEmail3 | Optional |
|# Customer_NDA | `yes` |
|# ec2_resources | [EC2 resource IDs to be tested](#find-penetration-testable-ec2-instance-ids). |
|# cloudfront_ID | [CloudFront distribution IDs to be tested](#find-cloudfront-distributions). |
|# api_gateway | N/A |
|# rds_resources | N/A |
|# elb_resources | [ELB hostnames to be tested](#find-elbs). |
|# external_IPs | N/A |
|# nameserver_info | N/A |
|# dns_owner_notified | N/A |
|# TLD_scanned | N/A |
|# source_IP | Provided by tester. The IPs that the test will originate from. |
|# on_prem | Provided by tester. Will the requests originate from the office of the testers? |
|# third_party | Provided by tenant. Are the testers a third-party company? |
|# phone_for_testing_team | Provided by tester. Phone number of the testers. |
|# testing_company_NDA | Provided by tester. Has an NDA with AWS been signed by the penetration testers? |
|# peak_bandwidth | Provided by tester. The peak amount of bandwidth the tests will consume (Gbps). |
|# peak_rps | Provided by tester. The peak number of requests-per-second the tests will perform. |
|# dns_walking_qps | N/A |
|# StartDate | Provided by tester. When will the test start?  (eg. `2017-09-26T09:00:00Z` ) |
|# EndDate | Provided by tester. When will the test end? (eg. `2017-09-26T18:00:00Z` ) |
|# testing_details | Provided by tenant. Why is the test being carried out? What is the test covering? |
|# metrics_of_test | Provided by tester. What metrics are being measured in order to decide the success or failure of the test? |
|# can_you_stop | Provided by tester. Once started, is it possible to stop the test immediately if there is an issue? |
|# emergency_contact | Provided by tester. Email and phone number in case issues arise. |

## Find penetration testable EC2 instance IDs

AWS only allows penetration tests on instances of certain sizes. You can find all valid instances with the following:

```
aws ec2 describe-instances \
| jq '.Reservations[].Instances[] | select(.InstanceType != "t2.nano" and .InstanceType != "t1.micro" and .InstanceType != "m1.small") | .InstanceId' --raw-output
```

## Find ELBs

For tenant application penetration testing it should only be necessary to provide the router ELB:

```
aws elb describe-load-balancers \
| jq '.LoadBalancerDescriptions[] | select(.Scheme == "internet-facing") | select(.LoadBalancerName | endswith("-router")) | .DNSName' --raw-output
```

## Find CloudFront distributions

The `cdn-route` service uses a CloudFront distribution. You can discover these distributions with the following:

```
aws cloudfront list-distributions \
| jq '.DistributionList.Items[] | select(.Comment == "cdn route service") | .Id' --raw-output
```

## Find external IPs (NAT)

```
aws ec2 describe-nat-gateways | jq -r '.NatGateways[].NatGatewayAddresses[].PublicIp
```

## Find RDS instances from a given org

Assuming you are logged in the production CF and `AWS_DEFAULT_REGION` set to the right region

```
# AWS_DEFAULT_REGION=eu-west-1

ORG=tenant-org

account_id="$(aws sts get-caller-identity --output text  --query Account)"
rds_services="$(cf curl /v2/services | jq '[ .resources[] | select(.entity.service_broker_name == "rds-broker") | .metadata.guid ]')"

cf curl /v2/service_instances?q=organization_guid:$(cf org --guid $ORG) | \
    jq -r \
        --argjson rds_services "${rds_services}" \
        --arg aws_default_region "${AWS_DEFAULT_REGION}" \
        --arg account_id "${account_id}" \
        '
        .resources[] |
            select([.entity.service_guid] | inside($rds_services)) |
            "arn:aws:rds:\($aws_default_region):\($account_id):db:rdsbroker-\(.metadata.guid)"
        '
```
