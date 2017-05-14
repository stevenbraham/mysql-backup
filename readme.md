# About

This is a small script I created to backup my MySQL database. My hoster offers a free online storage service for VPS customers called ["Stack"](https://www.transip.nl/stack/). Stack has 1TB of storage! You can also access Stack via Webdav. That's why I created a script that dumps all my databbases, gzips them and uploads them via webdav to Stack.

# Why Perl?

This script could of course have been written using only bash. However I find the syntax of bash confusing and I don't like to constantly pipe variables and command outputs to eachother. I wanted to use a proper programming language. I have a dislike for Python and I have never written a Perl program before, so I thougth this would be a fun learning expierence.

# How to use
*(I take no responsibility if you use my script and something goes wrong)*

1. Make sure you have all modules installed
2. Rename `config.sample.yaml` to `config.yaml`
3. Fill out `config.yaml` with your information
4. Create a cron or run `backup.pl`

# Required CPAN libraries

* [YAML::XS](https://metacpan.org/pod/YAML::XS)