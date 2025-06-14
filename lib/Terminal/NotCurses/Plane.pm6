use v6;

use NativeCall;

use Terminal::NotCurses::Raw::Types;
use Terminal::NotCurses::Raw::Plane;

class Terminal::NotCurses::Plane {
  has ncplane $!p;

  submethod BUILD ( :plane(:$!p) ) { }

  method Terminal::NotCurses::Raw::Definitions::ncplane
  { $!p }

  method new (ncplane $plane) {
    $plane ?? self.bless( :$plane ) !! Nil;
  }

  method above {
    ncplane_above($!p);
  }

  method abs_x {
    ncplane_abs_x($!p);
  }

  method abs_y {
    ncplane_abs_y($!p);
  }

  proto method as_rgba (|)
  { * }

  multi method as_rgba (
    Int() $blit,
    Int() $begy,
    Int() $begx,
    Int() $leny,
    Int() $lenx,
  ) {
    samewith($blit, $begy, $begx, $leny, $lenx, $, $);
  }
  multi method as_rgba (
    Int() $blit,
    Int() $begy,
    Int() $begx,
    Int() $leny,
    Int() $lenx,
          $pxdimy is rw,
          $pxdimx is rw
  ) {
    my ncblitter_e   $b        = $blit;
    my int32        ($y,  $x ) = ($begy, $begx);
    my uint32       ($py, $px) = (0, 0);

    my $r = ncplane_as_rgba($!p, $b, $begy, $begx, $py, $px);
    return Nil unless $r;
    ($pxdimy, $pxdimx) = ($py, $px);
  }

  proto method ascii_box (|)
  { * }

  multi method ascii_box (Int() $channels, :mask(:$style) = 0) {
    my uint16 $s = newCArray(uint16, $style);
    my uint64 $c = newCArray(uint64, $channels);

    samewith($s, $c);
  }
  multi method ascii_box (CArray[uint16] $s, CArray[uint64] $c) {
    ncplane_ascii_box($!p, $s, $c);
  }

  proto method at_cursor (|)
  { * }

  multi method at_cursor (Int() $channels, :mask(:$style) = 0) {
    my uint16 $s = newCArray(uint16, $style);
    my uint64 $c = newCArray(uint64, $channels);

    samewith($s, $c);
  }
  multi method at_cursor (CArray[uint16] $s, CArray[uint64] $c) {
    ncplane_at_cursor($s, $c);
  }

  method at_cursor_cell (nccell() $c) {
    ncplane_at_cursor_cell($!p, $c);
  }

  proto method at_yx (|)
  { * }

  multi method at_yx ($y, $x, $c, :mask(:$style) = 0) {
    samewith($y, $x, $style, $c);
  }
  multi method at_yx (
    Int()          $y,
    Int()          $x,
    CArray[uint16] $stylemask,
    CArray[uint64] $channels
  ) {
    my int32 ($yy, $xx) = ($y, $x);

    ncplane_at_yx($!p, $yy, $xx, $stylemask, $channels);
  }

  method autogrow_p {
    ncplane_autogrow_p($!p);
  }

  method base (nccell() $c) {
    ncplane_base($!p, $c);
  }

  method bchannel  {
    ncplane_bchannel($!p);
  }

  method below {
    ncplane_below($!p);
  }

  method bg_alpha {
    ncplane_bg_alpha($!p);
  }

  method bg_default_p {
    ncplane_bg_default_p($!p);
  }

  proto method bg_rgb8 (|)
  { * }

  multi method bg_rgb8 {
    samewith($, $, $);
  }
  multi method bg_rgb8 ($r is rw, $g is rw, $b is rw) {
    my int32 ($rr, $gg, $bb) = 0 xx 3;

    my $r = ncplane_bg_rgb8($!p, $rr, $gg, $bb);
    return Nil unless $r;
    ($r, $g, $b) = ($rr, $gg, $bb);
  }
  multi method bg_rgb {
    ncplane_bg_rgb($!p);
  }

