use v6;

use NativeCall;

use Terminal::NotCurses::Raw::Definitions;
use Terminal::NotCurses::Raw::Enums;
use Terminal::NotCurses::Raw::Structs;

unit package Terminal::NotCurses::Raw::Cell;

sub nccell_duplicate (
  ncplane $n,
  nccell  $targ,
  nccell  $c
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_extended_gcluster (
  ncplane $n,
  nccell  $c
)
  returns Str
  is      native(&notcurses)
  is      export

{ * }

sub nccell_load (
  ncplane $n,
  nccell  $c,
  Str     $gcluster
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_release (
  ncplane $n,
  nccell  $c
)
  is      native(&notcurses)
  is      export
{ * }

sub nccell_bchannelexport (nccell $cl)
  returns uint32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_bg_alphaexport (nccell $cl)
  returns uint32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_bg_default_pexport (nccell $cl)
  returns bool
  is      native(&notcurses)
  is      export
{ * }

sub nccell_bg_palindex_pexport (nccell $cl)
  returns bool
  is      native(&notcurses)
  is      export
{ * }

sub nccell_bg_palindexexport (nccell $cl)
  returns uint32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_bg_rgb8export (
  nccell $cl,
  int32   $r is rw,
  int32   $g is rw,
  int32   $b is rw
)
  returns uint32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_bg_rgbexport (nccell $cl)
  returns uint32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_channelsexport (nccell $c)
  returns uint64
  is      native(&notcurses)
  is      export
{ * }

sub nccell_colsexport (nccell $c)
  is      native(&notcurses)
  is      export
{ * }

sub nccell_double_wide_pexport (nccell $c)
  returns bool
  is      native(&notcurses)
  is      export
{ * }

sub nccell_extractexport (
  ncplane  $n,
  nccell   $c,
  uint16 $stylemask,
  uint64 $channels
)
  returns Str
  is      native(&notcurses)
  is      export
{ * }

sub nccell_fchannelexport (nccell $cl)
  returns uint32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_fg_alphaexport (nccell $cl)
  returns uint32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_fg_default_pexport (nccell $cl)
  returns bool
  is      native(&notcurses)
  is      export
{ * }

sub nccell_fg_palindex_pexport (nccell $cl)
  returns bool
  is      native(&notcurses)
  is      export
{ * }

sub nccell_fg_palindexexport (nccell $cl)
  returns uint32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_fg_rgb8export (
  nccell $cl,
  int32   $r is rw,
  int32   $g is rw,
  int32   $b is rw
)
  returns uint32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_fg_rgbexport (nccell $cl)
  returns uint32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_initexport (nccell $c)
  is      native(&notcurses)
  is      export
{ * }

sub nccell_load_charexport (
  ncplane $n,
  nccell  $c,
  Str     $ch
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_load_egc32export (
  ncplane  $n,
  nccell   $c,
  uint32 $egc
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_load_ucs32export (
  ncplane  $n,
  nccell   $c,
  uint32 $u
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_off_stylesexport (nccell $c)
  is      native(&notcurses)
  is      export
{ * }

sub nccell_on_stylesexport (nccell $c)
  is      native(&notcurses)
  is      export
{ * }

sub nccell_primeexport (
  ncplane  $n,
  nccell   $c,
  Str      $gcluster,
  uint16 $stylemask,
  uint64 $channels
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_bchannelexport (
  nccell   $c,
  uint32 $channel
)
  returns uint64
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_bg_alphaexport (nccell $c)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_bg_defaultexport (nccell $c)
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_bg_palindexexport (nccell $cl)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_bg_rgb8_clippedexport (
  nccell $cl,
  int32   $r,
  int32   $g,
  int32   $b
)
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_bg_rgb8export (nccell $cl)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_bg_rgbexport (
  nccell   $c,
  uint32 $channel
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_channelsexport (
  nccell   $c,
  uint64 $channels
)
  returns uint64
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_fchannelexport (
  nccell   $c,
  uint32 $channel
)
  returns uint64
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_fg_alphaexport (nccell $c)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_fg_defaultexport (nccell $c)
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_fg_palindexexport (nccell $cl)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_fg_rgb8_clippedexport (
  nccell $cl,
  int32   $r,
  int32   $g,
  int32   $b
)
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_fg_rgb8export (nccell $cl)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_fg_rgbexport (
  nccell   $c,
  uint32 $channel
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_stylesexport (nccell $c)
  is      native(&notcurses)
  is      export
{ * }

sub nccell_strdupexport (
  ncplane $n,
  nccell  $c
)
  returns Str
  is      native(&notcurses)
  is      export
{ * }

sub nccell_stylesexport (nccell $c)
  returns uint16
  is      native(&notcurses)
  is      export
{ * }

sub nccell_wide_left_pexport (nccell $c)
  returns bool
  is      native(&notcurses)
  is      export
{ * }

sub nccell_wide_right_pexport (nccell $c)
  returns bool
  is      native(&notcurses)
  is      export
{ * }

sub nccellcmpexport (
  ncplane $n1,
  nccell  $c1,
  ncplane $n2,
  nccell  $c2
)
  returns bool
  is      native(&notcurses)
  is      export
{ * }
