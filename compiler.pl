#!/bin/usr/perl


my %Registor = (		#the hash for 32 registors in MIPS
	"\$0"	 => "00000",
	"\$zero" => "00000",
	"\$1"    => "00001",
	"\$at"   => "00001",
	"\$2"    => "00010",
	"\$v0"   => "00010",
	"\$3"    => "00011",
	"\$v1"   => "00011",
	"\$4"    => "00100",
	"\$a0"   => "00100",
	"\$5"    => "00101",
	"\$a1"   => "00101",
	"\$6"    => "00110",
	"\$a2"   => "00110",
	"\$7"    => "00111",
	"\$a3"   => "00111",
	"\$8"    => "01000",
	"\$t0"   => "01000",
	"\$9"    => "01001",
	"\$t1"   => "01001",
	"\$10"   => "01010",
	"\$t2"   => "01010",
	"\$11"   => "01011",
	"\$t3"   => "01011",
	"\$12"   => "01100",
	"\$t4"   => "01100",
	"\$13"   => "01101",
	"\$t5"   => "01101",
	"\$14"   => "01110",
	"\$t6"   => "01110",
	"\$15"   => "01111",
	"\$t7"   => "01111",
	"\$16"   => "10000",
	"\$s0"   => "10000",
	"\$17"   => "10001",
	"\$s1"   => "10001",
	"\$18"   => "10010",
	"\$s2"   => "10010",
	"\$19"   => "10011",
	"\$s3"   => "10011",
	"\$20"   => "10100",
	"\$s4"   => "10100",
	"\$21"   => "10101",
	"\$s5"   => "10101",
	"\$22"   => "10110",
	"\$s6"   => "10110",
	"\$23"   => "10111",
	"\$s7"   => "10111",
	"\$24"   => "11000",
	"\$t8"   => "11000",
	"\$25"   => "11001",
	"\$t9"   => "11001",
	"\$26"   => "11010",
	"\$k0"   => "11010",
	"\$27"   => "11011",
	"\$k1"   => "11011",
	"\$28"   => "11100",
	"\$gp"   => "11100",
	"\$29"   => "11101",
	"\$sp"   => "11101",
	"\$30"   => "11110",
	"\$fp"   => "11110",
	"\$31"   => "11111",
	"\$ra"   => "11111"

);


my %opcode = (			#the hash for opcode 
	"add"	=> "000000",
	"addu"	=> "000000",
	"and"	=> "000000",
	"jr"	=> "000000",
	"addi"	=> "001000",	#8_hex
	"addiu"	=> "001001",	#9_hex
	"andi"	=> "001100",	#c_hex
	"beq" 	=> "000100",	#4_hex
	"bne"	=> "000101",	#5_hex
	"lbu"	=> "100100",	#24_hex	
	"lhu"	=> "100101",	#25_hex
	"lui"	=> "001111",	#f_hex
	"lw"	=> "100011",	#23_hex
	"sw"	=> "101011",	#2b_hex
	"j"	=> "000010",	#2_hex
	"jal"	=> "000011",	#3_hex
	"slt"	=> "000000",
        "or"    => "000000",
	"nor"   => "000000",
	"ori"	=> "001101",	#d_hex
	"sub"   => "000000",
	"subu"  => "000000",
	"sltu"	=> "000000",
	"sltiu"	=> "001011",	#b_hex
	"slti"	=> "001010"	#a_hex
);

my %funct = (			#the hash for function
	"add"	=> "100000",	#20_hex
	"addu"	=> "100001",	#21_hex
	"and"	=> "100100",	#24_hex
	"jr"	=> "001000",	#08_hex
	"slt"	=> "101010",	#2a_hex
	"or"	=> "100101",	#25_hex
	"nor"	=> "100111",	#27_hex
	"sub"	=> "100010",	#22_hex
	"subu"	=> "100011",	#23_hex
	"sltu"	=> "101011"	#2b_hex
);

my %format = (			#the hash for format type
	"add"	=> "R",
	"addu"	=> "R",
	"and"	=> "R",
	"jr"	=> "Rj",
	"addi"	=> "I",
	"addiu"	=> "I",
	"andi"	=> "I",
	"beq"	=> "Ia",
	"bne"	=> "Ia",
	"lbu"	=> "Im",
	"lhu"	=> "Im",
	"lui"	=> "Il",
	"lw"	=> "Im",
	"sw"	=> "Im",
	"j"	=> "J",
	"jal"	=> "J",
	"syscall"=> "syscall",
	"slt"	=> "R",
	"or"	=> "R",
	"nor" 	=> "R",
	"ori"	=> "I",
	"sub"	=> "R",
	"subu"	=> "R",
	"sltu"	=> "R",
	"sltiu"	=> "I",
	"slti"	=> "I"
);

my %label;			#the hash to adding label and address in the input file

#main function
my $asm;
my $output;
my $statement;
my $rs;
my $rt;
my $rd;
my $function;
my $imme;

open $asm, $ARGV[0];
open $output, ">output.txt";

find_label();
seek $asm, 0, 0;
GenerateHexa();
print "Compile completely\n";
close $asm;
close $output;


