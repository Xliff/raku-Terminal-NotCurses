use v6;

use Terminal::NotCurses::Raw::Types;

use Terminal::NotCurses::Main;
use Terminal::NotCurses::Cell;
use Terminal::NotCurses::Plane;

use Test;

plan 4;

# cw: Must render output to file handle.
my ($output-file, $output);

INIT {
  $output-file = 'test-polyfill-output.log';
  $output = $output-file.IO.open( :w );
}

Test::output()         = $output;
Test::failure_output() = $output;

my $nc = Terminal::NotCurses::Main.init( :!stop );
my $n  = Terminal::NotCurses::Plane.new( Terminal::NotCurses::Main.stdplane );

subtest {
  my $c = Terminal::NotCurses::Cell.new;
  ok $n.polyfill-yx( |$n.dim-yx, $c ) < 0,    'Cannot fill plane with NUL char';
}, 'Polyfill NUL';

subtest {
  my @d = $n.dim-yx;
  my $c = Terminal::NotCurses::Cell.new;
  ok $n.polyfill-yx(@d.head, 0, $c) < 0,      'Cannot fill along x-border';
  ok $n.polyfill-yx(0, @d.tail, $c) < 0,      'Cannot fill along y-border';
  ok $n.polyfill-yx(0, -2, $c)      < 0,      'Cannot fill outside x bounds';
  ok $n.polyfill-yx(-2, 0, $c)      < 0,      'Cannot fill outside y bounds';
}, 'Polyfill outside bounds';

subtest {
  my $c = Terminal::NotCurses::Cell.new('+');
  my $p = $n.new(4, 4);
  ok $p,                                   'Created 4x4 plane successfully';
  ok $nc.render.not,                       'Changes rendered with no errors';
  ok $p.putc_yx(0, 0, $c)     > 0,         'Placed cell at (0, 0)';
  ok $c.load($p, '/')         > 0,         'Loaded cell with "/" character';
  ok $p.polyfill_yx(0, 0, $c) > 0,         'Filled plane with "/" at (0, 0)';
  is $p.at-yx(0, 0), '/',                  'Character at (0, 0) is confirmed to be "/"';
  ok $nc.render.not,                       'Changes rendered with no errors';
  ok $p.destroy.not,                       'Plane destroyed';
}

subtest {
  my $c = Terminal::NotCurses::Cell.new('-');
  ok $n.polyfill-yx(0, 0, $c) > 0,             'Fill stdplane with "-"';
  ok $nc.render.not,                           'Changes rendered with no errors';
}, 'Polyfill StdPlane';