  method box (
    nccell() $ul,
    nccell() $ur,
    nccell() $ll,
    nccell() $lr,
    nccell() $hline,
    nccell() $vline
  ) {
    ncplane_box($!p, $ul, $ur, $ll, $lr, $hline, $vline);
  }

  method box_sized (
    nccell() $ul,
    nccell() $ur,
    nccell() $ll,
    nccell() $lr,
    nccell() $hline,
    nccell() $vline
  ) {
    ncplane_box_sized($!p, $ul, $ur, $ll, $lr, $hline, $vline);
  }

  proto method center_abs (|)
  { * }

  multi method center_abs {
    samewith($, $);
  }
  multi method center_abs ($y is rw, $x is rw) {
    my int32 ($yy, $xx) = (0, 0);

    ncplane_center_abs($!p, $yy, $xx);
    ($y, $x) = ($yy, $xx);
  }

  method channels {
    ncplane_channels($!p);
  }

  method contents (Int() $begy, Int() $begx) {
    my int32 ($y, $x) = ($begy, $begx);

    ncplane_contents($!p, $begy, $begx);
  }

  method cursor_move_rel (Int() $y, Int() $x) {
    my int32 ($yy, $xx) = ($y, $x);

    ncplane_cursor_move_rel($!p, $y, $x);
  }

  method cursor_x {
    ncplane_cursor_x($!p);
  }

  proto method cursor_yx (|)
  { * }

  multi method cursor_yx {
    samewith($, $);
  }
  multi method cursor_yx ($y is rw, $x is rw) {
    my int32 ($yy, $xx) = (0, 0);

    ncplane_cursor_yx($!p, $y, $x);
  }

  method cursor_y {
    ncplane_cursor_y($!p);
  }

  method ncplane_descendant_p (ncplane() $ancestor) {
    so ncplane_descendant_p($!p, $ancestor);
  }

  method destroy {
    ncplane_destroy($!p);
  }

  method dim {
    ($.dim_x, $.dim_y)
  }

  method dim_x {
    ncplane_dim_x($!p);
  }

  method dim_y {
    ncplane_dim_y($!p);
  }

  proto method dim_yx (|)
  { * }

  multi method dim_yx {
    samewith($, $);
  }
  multi method dim_yx ($y is rw, $x is rw) {
    my gint ($yy, $xx) = 0 xx 2;

    my $r = ncplane_dim_yx($!p, $yy, $xx);
    return Nil unless $r;
    ($y, $x) = ($yy, $xx);
  }

  method double_box_sized (
    Int() $styles,
    Int() $channels
    Int() $ylen,
    Int() $xlen,
    Int() $ctlword
  ) {
    my uint16  $s          =  $styles;
    my uint64  $c          =  $channels;
    my uint32 ($y, $x, $w) = ($ylen, $xlen, $ctlword);

    ncplane_double_box_sized($!p, $s, $c, $y, $x, $w);
  }

  multi method box (
           $styles,
           $channels,
          :$round     is required
          :$ul        is copy,
          :$ur        is copy,
          :$ll        is copy,
          :$lr        is copy,
          :$hl        is copy,
          :$vl        is copy,
    Int() :$attr
  ) {
    ($ul, $ur, $ll, $lr, $hl, $vl) //= Terminal::NotCurses::Cells.rounded_box(
      $!p,
      $attr,
      $channels
    );

    samewith($styles, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
  }
  multi method box (
         $styles,
         $channels,
        :$light     is required
        :$ul        is copy,
        :$ur        is copy,
        :$ll        is copy,
        :$lr        is copy,
        :$hl        is copy,
        :$vl        is copy,
  Int() :$attr
  ) {
    ($ul, $ur, $ll, $lr, $hl, $vl) //= Terminal::NotCurses::Cells.light_box(
      $!p,
      $attr,
      $channels
    );

    samewith($styles, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
  }
  multi method box (
           $styles,
           $channels,
          :$heavy     is required
          :$ul        is copy,
          :$ur        is copy,
          :$ll        is copy,
          :$lr        is copy,
          :$hl        is copy,
          :$vl        is copy,
    Int() :$attr
  ) {
    ($ul, $ur, $ll, $lr, $hl, $vl) //= Terminal::NotCurses::Cells.heavy_box(
      $!p,
      $attr,
      $channels
    );

