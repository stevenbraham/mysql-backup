use strict;
use warnings FATAL => 'all';
use YAML::XS 'LoadFile';

#read values from config.yaml
my $config = LoadFile('config.yaml');

my $webdavUrl = $config->{webdav}->{url};
my $webdavUsername = $config->{webdav}->{username};
my $webdavPassword = $config->{webdav}->{password};
my $mysqlUsername = $config->{mysql}->{username};
my $mysqlPassword = $config->{mysql}->{username};

print $webdavUrl;