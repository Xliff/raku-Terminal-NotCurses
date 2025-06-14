use v6;

use NativeCall;

use Terminal::NotCurses::Raw::Definitions;
use Terminal::NotCurses::Raw::Enums;
use Terminal::NotCurses::Raw::Structs;

unit package Termninal::NotCurses::Raw::Plane;

sub ncplane_above (ncplane $n)
  returns ncplane
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_abs_x (ncplane $n)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_abs_y (ncplane $n)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_as_rgba (
  ncplane     $n,
  ncblitter_e $blit,
  int32       $begy,
  int32       $begx,
  uint32      $leny,
  uint32      $lenx,
  uint32      $pxdimy is rw,
  uint32      $pxdimx is rw
)
  returns uint32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_ascii_box (
  ncplane $n,
  uint16  $styles,
  uint64  $channels
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_ascii_box_export')
{ * }

sub ncplane_at_cursor (
  ncplane $n,
  uint16  $stylemask,
  uint64  $channels
)
  returns Str
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_at_cursor_cell (
  ncplane $n,
  nccell  $c
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_at_yx (
  ncplane $n,
  int32   $y,
  int32   $x,
  uint16  $stylemask,
  uint64  $channels
)
  returns Str
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_autogrow_p (ncplane $n)
  returns bool
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_base (
  ncplane $n,
  nccell  $c
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_bchannel (ncplane $n)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_bchannel_export')
{ * }

sub ncplane_below (ncplane $n)
  returns ncplane
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_bg_alpha (ncplane $n)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_bg_alpha_export')
{ * }

sub ncplane_bg_default_p (ncplane $n)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_bg_default_p_export')
{ * }

sub ncplane_bg_rgb8 (
  ncplane $n,
  int32    $r is rw,
  int32    $g is rw,
  int32    $b is rw
)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_bg_rgb8_export')
{ * }

sub ncplane_bg_rgb (ncplane $n)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_bg_rgb_export')
{ * }

sub ncplane_box (
  ncplane $n,
  nccell  $ul,
  nccell  $ur,
  nccell  $ll,
  nccell  $lr,
  nccell  $hline,
  nccell  $vline
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_box_sized (
  ncplane $n,
  nccell  $ul,
  nccell  $ur,
  nccell  $ll,
  nccell  $lr,
  nccell  $hline,
  nccell  $vline
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_box_sized_export')
{ * }

sub ncplane_center_abs (
  ncplane $n,
  int32    $y is rw,
  int32    $x is rw
)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_channels (ncplane $n)
  returns uint64
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_contents (
  ncplane $n,
  int32    $begy,
  int32    $begx
)
  returns Str
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_cursor_move_rel (
  ncplane $n,
  int32    $y,
  int32    $x
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_cursor_x (ncplane $n)
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_cursor_x_export')
{ * }

sub ncplane_cursor_y (ncplane $n)
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_cursor_y_export')
{ * }

sub ncplane_cursor_yx (
  ncplane $n,
  int32    $y is rw,
  int32    $x is rw
)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_descendant_p (
  ncplane $n,
  ncplane $ancestor
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_descendant_p_export')
{ * }

sub ncplane_destroy (ncplane $n)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_dim_x (ncplane $n)
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_dim_x_export')
{ * }

sub ncplane_dim_y (ncplane $n)
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_dim_y_export')
{ * }

sub ncplane_dim_yx (
  ncplane $n,
  int32   $y is rw,
  int32   $x is rw
)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_double_box_sized (
  ncplane  $n,
  uint16 $styles,
  uint64 $channels
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_double_box_sized_export')
{ * }

sub ncplane_double_box (
  ncplane  $n,
  uint16 $styles,
  uint64 $channels
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_double_box_export')
{ * }

sub ncplane_dup (
  ncplane $n,
  Pointer $opaque
)
  returns ncplane
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_erase (ncplane $n)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_erase_region (
  ncplane $n,
  int32   $ystart,
  int32   $xstart,
  int32   $ylen,
  int32   $xlen
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_fadein (
  ncplane  $n,
  timespec $ts,
           &fader (notcurses, ncplane, timespec, Pointer --> int32),
  Pointer  $curry
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_fadein_iteration (
  ncplane   $n,
  ncfadectx $nctx,
  int32     $iter,
            &fader (notcurses, ncplane, timespec, Pointer --> int32),
  Pointer   $curry
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_fadeout (
  ncplane  $n,
  timespec $ts,
           &fader (notcurses, ncplane, timespec, Pointer --> int32),
  Pointer  $curry
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_fadeout_iteration (
  ncplane   $n,
  ncfadectx $nctx,
  int32     $iter,
            &fader (notcurses, ncplane, timespec, Pointer --> int32),
  Pointer   $curry
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_fchannel (ncplane $n)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_fchannel_export')
{ * }

sub ncplane_fg_alpha (ncplane $n)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_fg_alpha_export')
{ * }

sub ncplane_fg_default_p (ncplane $n)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_fg_default_p_export')
{ * }

sub ncplane_fg_rgb8 (
  ncplane $n,
  int32    $r is rw,
  int32    $g is rw,
  int32    $b is rw
)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_fg_rgb8_export')
{ * }

sub ncplane_fg_rgb (ncplane $n)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_fg_rgb_export')
{ * }

sub ncplane_format (
  ncplane $n,
  int32   $y,
  int32   $x,
  uint32  $ylen,
  uint32  $xlen,
  uint16  $stylemask
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_gradient (
  ncplane $n,
  int32   $y,
  int32   $x,
  int32   $ylen,
  int32   $xlen,
  Str     $egc,
  uint16  $styles,
  uint64  $ul,
  uint64  $ur,
  uint64  $ll,
  uint64  $lr
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_gradient2x1 (
  ncplane $n,
  int32   $y,
  int32   $x,
  int32   $ylen,
  int32   $xlen,
  uint32  $ul,
  uint32  $ur,
  uint32  $ll,
  uint32  $lr
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_halign (
  ncplane   $n,
  ncalign_e $align,
  int32      $c
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_halign_export')
{ * }

sub ncplane_hline_interp (
  ncplane  $n,
  nccell   $c,
  uint32   $len,
  uint64   $c1,
  uint64   $c2
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_hline (
  ncplane $n,
  nccell  $c
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_hline_export')
{ * }

sub ncplane_mergedown (
  ncplane $src,
  ncplane $dst,
  int32   $begsrcy,
  int32   $begsrcx,
  uint32  $leny,
  uint32  $lenx,
  int32   $dsty,
  int32   $dstx
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_mergedown_simple (ncplane $src, ncplane $dst)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_move_above (
  ncplane $n,
  ncplane $above
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_move_below (
  ncplane $n,
  ncplane $below
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_move_bottom (ncplane $n)
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_move_bottom_export')
{ * }

sub ncplane_move_family_above (
  ncplane $n,
  ncplane $targ
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_move_family_below (
  ncplane $n,
  ncplane $targ
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_move_family_bottom (ncplane $n)
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_move_family_bottom_export')
{ * }

sub ncplane_move_family_top (ncplane $n)
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_move_family_top_export')
{ * }

sub ncplane_move_rel (
  ncplane $n,
  int32    $y,
  int32    $x
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_move_rel_export')
{ * }

sub ncplane_move_top (ncplane $n)
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_move_top_export')
{ * }

sub ncplane_move_yx (
  ncplane $n,
  int32    $y,
  int32    $x
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_name (ncplane $n)
  returns Str
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_notcurses (ncplane $n)
  returns notcurses
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_notcurses_const (ncplane $n)
  returns notcurses
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_off_styles (ncplane $n)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_on_styles (ncplane $n)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_parent (ncplane $n)
  returns ncplane
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_parent_const (ncplane $n)
  returns ncplane
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_perimeter_double (
  ncplane  $n,
  uint16 $stylemask,
  uint64 $channels
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_perimeter_double_export')
{ * }

sub ncplane_perimeter_rounded (
  ncplane  $n,
  uint16 $stylemask,
  uint64 $channels
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_perimeter_rounded_export')
{ * }

sub ncplane_perimeter (
  ncplane $n,
  nccell  $ul,
  nccell  $ur,
  nccell  $ll,
  nccell  $lr,
  nccell  $hline,
  nccell  $vline
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_perimeter_export')
{ * }

sub ncplane_pixel_geom (
  ncplane $n,
  int32   $pxy      is rw,
  int32   $pxx      is rw,
  int32   $celldimy is rw,
  int32   $celldimx is rw,
  int32   $maxbmapy is rw,
  int32   $maxbmapx is rw
)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_polyfill_yx (
  ncplane $n,
  int32   $y,
  int32   $x,
  nccell  $c
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_printf_aligned (
  ncplane   $n,
  int32      $y,
  ncalign_e $align,
  Str       $format
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_printf_aligned_export')
{ * }

sub ncplane_printf_stained (
  ncplane $n,
  Str     $format
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_printf_stained_export')
{ * }

sub ncplane_printf_yx (
  ncplane $n,
  int32    $y,
  int32    $x,
  Str     $format
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_printf_yx_export')
{ * }

sub ncplane_printf (
  ncplane $n,
  Str     $format
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_printf_export')
{ * }

sub ncplane_pulse (
  ncplane  $n,
  timespec $ts,
           &fader (notcurses, ncplane, timespec, Pointer --> int32),
  Pointer  $curry
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_putc_yx (
  ncplane $n,
  int32    $y,
  int32    $x,
  nccell  $c
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_putc (
  ncplane $n,
  nccell  $c
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putc_export')
{ * }

sub ncplane_putchar_stained (
  ncplane $n,
  Str     $c
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_putchar_yx (
  ncplane $n,
  int32    $y,
  int32    $x,
  Str     $c
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putchar_yx_export')
{ * }

sub ncplane_putchar (
  ncplane $n,
  Str     $c
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putchar_export')
{ * }

sub ncplane_putegc_stained (
  ncplane $n,
  Str     $gclust,
  size_t  $sbytes
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_putegc_yx (
  ncplane $n,
  int32    $y,
  int32    $x,
  Str     $gclust,
  size_t  $sbytes
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_putegc (
  ncplane $n,
  Str     $gclust,
  size_t  $sbytes
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putegc_export')
{ * }

sub ncplane_putnstr_aligned (
  ncplane   $n,
  int32      $y,
  ncalign_e $align,
  size_t    $s,
  Str       $str
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_putnstr_yx (
  ncplane $n,
  int32    $y,
  int32    $x,
  size_t  $s,
  Str     $gclusters
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putnstr_yx_export')
{ * }

sub ncplane_putnstr (
  ncplane $n,
  size_t  $s,
  Str     $gclustarr
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putnstr_export')
{ * }

sub ncplane_putstr_aligned (
  ncplane   $n,
  int32      $y,
  ncalign_e $align,
  Str       $s
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putstr_aligned_export')
{ * }

sub ncplane_putstr_stained (
  ncplane $n,
  Str     $gclusters
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putstr_stained_export')
{ * }

sub ncplane_putstr_yx (
  ncplane $n,
  int32    $y,
  int32    $x,
  Str     $gclusters
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putstr_yx_export')
{ * }

sub ncplane_putstr (
  ncplane $n,
  Str     $gclustarr
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putstr_export')
{ * }

sub ncplane_puttext (
  ncplane   $n,
  int32     $y,
  ncalign_e $align,
  Str       $text,
  size_t    $bytes
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_pututf32_yx (
  ncplane  $n,
  int32     $y,
  int32     $x,
  uint32 $u
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_pututf32_yx_export')
{ * }

sub ncplane_putwc_stained (
  ncplane $n,
  wchar_t $w
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putwc_stained_export')
{ * }

sub ncplane_putwc_utf32 (
  ncplane         $n,
  CArray[wchar_t] $w,
  int32           $wchars is rw
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putwc_utf32_export')
{ * }

sub ncplane_putwc_yx (
  ncplane $n,
  int32    $y,
  int32    $x,
  wchar_t $w
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putwc_yx_export')
{ * }

sub ncplane_putwc (
  ncplane $n,
  wchar_t $w
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putwc_export')
{ * }

sub ncplane_putwegc_stained (
  ncplane         $n,
  CArray[wchar_t] $gclust,
  size_t          $sbytes
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_putwegc_yx (
  ncplane         $n,
  int32           $y,
  int32           $x,
  CArray[wchar_t] $gclust,
  size_t          $sbytes
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putwegc_yx_export')
{ * }

sub ncplane_putwegc (
  ncplane         $n,
  CArray[wchar_t] $gclust,
  size_t          $sbytes
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putwegc_export')
{ * }

sub ncplane_putwstr (
  ncplane         $n,
  CArray[wchar_t] $gclustarr
)
  returns int32
  is      native(notcurses-export)
  is      symbol('ncplane_putwstr_export')
  is      export
{ * }

sub ncplane_putwstr_aligned (
  ncplane         $n,
  int32           $y,
  ncalign_e       $align,
  CArray[wchar_t] $gclustarr
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putwstr_aligned_export')
{ * }

sub ncplane_putwstr_stained (
  ncplane         $n,
  CArray[wchar_t] $gclustarr
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_putwstr_yx (
  ncplane         $n,
  int32           $y,
  int32           $x,
  CArray[wchar_t] $gclustarr
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_putwstr_yx_export')
{ * }

sub ncplane_qrcode (
  ncplane $n,
  int32   $ymax is rw,
  int32   $xmax is rw,
  Pointer $data,
  size_t  $len
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_reparent (
  ncplane $n,
  ncplane $newparent
)
  returns ncplane
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_reparent_family (
  ncplane $n,
  ncplane $newparent
)
  returns ncplane
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_resize (
  ncplane  $n,
  int32    $keepy,
  int32    $keepx,
  uint32   $keepleny,
  uint32   $keeplenx,
  uint32   $yoff,
  uint32   $xoff,
  uint32   $ylen,
  uint32   $xlen
)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_resize_simple (ncplane $n)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_resize_simple_export')
{ * }

sub ncplane_rotate_ccw (ncplane $n)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_rotate_cw (ncplane $n)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_rounded_box_sized (
  ncplane $n,
  uint16  $styles,
  uint64  $channels
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_rounded_box_sized_export')
{ * }

sub ncplane_rounded_box (
  ncplane $n,
  uint16  $styles,
  uint64  $channels
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_rounded_box_export')
{ * }

sub ncplane_scrolling_p (ncplane $n)
  returns bool
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_scrollup (
  ncplane $n,
  int32    $r
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_scrollup_child (
  ncplane $n,
  ncplane $child
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_autogrow (ncplane $n)
  returns bool
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_base (
  ncplane  $n,
  Str      $egc,
  uint16 $stylemask,
  uint64 $channels
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_base_cell (
  ncplane $n,
  nccell  $c
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_bchannel (
  ncplane $n,
  uint32  $channel
)
  returns uint64
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_bg_alpha (
  ncplane $n,
  int32   $alpha
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_bg_default (ncplane $n)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_bg_palindex (ncplane $n)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_bg_rgb (
  ncplane $n,
  uint32  $channel
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_bg_rgb8 (ncplane $n)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_bg_rgb8_clipped (
  ncplane $n,
  int32   $r,
  int32   $g,
  int32   $b
)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_channels (
  ncplane $n,
  uint64  $channels
)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_fchannel (
  ncplane $n,
  uint32  $channel
)
  returns uint64
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_fg_alpha (
  ncplane $n,
  int32   $alpha
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_fg_default (ncplane $n)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_fg_palindex (ncplane $n)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_fg_rgb (
  ncplane $n,
  uint32  $channel
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_fg_rgb8 (ncplane $n)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_fg_rgb8_clipped (
  ncplane $n,
  int32   $r,
  int32   $g,
  int32   $b
)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_scrolling (ncplane $n)
  returns bool
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_styles (ncplane $n)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_set_userptr (
  ncplane $n,
  Pointer $opaque
)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_stain (
  ncplane $n,
  int32   $y,
  int32   $x,
  uint32  $ylen,
  uint32  $xlen,
  uint64  $ul,
  uint64  $ur,
  uint64  $ll,
  uint64  $lr
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_styles (ncplane $n)
  returns uint16
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_translate (
  ncplane $src,
  ncplane $dst,
  int32    $y is rw,
  int32    $x is rw
)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_translate_abs (
  ncplane $n,
  int32    $y is rw,
  int32    $x is rw
)
  returns bool
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_userptr (ncplane $n)
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_valign (
  ncplane   $n,
  ncalign_e $align,
  int32     $r
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_valign_export')
{ * }

sub ncplane_vline_interp (
  ncplane $n,
  nccell  $c,
  uint32  $len,
  uint64  $c1,
  uint64  $c2
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_vline (
  ncplane $n,
  nccell  $c
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_vline_export')
{ * }

sub ncplane_vprintf_aligned (
  ncplane   $n,
  int32     $y,
  ncalign_e $align,
  Str       $format,
  Str
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_vprintf_stained (ncplane $n, Str $format, Str)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_vprintf_yx (
  ncplane $n,
  int32   $y,
  int32   $x,
  Str     $format,
  Str
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_vprintf (
  ncplane $n,
  Str     $format,
  Str
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncplane_vprintf_export')
{ * }

sub ncplane_x (ncplane $n)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_y (ncplane $n)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncplane_yx (
  ncplane $n,
  int32    $y is rw,
  int32    $x is rw
)
  is      native(&notcurses)
  is      export
{ * }
