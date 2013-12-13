#!/usr/bin/env perl

sub city_ll {
  my $file_name = shift;
  open(FILE,$file_name);
  
  while(<FILE>) {
  
    if ($_ =~ /Address:.*,\s+(.*?), CA/) {
      print "$1,";
    } elsif ($_ =~ /^[0-9]+/) {
      chop $_;
      chop $_;
      $ll = $_;
      print $ll . ", 100\n";
    }
  }
  
  $ll = "";
  close(FILE);

}

@files = qw(711_california_google_data.log 711_california_google_data_oxnard.log 711_california_google_data_glendale.log 711_california_google_data_visalia.log);

foreach (@files ) {
  city_ll($_);
}
