#!/usr/bin/env raku
use v6;

use Color;

use Terminal::NotCurses::Channel;
use Terminal::NotCurses::Main;
use Terminal::NotCurses::Plane;
use Terminal::NotCurses::ProgressBar;

sub getHues ($n) {
  my $hues = (0...360).rotor(360 / $n, :partial).map( *.head );

  $hues.map({ Color.new( hsl => ($_, 78, 60) ) }).head($n);
}

my $max-lock = Lock.new;
my $MAX      = 10;
my $SCALE    = 1.5;
my $nc       = Terminal::NotCurses::Main.init( :!stop );

my $main     = Terminal::NotCurses::Plane.new(
  Terminal::NotCurses::Main.stdplane
);
my $base     = Terminal::NotCurses::Cell.new(' ');
$base.set_bchannel( Terminal::NotCurses::Channel.new(75, 75, 75) );

class ProgressLine {
  has $!row    is built;
  has $!color  is built;
  has $!text   is built;
  has $!plane;
  has $!bar;
  has $!value;

  submethod TWEAK {
    # Default white
    $!color //= [ 255, 255, 255 ];

    # Create plane and progress bar
    $!plane = $main.create(
      x => 32,
      y => $!row,
      r => 1,
      c => 40
    );
    $!plane.set_base_cell($base);
    my $cl = Terminal::NotCurses::Channel.new( |$!color.rgb );
    #my $cr = Terminal::NotCurses::Channel.new( |$!color.darken(50).rgb );
    #$!bar = Terminal::NotCurses::ProgressBar.new($!plane, $cl, $cr);
    $!bar = Terminal::NotCurses::ProgressBar.new($!plane, $cl);
    $nc.render;
  }

  method set-label ($t is copy) {
    $t = $t.substr(0, 29) ~ '…' if $t.chars > 30;
    $!text = $t;
    # Place label on MAIN (not STD) plane
    $main.putstr-yx($!row, 0, ' ' xx 30);
    $main.putstr-yx($!row, 0, $!text);
    $nc.render;
    self;
  }

  method set-value ($v, :$draw = True) {
    $!value = $v;
    # Update progress bar value
    $!bar.set-value($!value / $MAX);
    $nc.render if $draw;
    self;
  }

  method redraw {
    $!bar.set-value($!bar.value, :!draw);
    $nc.render;
    $nc.refresh;
  }

}


#| Main entry point - parse arguments and display progress bar
multi sub MAIN {
    my $cores   = $*KERNEL.cpu-cores;
    my @rainbow = getHues($cores);
    #my @values  = (25..100).pick($nc);
    my @threads;

    sub check-redraw-threads ($v) {
      $max-lock.protect: {
        if $v > $MAX * 0.8 {
            $MAX *= $SCALE;

            @threads».map( *.head.redraw );
        }
      }
    }

    for @rainbow.kv -> $k, $c {
      my $t = [
        ProgressLine.new(
          color => $c,
          row   => $k
        ),
        Promise.new;
      ];
      $t.head.set-label("My Progress { $k.succ.fmt('%2d') }").set-value(0);
      $t.head.redraw;
      my $dt = DateTime.now;
      $t.push: $*SCHEDULER.cue(
        in    => 2.rand,
        every => 1,
        sub {
          my $v = DateTime.now - $dt;
          check-redraw-threads($v);
          if $v >= 20 {
            $t.tail.cancel,
            $t[1].keep;
          }
          $t.head.set-value($v)
        }
      );
      @threads.push: $t;
    }

    await Promise.allof( @threads.map( *[1] ) );

    $nc.stop;
}
