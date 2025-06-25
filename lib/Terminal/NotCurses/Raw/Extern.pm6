use NativeCall;

use Terminal::NotCurses::Raw::Definitions;
use Terminal::NotCurses::Raw::Structs;

unit package Terminal::NotCurses::Raw::Extern;

#
#
# ### /home/cbwood/Projects/raku-Terminal-Notcurses/notcurses-extern.h
#
# sub ncbprefixexport (
#   uintmax_t $val,
#   uintmax_t $decimal,
#   Str       $buf,
#   gint      $omitdec
# )
#   returns Str
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub nccapability_canchangecolorexport (nccapabilities $caps)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
#
#

#

#
# sub nciprefixexport (
#   uintmax_t $val,
#   uintmax_t $decimal,
#   Str       $buf,
#   gint      $omitdec
# )
#   returns Str
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub nckey_mouse_pexport (uint32_t $r)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncpalette_get_rgb8export (
#   ncpalette $p,
#   gint      $idx,
#   gint      $r is rw,
#   gint      $g is rw,
#   gint      $b is rw
# )
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncpalette_getexport (
#   ncpalette $p,
#   gint      $idx,
#   uint32_t  $palent
# )
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncpalette_set_rgb8export (
#   ncpalette $p,
#   gint      $idx
# )
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncpalette_setexport (
#   ncpalette $p,
#   gint      $idx
# )
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncpixel_aexport (uint32_t $pixel)
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncpixel_bexport (uint32_t $pixel)
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncpixel_gexport (uint32_t $pixel)
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncpixel_rexport (uint32_t $pixel)
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncpixel_set_aexport (uint32_t $pixel)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncpixel_set_bexport (uint32_t $pixel)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncpixel_set_gexport (uint32_t $pixel)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncpixel_set_rexport (uint32_t $pixel)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncpixel_set_rgb8export (uint32_t $pixel)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncpixelexport
#   returns uint32_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncqprefixexport (
#   uintmax_t $val,
#   uintmax_t $decimal,
#   Str       $buf,
#   gint      $omitdec
# )
#   returns Str
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub nctabbed_hdrchanexport (nctabbed $nt)
#   returns uint64_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub nctabbed_selchanexport (nctabbed $nt)
#   returns uint64_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub nctabbed_sepchanexport (nctabbed $nt)
#   returns uint64_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncvisualplane_createexport (
#   notcurses        $nc,
#   ncplane_options  $opts,
#   ncvisual         $ncv,
#   ncvisual_options $vopts
# )
#   returns ncplane
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncwcsrtombsexport (wchar_t $src)
#   returns Str
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_alignexport (
#   gint      $availu,
#   ncalign_e $align,
#   gint      $u
# )
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_bottomexport (&notcurses $n)
#   returns ncplane
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_canbrailleexport (&notcurses $nc)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_canchangecolorexport (&notcurses $nc)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_canfadeexport (&notcurses $n)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_canhalfblockexport (&notcurses $nc)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_canpixelexport (&notcurses $nc)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_canquadrantexport (&notcurses $nc)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_cansextantexport (&notcurses $nc)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_cantruecolorexport (&notcurses $nc)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_canutf8export (&notcurses $nc)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_get_blockingexport (
#   notcurses $n,
#   ncinput   $ni
# )
#   returns uint32_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_get_nblockexport (
#   notcurses $n,
#   ncinput   $ni
# )
#   returns uint32_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_mice_disableexport (notcurses $n)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }

sub notcurses_render (notcurses $nc)
  returns int32
  is      native(notcurses-export)
  is      symbol('notcurses_render_export')
  is      export
{ * }

sub ncplane_options_create
  returns ncplane_options
  is      native(notcurses-export)
  is      export
{ * }

# sub notcurses_stddim_yx_constexport (
#   notcurses $nc,
#   gint      $y is rw,
#   gint      $x is rw
# )
#   returns ncplane
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_stddim_yxexport (
#   notcurses $nc,
#   gint      $y is rw,
#   gint      $x is rw
# )
#   returns ncplane
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_term_dim_yxexport (
#   notcurses $n,
#   gint      $rows is rw,
#   gint      $cols is rw
# )
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub notcurses_topexport (&notcurses $n)
#   returns ncplane
#   is      native(&notcurses)
#   is      export
# { * }
