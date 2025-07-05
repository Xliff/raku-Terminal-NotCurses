use v6;

use Terminal::NotCurses::Raw::Types;

use Terminal::NotCurses::Main;
use Terminal::NotCurses::Cells;
use Terminal::NotCurses::Plane;
use Terminal::NotCurses::Testing;

use Test;

plan 20;

# cw: Must render output to file handle.


INIT {
  $nc-output-file = 'test-plane-output.log';
  $nc-output = $nc-output-file.IO.open( :w );
}

my $OLD-ERR = $*ERR;
Test::output()         = $nc-output;
Test::failure_output() = $nc-output;
$*ERR                  = $nc-output;

$NC = Terminal::NotCurses::Main.init( :!stop );

my $n  = Terminal::NotCurses::Plane.new( Terminal::NotCurses::Main.stdplane );

sub BoxPermutationsRounded ($nc, $n, $e) {
  my @d = $n.dim-yx;
  ok @d.head > 2,                            'Rows greater than 2';
  ok @d.tail > 47,                           'Columns greater than 47';
  my $bm = $e +< NCBOXCORNER_SHIFT;
  for ^16 {
    $n.move-yx(0, $_ * 3);
    $n.rounded-box-sized(0, 0, 3, 3, $bm);
    ++$bm;
  }
  render;
}


nc-subtest {
  my ($x, $y) = $n.cursor_yx;
  ok ($x, $y) ~~ (0, 0), 'Cursor is at (0, 0)'
}, 'StdPlane position';


my $p;
nc-subtest {
  my ($rows, $cols) = Terminal::NotCurses::Main.dim_yx;
  my ($r, $c)       = $n.dim_yx;
  is ($r, $c), ($rows, $cols), 'StdPlane is the size of the terminal';
  my $no = ncplane_options.new( :$rows, :$cols );
  $p  = $n.create($no);;
  ok $p,                       "Created plane with dimensions ({ $rows }, { $cols })";
}, 'StdPlane dimensions';

nc-subtest {
  my ($rows, $cols) = Terminal::NotCurses::Main.dim_yx;
  diag $p.cursor_move_yx(0, 0);
  ok $p.move_yx(0, 0).not,                         'Can move cursor to (0, 0)';

  my ($x, $y) = $p.cursor_yx;
  ok ($x, $y) ~~ (0, 0),                           'Cursor verified at position (0, 0)';

  ok $p.cursor_move_yx($rows.pred, 0).not,                "Can move cursor to ({$rows.pred}, 0)";
  is $p.cursor_yx, ($rows.pred, 0),                "Cursor verified at position ({$rows.pred}, 0)";

  ok $p.cursor_move_yx($rows.pred, $cols.pred).not,       "Can move cursor to ({$rows.pred}, {$cols.pred})";
  is $p.cursor_yx, ($rows.pred, $cols.pred),     "Cursor verified at position ({$rows.pred}, {$cols.pred}))";

  ok $p.cursor_move_yx(0, $cols.pred).not,                "Can move cursor to (0, {$cols.pred})";
  is $p.cursor_yx, (0, $cols.pred),              "Cursor verified at position (0, {$cols.pred}))";
}, 'Move StdPlane Dimensions';

nc-subtest {
  my ($rows, $cols) = Terminal::NotCurses::Main.dim_yx;
  ok $p.cursor_move_yx(-2, 0),                        "Cursor cannot be moved to (-2, 0)";

  ok $p.cursor_move_yx(-2,                -2),        "Cursor cannot be moved to (-2, -2)";
  ok $p.cursor_move_yx(0,                 -2),        "Cursor cannot be moved to (0,  -2)";
  ok $p.cursor_move_yx($rows - 1,         -2),        "Cursor cannot be moved to ({ $rows - 1 }, -2)";
  ok $p.cursor_move_yx($rows,              0),        "Cursor cannot be moved to ({ $rows,    },  0)";
  ok $p.cursor_move_yx($rows + 1,          0),        "Cursor cannot be moved to ({ $rows + 1 },  0)";
  ok $p.cursor_move_yx($rows,      $cols    ),        "Cursor cannot be moved to ({ $rows     } , { $cols })";
  ok $p.cursor_move_yx(-2,         $cols - 1),        "Cursor cannot be moved to (-2, { $cols - 1 })";
  ok $p.cursor_move_yx(0,          $cols    ),        "Cursor cannot be moved to (0,  { $cols     })";
  ok $p.cursor_move_yx(0,          $cols + 1),        "Cursor cannot be moved to (0,  { $cols + 1 })";
}, 'Move Beyond Plane Fails';

nc-subtest {
  ok $p.set-fg-rgb8(0, 0, 0).not,                     'Can set plane fg to black';
  ok $p.set-fg-rgb8(255, 255, 255).not,               'Can set plane fg to white';
  render;
}, 'Plane RGB';

