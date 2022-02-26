#!/usr/bin/perl

use warnings;
use strict;
use Term::ANSIColor qw(:constants);
use Smart::Comments;
use Getopt::Long;


my $wordlist = '';
my $data_enc = '';
my $help;

GetOptions ( 'help|h' => \$help, 'wordlist|w=s' => \$wordlist, 'data|d=s' => \$data_enc );

my @ciphers = qw( AES-128-CBC AES-128-CFB AES-128-CFB1 AES-128-CFB8 AES-128-CTR AES-128-ECB AES-128-OFB AES-192-CBC AES-192-CFB AES-192-CFB1 AES-192-CFB8 AES-192-CTR AES-192-ECB AES-192-OFB AES-256-CFB AES-256-CFB1 AES-256-CFB8 AES-256-CTR AES-256-ECB AES-256-CBC AES-256-OFB AES128 AES192 AES256 BF BF-CBC BF-CFB BF-ECB BF-OFB CAMELLIA-128-CBC CAMELLIA-128-CFB CAMELLIA-128-CFB1 CAMELLIA-128-CFB8 CAMELLIA-128-CTR CAMELLIA-128-ECB CAMELLIA-128-OFB CAMELLIA-192-CBC CAMELLIA-192-CFB CAMELLIA-192-CFB1 CAMELLIA-192-CFB8 CAMELLIA-192-CTR CAMELLIA-192-ECB CAMELLIA-192-OFB CAMELLIA-256-CBC CAMELLIA-256-CFB CAMELLIA-256-CFB1 CAMELLIA-256-CFB8 CAMELLIA-256-CTR CAMELLIA-256-ECB CAMELLIA-256-OFB CAMELLIA128 CAMELLIA192 CAMELLIA256 CAST CAST-cbc CAST5-CBC CAST5-CFB CAST5-ECB CAST5-OFB ChaCha20 DES DES-CBC DES-CFB DES-CFB1 DES-CFB8 DES-ECB DES-EDE DES-EDE-CBC DES-EDE-CFB DES-EDE-ECB DES-EDE-OFB DES-EDE3 DES-EDE3-CBC DES-EDE3-CFB DES-EDE3-CFB1 DES-EDE3-CFB8 DES-EDE3-ECB DES-EDE3-OFB DES-OFB DES3 DESX DESX-CBC RC2 RC2-40-CBC RC2-64-CBC RC2-CBC RC2-CFB RC2-ECB RC2-OFB RC4 RC4-40 SEED SEED-CBC SEED-CFB SEED-ECB SEED-OFB );

if ( $help or $wordlist eq '' or $data_enc eq '' ) {

	print BOLD YELLOW "\nUsage:", BOLD GREEN ,"\tperl $0 -w /path/to/wordlist -d data_encrypted\n", RESET;
	exit 255;
	
} ;

open my $fh, '<', $wordlist or die "Failed to open file: $wordlist";

chomp( my @diccionario = <$fh> ); ## matriz cuyos elemetos son palabras del diccionario


LOOP: foreach my $cipher ( @ciphers ) { ### Progreso [===>[%]   ]  done.  

		foreach my $password ( @diccionario ) {
		
		my $command = `openssl '$cipher' -d -in '$data_enc' -out decrypted.txt -pass pass:'$password' > /dev/null 2>&1`;
		my $decrypted = "./decrypted.txt";
	
		if ( ! $? and -T $decrypted and ! -B $decrypted ) { 
			system 'clear';	
			print BOLD GREEN, "\n\n[*] Password:", BOLD YELLOW, " '$password'\n", BOLD GREEN ,"[*] Cifrado:", BLUE, " \U'$cipher'\n" , RESET; 
			last LOOP;

		}



	}

	print "\tCifrado: $cipher\n";

}

close $fh;
exit 0;


