#!/usr/bin/env perl
# Perl program to return the name of an application
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

 # if ( $line =~ m/APPLICATION\s+=\s\'(.*)\'/ ) {
   if ( $line =~ m/\s+<application>(.*)<\/application>/ ) {
 
    print "$1\n";
    exit 0;
  }
}

# exit
exit 0;

    

