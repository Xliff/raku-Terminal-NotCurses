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
# sub nccells_ascii_boxexport (
#   ncplane  $n,
#   uint16_t $attr,
#   uint64_t $channels,
#   nccell   $ul,
#   nccell   $ur,
#   nccell   $ll,
#   nccell   $lr,
#   nccell   $hl,
#   nccell   $vl
# )
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub nccells_double_boxexport (
#   ncplane  $n,
#   uint16_t $attr,
#   uint64_t $channels,
#   nccell   $ul,
#   nccell   $ur,
#   nccell   $ll,
#   nccell   $lr,
#   nccell   $hl,
#   nccell   $vl
# )
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub nccells_heavy_boxexport (
#   ncplane  $n,
#   uint16_t $attr,
#   uint64_t $channels,
#   nccell   $ul,
#   nccell   $ur,
#   nccell   $ll,
#   nccell   $lr,
#   nccell   $hl,
#   nccell   $vl
# )
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub nccells_light_boxexport (
#   ncplane  $n,
#   uint16_t $attr,
#   uint64_t $channels,
#   nccell   $ul,
#   nccell   $ur,
#   nccell   $ll,
#   nccell   $lr,
#   nccell   $hl,
#   nccell   $vl
# )
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub nccells_load_boxexport (
#   ncplane  $n,
#   uint16_t $styles,
#   uint64_t $channels,
#   nccell   $ul,
#   nccell   $ur,
#   nccell   $ll,
#   nccell   $lr,
#   nccell   $hl,
#   nccell   $vl,
#   Str      $gclusters
# )
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub nccells_rounded_boxexport (
#   ncplane  $n,
#   uint16_t $attr,
#   uint64_t $channels,
#   nccell   $ul,
#   nccell   $ur,
#   nccell   $ll,
#   nccell   $lr,
#   nccell   $hl,
#   nccell   $vl
# )
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannel_alphaexport (uint32_t $channel)
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannel_bexport (uint32_t $channel)
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannel_default_pexport (uint32_t $channel)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannel_gexport (uint32_t $channel)
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannel_palindex_pexport (uint32_t $channel)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannel_palindexexport (uint32_t $channel)
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannel_rexport (uint32_t $channel)
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannel_rgb8export (
#   uint32_t $channel,
#   gint     $r is rw,
#   gint     $g is rw,
#   gint     $b is rw
# )
#   returns uint32_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannel_rgb_pexport (uint32_t $channel)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannel_rgbexport (uint32_t $channel)
#   returns uint32_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannel_set_alphaexport (uint32_t $channel)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannel_set_defaultexport (uint32_t $channel)
#   returns uint32_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannel_set_palindexexport (uint32_t $channel)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannel_set_rgb8_clippedexport (
#   uint32_t $channel,
#   gint     $r,
#   gint     $g,
#   gint     $b
# )
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannel_set_rgb8export (uint32_t $channel)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannel_setexport (
#   uint32_t $channel,
#   uint32_t $rgb
# )
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_bchannelexport (uint64_t $channels)
#   returns uint32_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_bg_alphaexport (uint64_t $channels)
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_bg_default_pexport (uint64_t $channels)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_bg_palindex_pexport (uint64_t $channels)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_bg_palindexexport (uint64_t $channels)
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_bg_rgb8export (
#   uint64_t $channels,
#   gint     $r is rw,
#   gint     $g is rw,
#   gint     $b is rw
# )
#   returns uint32_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_bg_rgb_pexport (uint64_t $channels)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_bg_rgbexport (uint64_t $channels)
#   returns uint32_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_channelsexport (uint64_t $channels)
#   returns uint64_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_combineexport (
#   uint32_t $fchan,
#   uint32_t $bchan
# )
#   returns uint64_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_fchannelexport (uint64_t $channels)
#   returns uint32_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_fg_alphaexport (uint64_t $channels)
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_fg_default_pexport (uint64_t $channels)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_fg_palindex_pexport (uint64_t $channels)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_fg_palindexexport (uint64_t $channels)
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_fg_rgb8export (
#   uint64_t $channels,
#   gint     $r is rw,
#   gint     $g is rw,
#   gint     $b is rw
# )
#   returns uint32_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_fg_rgb_pexport (uint64_t $channels)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_fg_rgbexport (uint64_t $channels)
#   returns uint32_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_reverseexport (uint64_t $channels)
#   returns uint64_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_set_bchannelexport (
#   uint64_t $channels,
#   uint32_t $channel
# )
#   returns uint64_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_set_bg_alphaexport (uint64_t $channels)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_set_bg_defaultexport (uint64_t $channels)
#   returns uint64_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_set_bg_palindexexport (uint64_t $channels)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_set_bg_rgb8_clippedexport (
#   uint64_t $channels,
#   gint     $r,
#   gint     $g,
#   gint     $b
# )
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_set_bg_rgb8export (uint64_t $channels)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_set_bg_rgbexport (uint64_t $channels)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_set_channelsexport (
#   uint64_t $dst,
#   uint64_t $channels
# )
#   returns uint64_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_set_fchannelexport (
#   uint64_t $channels,
#   uint32_t $channel
# )
#   returns uint64_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_set_fg_alphaexport (uint64_t $channels)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_set_fg_defaultexport (uint64_t $channels)
#   returns uint64_t
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_set_fg_palindexexport (uint64_t $channels)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_set_fg_rgb8_clippedexport (
#   uint64_t $channels,
#   gint     $r,
#   gint     $g,
#   gint     $b
# )
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_set_fg_rgb8export (uint64_t $channels)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncchannels_set_fg_rgbexport (uint64_t $channels)
#   returns gint
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncinput_alt_pexport (ncinput $n)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncinput_capslock_pexport (ncinput $n)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncinput_ctrl_pexport (ncinput $n)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncinput_equal_pexport (
#   ncinput $n1,
#   ncinput $n2
# )
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncinput_hyper_pexport (ncinput $n)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncinput_meta_pexport (ncinput $n)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncinput_nomod_pexport (ncinput $ni)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncinput_numlock_pexport (ncinput $n)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncinput_shift_pexport (ncinput $n)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
#
# sub ncinput_super_pexport (ncinput $n)
#   returns bool
#   is      native(&notcurses)
#   is      export
# { * }
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
