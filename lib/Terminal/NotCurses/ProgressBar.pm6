use v6;

use NativeCall;
use Method::Also;

use Terminal::NotCurses::Raw::Types;

use Proto::Roles::Implementor;

class Terminal::NotCurses::ProgressBar {
  also does Proto::Roles::Implementor;

  has $!pb is implementor;

  submethod BUILD ( :$progress-bar ) {
    $!pb = $progress-bar if $progress-bar;
  }

  method Terminal::NotCurses::Raw::Definitions::ncprogbar
    is also<ncprogbar>
  { $!pb }

  multi method new (ncprogbar $progress-bar) {
    $progress-bar ?? self.bless( :$progress-bar ) !! Nil;
  }
  multi method new (
    ncplane()  $plane,
    Int()      $color,
              :r(:rev(:$reverse)) = False
  ) {
    my $no = ncprogbar_options.new(
      ulchannel => $color,
      urchannel => $color,
      blchannel => $color,
      brchannel => $color,
      flags     => ($reverse ?? NCPROGBAR_OPTION_RETROGRADE !! 0)
    );
    self.create($plane, $no);
  }
  multi method new (
    ncplane()  $plane,
    Int()      $left-color,
    Int()      $right-color,
              :r(:rev(:$reverse)) = False
  ) {
    my $no = ncprogbar_options.new(
      ulchannel => $right-color,
      urchannel => $right-color,
      blchannel => $left-color,
      brchannel => $left-color,
      flags     => $reverse ?? NCPROGBAR_OPTION_RETROGRADE !! 0
    );
    self.create($plane, $no);
  }

  method create (ncplane() $n, ncprogbar_options() $opts) {
    my $progress-bar = ncprogbar_create($n, $opts);

    $progress-bar ?? self.bless( :$progress-bar ) !! Nil;
  }

  method destroy {
    ncprogbar_destroy($!pb);
  }

  method plane ( :$raw = False ) {
    propReturnObject(
      ncprogbar_plane($!pb),
      $raw,
      Terminal::NotCurses::Plane.getTypePair
    );
  }

  method progress is rw is also<value> {
    Proxy.new:
      FETCH => -> $     { $.get_progress    },
      STORE => -> $, \v { $.set_progress(v) }
  }

  method get_progress
    is also<
      get-progress
      get_value
      get-value
    >
  {
    ncprogbar_progress($!pb);
  }

  method set_progress (Num() $p)
    is also<
      set-progress
      set_value
      set-value
    >
  {
    my num64 $pp = $p;

    ncprogbar_set_progress($!pb, $pp);
  }
}

sub ncprogbar_create (ncplane $n, ncprogbar_options $opts)
  returns ncprogbar
  is      native(&notcurses)
  is      export
{ * }

sub ncprogbar_destroy (ncprogbar $n)
  is      native(&notcurses)
  is      export
{ * }

sub ncprogbar_plane (ncprogbar $n)
  returns ncplane
  is      native(&notcurses)
  is      export
{ * }

sub ncprogbar_progress (ncprogbar $n)
  returns num64
  is      native(&notcurses)
  is      export
{ * }

sub ncprogbar_set_progress (ncprogbar $n, num64 $p)
  returns int32
  is      native(&notcurses)
  is      export
{ * }
