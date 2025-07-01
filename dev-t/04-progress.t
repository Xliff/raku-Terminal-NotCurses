#!/usr/bin/env raku

#| A command-line program to display a customizable, colorful progress bar
#| Usage: raku progress-bar.raku <percentage>
#| Example: raku progress-bar.raku 75

use v6;

use Color;
use Terminal::NotCurses::Channel;
use Terminal::NotCurses::Main;
use Terminal::NotCurses::Plane;
use Terminal::NotCurses::ProgressBar;

sub getHues ($n) {
  my $hues = (0...360).rotor(360 / $n, :partial).map( *.head );

  $hues.map({ Color.new( hsl => ($_, 78, 60) ) });
}

my $MAX     = 10;
my $nc      = Terminal::NotCurses::Main.init( :!stop );
my $main    = Terminal::NotCurses::Plane.new(
  Terminal::NotCurses::Main.stdplane
);

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
    $!plane.set_bg_rgb( Terminal::NotCurses::Channel.new(75, 75, 75) );
    my $c = Terminal::NotCurses::Channel.new( |$!color );
    $*ERR.say: $c.Int;
    $!bar = Terminal::NotCurses::ProgressBar.new(
      $!plane,
      $c
    );
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

  method set-value ($v) {
    $!value = $v / $MAX;
    # Update progress bar value
    $!bar.set-value($!value);
    $nc.render;
    self;
  }

}

#| Main entry point - parse arguments and display progress bar
multi sub MAIN {
    my $cores   = $*KERNEL.cpu-cores;
    my @rainbow = getHues($cores);
    my @values  = (2.5..10).roll($cores);

    #try {
      #CATCH { default { } }

      my $k = 1;
      for @rainbow Z @values -> ($c, $v) {
        my $p = ProgressLine.new(
          color => $c.rgb,
          row   => $k
        );
        unless $p {
          $nc.stop;
          die "Could not create ProgressLine!";
        }

        $p.set-label("My Progress { $k++ }");
        $p.set-value($v);
      }

      sleep 4;
    #}

    $nc.stop;

  END {
    @rainbow.say;
    @values.say;
  }
}
