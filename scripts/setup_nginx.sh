#!/bin/bash

user_acc_name=ec2-user
passwd_path_user=/home/${user_acc_name}/passwd_${user_acc_name}.txt
password=$(sudo -S cat ${passwd_path_user} < ${passwd_path_user})

nginx_path=/etc/nginx
ssl_path=${nginx_path}/ssl

ssl_key=${ssl_path}/example.key
ssl_crt=${ssl_path}/example.crt
server_name="www.example.com"

config_file=/etc/nginx/nginx.conf

echo ${password} | sudo -S cp ${config_file} ${config_file}.bak
echo ${password} | sudo -S chmod 606 ${config_file}

echo "Adding https configuration"
echo ${password} | sudo -S cat <<EOF > ${config_file}
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80;
        server_name  ${server_name};
        return 301 https://\$server_name\$request_uri;
    }

    server {
        listen       443 ssl;
        server_name ${server_name};
        root         /usr/share/nginx/html;

        ssl_certificate "/etc/nginx/ssl/example.crt";
        ssl_certificate_key "/etc/nginx/ssl/example.key";
        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout  10m;
        ssl_ciphers PROFILE=SYSTEM;
        ssl_prefer_server_ciphers on;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
            root /usr/share/nginx/html;
            index index.html index.html;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
}
EOF

echo ${password} | sudo -S chmod 644 ${config_file}
echo "Reloading ngninx service"
echo ${password} | sudo -S nginx -s reload