nc-subtest {
  nok $p.set-fg-rgb8( -1, 0, 0).not,                  'Attempting to set fg color to ( -1, 0, 0) fails.';
  nok $p.set-fg-rgb8(0, -1, 0).not,                   'Attempting to set fg color to (0, -1, 0) fails.';
  nok $p.set-fg-rgb8(0, 0, -1).not,                   'Attempting to set fg color to (0, 0, -1) fails.';
  nok $p.set-fg-rgb8(-1, -1, -1).not,                 'Attempting to set fg color to (-1, -1, -1) fails.';
  nok $p.set-fg-rgb8(256, 255, 255).not,              'Attempting to set fg color to (256, 255, 255) fails.';
  nok $p.set-fg-rgb8(255, 256, 255).not,              'Attempting to set fg color to (255, 256, 255) fails.';
  nok $p.set-fg-rgb8(255, 255, 256).not,              'Attempting to set fg color to (255, 255, 256) fails.';
  nok $p.set-fg-rgb8(256, 256, 256).not,              'Attempting to set fg color to (256, 256, 256) fails.';
}, 'Reject bad RGB';

nc-subtest {
  my $d  = $n.dim_yx;
  my $no = ncplane_options.new( |$d );
  my $nn = $p.create($no);
  ok $nn,                                             "New subplane created with size ({ $d.join(', ') })";
  is $p.dim_y, $nn.dim_y,                             'Subplane has the same number of rows';
  is $p.dim_x, $nn.dim_x,                             'Subplane has the same number of columns';
  ok $nn.destroy.not,                                 'Subplane is destroyed with no errors';
}, 'Plane child';

nc-subtest {
  my $t = 'a';
  my $c = Terminal::NotCurses::Cell.new($t);
  ok $p.putc_yx(0, 0, $c),                             "Character '{ $t }' placed at point (0, 0)";
  is $p.at_yx(0, 0), $t,                               "Character at point (0, 0) is '{ $t }'";
  my @c = $p.cursor_yx;
  is @c.head, 0,                                       'Cursor is at row 0';
  is @c.tail, 1,                                       'Cursor was advanced to col 1';
  render;
  $c = Terminal::NotCurses::Cell.new;
  ok $p.putc_yx(0, 0, $c),                             'NUL character placed at point (0, 0)';
  is $p.at_yx(0, 0), '',                               "Character at point (0, 0) is NUL";
  @c = $p.cursor_yx;
  is @c.head, 0,                                       'Cursor is at row 0';
  is @c.tail, 1,                                       'Cursor was advanced to col 1';
  render;
}, 'Emit NUL';

nc-subtest {
  my $ch = '✔';
  my $c  = Terminal::NotCurses::Cell.new;
  is strlen($ch), $c.load($p, $ch),                    q<Length of cell and '✔' character are the same>;
  ok $p.putc($c),                                      'Cell placed on plane without error';
  my @c = $p.cursor-yx;
  is @c.head, 0,                                       'Cursor is at row 0';
  is @c.tail, 1,                                       'Cursor was advanced to col 1';
  render;
}, 'Emit Cell';

nc-subtest {
  my $ch = '✔';
  ok $p.putwegc('✔'),                                  'Checkmark character placed on plane without error';
  my @c = $p.cursor-yx;
  is @c.head, 0,                                       'Cursor is at row 0';
  is @c.tail, 1,                                       'Cursor was advanced to col 1';
  render;
}, 'Emit Wide Char';

nc-subtest {
  my @ss = «
    'Σιβυλλα τι θελεις;'
    ' respondebat illa:'
    ' αποθανειν θελω.'
  »;

  for @ss {
    ok $p.cursor_move_yx( .head.chars - @ss.head.chars, 0 ).not, 'Cursor moved into position without error';
    my $w = $p.putstr($_);
    is ncstrwidth($_), $w,                                       "Wrote out { $w } chars";
  }

  my @c = $p.cursor-yx;
  is @c.head, 2,                                                 'Cursor is at row 2';
  ok @c.tail < 10,                                               'Cursor has not advanced past the 10th column';
  render;
}, 'Emit Str';

nc-subtest {
  my @ss = «
    'Σιβυλλα τι θελεις;'
    ' respondebat illa:'
    ' αποθανειν θελω.'
  »;

  for @ss {
    ok $p.cursor_move_yx( .head.chars - @ss.head.chars, 0 ).not, 'Cursor moved into position without error';
    # cw: API changes between 3.0.6 and master?
    #is $p.putwstr($_), -1,                                       "Wrote out wide string successfully";
  }

  my @c = $p.cursor-yx;
  is @c.head, 2,                                                 'Cursor is at row 2';
  ok @c.tail < 10,                                               'Cursor has not advanced past the 10th column';
  render;
}, 'Emit Wide Str';

nc-subtest {
  my $s = '🍺🚬🌿💉💊🔫💣🤜🤛🐌🐎🐑🐒🐔🐗🐘🐙🐚 🐛🐜🐝🐞🐟🐠🐡🐢🐣🐤🐥🐦🐧🐨🐩🐫🐬🐭🐮';
  ok $p.set-scrolling(True).not,                                 'Plane set to allow scrolling';
  ok $p.putwstr($s),                                             'Wide str emitted properly';
  my @c = $p.cursor-yx;
  ok @c.head >= 0,                                               'Cursor is at least on row 0';
  ok @c.tail >= 1,                                               'Cursor is not beyond column 1';
  render;
}, 'Emit String of Emojis';

