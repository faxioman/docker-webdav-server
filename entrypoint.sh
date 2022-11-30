#!/bin/sh -
cp /etc/passwd.orig /etc/passwd
cp /etc/group.orig /etc/group
echo "__wd:x:$UID:$GID:__wd:/data:/usr/sbin/nologin" >> /etc/passwd
echo "__wd:x:$GID:" >> /etc/group
cat > /tmp/wsgidav.yaml << EOF
server: cheroot
host: 0.0.0.0
port: 80
block_size: 8192

provider_mapping:
    '/': '/data'

dir_browser:
    enable: false

http_authenticator:
    accept_basic: true
    accept_digest: false
    default_to_digest: false
    domain_controller: wsgidav.dc.simple_dc.SimpleDomainController

simple_dc:
    user_mapping:
        '*':  # default (used for all shares that are not explicitly listed)
            '$USER':
                password: '$PASSWORD'


lock_storage: true
EOF
if [ "$FIX_DATA_PERMISSIONS" == "true" ]
then
    chown -R __wd:__wd /data
else
    chown __wd:__wd /data
fi
exec sudo -u __wd -g __wd wsgidav --config /tmp/wsgidav.yaml
