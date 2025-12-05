#!/bin/bash

cat <<EOF > /var/www/html/index.html
Hello!
EOF

cat <<EOF > /var/www/html/health
ok
EOF

systemctl restart httpd || systemctl restart nginx || true
