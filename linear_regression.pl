
## By BingLi224
##
## 23:04 THA 31/05/2018
##
## Linear Regression Example
##
## Click a point. When got > 1 point, auto calculate linear regression line.

use strict;
use warnings;
use Tkx;

$| = 1;

my @point;

my $cv = Tkx::canvas ( '.cv', -width => 800, -height => 800, );
$cv = Tkx::widget->new ( $cv );
$cv->g_bind ( '<1>', [ sub {
		print join "\t", @_;
		print "\n";
		$cv->create ( 'rectangle',
			$_ [ 0 ] - 1, $_ [ 1 ] - 1,
			$_ [ 0 ] + 1, $_ [ 1 ] + 1,
		);
		push @point, [ $_ [ 0 ], $_ [ 1 ] ];

		&update_linearRegression ( );
	}, Tkx::Ev ( '%x %y' ) ]
);

Tkx::pack ( '.cv', -expand => 1, -fill => 'both' );

Tkx::MainLoop;

################################################################################

sub update_linearRegression
{
	if ( $#point > 0 )
	{
		my $width = $cv->cget ( -width );
		my ( $x_avg, $y_avg ) = ( 0, 0 );

		## find average
		foreach ( 0 .. $#point )
		{
			$x_avg += $point [ $_ ]->[ 0 ];
			$y_avg += $point [ $_ ]->[ 1 ];
		}

		$x_avg /= scalar @point;
		$y_avg /= scalar @point;

		## find slope
		my $slope = 0;
		my $slope_div = 0;
		foreach ( 0 .. $#point )
		{
			$slope += ( $point [ $_ ]->[ 0 ] - $x_avg ) * ( $point [ $_ ]->[ 1 ] - $y_avg );
			$slope_div += ( $point [ $_ ]->[ 0 ] - $x_avg ) * ( $point [ $_ ]->[ 0 ] - $x_avg );
		}

		$slope /= $slope_div;

		## draw the regression line
		$cv->delete ( 'regression' );
		$cv->create ( 'line',
			0, $y_avg + $slope * ( - $x_avg ),
			$width, $y_avg + $slope * ( $width - $x_avg ),
			-tags => 'regression',
		);
	}
}
