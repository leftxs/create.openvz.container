Notes:
------

*This is for openvz not for virtualbox !!*

In case we want to create a fresh pair of ssh-keys on first boot we do the followig [Ubuntu12.04]:

Generate a unique set of ssh (host) keys.::
        rm -f /etc/ssh/ssh_host_*
        cat << EOF > /etc/rc2.d/S15ssh_gen_host_keys
        #!/bin/sh
        ssh-keygen -f /etc/ssh/ssh_host_rsa_key -t rsa -N ''
        ssh-keygen -f /etc/ssh/ssh_host_dsa_key -t dsa -N ''
        rm -f \$0
        EOF

Make the script executable::
        chmod a+x /etc/rc2.d/S15ssh_gen_host_keys
