---
title: ADR043 - new product pages language and framework
---

# ADR043: new product pages language and framework

## Context

[PaaS product pages] have been reviewed and a number of accessibility issues
have been identified. To resolve those we, would need to make an upgrade and
and review if any additional changes are needed to align with the GOV.UK Design System.

As those pages are built in Ruby and in [ADR024] we've made the decision
to develop our user-facing applications on Node, it's a good opportunity to 
look at rebuilding the product pages.

We've discussed user needs and it emerged that:

* anyone in the team (developer and non-developer) should be able to update pages 
with less effort
* pages should be performant for end users
* pages should be rendered by the server
* keeping pages up to date with GOV.UK Design System releases should be quicker and easier
* alignment of technologies for our user-facing web products should provide better 
developer experience and give us the option to have shared component libraries

With the above in mind we researched options. Our admin interface is built in React,
so we narrowed the scope to React-based static site generators.

We ended up comparing two: [NextJS] with static page export and [GatsbyJS] 
which exports static pages by default.
For page content we agreed that writing pages in [Markdown] is a good option,
so we tested both with [MDX] which can also embed React components inside content pages.

[NextJS] and [GatsbyJS] have different approaches to development and there are minor 
performance differences between them.

Our use case for now is narrow enough, and with the primary need of anyone in the team
being able to update pages, [NextJS] marginally gets more votes as Gatsby cannot be installed and run on
non-developer machines.

## Decision

We will use [NextJS] together with [MDX] to author PaaS product pages content in 
[Markdown] and deliver them to users as static pages.

## Status

Accepted.

## Consequences

This implementation will allow us to:

- iterate our content more quickly as non-developers will be able to make changes easily
- keep our page updated with newer releases of GOV.UK Design System to continue to makem
accessible to everyone and aligned with the latest designs
- have both user-facing products on the same platform
- allow us to have shared components if the need arises

[ADR024]: /architecture_decision_records/ADR024-web-app-language-and-framework-selection-2
[NextJS]: https://nextjs.org/
[GatsbyJS]: https://www.gatsbyjs.org/
[MDX]: https://mdxjs.com/
[Markdown]: https://www.markdownguide.org/getting-started/
[PaaS product pages]: https://www.cloud.service.gov.uk/
