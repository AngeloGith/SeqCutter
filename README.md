# SeqCutter features
 It is a Perl script designed to extract specific subsequences from a FASTA file based on a cluster definition.

# Requirements 

* Perl
* Bio::SeqIO module from BioPerl

# Usage

`perl SeqCutter.pl -df <cluster_definition_file> -f <fasta_file> -o <output_file>`

# Parameters

-df: Path to the cluster definition file. Each line should contain a sequence ID followed by start and end positions separated by tabs.

-f: Path to the FASTA file containing the sequences.

-o: Path to the output file where the extracted subsequences will be saved.


```plaintext
# -df (Cluster Definition File Format)
# Each line should contain a sequence ID, start position, and end position, separated by tabs.

SEQ1    100     200
SEQ2    50      150
SEQ3    75      175

