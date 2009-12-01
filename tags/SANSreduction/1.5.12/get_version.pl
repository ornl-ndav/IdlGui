#!/usr/bin/env perl
# Perl program to return the version number of an application (ex: 1_0_4)
if ( ! (defined($ARGV[0])) ) {
  print "filename not specified. Exiting!\n";
  exit 1;
}

# variables
my $filename = $ARGV[0];

# make sure the file exists
if ( ! -f "$filename" ) {
  print "$filename does not exist. Exiting!\n";
  exit 1;
}

# open the file
open ( FILE, "<$filename" );

# process the data
my @filedata = <FILE>;
close (FILE);

foreach my $line ( @filedata ) {

  # chomp the line
  chomp ($line);

#  if ( $line =~ m/VERSION\s+=\s\'(.*)\'/ ) {
  if ( $line =~ m/\s+<version>(.*)<\/version>/ ) {
    $version = $1;
    $version =~ s/\./_/g;
    print "$version\n";
    exit 0;
  }
}

# exit
exit 0;

    

