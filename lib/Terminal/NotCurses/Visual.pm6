use v6;

use NativeCall;

#use Terminal::NotCurses::Raw::Types;
use Terminal::NotCurses::Raw::Definitions;
use Terminal::NotCurses::Raw::Enums;
use Terminal::NotCurses::Raw::Structs;

use Terminal::NotCurses::Raw::Plane;

class Terminal::NotCurses::Visual {
  has ncvisual $!v;

  submethod BUILD ( :visual(:$!v) ) { }

  method Terminal::NotCurses::Raw::Definitions::ncvisual
  { $!p }

  method new (ncvisual $plane) {
    $plane ?? self.bless( :$plane ) !! Nil;
  }

  method ncvisual_from_bgra (
    Pointer $bgra,
    gint    $rows,
    gint    $rowstride,
    gint    $cols
  ) {
    ncvisual_from_bgra($bgra, $rows, $rowstride, $cols);
  }

  method ncvisual_from_file (Str $file) {
    ncvisual_from_file($file);
  }

  method ncvisual_from_palidx (
    Pointer  $data,
    gint     $rows,
    gint     $rowstride,
    gint     $cols,
    gint     $palsize,
    gint     $pstride,
    uint32_t $palette
  ) {
    ncvisual_from_palidx($data, $rows, $rowstride, $cols, $palsize, $pstride, $palette);
  }

  method ncvisual_from_plane (
    ncplane     $n,
    ncblitter_e $blit,
    gint        $begy,
    gint        $begx
  ) {
    ncvisual_from_plane($n, $blit, $begy, $begx);
  }

  method ncvisual_from_rgb_loose (
    Pointer $rgba,
    gint    $rows,
    gint    $rowstride,
    gint    $cols,
    gint    $alpha
  ) {
    ncvisual_from_rgb_loose($rgba, $rows, $rowstride, $cols, $alpha);
  }

  method ncvisual_from_rgb_packed (
    Pointer $rgba,
    gint    $rows,
    gint    $rowstride,
    gint    $cols,
    gint    $alpha
  ) {
    ncvisual_from_rgb_packed($rgba, $rows, $rowstride, $cols, $alpha);
  }

  method ncvisual_from_rgba (
    Pointer $rgba,
    gint    $rows,
    gint    $rowstride,
    gint    $cols
  ) {
    ncvisual_from_rgba($rgba, $rows, $rowstride, $cols);
  }

  method ncvisual_from_sixel (Str $s) {
    ncvisual_from_sixel($s);
  }

  method ncvisual_at_yx (
    ncvisual $n,
    gint     $y,
    gint     $x,
    uint32_t $pixel
  ) {
    ncvisual_at_yx($n, $y, $x, $pixel);
  }

  method ncvisual_blit (
    notcurses        $nc,
    ncvisual         $ncv,
    ncvisual_options $vopts
  ) {
    ncvisual_blit($nc, $ncv, $vopts);
  }

  method ncvisual_decode (ncvisual $nc) {
    ncvisual_decode($nc);
  }

  method ncvisual_decode_loop (ncvisual $nc) {
    ncvisual_decode_loop($nc);
  }

  method ncvisual_destroy (ncvisual $ncv) {
    ncvisual_destroy($ncv);
  }

  method ncvisual_geom (
    notcurses        $nc,
    ncvisual         $n,
    ncvisual_options $vopts,
    ncvgeom          $geom
  ) {
    ncvisual_geom($nc, $n, $vopts, $geom);
  }

  method ncvisual_media_defblitter (
    notcurses $nc,
    ncscale_e $scale
  ) {
    ncvisual_media_defblitter($nc, $scale);
  }

  method ncvisual_polyfill_yx (
    ncvisual $n,
    gint     $y,
    gint     $x,
    uint32_t $rgba
  ) {
    ncvisual_polyfill_yx($n, $y, $x, $rgba);
  }

  method ncvisual_resize (
    ncvisual $n,
    gint     $rows,
    gint     $cols
  ) {
    ncvisual_resize($n, $rows, $cols);
  }

  method ncvisual_resize_noninterpolative (
    ncvisual $n,
    gint     $rows,
    gint     $cols
  ) {
    ncvisual_resize_noninterpolative($n, $rows, $cols);
  }

  method ncvisual_rotate (
    ncvisual $n,
    gdouble  $rads
  ) {
    ncvisual_rotate($n, $rads);
  }

  method ncvisual_set_yx (
    ncvisual $n,
    gint     $y,
    gint     $x,
    uint32_t $pixel
  ) {
    ncvisual_set_yx($n, $y, $x, $pixel);
  }

  method ncvisual_stream (
    notcurses        $nc,
    ncvisual         $ncv,
    gfloat           $timescale,
    ncstreamcb       $streamer,
    ncvisual_options $vopts,
    Pointer          $curry
  ) {
    ncvisual_stream($nc, $ncv, $timescale, $streamer, $vopts, $curry);
  }

  method ncvisual_subtitle_plane (
    ncplane  $parent,
    ncvisual $ncv
  ) {
    ncvisual_subtitle_plane($parent, $ncv);
  }
