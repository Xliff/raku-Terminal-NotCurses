use v6.c;

use NativeCall;

use Terminal::NotCurses::Raw::Orig;
use Terminal::NotCurses::Raw::Enums;
use Terminal::NotCurses::Raw::Structs;

class Terminal::NotCurses::Main {

  method init (
    :$term       = Str,
    :$log        = 0,
    :top(:$t)    = 0,
    :right(:$r)  = 0,
    :bottom(:$b) = 0,
    :left(:$l)   = 0,
    :$flags      = [+|](
      NCOPTION_SUPPRESS_BANNERS,
      NCOPTION_NO_ALTERNATE_SCREEN,
      NCOPTION_DRAIN_INPUT
    )
  ) {
    my $o = notcurses_options.new(
      :$term,
      :$log,
      :$t,
      :$r,
      :$b,
      :$l,
      :$flags
    );

    notcurses_core_init($o, Pointer);
  }

}
