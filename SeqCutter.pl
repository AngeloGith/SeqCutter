#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
use Getopt::Long;

#By Angelo Armijos Carrion.
#run (perl SeqCutter.pl -df cluster_definition -f fasta_file.fasta > output.fasta)

# Variables for the options
my $cluster_definition;
my $fasta_file;
my $output_file;

# Process the options from the command line
GetOptions(
    'df=s' => \$cluster_definition,
    'f=s'  => \$fasta_file,
    'o=s'  => \$output_file
) or die "Invalid options!\n";

# Check that the required options are present
unless ($cluster_definition && $fasta_file && $output_file) {
    die "Usage: perl script.pl -df <cluster_definition_file> -f <fasta_file> -o <output_file>\n";
}

# Read the FASTA file once and store sequences in a hash
my %sequences;
my $in = Bio::SeqIO->new(-file => $fasta_file, -format => 'Fasta');
while (my $seq = $in->next_seq()){
    $sequences{$seq->id()} = $seq;
}

# Open the output file for writing (overwriting if it already exists)
open (OUTPUT, ">".$output_file) || die "Can't open $output_file, $!\n";
# Open the cluster definition file for reading
open (CLUSTER, $cluster_definition) || die "Can't open $cluster_definition, $!\n";

while (my $line = <CLUSTER>){
    chomp $line; # Remove newline character
    unless ($line =~ m/^([A-Z0-9]+)\t(\d+)\t(\d+)$/) {
        print "Warning: Invalid format on line $. of cluster definition file: $line\n";
        next; # Skip to the next line
    }
    my ($id, $start, $end) = ($1, $2, $3);
    
    # Start the print statement but don't add a newline at the end
    print "Searching: $id";
    
    # Check for negative or zero positions
    if ($start <= 0 || $end <= 0) {
        print " (Warning: Negative or zero positions for ID $id!)\n";
        next; # Skip to the next line
    }
    
    # Check for end before start
    if ($end < $start) {
        print " (Warning: End position before start position for ID $id!)\n";
        next; # Skip to the next line
    }
    
    if (exists $sequences{$id}) {
        # Check if start and end are within the bounds of the sequence length
        if ($start > 0 && $end <= $sequences{$id}->length()) {
            my $subsequence = $sequences{$id}->subseq($start,$end);
            print OUTPUT ">".$id."_".$start.":".$end."\n";
            print OUTPUT $subsequence."\n";
            print "\n"; # Move to the next line after processing this ID
        } else {
            print " (Warning: Start and/or end positions for ID $id are outside the bounds of the sequence length!)\n";
        }
    } else {
        print " (Warning: ID $id not found in FASTA file!)\n";
    }
}

close CLUSTER;
close OUTPUT;
