use v6;

use NativeCall;

use Terminal::NotCurses::Raw::Definitions;
use Terminal::NotCurses::Raw::Enums;
use Terminal::NotCurses::Raw::Structs;

unit package Terminal::NotCurses::Raw::Cell;

sub nccell_bchannel (nccell $cl)
  returns uint32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_bchannel_export')
{ * }

sub nccell_bg_alpha (nccell $cl)
  returns uint32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_bg_alpha_export')
{ * }

sub nccell_bg_default_p (nccell $cl)
  returns bool
  is      native(&notcurses)
  is      export
  is      symbol('nccell_bg_default_p_export')
{ * }

sub nccell_bg_palindex_p (nccell $cl)
  returns bool
  is      native(&notcurses)
  is      export
  is      symbol('nccell_bg_palindex_p_export')
{ * }

sub nccell_bg_palindex (nccell $cl)
  returns uint32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_bg_palindex_export')
{ * }

sub nccell_bg_rgb8 (
  nccell $cl,
  int32   $r is rw,
  int32   $g is rw,
  int32   $b is rw
)
  returns uint32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_bg_rgb8_export')
{ * }

sub nccell_bg_rgb (nccell $cl)
  returns uint32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_bg_rgb_export')
{ * }

sub nccell_channels (nccell $c)
  returns uint64
  is      native(&notcurses)
  is      export
  is      symbol('nccell_channels_export')
{ * }

sub nccell_cols (nccell $c)
  is      native(&notcurses)
  is      export
  is      symbol('nccell_cols_export')
{ * }

sub nccell_double_wide_p (nccell $c)
  returns bool
  is      native(&notcurses)
  is      export
  is      symbol('nccell_double_wide_p_export')
{ * }

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

sub nccell_extract (
  ncplane  $n,
  nccell   $c,
  uint16   $stylemask is rw,
  uint64   $channels  is rw
)
  returns Str
  is      native(&notcurses)
  is      export
  is      symbol('nccell_extract_export')
{ * }

sub nccell_fchannel (nccell $cl)
  returns uint32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_fchannel_export')
{ * }

sub nccell_fg_alpha (nccell $cl)
  returns uint32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_fg_alpha_export')
{ * }

sub nccell_fg_default_p (nccell $cl)
  returns bool
  is      native(&notcurses)
  is      export
  is      symbol('nccell_fg_default_p_export')
{ * }

sub nccell_fg_palindex_p (nccell $cl)
  returns bool
  is      native(&notcurses)
  is      export
  is      symbol('nccell_fg_palindex_p_export')
{ * }

sub nccell_fg_palindex (nccell $cl)
  returns uint32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_fg_palindex_export')
{ * }

sub nccell_fg_rgb8 (
  nccell $cl,
  int32   $r is rw,
  int32   $g is rw,
  int32   $b is rw
)
  returns uint32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_fg_rgb8_export')
{ * }

sub nccell_fg_rgb (nccell $cl)
  returns uint32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_fg_rgb_export')
{ * }

sub nccell_init (nccell $c)
  is      native(&notcurses)
  is      export
  is      symbol('nccell_init_export')
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

sub nccell_load_char (
  ncplane $n,
  nccell  $c,
  Str     $ch
)
  returns int32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_load_char_export')
{ * }

sub nccell_load_egc32 (
  ncplane  $n,
  nccell   $c,
  uint32 $egc
)
  returns int32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_load_egc32_export')
{ * }

sub nccell_load_ucs32 (
  ncplane  $n,
  nccell   $c,
  uint32 $u
)
  returns int32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_load_ucs32_export')
{ * }

sub nccell_off_styles (nccell $c)
  is      native(&notcurses)
  is      export
  is      symbol('nccell_off_styles_export')
{ * }

sub nccell_on_styles (nccell $c)
  is      native(&notcurses)
  is      export
  is      symbol('nccell_on_styles_export')
{ * }

