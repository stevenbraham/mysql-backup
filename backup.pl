#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
use YAML::XS 'LoadFile';
use DBI;
use POSIX 'strftime';
no warnings 'experimental::smartmatch';

#clear ouput folder
`rm -rf out && mkdir out`;

#read values from config.yaml
my $config = LoadFile('config.yaml');
my $webdavUrl = $config->{webdav}->{url};
my $webdavUsername = $config->{webdav}->{username};
my $webdavPassword = $config->{webdav}->{password};
my $backupDir = $config->{webdav}->{backupDir};
my $mysqlUsername = $config->{mysql}->{username};
my $mysqlPassword = $config->{mysql}->{password};
my $blacklist = $config->{blacklist};
my $mountPoint = "/mnt/sqlbackup";

# write to temp file to pipe username/password to mount
open (OUTFILE, '>>cred');
print OUTFILE "$webdavUsername\n$webdavPassword";
close (OUTFILE);
# create mountpoint
`mkdir $mountPoint`;
`cat cred | mount -t davfs $webdavUrl $mountPoint`;
unlink('cred');

my $mountPrefix = $mountPoint."/".$backupDir."/".POSIX::strftime('%Y/%m/%d', localtime);
`mkdir -p $mountPrefix`;

#connect to mysql
my $connection = DBI->connect("DBI:mysql:information_schema:localhost:", $mysqlUsername, $mysqlPassword);
my $sql = $connection->prepare("show databases");
$sql->execute();

#loop over databases and execute dump command
while ((my $databaseName) = $sql->fetchrow_array()){
    if (not $databaseName ~~ $blacklist) {
        #use smartwatch to exclude items from blacklist
        print $databaseName."\n";
        #run dump command
        `mysqldump --force --opt --user=$mysqlUsername --password=$mysqlPassword --databases $databaseName > out/$databaseName.sql`;
        # gzip
        `gzip -f out/$databaseName.sql`;
        `rm -f out/$databaseName.sql`;
        `cp out/$databaseName.sql.gz $mountPrefix/$databaseName.sql.gz`
    }
}