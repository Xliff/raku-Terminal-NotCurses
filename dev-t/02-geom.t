use v6;

use Terminal::NotCurses::Raw::Types;

use Terminal::NotCurses::Main;
use Terminal::NotCurses::Cells;
use Terminal::NotCurses::Plane;

use Test;

plan 144;

# cw: Must render output to file handle.
my ($output-file, $output);

INIT {
  $output-file = 'test-output.log';
  $output = $output-file.IO.open( :w );
}

Test::output()         = $output;
Test::failure_output() = $output;

my $nc = Terminal::NotCurses::Main.init( :!stop );
my $n  = Terminal::NotCurses::Plane.new( Terminal::NotCurses::Main.stdplane );

class GeomTest {
  has $.leny;
  has $.lenx;
  has $.ceny;
  has $.cenx;
  has $.absy;
  has $.absx;

  multi method new ($ly, $lx, $cy, $cx) {
    self.bless( leny => $ly, lenx => $lx, ceny => $cy, cenx => $cx )
  }
  multi method new ($ly, $lx, $ay, $ax, $cy, $cx ) {
    self.bless(
      leny => $ly, lenx => $lx,
      absy => $ay, absx => $ax,
      ceny => $cy, cenx => $cx
    )
  }

}

subtest {
  for
    (
      [ 1, 1, 0, 0 ], [ 1, 2, 0, 0 ], [ 3, 1, 1, 0 ],
      [ 1, 3, 0, 1 ], [ 2, 3, 0, 1 ], [ 3, 2, 1, 0 ],
      [ 3, 3, 1, 1 ], [ 4, 1, 1, 0 ], [ 1, 4, 0, 1 ],
      [ 2, 4, 0, 1 ],

      [ 4, 2, 1, 0 ], # center abs

      [ 3, 4, 1, 1 ],
      [ 4, 3, 1, 1 ], [ 4, 4, 1, 1 ], [ 4, 4, 1, 1 ],
      [ 5, 1, 2, 0 ], [ 1, 5, 0, 2 ], [ 2, 5, 0, 2 ],

      [ 5, 2, 2, 0 ], # center-abs

      [ 3, 5, 1, 2 ], [ 5, 3, 2, 1 ],
      [ 4, 5, 1, 2 ], [ 5, 4, 2, 1 ], [ 5, 5, 2, 2 ]
    ).map({ GeomTest.new( |$_ ) })
  {
    my $no = ncplane_options.new( .leny, .lenx );
    my $p  = $n.create($no);

    my $c = Terminal::NotCurses::Cells.double_box($n, 0, 0);
    ok $c.defined,                                            'Can create double box cells';

    my $pr = $p.perimeter( |$c );
    if .leny >= 2 && .lenx >= 2 {
      ok $pr.not,                                             "Can create a plane perimeter from cells ({ .leny } x { .lenx })";
    } else {
      ok $pr == -1,                                           "Cannot create a plane with side less than size 2 ({ .leny } x { .lenx })";
    }

    ok $nc.render.not,                                        'Can render plane to screen';

    my @cen = $p.center_abs;
    is @cen.head, .ceny,                                      "Plane has center y of { .ceny }";
    is @cen.tail, .cenx,                                      "Plane has center x of { .cenx }";
    ok $p.destroy.not,                                        "Plane was destroyed";
  }
}, 'Center-ish';

subtest {
  for (
    [ 1, 1, 10, 20, 0, 0 ], [ 1, 2, 10, 20, 0, 0 ], [ 3, 1, 10, 20, 1, 0 ],
    [ 1, 3, 10, 20, 0, 1 ], [ 2, 3, 10, 20, 0, 1 ], [ 3, 2, 10, 20, 1, 0 ],
    [ 3, 3, 10, 20, 1, 1 ], [ 4, 1, 10, 20, 1, 0 ], [ 1, 4, 10, 20, 0, 1 ],
    [ 2, 4, 10, 20, 0, 1 ], [ 4, 2, 10, 20, 0, 1 ], [ 3, 4, 10, 20, 1, 1 ],
    [ 4, 3, 10, 20, 1, 1 ], [ 4, 4, 10, 20, 1, 1 ], [ 4, 4, 10, 20, 1, 1 ],
    [ 5, 1, 10, 20, 2, 0 ], [ 1, 5, 10, 20, 0, 2 ], [ 2, 5, 10, 20, 0, 2 ],
    [ 5, 2, 10, 20, 2, 1 ], [ 3, 5, 10, 20, 1, 2 ], [ 5, 3, 10, 20, 2, 1 ],
    [ 4, 5, 10, 20, 1, 2 ], [ 5, 4, 10, 20, 2, 1 ], [ 5, 5, 10, 20, 2, 2 ]
  ).map({ GeomTest.new( |$_ ) }) {
    my $no = ncplane_options.new(
      y    => .absy, x    => .absx,
      rows => .leny, cols => .lenx
    );
    my $p  = $n.create($no);

    my $c = Terminal::NotCurses::Cells.double_box($n, 0, 0);
    ok $c.defined,                                            'Can create double box cells';

    my $pr = $p.perimeter( |$c );
    if .leny >= 2 && .lenx >= 2 {
      ok $pr.not,                                             "Can create a plane perimeter from cells ({ .leny } x { .lenx })";
    } else {
      ok $pr == -1,                                           "Cannot create a plane with side less than size 2 ({ .leny } x { .lenx })";
    }

    ok $nc.render.not,                                        'Can render plane to screen';

    my @cen = $p.center_abs;
    is @cen.head, .ceny + .absy,                              "Plane has center y of { .ceny + .absy }";
    is @cen.tail, .cenx + .absx,                              "Plane has center x of { .cenx + .absx }";
    ok $p.destroy.not,                                        "Plane was destroyed";
  }

}, 'Center ABS';

Terminal::NotCurses::Main.stop;
$output.close;
$output-file.IO.slurp( :close ).say;
