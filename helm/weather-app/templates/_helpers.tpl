{{/*
Common template helpers for your chart.
*/}}

{{- define "weather-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "weather-app.chart" -}}
{{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{- define "weather-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- include "weather-app.name" . }}-{{ .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end -}}
