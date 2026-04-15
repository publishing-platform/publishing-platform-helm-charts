{{/*
Expand the name of the chart.
*/}}
{{- define "publishing-platform-e2e-tests.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "publishing-platform-e2e-tests.chart" -}}
{{- printf "%s-%s" .Release.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "publishing-platform-e2e-tests.labels" -}}
helm.sh/chart: {{ include "publishing-platform-e2e-tests.chart" . }}
{{ include "publishing-platform-e2e-tests.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/arch: {{ default "amd64" .Values.arch }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "publishing-platform-e2e-tests.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}