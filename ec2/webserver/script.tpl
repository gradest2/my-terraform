#!/bin/bash
apt-get -y update
apt-get -y install apache2


cat <<EOF > /var/www/html/index.html
<html>

<h2>Owner ${f_name} ${l_name}</h2><br>
%{ for x in names ~}
Hello to ${x} from ${f_name}!<br>
%{ endfor ~}

</html>
EOF

systemctl enable apache2
ufw allow 'Apache'
