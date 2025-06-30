use v6.c;

use NativeCall;

use Terminal::NotCurses::Raw::Definitions;
use Terminal::NotCurses::Raw::Enums;

unit package Terminal::NotCurses::Raw::Subs;

sub ncstrwidth_c (Str, int32 $validbytes is rw, int32 $validwidth is rw)
  returns int32
  is      export
  is      native(&notcurses)
  is      symbol('ncstrwidth')
{ * }

proto sub ncstrwidth ( |c )
  is export
{ * }

multi sub ncstrwidth (Str() $egcs, :$all = False) {
  samewith($egcs, $, $, :$all);
}
multi sub ncstrwidth (Str() $egcs, $vb is rw, $vw is rw, :$all = False) {
  my int32 ($b, $w) = 0 xx 2;

  my $rv = ncstrwidth_c($egcs, $b, $w);
  ($vb, $vw) = ($b, $w);
  return $rv unless $all;
  ($rv, $vb, $vw);
}
