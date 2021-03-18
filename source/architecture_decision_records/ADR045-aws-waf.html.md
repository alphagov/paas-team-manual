---
title: ADR045 - AWS WAF and WAF Log access by AWS DDoS Response Team
---

# ADR045: AWS WAF and WAF Log access by AWS DDoS Response Team

## Context

GOV.UK PaaS uses [AWS Shield Advanced](https://aws.amazon.com/shield/features/#AWS_Shield_Advanced) as well as AWS WAF to protect from DDoS attacks.

However the mitigations are not automatic and we have access to the AWS DDoS Response Team 
(DRT) who are experts in mitigating these types of attack.

```
Shield Advanced detects web application layer vectors, like web request floods and 
low-and-slow bad bots, but does not automatically mitigate them. To mitigate web 
application layer vectors, you must employ AWS WAF rules or the DRT must employ the 
rules on your behalf.
```

In order to be functional they require access to our AWS WAF logs in order to identify what 
the attack is and where is is coming from, and API access to the WAF in order to apply the 
mitigating rules.

To enagage the AWS DRT team we will set up CloudWatch alarms on our WAF rules in order to trigger 
the [emergency engagement Lambda](https://s3.amazonaws.com/aws-shield-lambda/ShieldEngagementLambda.pdf)

## Decision

We will grant access to the AWS DRT to read from restricted S3 buckets

## Status

Accepted.

## Consequences

End-to-end encryption between gorouter and apps will done solely by mTLS.