    samewith($styles, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
  }
  method box (
    Int()    $styles,
    Int()    $channels
    nccell() $ul,
    nccell() $ur,
    nccell() $ll,
    nccell() $lr,
    nccell() $hl,
    nccell() $vl
  ) {
    my uint16  $s = $styles;
    my uint64  $c = $channels;

    ncplane_box_export($s, $c, $ul, $ur, $ll, $lr, $hl, $vl);
  }

  method dup (Pointer $opaque = gpointer) {
    ncplane_dup($!p, $opaque);
  }

  method erase {
    ncplane_erase($!p);
  }

  method erase_region (
    Int() $ystart,
    Int() $xstart,
    Int() $ylen,
    Int() $xlen
  ) {
    my int32 = ($yy, $xx, $yl, $xl) = ($ystart, $xstart, $ylen, $xlen);

    ncplane_erase_region($!p, $yy, $xx, $yl, $xl);
  }

  multi method fadein (Int $t, &fader) {
    samewith($t.Num, &fader);
  }
  multi method fadein (Num $t, &fader) {
    my $ts = timespec.new;
    ($ts.tv_sec, $ts.tv_usec) = ( $ts.Int, ($ts - $ts.Int) * e6 )

    samewith($ts, &fader);
  }
  method fadein (
    timespec $ts,
             &fader,
    Pointer  $curry  = Pointer
  ) {
    ncplane_fadein($!p, $ts, &fader, $curry);
  }

  method fadein_iteration (
    ncfadectx() $nctx,
    Int()       $iter,
                &fader,
    Pointer     $curry  = Pointer
  ) {
    my int32 $i = $iter;

    ncplane_fadein_iteration($!p, $nctx, $iter, &fader, $curry);
  }

  multi method fadeout (Int $t, &fader) {
    samewith($t.Num, &fader);
  }
  multi method fadeout (Num $t, &fader) {
    my $ts = timespec.new;
    ($ts.tv_sec, $ts.tv_usec) = ( $ts.Int, ($ts - $ts.Int) * e6 )

    samewith($ts, &fader);
  }
  method fadeout (
    timespec $ts,
             &fader,
    Pointer  $curry  = Pointer
  ) {
    ncplane_fadeout($!p, $ts, &fader, $curry);
  }

  method fadeout_iteration (
    ncfadectx $nctx,
    Int()       $iter,
                &fader,
    Pointer     $curry  = Pointer
  ) {
    my int32 $i = $iter;

    ncplane_fadeout_iteration($!p, $nctx, $iter, &fader, $curry);
  }

  method fchannel {
    ncplane_fchannel($!p);
  }

  method fg_alpha {
    ncplane_fg_alpha($!p);
  }

  method fg_default_p {
    ncplane_fg_default_p($!p);
  }

  proto method fg_rgb8 (|)
  { * }

  multi method fg_rgb8 {
    samewith($, $, $);
  }
  multi method fg_rgb8 ($r is rw, $g is rw, $b is rw) {
    my int32 ($rr, $gg, $bb) = 0 xx 3;

    my $r = ncplane_fg_rgb8($!p, $rr, $gh, $bb);
    return Nil $r;
    ($r, $g, $b) = ($rr, $gh, $bb);
  }

  method fg_rgb {
    ncplane_fg_rgb($!p);
  }

  method format (
    Int() $y,
    Int() $x,
    Int() $ylen,
    Int() $xlen,
    Int() $stylemask
  ) {
    my int32  ($yy, $xx) = ($y, $x);
    my uint32 ($yl, $xl) = ($ylen, $xlen);
    my uint16  $s        =  $stylemask;

    ncplane_format($!p, $y, $x, $yl, $xl, $s);
  }