sub nccell_prime (
  ncplane  $n,
  nccell   $c,
  Str      $gcluster,
  uint16 $stylemask,
  uint64 $channels
)
  returns int32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_prime_export')
{ * }

sub nccell_release (
  ncplane $n,
  nccell  $c
)
  is      native(&notcurses)
  is      export
{ * }

sub nccell_set_bchannel (
  nccell   $c,
  uint32 $channel
)
  returns uint64
  is      native(&notcurses)
  is      export
  is      symbol('nccell_set_bchannel_export')
{ * }

sub nccell_set_bg_alpha (nccell $c)
  returns int32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_set_bg_alpha_export')
{ * }

sub nccell_set_bg_default (nccell $c)
  is      native(&notcurses)
  is      export
  is      symbol('nccell_set_bg_default_export')
{ * }

sub nccell_set_bg_palindex (nccell $cl)
  returns int32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_set_bg_palindex_export')
{ * }

sub nccell_set_bg_rgb8_clipped (
  nccell $cl,
  int32   $r,
  int32   $g,
  int32   $b
)
  is      native(&notcurses)
  is      export
  is      symbol('nccell_set_bg_rgb8_clipped_export')
{ * }

sub nccell_set_bg_rgb8 (nccell $cl)
  returns int32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_set_bg_rgb8_export')
{ * }

sub nccell_set_bg_rgb (
  nccell   $c,
  uint32 $channel
)
  returns int32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_set_bg_rgb_export')
{ * }

sub nccell_set_channels (
  nccell   $c,
  uint64 $channels
)
  returns uint64
  is      native(&notcurses)
  is      export
  is      symbol('nccell_set_channels_export')
{ * }

sub nccell_set_fchannel (
  nccell   $c,
  uint32 $channel
)
  returns uint64
  is      native(&notcurses)
  is      export
  is      symbol('nccell_set_fchannel_export')
{ * }

sub nccell_set_fg_alpha (nccell $c)
  returns int32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_set_fg_alpha_export')
{ * }

sub nccell_set_fg_default (nccell $c)
  is      native(&notcurses)
  is      export
  is      symbol('nccell_set_fg_default_export')
{ * }

sub nccell_set_fg_palindex (nccell $cl)
  returns int32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_set_fg_palindex_export')
{ * }

sub nccell_set_fg_rgb8_clipped (
  nccell $cl,
  int32   $r,
  int32   $g,
  int32   $b
)
  is      native(&notcurses)
  is      export
  is      symbol('nccell_set_fg_rgb8_clipped_export')
{ * }

sub nccell_set_fg_rgb8 (nccell $cl)
  returns int32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_set_fg_rgb8_export')
{ * }

sub nccell_set_fg_rgb (
  nccell   $c,
  uint32 $channel
)
  returns int32
  is      native(&notcurses)
  is      export
  is      symbol('nccell_set_fg_rgb_export')
{ * }

sub nccell_set_styles (nccell $c)
  is      native(&notcurses)
  is      export
  is      symbol('nccell_set_styles_export')
{ * }

sub nccell_strdup (
  ncplane $n,
  nccell  $c
)
  returns Str
  is      native(&notcurses)
  is      export
  is      symbol('nccell_strdup_export')
{ * }

sub nccell_styles (nccell $c)
  returns uint16
  is      native(&notcurses)
  is      export
  is      symbol('nccell_styles_export')
{ * }

sub nccell_wide_left_p (nccell $c)
  returns bool
  is      native(&notcurses)
  is      export
  is      symbol('nccell_wide_left_p_export')
{ * }

sub nccell_wide_right_p (nccell $c)
  returns bool
  is      native(&notcurses)
  is      export
  is      symbol('nccell_wide_right_p_export')
{ * }

sub nccellcmp (
  ncplane $n1,
  nccell  $c1,
  ncplane $n2,
  nccell  $c2
)
  returns bool
  is      native(&notcurses)
  is      export
  is      symbol('nccellcmp_export')
{ * }
