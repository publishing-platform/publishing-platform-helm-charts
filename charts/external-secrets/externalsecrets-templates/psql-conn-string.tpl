postgresql://{{ .postgresUsername | toString }}:{{ .postgresPassword | toString }}@{{ .postgresHost | toString }}