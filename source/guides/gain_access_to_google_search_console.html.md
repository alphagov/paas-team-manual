---
title: How to get Google Search Console Back
---

# How to get Google Search Console Back

To maintain access to the [Google Search Console](https://search.google.com/search-console/welcome), we require at least one verified site owner for the domain.

An individual can verify ownership by adding a `google-site-verification` token as a `TXT` record in our DNS service ([Route53](https://aws.amazon.com/route53/))

In the following example, we will verify site ownership for `cloud.service.gov.uk`:

1. Go to the [Google Search Console](https://search.google.com/search-console/welcome) and select/type in the domain `cloud.service.gov.uk`. 
2. Follow the instructions. If you are not a verified owner, you will be given a `google-site-verification` token. Copy the value.
3. Update the DNS records in the paas-aws-account-wide-terraform by [adding the token as shown in this pull request](https://github.com/alphagov/paas-aws-account-wide-terraform/pull/295). If you are adding multiple owners, you will have to add multiple tokens to the records (one per person).

A verified owner can [grant access to other users](https://support.google.com/webmasters/answer/7687615?hl=en) from the console.