sub find_label			#this function is used to find label in the input file
{
	my $pc = 4194304 - 4;	#$PC = 0x00400000 in MIPS
	my $row;		

	foreach $row (<$asm>) 
	{
		$row =~ s/^\s+//;		#delete spaces before $row				
		next if ($row =~ /^#/);		#next if $row does exist # in the beginning
		next if ($row =~ /^$/);		#next if $row does exist $ in the beginning
		next if ($row =~ /\./);		#next if $row does exist . in the beginning
		if ($row =~ /\:/) 		#check $row have :	
		{
			my @newLabel = split(/\:/, $row);	#split function
			$newLabel[0] =~ s/^\s+//;	
			$newLabel[0] =~ s/\s+$//;
			$label{$newLabel[0]} =  $pc + 4;	#save label and address in the hash
			next if ($row !~ /\$/);			#next if $row doesn't exist $
		}
		$pc += 4;
	}
}



sub GenerateHexa			#this function is used to convert MIPS code to machine code (Hexa form)
{
	my $flag = 0;
	my $row;
	my $pc = 4194304;

	foreach $row (<$asm>)
	{
		if ($row =~ /#/)
		{
			my @temp = split(/#/, $row);
		        $row = $temp[0];
		}
                if ($row =~ /\:/)
                {
	                next if ($row !~ /\$/);
	                my @temp = split(/\:/, $row);
	                $row = $temp[1];
	        }

		$row =~ s/^\s+//;	#delete spaces before $row
		$row =~ s/\s+$//;	#delete spaces after $row
		$row =~ s/\(/ /g;	#delete ( in $row
		$row =~ s/\)/ /g;	#delete ) in $row
		$row =~ s/,//g;		#delete , in $row
		
		next if ($row =~ /^#/);	#next if $row does exist # in the beginning
		next if ($row =~ /^$/);	#next if $row does exist $ in the beginning
		next if ($row =~ /^\./);#next if $row does exist . in the beginning

		$flag = 0;
		my @element = split(/\s+/, $row);

		if ($format{$element[0]} eq "R")		#R format: 6 bits opcode + 5 bits rs + 5 bits rt + 5 bits rd + 5 bits shamt + 6 bits function
		{
			$statement = $opcode{$element[0]};
			$rs = $Registor{$element[2]};
			$rt = $Registor{$element[3]};
			$rd = $Registor{$element[1]};
			$function = $funct{$element[0]};
			my $temp = '00000';

			my $bin_num = $statement.$rs.$rt.$rd.$temp.$function;
			my $hex_num = oct("0b".$bin_num);
			printf $output '%#.8x', $hex_num;
			print $output "\n";
			$flag = 1;
		}
	
		elsif ($format{$element[0]} eq "Rj") {		#use for jr command
			$statement = $opcode{$element[0]};
			$rs = $Registor{$element[1]};
			$function = $funct{$element[0]};
			my $temp = '000000000000000';

			my $bin_num = $statement.$rs.$temp.$function;
			my $hex_num = oct("0b".$bin_num);
			printf $output '%#.8x', $hex_num;
			print $output "\n";
			$flag = 1;
		}

		elsif ($format{$element[0]} eq "I") {		#I format: 6 bits opcode + 5 bits rs + 5 bits rt + 26 bits immediate
			$statement = $opcode{$element[0]};
			$rs = $Registor{$element[2]};
			$rt = $Registor{$element[1]};
			$imme = sprintf ("%016b", $element[3]);
			$imme = substr ($imme, -16);
			my $bin_num = $statement.$rs.$rt.$imme;
			
			my $hex_num = oct("0b".$bin_num);
			printf $output '%#.8x', $hex_num; 
			print $output "\n";
			$flag = 1;	
		}
					
		elsif ($format{$element[0]} eq "Im") {		#use for lbu, lhu, lw, sw command
			$statement = $opcode{$element[0]};
			$rt = $Registor{$element[1]};
			$rs = $Registor{$element[3]};
			$imme = sprintf ("%016b", $element[2]);
	                $imme = substr ($imme, -16);
			my $bin_num = $statement.$rs.$rt.$imme;

			my $hex_num = oct("0b".$bin_num); 
			printf $output '%#.8x', $hex_num;
			print $output "\n";
		        $flag = 1;
		}

		elsif ($format{$element[0]} eq "Ia"){		#use for beq, bne command
			$statement = $opcode{$element[0]};
			$rs = $Registor{$element[1]};
			$rt = $Registor{$element[2]};
			$imme = ($label{$element[3]} - $pc - 4) >> 2;
			$imme = sprintf ("%016b", $imme);
			$imme = substr ($imme, -16);
			my $bin_num = $statement.$rs.$rt.$imme;

                        my $hex_num = oct("0b".$bin_num);     
			printf $output '%#.8x', $hex_num;
			print $output "\n";
			$flag = 1;
		}

		elsif ($format{$element[0]} eq "Il") {		#use for lui command
			$statement = $opcode{$element[0]};
			$rt = $Registor{$element[1]};
			$imme = sprintf("%.16b", $element[2]);
			my $temp = '00000';

			my $bin_num = $statement.$temp.$rt.$imme;
			my $hex_num = oct("0b".$bin_num);   
			printf $output '%#.8x', $hex_num;
			print $output "\n";
			$flag = 1;
		}

		elsif ($format{$element[0]} eq "J") {		#J format: 6 bits opcode + 26 bits address
			$statement = $opcode{$element[0]};
			my $thutuc = $label{$element[1]};
			$thutuc = $thutuc >> 2;
			$thutuc = sprintf("%.26b", $thutuc);
			
			my $bin_num = $statement.$thutuc;
			my $hex_num = oct("0b".$bin_num);
			printf $output '%#.8x', $hex_num;
			printf $output "\n";
			$flag = 1;			
		}

		elsif ($format{$element[0]} eq "syscall") { 	#use for syscall command
			print $output "0x0000000c\n";
			$flag = 1;
		}	
			
		if ($flag eq 1) {$pc = $pc + 4;}		#if $flag = 1, $row has command, so need to increase $pc up 
	}							#Opposite, $flag = 0 so $row hasn't command
}


