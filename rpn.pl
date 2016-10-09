=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, содержащий обратную польскую нотацию
Один элемент массива - это число или арифметическая операция
В случае ошибки функция должна вызывать die с сообщением об ошибке

=cut

use 5.010;
use strict;
use warnings;
use diagnostics;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
use FindBin;
require "$FindBin::Bin/../lib/tokenize.pl";

sub rpn {
	my $expr = shift;
	my $so = tokenize($expr);
	my @stek;
	my @rpn;
	my $ret;
	
	sub prior
	{
	my ($x) = @_;
	if($x=~/U[\-\+]/)	{$x=4; goto MET;}
	elsif($x=~/[\+\-]/)	{$x=1; goto MET;}
	elsif($x=~/[\*\/]/)	{$x=2; goto MET;}
	elsif($x=~/\^/)		{$x=4; goto MET;}
	elsif($x=~/\d+/)	{$x=0; goto MET;}
	elsif($x=~/\(/)		{$x=(-7); goto MET;}
	MET:
	return $x;
	}
	
	for my $simv (@{$so})
	{
		my $set;
		given($simv)
		{
			when(/\(/)	{push(@stek,$simv);} 			
			when(/\)/)	
			{						
				do
				{							
					$set=pop(@stek);					
					push(@rpn,$set);
				} until($set=~/\(/);	
				pop(@rpn);
			}
			when(/\d/)
			{
				push(@rpn,$simv);
				for(@rpn) {chomp($_);}
			}
			when(/(?:(U\+)|(U\-)|(\*)|(\/)|(\^)|(\()|(\))|(-)|(\+))/)
			{
				$set=pop(@stek);
				if(!defined($set)) 
				{
					push(@stek, $simv);
					goto MET2;
				}
				else
				{
					my $st=prior($set);
					my $rp=prior($simv);					
					if ($rp > $st)
					{
					push(@stek, $set);
					push(@stek, $simv);
					}
					else
					{	
						if(($rp == $st)&&($rp == 4))
						{
							push(@stek,$set);
							push(@stek,$simv);
						}
						else
						{
							{
								do
								{
									push(@rpn,$set);
									$set=pop(@stek);
									if  (!defined $set) {last;}												
									$st = prior($set);
								}
								while ($rp <= $st);
							}
							push(@stek,$set);	
							push(@stek,$simv);
						}
					}
				}
			}
			MET2:
		}
	}

	for (my $i=0; $i <= ($#stek+3); $i++)
	{
		$ret = pop(@stek);
		if (defined($ret))
		{
			push(@rpn, $ret);
		}
	
	}	
	return \@rpn;
}

1;
