use v6;

use Terminal::NotCurses::Raw::Types;

use Terminal::NotCurses::Main;
use Terminal::NotCurses::Cell;
use Terminal::NotCurses::Channels;
use Terminal::NotCurses::Plane;
use Terminal::NotCurses::Testing;

use Test;

plan 4;


INIT {
  $nc-output-file = 'test-polyfill-output.log';
  $nc-output      = $nc-output-file.IO.open( :w );
}

my $STDERR = $*ERR;
Test::output()         = $nc-output;
Test::failure_output() = $nc-output;
$*ERR                  = $nc-output;

$NC = Terminal::NotCurses::Main.init( :!stop );

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
  render;
  ok $p.putc_yx(0, 0, $c)     > 0,         'Placed cell at (0, 0)';
  ok $c.load($p, '/')         > 0,         'Loaded cell with "/" character';
  ok $p.polyfill_yx(0, 0, $c) > 0,         'Filled plane with "/" at (0, 0)';
  is $p.at-yx(0, 0), '/',                  'Character at (0, 0) is confirmed to be "/"';
  render;
  ok $p.destroy.not,                       'Plane destroyed';
}, 'Polyfill on Glyph';

subtest {
  my $c = Terminal::NotCurses::Cell.new('-');
  ok $n.polyfill-yx(0, 0, $c) > 0,             'Fill stdplane with "-"';
  render;
}, 'Polyfill StdPlane';

subtest {
  my $c = Terminal::NotCurses::Cell.new('+');
  my $p = $n.new(20, 20);
  ok $p,                                   'Created 20x20 plane successfully';
  is $p.polyfill-yx(0, 0, $c), 400,        'Filled plane with 400 cells';
  render;
  ok $p.destroy.not,                       'Plane destroyed';
}, 'Polyfill Empty Plane';

subtest {
  my $c = Terminal::NotCurses::Cell.new('+');
  my $p = $n.new(4, 4);
  ok $p,                                   'Created 4x4 plane successfully';
  ok $p.putc-yx(0, 1, $c) > 0,             'Placed a cell at (0, 1) successfully';
  ok $p.putc-yx(1, 1, $c) > 0,             'Placed a cell at (1, 1) successfully';
  ok $p.putc-yx(1, 0, $c) > 0,             'Placed a cell at (1, 0) successfully';
  is $p.polyfill-yx(0, 0, $c),  1,         'Filled in 1 cell at (0, 0)';
  is $p.polyfill-yx(2, 2, $c), 12,         'Filled in 12 cells at (2, 2)';
  render;
  ok $p.destroy.not,                       'Plane destroyed';
}, 'Polyfill Walled Plane';

subtest {
  my $c = Terminal::NotCurses::Channels.new;
  $c.set-fg-rgb(0x40f040);
  $c.set-bg-rgb(0x40f040);
  my @d = $n.dim-yx;
  ok $n.gradient(-1, -1, |@d, 'M', 0, $c) > 0, 'Plane gradient performed successfully';
  for [X]( |@d.map({ 0 ..^ $_ }) ) -> ($y, $x) {
    my @yx = $n.at_yx_cell($y, $x, :all);
    ok @yx.head > 0,                           "Call to .at-yx-cell completed at ({ $y }, { $x })";
    is @yx.tail.nccell.gcluster.chr, 'M',      'Cell contains an "M" character';
    ok @yx.tail.stylemask.not,                 'Cell has no stylemask';
    # cw: -YYY- Non-raw channels aren't showing both values!
    is @yx.tail.channels(:raw), $c.Int,        'Cell is colored properly';
  }
  render;
}, 'Gradient Monochromatic';

subtest {
  my ($ul, $ll, $ur, $lr) = Terminal::NotCurses::Channels.new xx 4;
  .bgfg = 0x40f040 for $ul, $ll, $ur, $lr;

  my @d = $n.dim-yx;
  ok $n.gradient(-1, -1, |@d, 'V', 0, $ul, $ur, $ll, $lr) > 0, 'Plane gradient performed successfully';

  my $lasty;
  for [X]( |@d.map({ 0 ..^ $_ }) ) -> ($y, $x) {
    my $lastx;
    my ($rv, $c) = $n.at_yx_cell($y, $x, :all);
    ok $rv > 0,                                "Call to .at-yx-cell completed at ({ $y }, { $x })";
    is $c.nccell.gcluster.chr, 'V',            'Cell contains an "V" character';
    ok $c.tail.stylemask.not,                  'Cell has no stylemask';
    if $lastx.defined.not {
      if $lasty.defined.not {
        $lasty = $c.channels.Int;
        is $ul.Int, $c.channels.Int,           'Cell is colored with the UL channel';
      } else {
        is $ll.Int, $c.channels.Int,           'Cell is colored with the LL channel';
      }
      $lastx = $c.channels.Int;
    } else {
      is $lastx, $c.channels.Int,              'Last X-channel compared is the current cell';
    }

    if $x == @d.tail {
      $y.not ?? ( is $ur.Int, $c.channels.Int, 'Cell is colored with the UR channel' )
             !! ( is $lr.Int, $c.channels.Int, 'Cell is colored with the LR channel' );
    }
  }
  render;
}, 'Gradient Vertical';

