#!/bin/bash
# check root

echo $EUID
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 0
fi
#echo "You can enter multiple versions through 'space'."
#echo "Enter php version/versions(for example 7.0):"
for ((i = 0; i < 4; i++))
{
   echo "Install php 7.$i ?(y/N)"
   read -p ">" question
   if [ "$question" == "y" ]||[ "$question" == "Y" ]; then
      vers="$vers "7.$i
   fi
}

for ver in $vers; do
echo "Start install php" $ver
sleep 5
   apt install php$ver php$ver-cli php$ver-xml php$ver-mysql -y
   if ! [ -f /tmp/ioncube/ioncube_loader_lin_$ver.so ]; then
      cd /tmp/
      wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
      tar -xvzf ioncube_loaders_lin_x86-64.tar.gz
   fi
   cd /tmp/ioncube/
   io_cub=`php -i | grep extension_dir | awk '{print $5}'`
   cp ioncube_loader_lin_$ver.so $io_cub
#   io_lou=`php -i | grep additional | awk '{print $9}'`
   io_lou=`php -i | grep additional | sed 's/cli/apache2/'`
   echo 'zend_extension=ioncube_loader_lin_'$ver'.so' > $io_lou/00-ioncube-loader.ini

done
if [ -d /tmp/ioncube/ ]; then
   rm -r /tmp/ioncube/
fi
#done

