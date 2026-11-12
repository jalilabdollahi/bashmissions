# generated for {{domain}} - do not edit by hand
server {
    listen {{port:-80}};
    server_name {{domain}};
{% if tls %}
    ssl_certificate /etc/ssl/{{ domain }}.pem;
{% else %}
    # no TLS yet
{% endif %}
{% for host in backends %}
    server {{host}}:8080;   # backend {{loop.index}}
{% endfor %}
}
