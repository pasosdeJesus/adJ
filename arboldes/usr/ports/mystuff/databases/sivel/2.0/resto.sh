#!/bin/sh
# Dominio público de acuerdo a legislación colombiana. 2016. vtamara@pasosdeJesus.org

chmod +x /var/www/htdocs/sivel2/bin/uc.sh
cd /var/www/htdocs/sivel2/
echo "Favor editar  los siguientes:"
for i in `find /var/www/htdocs/sivel2/config -name "*plantilla"`; do
	n=`echo $i | sed -e "s|.plantilla||g"`;
	echo $n
	if (test ! -f "$n") then {
		cp $i $n;
	} fi;
done
echo "[Retorno] para continuar"
read
mkdir -p tmp/cache
chown -R www:www tmp
mkdir -p log
chown -R www:www log
mkdir -p /var/www/htdocs/sivel2/.gem
chown www:www /var/www/htdocs/sivel2/.gem

chown www:www .bundle/config
chmod +w .bundle/config
chown -R www:www /var/www/usr/local/lib/ruby/gems/2.3
chown -R www:www /var/www/htdocs/sivel2/vendor/bundle/ruby/2.3/cache/
chown -R www:www /var/www/htdocs/sivel2/vendor/bundle/ruby/2.3/bundler/
chmod -R +w /var/www/htdocs/sivel2/vendor/bundle/ruby/2.3/bundler/gems
touch /var/www/usr/local/bin/bundle
chown www:www /var/www/usr/local/bin/bundle
touch /var/www/usr/local/bin/bundler
chown www:www /var/www/usr/local/bin/bundler
chown -R www:www /var/www/htdocs/sivel2/public/assets
mkdir -p /var/www/htdocs/sivel2/public/sivel2/assets
chown -R www:www /var/www/htdocs/sivel2/public/sivel2/assets

gem install --install-dir /var/www/usr/local/lib/ruby/gems/2.3/ debug_inspector -v 0.0.2
gem install --install-dir /var/www/usr/local/lib/ruby/gems/2.3/ bcrypt -v 3.1.11
gem install --install-dir /var/www/usr/local/lib/ruby/gems/2.3/ debug_inspector -v 0.0.2
gem install --install-dir /var/www/usr/local/lib/ruby/gems/2.3/ pg -v 0.18.4
gem install --install-dir /var/www/usr/local/lib/ruby/gems/2.3/ nokogiri -v 1.6.8 -- --use-system-libraries
gem install --install-dir /var/www/usr/local/lib/ruby/gems/2.3/ binding_of_caller -v 0.7.2
gem install --install-dir /var/www/usr/local/lib/ruby/gems/2.3/ interception -v 0.5
gem install --install-dir /var/www/usr/local/lib/ruby/gems/2.3/ pry-stack_explorer -v 0.4.9.2
chroot -u www -g www /var/www/ gem install bundler
chroot -u www -g www /var/www/ gem install rake -v 11.2.2

echo "cd /htdocs/sivel2; bundle check" > /var/www/tmp/bc.sh
chmod +x /var/www/tmp/bc.sh
echo "cd /htdocs/sivel2" > /var/www/tmp/ig.sh
chroot -u www -g www /var/www/ /tmp/bc.sh | grep "^ \* " | sed -e  "s/^ \* /gem install /g;s/(/-v /g;s/)$//g" >> /var/www/tmp/ig.sh
chmod +x /var/www/tmp/ig.sh
chroot -u www -g www /var/www/ /tmp/ig.sh 

echo "cd /htdocs/sivel2; RAILS_ENV=production rake sip:indices" > /var/www/tmp/s.sh
chmod +x /var/www/tmp/s.sh
chroot -u www -g www /var/www/ /tmp/s.sh 

