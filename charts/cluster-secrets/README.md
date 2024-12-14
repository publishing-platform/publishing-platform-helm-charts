The `cluster-secrets` chart defines ExternalSecrets for **cluster-wide services**.

Please avoid adding ExternalSecrets for apps to this chart. Apps'
ExternalSecrets belong in the apps' own charts, or in
[../app-config](../app-config) for apps which use the generic
`generic-publishing-platform-app` chart.

**This chart is deployed by the `cluster-services` Terraform module, not by
ArgoCD.** See [Applying Terraform] for how to deploy the cluster-services
module.

[Applying Terraform]: https://github.com/publishing-platform/publishing-platform-infrastructure/blob/main/terraform/README.md