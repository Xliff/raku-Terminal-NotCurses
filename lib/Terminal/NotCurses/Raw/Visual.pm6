use v6;

use NativeCall;

use Terminal::NotCurses::Raw::Definitions;
use Terminal::NotCurses::Raw::Enums;
use Terminal::NotCurses::Raw::Structs;

unit package Termninal::NotCurses::Raw::Plane;

sub ncvisual_at_yx (
  ncvisual $n,
  int32    $y,
  int32    $x,
  uint32   $pixel
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_blit (
  notcurses        $nc,
  ncvisual         $ncv,
  ncvisual_options $vopts
)
  returns ncplane
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_decode (ncvisual $nc)
  returns  int32
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_decode_loop (ncvisual $nc)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_destroy (ncvisual $ncv)
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_from_bgra (
  Pointer $bgra,
  int32   $rows,
  int32   $rowstride,
  int32   $cols
)
  returns ncvisual
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_from_file (Str $file)
  returns ncvisual
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_from_palidx (
  Pointer  $data,
  int32    $rows,
  int32    $rowstride,
  int32    $cols,
  int32    $palsize,
  int32    $pstride,
  uint32   $palette
)
  returns ncvisual
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_from_plane (
  ncplane     $n,
  ncblitter_e $blit,
  int32       $begy,
  int32       $begx
)
  returns ncvisual
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_from_rgb_loose (
  Pointer $rgba,
  int32   $rows,
  int32   $rowstride,
  int32   $cols,
  int32   $alpha
)
  returns ncvisual
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_from_rgb_packed (
  Pointer $rgba,
  int32   $rows,
  int32   $rowstride,
  int32   $cols,
  int32   $alpha
)
  returns ncvisual
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_from_rgba (
  Pointer $rgba,
  int32   $rows,
  int32   $rowstride,
  int32   $cols
)
  returns ncvisual
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_from_sixel (Str $s)
  returns ncvisual
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_geom (
  notcurses        $nc,
  ncvisual         $n,
  ncvisual_options $vopts,
  ncvgeom          $geom
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_media_defblitter (
  notcurses $nc,
  ncscale_e $scale
)
  returns ncblitter_e
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_polyfill_yx (
  ncvisual $n,
  int32    $y,
  int32    $x,
  int32    $rgba
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_resize (
  ncvisual $n,
  int32    $rows,
  int32    $cols
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_resize_noninterpolative (
  ncvisual $n,
  int32    $rows,
  int32    $cols
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_rotate (
  ncvisual $n,
  num64    $rads
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_set_yx (
  ncvisual $n,
  int32    $y,
  int32    $x,
  uint32   $pixel
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_stream (
  notcurses        $nc,
  ncvisual         $ncv,
  num32            $timescale,
                   &streamer (
                     ncvisual,
                     ncvisual_options,
                     timespec,
                     Pointer --> int32
                   ),
  ncvisual_options $vopts,
  Pointer          $curry
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncvisual_subtitle_plane (
  ncplane  $parent,
  ncvisual $ncv
)
  returns ncplane
  is      native(&notcurses)
  is      export
{ * }