subtest {
  my ($ul, $ll, $ur, $lr) = Terminal::NotCurses::Channels.new xx 4;
  .bgfg = 0x40f040 for $ul, $ll, $ur, $lr;

  my @d = $n.dim-yx;
  ok $n.gradient(0, 0, |@d, 'H', 0, $ul, $ur, $ll, $lr) > 0, 'Plane gradient performed successfully';
  render;
}, 'Gradient Horizontal';

subtest {
  my ($ul, $ll, $ur, $lr) = Terminal::NotCurses::Channels.new xx 4;

  for (
    $ul, 0x000000, 0xffffff,
    $ll, 0x40f040, 0x40f040,
    $ur, 0xf040f0, 0xf040f0,
    $lr, 0xffffff, 0x000000
  ) -> $c, $fg, $bg {
    ($c.fg, $c.bg) = ($fg, $bg);
  }

  my @d = $n.dim-yx;
  ok $n.gradient(0, 0, |@d, 'X', 0, $ul, $ur, $ll, $lr) > 0, 'Plane gradient performed successfully';
  render;
}, 'Gradient X';

subtest {
  my ($ul, $ll, $ur, $lr) = Terminal::NotCurses::Channels.new xx 4;

  for (
    [ $ul, 0xffffff, $        ],
    [ $lr, 0x000000, $        ],
    [ $ll, 0xffffff, 0xff0000 ],
    [ $ur, 0xff00ff, 0x00ff00 ]
  ) -> ($c, $fg, $bg) {
    .tail.defined.not
      ?? ( $c.bgfg        = $fg )
      !! ( ($c.fg, $c.bg) = ($fg, $bg) );
  }

  my @d = $n.dim-yx;
  ok $n.gradient(0, 0, |@d, 'S', 0, $ul, $ur, $ll, $lr) > 0, 'Plane gradient performed successfully';
  render;
  $n.erase;
}, 'Gradient S';

subtest {
  ok $n.set-fg-rgb(0x444444).not,           'Plane foreground color set successfully';
  is $n.putegc('A'), 1,                     'Placed an "A" character on the screen';
  ok $n.set-fg-rgb(0x888888).not,           'Plane foreground color reset successfully';
  is $n.putegc('B'), 1,                     'Placed an "A" character on the screen';
  render;
  ok $n.cursor-move-yx(0, 0).not,           'Cursor moved to (0, 0) successfully';
  my $c  = Terminal::NotCurses::Cell.new;
  $c.on-styles(NCSTYLE_BOLD);
  ok $n.format(0, 0, 0, 0, $c.stylemask),   'Plane formatted with a stylemask';
  my ($rv, $d) = $n.at-yx-cell(0, 0, :all);
  is $rv,            1,                     'Retrieved cell at (0, 0)';
  is $c.stylemask,   $d.stylemask,          'Stylemasks are the same';
  is $d.fg-rgb.Int,  0x444444,              'Retrieved Cell has the proper foreground color';
  $n.erase;
}, 'Format';

subtest {
  ok $n.set-fg-rgb(0x444444).not,                 'Plane foreground color set successfully';
  for ^8 X ^8 -> ($y, $x) {
    is $n.putegc-yx($y, $x, 'A'), 1,              "Placed an 'A' at ({ $y }, { $x })";
  }
  my $c = Terminal::NotCurses::Channels.new;
  $c.set-fg-rgb8(0x88, 0x99, 0x77);
  ok $n.stain(0, 0, 7, 7, $c),                    '7x7 area of plane stained with foreground color';
  render;
  for ^7 X ^7 -> ($y, $x) {
    my ($rv, $d) = $n.at-yx-cell($y, $x, :all);
    is $rv,                      1,               "Retrieved cell at ({ $y }, { $x })";
    is $c.channels.Int,          $d.channels.Int, q<Retrieved cell's channel is the same as reference channel>;
    is $d.nccell.gcluster.chr,   'A',             'Cell contains an "A" character';
  }
  $n.erase;
}, 'Stain';

Terminal::NotCurses::Main.stop;
