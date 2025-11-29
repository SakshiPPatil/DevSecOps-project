cd /app
cat <<EOL > hosts.ini
[local]
localhost ansible_connection=local
EOL
