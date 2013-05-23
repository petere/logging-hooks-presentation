set -eux

test -e dellstore2-normal-1.0.tar.gz || wget http://pgfoundry.org/frs/download.php/543/dellstore2-normal-1.0.tar.gz
test -e pagila-0.10.1.zip || wget http://pgfoundry.org/frs/download.php/1719/pagila-0.10.1.zip

test -d dellstore2-normal-1.0 || tar xf dellstore2-normal-1.0.tar.gz
test -d pagila-0.10.1 || unzip pagila-0.10.1.zip

vagrant ssh -c 'sudo -u postgres createdb dellstore2 && sudo -u postgres psql dellstore2 -f /vagrant/dellstore2-normal-1.0/dellstore2-normal-1.0.sql'
vagrant ssh -c 'sudo -u postgres createdb pagila && sudo -u postgres psql pagila -f /vagrant/pagila-0.10.1/pagila-schema.sql && sudo -u postgres psql pagila -f /vagrant/pagila-0.10.1/pagila-data.sql'