nc-subtest {
  my @c = $p.dim-yx;
  ok @c.all > 0,                                                 'Both plane dimensions are greater than 0';
  my $c = Terminal::NotCurses::Cell.new;
  $c.load($p, '-');
  for ^@c.head {
    ok $p.cursor-move-yx($_, 1).not,                             'Cursor move succeeds';
    my $x = @c.tail - 2;
    is $p.hline($c, $x), $x,                                     ".hline method returns length of { $x }";
    @c = $p.cursor-yx;
    is @c.head, $_,                                              "Y position is { $_ }";

    # cw: Confirm this is a failure!
    #is @c.tail, $x.pred,                                         "X position is { $x.pred }";
  }
  $c.release($p);
  render;
  $p.erase;
}, 'Horizontal Lines';

nc-subtest {
  my @c = $p.dim-yx;
  ok @c.all > 0,                                                 'Both plane dimensions are greater than 0';
  my $c = Terminal::NotCurses::Cell.new;
  $c.load($p, '|');
  for 1 ..^ @c.tail.pred {
    ok $p.cursor-move-yx(1, $_).not,                             'Cursor move succeeds';
    my $y = @c.head - 2;
    is $p.vline($c, $y), $y,                                     ".vline method returns length of { $y }";
    @c = $p.cursor-yx;
    is @c.tail, $_,                                              "Y position is { $_ }";

    # cw: Confirm this is a failure!
    #is @c.tail, $x.pred,                                         "X position is { $x.pred }";
  }
  $c.release($p);
  render;
  $p.erase;
}, 'Vertical Lines';

nc-subtest {
  my @c = ( my ($y, $x) = $p.dim-yx );
  ok @c.all > 2,                                                'Dimensions of plane are greater than 2';
  my $cc = $p.rounded_box_cells(0, 0);
  ok $cc.defined,                                               'Rounded box characters loaded properly';
  is $p.box( |$cc, $y.succ, $x.succ ), -1,                      'Box outside of plane dimensions is invalid';
  ok $p.move_yx(1, 0).not,                                      'Cursor moved to (1, 0) successfully';
  is $p.box( |$cc, $y, $x, 0 ), -1,                             'Another box outside of plane dimensions is invalid';
  ok $p.move_yx($y.pred, $x.pred).not,                          "Cursor moved to ({ $y.pred }, { $x.pred }) successfully";
  is $p.box( |$cc, 2, 2, 0 ), -1,                               'Third box outside of plane dimensions is invalid';
  ok $p.move_yx($y - 2, $x - 1).not,                            "Cursor moved to ({ $y - 2 }, { $x - 1 }) successfully";
  is $p.box( |$cc, 2, 2, 0 ), -1,                               'Fourth box outside of plane dimensions is invalid';
  ok $p.move_yx($y - 1, $x - 2).not,                            "Cursor moved to ({ $y - 1 }, { $x - 2 }) successfully";
  is $p.box( |$cc, 2, 2, 0 ), -1,                               'Fifth box outside of plane dimensions is invalid';
  render;
  $p.erase;
  $p.destroy;
  render(0);
}, 'Invalid Box Placement';

for 0 .. 3 {
  nc-subtest {
    BoxPermutationsRounded($NC, $p, $_);
  }, "Rounded Box Permutations ({ $_ } { $_ == 1  ?? 'edge' !! 'edges' })";
}

nc-subtest {
  my @d = $n.dim-yx;
  ok @d.tail ~~ 2 .. 47,                           'Terminal size between 2 and 47 columns in size.';
  my $bm = 0;
  for ^16 {
    ok $n.cursor-move-yx(0, $_ * 3).not,           "Cursor moved to (0, { $_ * 3}) successfully";
    ok $n.double_box_sized(0, 0, 3, 3, $bm++).not, "Boxes rendered with mask { $bm } successfully";
  }
  render(2);
  $n.erase;
}, 'Double Box Permutations';

nc-subtest {
  my @d = $n.dim-yx;
  ok @d.all > 2,                                     'All dimensions greater than 2';
  ok $n.cursor-move-yx(0, 0).not,                    'Cursor moved to (0, 0) successfully';
  ok $n.rounded-box(0, 0, |@d.map( *.pred ), 0).not, 'Rounded perimeter drawn';
  render(2);
  $n.erase;
}, 'Rounded Box Perimeter';

nc-subtest {
  my @d = $n.dim-yx;
  ok @d.all > 2,                                     'All dimensions greater than 2';
  ok $n.cursor-move-yx(0, 0).not,                    'Cursor moved to (0, 0) successfully';
  ok $n.double-box(0, 0, |@d.map( *.pred ), 0).not,  'Double perimeter drawn';
  render(2);
}, 'Double Box Perimeter';


Terminal::NotCurses::Main.stop;
