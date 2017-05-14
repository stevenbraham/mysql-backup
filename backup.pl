#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
use YAML::XS 'LoadFile';
use DBI;
use POSIX 'strftime';
no warnings 'experimental::smartmatch';
#clear ouput folder
`rm -rf output && mkdir out`;

#date prefix
my $datePrefix = POSIX::strftime('%Y/%m/%d', localtime);

#read values from config.yaml
my $config = LoadFile('config.yaml');
my $webdavUrl = $config->{webdav}->{url};
my $webdavUsername = $config->{webdav}->{username};
my $webdavPassword = $config->{webdav}->{password};
my $mysqlUsername = $config->{mysql}->{username};
my $mysqlPassword = $config->{mysql}->{password};
my $blacklist = $config->{blacklist};

#connect to mysql
my $connection = DBI->connect("DBI:mysql:information_schema:localhost:", $mysqlUsername, $mysqlPassword);
my $sql = $connection->prepare("show databases");
$sql->execute();

#loop over databases and execute dump command
while ((my $databaseName) = $sql->fetchrow_array()){
    if (not $databaseName ~~ $blacklist) { #use smartwatch to exclude items from blacklist
        print $databaseName."\n";
    }
}