  method gradient (
    Int()  $y,
    Int()  $x,
    Int()  $ylen,
    Int()  $xlen,
    Str()  $egc,
    Int()  $styles,
    Int()  $ul,
    Int()  $ur,
    Int()  $ll,
    Int()  $lr
  ) {
    my int32  ($yy, $xx, $yl, $xl)     = ($y, $x, $ylen, $xlen);
    my uint16  $s                      =  $styles
    my uint64 ($uul, $uur, $lll, $llr) = ($ul, $ur, $ll, $lr);

    ncplane_gradient(
      $!p,
      $yy,
      $xx,
      $yl,
      $xl,
      $egc,
      $s,
      $uul,
      $uur,
      $lll,
      $llr
    );
  }

  method gradient2x1 (
    Int() $y,
    Int() $x,
    Int() $ylen,
    Int() $xlen,
    Int() $ul,
    Int() $ur,
    Int() $ll,
    Int() $lr
  ) {
    my int32  ($yy,  $xx,  $yl,  $xl)  = ($y, $x, $ylen, $xlen);
    my uint64 ($uul, $uur, $lll, $llr) = ($ul, $ur, $ll, $lr);

    ncplane_gradient2x1($!p, $yy, $xx, $yl, $xl, $uul, $uur, $lll, $llr);
  }

  method halign (Int() $align, Int() $c) {
    my ncalign_e $a  = $align;
    my gint      $cc = $c;

    ncplane_halign_export($!p, $a, $cc);
  }

  method hline (nccell() $c) {
    ncplane_hline($!p, $c);
  }

  method hline_interp (
    nccell() $c,
    Int()    $len
    Int()    $c1,
    Int()    $c2
  ) {
    my int32   $l          =  $len;
    my uint64 ($cc1, $cc2) = ($c1, $c2);

    ncplane_hline_interp($!p, $c, $l, $cc1, $cc2);
  }

  method mergedown (
    ncplane() $dst,
    Int()     $begsrcy,
    Int()     $begsrcx,
    Int()     $leny,
    Int()     $lenx,
    Int()     $dsty,
    Int()     $dstx
  ) {
    my int32  ($sy, $sx, $dy, $dx) = ($begsrcy, $begsrxc, $dsty, $dstx);
    my uint32 ($ly, $lx)           = ($leny, $lenx);

    ncplane_mergedown($src, $dst, $sy, $sx, $ly, $lx, $dy, $dx);
  }

  method mergedown_simple (ncplane() $dst) {
    ncplane_mergedown_simple($src, $dst);
  }

  method move_above (ncplane() $above) {
    ncplane_move_above($!p, $above);
  }

  method move_below (ncplane() $below) {
    ncplane_move_below($!p, $below);
  }

  method move_bottom {
    ncplane_move_bottom($!p);
  }

  method move_family_above (ncplane() $targ) {
    ncplane_move_family_above($!p, $targ);
  }

  method move_family_below (ncplane() $targ) {
    ncplane_move_family_below($!p, $targ);
  }

  method move_family_bottom {
    ncplane_move_family_bottom($!p);
  }

  method move_family_top {
    ncplane_move_family_top($!p);
  }

