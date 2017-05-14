use strict;
use warnings FATAL => 'all';
use YAML::XS 'LoadFile';
use Data::Dumper;

#read values from config.yaml
my $config = LoadFile('config.yaml');

print Dumper($config);