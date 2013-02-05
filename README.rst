.. contents :: :local:

Introduction
--------------
*create.openvz.container* is a dirty wrapper script to make the creation of
containers even more easy.

This scipt is tested with Centos 6.3 and a RHEL6-based OpenVZ kernel

Usage
-----

* Download the script::

    https://raw.github.com/leftxs/create.openvz.container/master/create_container.sh

* Make the script executable::

    chmod +x create_container.sh

* Run it::

  ./create_container.sh

You could also add it to your path, if you want

What is does
------------

- The script will check the content of your '$VZDIR/template/cache' dir and will
display it as list, now you can choose one [copy and paste]

- Ask for a HOstname [fqdn]

- Ask for an IP

- Ask for Ram and Swap [via vswap]

- Ask if you want to create the container [y/N]

