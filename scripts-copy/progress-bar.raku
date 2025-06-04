#!/usr/bin/env raku
use v6;

use Color;
use Terminal::Print <T>;
use Terminal::Print;
use Terminal::QuickCharts;

sub getHues ($n) {
  my $hues = (0...360).rotor(360 / $n, :partial).map( *.head );

  $hues.map({ Color.new( hsl => ($_, 78, 60) ) }).head($n);
}

my $MAX   = 5;
my $SCALE = 1.5;

my $max-lock    = Lock.new;

class ProgressLine {
  has $!row    is built;
  has $!color  is built;
  has $.text   is built;
  has $!value;

  has $!pb-rendered;
  has $!lb-rendered;

  submethod TWEAK {
    $!color //= 'white';
  }

  method set-label ($t is copy, :$draw = False) {
    $t = '…' ~ $t.substr(* - 29, 29)  if $t.chars > 30;
    $!text = $t;

    $!lb-rendered = (
      ' ' x 30,
      $!text.fmt('%-30s')
    );

    self.draw-label if $draw;
    self;
  }

  method draw-label {
    for $!lb-rendered[] {
      T.print-string(0, $!row, $_) if .defined;
    }
  }

  method set-value ($v, :$draw = False) {
    $!value = $v;

    $!pb-rendered = hbar-chart(
      $!value.Array,
      min       => 0,
      max       => $MAX,
      style     => %(
        max-width => 40
      )
    );

    self.draw-progress-bar if $draw;
    self;
  }

  method draw-progress-bar {
    T.print-string(
      32,
      $!row,
      $!pb-rendered,
      "{ $!color } on_75,75,75"
    );
  }

  method draw {
    $.draw-label;
    $.draw-progress-bar;
  }

}

#| Main entry point - parse arguments and display progress bar
multi sub MAIN {
    my $nc      = $*KERNEL.cpu-cores;
    my @rainbow = getHues($nc);
    #my @values  = (25..100).pick($nc);
    my @threads;

    T.initialize-screen;

    sub check-redraw-threads ($v) {
      if $v > $MAX {
        $max-lock.protect: {
          $MAX *= $SCALE;
          .head.draw-progress-bar for @threads
        }
      }
    }

    for @rainbow.kv -> $k, $c {
      my $t = [
        ProgressLine.new(
          color => $c.rgb.join(','),
          row   => $k
        ),
        Promise.new;
      ];
      $t.head.set-label("My Progress { $k.succ.fmt('%2d') }").set-value(0);
      $t.head.draw;
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
          $t.head.set-value($v, :draw)
        }
      );
      @threads.push: $t;
    }

    await Promise.allof( @threads.map( *[1] ) );

    T.shutdown-screen;
}
