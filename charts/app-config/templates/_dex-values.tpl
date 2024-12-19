{{- define "app-config.dex-values" -}}
replicaCount: {{ .Values.replicaCount | default 1 }}
config:
  issuer: "https://dex.{{ .Values.k8sExternalDomainSuffix }}"
  oauth2:
    skipApprovalScreen: true
  storage:
    type: kubernetes
    config:
      inCluster: true
  connectors:
    - name: GitHub
      id: github
      type: github
      config:
        clientID: "$GITHUB_CLIENT_ID"
        clientSecret: "$GITHUB_CLIENT_SECRET"
        redirectURI: "https://dex.{{ .Values.k8sExternalDomainSuffix }}/callback"
        orgs:
          - name: {{ .Values.monitoring.authorisation.githubOrganisation }}
            teams: {{ list
              .Values.monitoring.authorisation.readOnlyGithubTeam
              .Values.monitoring.authorisation.readWriteGithubTeam
            | uniq | toYaml | nindent 14 }}
        teamNameField: both
        useLoginAsID: true
  staticClients:
    - name: argo-workflows
      idEnv: ARGO_WORKFLOWS_CLIENT_ID
      secretEnv: ARGO_WORKFLOWS_CLIENT_SECRET
      redirectURIs:
        - https://argo-workflows.{{ .Values.k8sExternalDomainSuffix }}/oauth2/callback
    - name: argocd
      idEnv: ARGOCD_CLIENT_ID
      secretEnv: ARGOCD_CLIENT_SECRET
      redirectURIs:
        - https://argo.{{ .Values.k8sExternalDomainSuffix }}/auth/callback
envVars:
  - name: GITHUB_CLIENT_ID
    valueFrom:
      secretKeyRef:
        name: publishing-platform-dex-github
        key: clientID
  - name: GITHUB_CLIENT_SECRET
    valueFrom:
      secretKeyRef:
        name: publishing-platform-dex-github
        key: clientSecret
  - name: ARGO_WORKFLOWS_CLIENT_ID
    valueFrom:
      secretKeyRef:
        name: publishing-platform-dex-argo-workflows
        key: clientID
  - name: ARGO_WORKFLOWS_CLIENT_SECRET
    valueFrom:
      secretKeyRef:
        name: publishing-platform-dex-argo-workflows
        key: clientSecret
  - name: ARGOCD_CLIENT_ID
    valueFrom:
      secretKeyRef:
        name: publishing-platform-dex-argocd
        key: clientID
  - name: ARGOCD_CLIENT_SECRET
    valueFrom:
      secretKeyRef:
        name: publishing-platform-dex-argocd
        key: clientSecret
service:
  ports:
    http:
      port: 80
    https:
      port: 443
ingress:
  enabled: true
  annotations:
    alb.ingress.kubernetes.io/group.name: dex
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/load-balancer-name: dex
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}, {"HTTPS":443}]'
    alb.ingress.kubernetes.io/ssl-redirect: "443"
  className: aws-alb
  hosts:
    - host: dex.{{ .Values.k8sExternalDomainSuffix }}
      paths:
        - path: "/*"
          pathType: ImplementationSpecific
{{- end -}}