  method move_rel (Int() $y, Int() $x) {
    my int32 ($yy, $xx) = ($y, $x;

    ncplane_move_rel($!p, $yy, $xx);
  }

  method move_top {
    ncplane_move_top($!p);
  }

  method move_yx (Int() $y, Int() $x) {
    my int32 ($yy, $xx) = ($y, $x);

    ncplane_move_yx($!p, $yy, $xx);
  }

  method name {
    ncplane_name($!p);
  }

  method notcurses {
    ncplane_notcurses($!p);
  }

  method notcurses_const {
    ncplane_notcurses_const($!p);
  }

  method off_styles {
    ncplane_off_styles($!p);
  }

  method on_styles {
    ncplane_on_styles($!p);
  }

  method parent {
    ncplane_parent($!p);
  }

  method parent_const {
    ncplane_parent_const($!p);
  }

  method putc_yx (Int() $y, Int() $x, nccell() $c) {
    my int32 ($yy, $xx) = ($y, $x);

    ncplane_putc_yx($!p, $yy, $xx, $c);
  }

  method putchar_stained (Str() $c) {
    ncplane_putchar_stained($!p, $c);
  }

  method ncplane_putegc_stained (
    Str() $gclust,
    Int() $sbytes = $gclust.encode.bytes
  ) {
    my size_t $s = $sbytes;

    ncplane_putegc_stained($!p, $gclust, $s);
  }

  proto method ncplane_putegc_yx (|)
  { * }

  multi method ncplane_putegc_yx (
     $y,
     $x,
     $gclust,
    :$encoding = 'utf8',
    :$sbytes   =  $gclust.encode($encoding).bytes
  ) {
    samewith($y, $x, $gclust, $sbytes);
  }
  multi method ncplane_putegc_yx (
    Int() $y,
    Int() $x,
    Str() $gclust,
    Int() $sbytes
  ) {
    my int32  ($yy, $xx) = ($y, $x);
    my size_t  $s        =  $sbytes;

    ncplane_putegc_yx($!p, $yy, $xx, $gclust, $s);
  }

  method ncplane_putnstr_aligned (
    ncplane   $n,
    gint      $y,
    ncalign_e $align,
    size_t    $s,
    Str       $str
  ) {
    ncplane_putnstr_aligned($!p, $y, $align, $s, $str);
  }

  proto method ncplane_putwegc_stained (|)
  { * }

  multi method ncplane_putwegc_stained ($s, :$size, :$encoding = 'utf8') {
    my $b  = $s.encode($encoding);
    my $ca = CArray[uint64].new($b);

    samewith($ca, $size // $ca.elems);
  }
  multi method ncplane_putwegc_stained (
    CArray[wchar_t] $gclust,
    Int()           $sbytes
  ) {
    my size_t $s = $sbytes;

    ncplane_putwegc_stained($!p, $gclust, $s);
  }

  method ncplane_putwstr_stained (
    ncplane $n,
    wchar_t $gclustarr
  ) {
    ncplane_putwstr_stained($!p, $gclustarr);
  }

  method reparent (ncplane() $newparent) {
    ncplane_reparent($!p, $newparent);
  }

  method ncplane_reparent_family (ncplane() $newparent) {
    ncplane_reparent_family($!p, $newparent);
  }

  method ncplane_resize (
    ncplane  $n,
    gint     $keepy,
    gint     $keepx,
    keepleny $yoff,
    keeplenx $xoff
  ) {
    ncplane_resize($!p, $keepy, $keepx, $yoff, $xoff);
  }

  method ncplane_rotate_ccw (ncplane $n) {
    ncplane_rotate_ccw($!p);
  }

  method ncplane_rotate_cw (ncplane $n) {
    ncplane_rotate_cw($!p);
  }

  method ncplane_scrolling_p (ncplane $n) {
    ncplane_scrolling_p($!p);
  }

  method ncplane_scrollup (
    ncplane $n,
    gint    $r
  ) {
    ncplane_scrollup($!p, $r);
  }

  method ncplane_scrollup_child (
    ncplane $n,
    ncplane $child
  ) {
    ncplane_scrollup_child($!p, $child);
  }

  method ncplane_set_autogrow (ncplane $n) {
    ncplane_set_autogrow($!p);
  }

  method ncplane_set_base (
    ncplane  $n,
    Str      $egc,
    uint16_t $stylemask,
    uint64_t $channels
  ) {
    ncplane_set_base($!p, $egc, $stylemask, $channels);
  }

  method ncplane_set_base_cell (
    ncplane $n,
    nccell  $c
  ) {
    ncplane_set_base_cell($!p, $c);
  }

  method ncplane_set_scrolling (ncplane $n) {
    ncplane_set_scrolling($!p);
  }

  method ncplane_set_userptr (
    ncplane $n,
    Pointer $opaque
  ) {
    ncplane_set_userptr($!p, $opaque);
  }

  method ncplane_styles (ncplane $n) {
    ncplane_styles($!p);
  }

  method ncplane_translate (
    ncplane $src,
    ncplane $dst,
    gint    $y is rw,
    gint    $x is rw
  ) {
    ncplane_translate($src, $dst, $y, $x);
  }

  method ncplane_translate_abs (
    ncplane $n,
    gint    $y is rw,
    gint    $x is rw
  ) {
    ncplane_translate_abs($!p, $y, $x);
  }

  method ncplane_userptr (ncplane $n) {
    ncplane_userptr($!p);
  }

  method ncplane_x (ncplane $n) {
    ncplane_x($!p);
  }

  method ncplane_y (ncplane $n) {
    ncplane_y($!p);
  }

  method ncplane_yx (
    ncplane $n,
    gint    $y is rw,
    gint    $x is rw
  ) {
    ncplane_yx($!p, $y, $x);
  }



  method ncplane_pixel_geom (
    ncplane $n,
    gint    $pxy is rw,
    gint    $pxx is rw,
    gint    $celldimy is rw,
    gint    $celldimx is rw,
    gint    $maxbmapy is rw,
    gint    $maxbmapx is rw
  ) {
    ncplane_pixel_geom($!p, $pxy, $pxx, $celldimy, $celldimx, $maxbmapy, $maxbmapx);
  }

  method ncplane_polyfill_yx (
    ncplane $n,
    gint    $y,
    gint    $x,
    nccell  $c
  ) {
    ncplane_polyfill_yx($!p, $y, $x, $c);
  }

  method ncplane_pulse (
    ncplane  $n,
    timespec $ts,
    fadecb   $fader,
    Pointer  $curry
  ) {
    ncplane_pulse($!p, $ts, $fader, $curry);
  }

  method ncplane_puttext (
    ncplane   $n,
    gint      $y,
    ncalign_e $align,
    Str       $text,
    size_t    $bytes
  ) {
    ncplane_puttext($!p, $y, $align, $text, $bytes);
  }

  method ncplane_qrcode (
    ncplane $n,
    gint    $ymax is rw,
    gint    $xmax is rw,
    Pointer $data,
    size_t  $len
  ) {
    ncplane_qrcode($!p, $ymax, $xmax, $data, $len);
  }

  method ncplane_set_bchannel (
    ncplane  $n,
    uint32_t $channel
  ) {
    ncplane_set_bchannel($!p, $channel);
  }

  method ncplane_set_bg_alpha (
    ncplane $n,
    gint    $alpha
  ) {
    ncplane_set_bg_alpha($!p, $alpha);
  }

  method ncplane_set_bg_default (ncplane $n) {
    ncplane_set_bg_default($!p);
  }

  method ncplane_set_bg_palindex (ncplane $n) {
    ncplane_set_bg_palindex($!p);
  }

  method ncplane_set_bg_rgb (
    ncplane  $n,
    uint32_t $channel
  ) {
    ncplane_set_bg_rgb($!p, $channel);
  }

  method ncplane_set_bg_rgb8 (ncplane $n) {
    ncplane_set_bg_rgb8($!p);
  }

  method ncplane_set_bg_rgb8_clipped (
    ncplane $n,
    gint    $r,
    gint    $g,
    gint    $b
  ) {
    ncplane_set_bg_rgb8_clipped($!p, $r, $g, $b);
  }

  method ncplane_set_channels (
    ncplane  $n,
    uint64_t $channels
  ) {
    ncplane_set_channels($!p, $channels);
  }

  method ncplane_set_fchannel (
    ncplane  $n,
    uint32_t $channel
  ) {
    ncplane_set_fchannel($!p, $channel);
  }

  method ncplane_set_fg_alpha (
    ncplane $n,
    gint    $alpha
  ) {
    ncplane_set_fg_alpha($!p, $alpha);
  }

  method ncplane_set_fg_default (ncplane $n) {
    ncplane_set_fg_default($!p);
  }

  method ncplane_set_fg_palindex (ncplane $n) {
    ncplane_set_fg_palindex($!p);
  }

  method ncplane_set_fg_rgb (
    ncplane  $n,
    uint32_t $channel
  ) {
    ncplane_set_fg_rgb($!p, $channel);
  }

  method ncplane_set_fg_rgb8 (ncplane $n) {
    ncplane_set_fg_rgb8($!p);
  }

  method ncplane_set_fg_rgb8_clipped (
    ncplane $n,
    gint    $r,
    gint    $g,
    gint    $b
  ) {
    ncplane_set_fg_rgb8_clipped($!p, $r, $g, $b);
  }

  method ncplane_set_styles (ncplane $n) {
    ncplane_set_styles($!p);
  }

  method ncplane_stain (
    ncplane  $n,
    gint     $y,
    gint     $x,
    ylen     $ul,
    xlen     $ur,
    uint64_t $ll,
    uint64_t $lr
  ) {
    ncplane_stain($!p, $y, $x, $ul, $ur, $ll, $lr);
  }

  method ncplane_vline_interp (
    ncplane  $n,
    nccell   $c,
    len      $c1,
    uint64_t $c2
  ) {
    ncplane_vline_interp($!p, $c, $c1, $c2);
  }

  method ncplane_vprintf_aligned (
    ncplane   $n,
    gint      $y,
    ncalign_e $align,
    Str       $format,
    va_list   $ap
  ) {
    ncplane_vprintf_aligned($!p, $y, $align, $format, $ap);
  }

  method ncplane_vprintf_stained (
    ncplane $n,
    Str     $format,
    va_list $ap
  ) {
    ncplane_vprintf_stained($!p, $format, $ap);
  }

  method ncplane_vprintf_yx (
    ncplane $n,
    gint    $y,
    gint    $x,
    Str     $format,
    va_list $ap
  ) {
    ncplane_vprintf_yx($!p, $y, $x, $format, $ap);
  }

  method ncplane_dim_yexport (ncplane $n) {
    ncplane_dim_yexport($!p);
  }channels
  ) {
    ncplane_double_boxexport($!p, $styles, $channels);
  }


  method ncplane_perimeter_doubleexport (
    ncplane  $n,
    uint16_t $stylemask,
    uint64_t $channels
  ) {
    ncplane_perimeter_doubleexport($!p, $stylemask, $channels);
  }

  method ncplane_perimeter_roundedexport (
    ncplane  $n,
    uint16_t $stylemask,
    uint64_t $channels
  ) {
    ncplane_perimeter_roundedexport($!p, $stylemask, $channels);
  }

  method ncplane_perimeterexport (
    ncplane $n,
    nccell  $ul,
    nccell  $ur,
    nccell  $ll,
    nccell  $lr,
    nccell  $hline,
    nccell  $vline
  ) {
    ncplane_perimeterexport($!p, $ul, $ur, $ll, $lr, $hline, $vline);
  }

  method ncplane_printf_alignedexport (
    ncplane   $n,
    gint      $y,
    ncalign_e $align,
    Str       $format
  ) {
    ncplane_printf_alignedexport($!p, $y, $align, $format);
  }

  method ncplane_printf_stainedexport (
    ncplane $n,
    Str     $format
  ) {
    ncplane_printf_stainedexport($!p, $format);
  }

  method ncplane_printf_yxexport (
    ncplane $n,
    gint    $y,
    gint    $x,
    Str     $format
  ) {
    ncplane_printf_yxexport($!p, $y, $x, $format);
  }

  method ncplane_printfexport (
    ncplane $n,
    Str     $format
  ) {
    ncplane_printfexport($!p, $format);
  }

  method ncplane_putcexport (
    ncplane $n,
    nccell  $c
  ) {
    ncplane_putcexport($!p, $c);
  }

  method ncplane_putchar_yxexport (
    ncplane $n,
    gint    $y,
    gint    $x,
    Str     $c
  ) {
    ncplane_putchar_yxexport($!p, $y, $x, $c);
  }

  method ncplane_putcharexport (
    ncplane $n,
    Str     $c
  ) {
    ncplane_putcharexport($!p, $c);
  }

  method ncplane_putegcexport (
    ncplane $n,
    Str     $gclust,
    size_t  $sbytes
  ) {
    ncplane_putegcexport($!p, $gclust, $sbytes);
  }

  method ncplane_putnstr_yxexport (
    ncplane $n,
    gint    $y,
    gint    $x,
    size_t  $s,
    Str     $gclusters
  ) {
    ncplane_putnstr_yxexport($!p, $y, $x, $s, $gclusters);
  }

  method ncplane_putnstrexport (
    ncplane $n,
    size_t  $s,
    Str     $gclustarr
  ) {
    ncplane_putnstrexport($!p, $s, $gclustarr);
  }

  method ncplane_putstr_alignedexport (
    ncplane   $n,
    gint      $y,
    ncalign_e $align,
    Str       $s
  ) {
    ncplane_putstr_alignedexport($!p, $y, $align, $s);
  }

  method ncplane_putstr_stainedexport (
    ncplane $n,
    Str     $gclusters
  ) {
    ncplane_putstr_stainedexport($!p, $gclusters);
  }

  method ncplane_putstr_yxexport (
    ncplane $n,
    gint    $y,
    gint    $x,
    Str     $gclusters
  ) {
    ncplane_putstr_yxexport($!p, $y, $x, $gclusters);
  }

  method ncplane_putstrexport (
    ncplane $n,
    Str     $gclustarr
  ) {
    ncplane_putstrexport($!p, $gclustarr);
  }

  method ncplane_pututf32_yxexport (
    ncplane  $n,
    gint     $y,
    gint     $x,
    uint32_t $u
  ) {
    ncplane_pututf32_yxexport($!p, $y, $x, $u);
  }

  method ncplane_putwc_stainedexport (
    ncplane $n,
    wchar_t $w
  ) {
    ncplane_putwc_stainedexport($!p, $w);
  }

  method ncplane_putwc_utf32export (
    ncplane $n,
    wchar_t $w,
    gint    $wchars is rw
  ) {
    ncplane_putwc_utf32export($!p, $w, $wchars);
  }

  method ncplane_putwc_yxexport (
    ncplane $n,
    gint    $y,
    gint    $x,
    wchar_t $w
  ) {
    ncplane_putwc_yxexport($!p, $y, $x, $w);
  }

  method ncplane_putwcexport (
    ncplane $n,
    wchar_t $w
  ) {
    ncplane_putwcexport($!p, $w);
  }

  method ncplane_putwegc_yxexport (
    ncplane $n,
    gint    $y,
    gint    $x,
    wchar_t $gclust,
    size_t  $sbytes
  ) {
    ncplane_putwegc_yxexport($!p, $y, $x, $gclust, $sbytes);
  }

  method ncplane_putwegcexport (
    ncplane $n,
    wchar_t $gclust,
    size_t  $sbytes
  ) {
    ncplane_putwegcexport($!p, $gclust, $sbytes);
  }

  method ncplane_putwstr_alignedexport (
    ncplane   $n,
    gint      $y,
    ncalign_e $align,
    wchar_t   $gclustarr
  ) {
    ncplane_putwstr_alignedexport($!p, $y, $align, $gclustarr);
  }

  method ncplane_putwstr_yxexport (
    ncplane $n,
    gint    $y,
    gint    $x,
    wchar_t $gclustarr
  ) {
    ncplane_putwstr_yxexport($!p, $y, $x, $gclustarr);
  }

  method ncplane_putwstrexport (
    ncplane $n,
    wchar_t $gclustarr
  ) {
    ncplane_putwstrexport($!p, $gclustarr);
  }

  method ncplane_resize_simpleexport (ncplane $n) {
    ncplane_resize_simpleexport($!p);
  }

  method ncplane_rounded_box_sizedexport (
    ncplane  $n,
    uint16_t $styles,
    uint64_t $channels
  ) {
    ncplane_rounded_box_sizedexport($!p, $styles, $channels);
  }

  method ncplane_rounded_boxexport (
    ncplane  $n,
    uint16_t $styles,
    uint64_t $channels
  ) {
    ncplane_rounded_boxexport($!p, $styles, $channels);
  }

  method ncplane_valignexport (
    ncplane   $n,
    ncalign_e $align,
    gint      $r
  ) {
    ncplane_valignexport($!p, $align, $r);
  }

  method ncplane_vlineexport (
    ncplane $n,
    nccell  $c
  ) {
    ncplane_vlineexport($!p, $c);
  }

  method ncplane_vprintfexport (
    ncplane $n,
    Str     $format,
    va_list $ap
  ) {
    ncplane_vprintfexport($!p, $format, $ap);
  }

}
