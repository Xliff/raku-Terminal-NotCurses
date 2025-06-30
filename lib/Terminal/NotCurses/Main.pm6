use v6.c;

use NativeCall;

use Terminal::NotCurses::Raw::Types;
use Terminal::NotCurses::Raw::Orig;
use Terminal::NotCurses::Raw::Extern;

use Terminal::NotCurses::Plane;

class Terminal::NotCurses::Main {
  my $NC;

  method Terminal::NotCurses::Raw::Definition::notcurses
  { $NC }

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
    ),
    :$stop       = True
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

    $NC = notcurses_core_init($o, Pointer);
    if $stop {
      END { ::?CLASS.stop }
    }

    self.bless;
  }

  multi method dim_yx {
    samewith($, $);
  }
  multi method dim_yx ($rows is rw, $cols is rw) {
    my int32 ($r, $c) = 0 xx 2;

    notcurses_term_dim_yx($NC, $r, $c);
    ($rows = $r, $cols = $c);
  }

  method stop {
    notcurses_stop($NC)
  }

  method stdplane ( :$raw = False ) {
    propReturnObject(
      notcurses_stdplane($NC),
      $raw,
      |Terminal::NotCurses::Plane.getTypePair
    );
  }

  method render {
    notcurses_render($NC);
  }

}
