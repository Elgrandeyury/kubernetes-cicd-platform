{{- define "platform-app.name" -}}
platform-app
{{- end }}

{{- define "platform-app.fullname" -}}
{{ .Release.Name }}-{{ include "platform-app.name" . }}
{{- end }}

{{- define "platform-app.labels" -}}
app.kubernetes.io/name: {{ include "platform-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: kubernetes-cicd-platform
{{- end }}
