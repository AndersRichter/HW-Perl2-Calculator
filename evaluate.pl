=head1 DESCRIPTION
Эта функция должна принять на вход ссылку на массив, который представляет из себя обратную польскую нотацию,
а на выходе вернуть вычисленное выражение
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

sub evaluate {
	my $rpn = shift;
	my @rub=@$rpn;
	
	for (my $i=0; $i<= $#rub; $i++)
	{		
		if($rub[$i]=~/\D/)
		{
			if(($rub[$i-1]=~/\d+/)&&($rub[$i]=~/U-/))
			{
				$rub[$i-1]=$rub[$i-1]*(-1);
				splice(@rub,$i,1);
				$i--;
			}
			elsif(($rub[$i-1]=~/\d+/)&&($rub[$i]=~/U\+/))
			{
				splice(@rub,$i,1);
				$i--;
			}
			elsif(($rub[$i-2]=~/-*\d+/)&&($rub[$i-1]=~/-*\d+/)&&($rub[$i]=~/\+/))
			{
				$rub[$i]=$rub[$i-2]+$rub[$i-1];
				splice(@rub,$i-2,2);
				$i-=2;
				
			}
			elsif(($rub[$i-2]=~/-*\d+/)&&($rub[$i-1]=~/-*\d+/)&&($rub[$i]=~/-/))
			{
				$rub[$i]=$rub[$i-2]-$rub[$i-1];
				splice(@rub,$i-2,2);
				$i-=2;
			}
			elsif(($rub[$i-2]=~/-*\d+/)&&($rub[$i-1]=~/-*\d+/)&&($rub[$i]=~/\*/))
			{
				$rub[$i]=$rub[$i-2]*$rub[$i-1];
				splice(@rub,$i-2,2);
				$i-=2;
			}
			elsif(($rub[$i-2]=~/-*\d+/)&&($rub[$i-1]=~/-*\d+/)&&($rub[$i]=~/\//))
			{
				$rub[$i]=$rub[$i-2]/$rub[$i-1];
				splice(@rub,$i-2,2);
				$i-=2;
			}
			elsif(($rub[$i-2]=~/-*\d+/)&&($rub[$i-1]=~/-*\d+/)&&($rub[$i]=~/\^/))
			{
				$rub[$i]=$rub[$i-2]**$rub[$i-1];
				splice(@rub,$i-2,2);
				$i-=2;
			}
			else{}
		}
		else{}		
	}			
	return $rub[0];
}

1;
