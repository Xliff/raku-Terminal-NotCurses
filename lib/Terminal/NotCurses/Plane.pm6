use v6;

use NativeCall;
use Method::Also;

use Terminal::NotCurses::Raw::Extern;
use Terminal::NotCurses::Raw::Types;
use Terminal::NotCurses::Raw::Plane;

use Proto::Roles::Implementor;
use Terminal::NotCurses::Cell;

sub create_ncplane_options is export {
  ncplane_options.new;
}

class Terminal::NotCurses::Plane {
  also does Proto::Roles::Implementor;

  has ncplane $!p is implementor;

  submethod BUILD ( :plane(:$!p) ) { }

  method Terminal::NotCurses::Raw::Definitions::ncplane
    is also<ncplane>
  { $!p }

  multi method new ( $plane where *.^can('ncplane') ) {
    samewith($plane.ncplane);
  }
  multi method new (ncplane $plane) {
    $plane ?? self.bless( :$plane ) !! Nil;
  }
  multi method new (ncplane_options $o) {
    self.create(ncplane, $o);
  }
  multi method new (Int() $x, Int() $y, Int() $rows, Int() $cols) {
    self.create( :$x, :$y, :$rows, :$cols );
  }
  multi method new (Int() $rows, Int() $cols) {
    self.create( x => 0, y => 0, :$rows, :$cols );
  }
  multi method new (
    ncplane()  $plane,
    Int()     :$x        is required,
    Int()     :$y        is required,
    Int()     :r(:$rows)                               = 1,
    Int()     :c(:$cols)                               = 1,
    Str()     :$name                                   = '',
    Int()     :$flags                                  = 0,
    Int()     :margin-right(:margin_right(:$right))    = 0,
    Int()     :margin-bottom(:margin_bottom(:$bottom)) = 0
  ) {
    my $no = ncplane_options.new(
      :$x,
      :$y,
      :$rows,
      :$cols,
      :$name,
      :$flags,
      margin_r => $right,
      margin_b => $bottom
    );
    self.create($plane, $no);
  }

  multi method create (
    Int()     :$x        is required,
    Int()     :$y        is required,
    Int()     :r(:$rows)                               = 1,
    Int()     :c(:$cols)                               = 1,
    Str()     :$name                                   = '',
    Int()     :$flags                                  = 0,
    Int()     :margin-right(:margin_right(:$right))    = 0,
    Int()     :margin-bottom(:margin_bottom(:$bottom)) = 0
  ) {
    my $no = ncplane_options.new(
      :$x,
      :$y,
      :$rows,
      :$cols,
      :$name,
      :$flags,
      margin_r => $right,
      margin_b => $bottom
    );
    samewith($no);
  }
  multi method create (ncplane_options() $nopts) {
    my $plane = ncplane_create($!p, $nopts);

    $plane ?? self.bless( :$plane ) !! Nil;
  }

  method above {
    ncplane_above($!p);
  }

  method abs_x is also<abs-x> {
    ncplane_abs_x($!p);
  }

  method abs_y is also<abs-y> {
    ncplane_abs_y($!p);
  }

  proto method as_rgba (|)
    is also<as-rgba>
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
    is also<ascii-box>
  { * }

  multi method ascii_box (Int() $channels, :mask(:$style) = 0) {
    my uint16 $s = CArray[uint16].new($style);
    my uint64 $c = CArray[uint64].new($channels);

    samewith($s, $c);
  }
  multi method ascii_box (CArray[uint16] $s, CArray[uint64] $c) {
    ncplane_ascii_box($!p, $s, $c);
  }

  proto method at_cursor (|)
    is also<at-cursor>
  { * }

  multi method at_cursor (Int() $channels, :mask(:$style) = 0) {
    my uint16 $s = CArray[uint16].new($style);
    my uint64 $c = CArray[uint64].new($channels);

    samewith($s, $c);
  }
  multi method at_cursor (CArray[uint16] $s, CArray[uint64] $c) {
    ncplane_at_cursor($!p, $s, $c);
  }

  method at_cursor_cell (nccell() $c) is also<at-cursor-cell> {
    ncplane_at_cursor_cell($!p, $c);
  }

  proto method at_yx (|)
    is also<at-yx>
  { * }

  multi method at_yx ($y, $x, :mask(:$style) = 0, :$all = False) {
    my CArray[uint16] $sa = CArray[uint16].allocate(1);
    my CArray[uint64] $ca = CArray[uint64].allocate(1);
    $sa[0] = $style.Int;
    $ca[0] = 0;

    my $cc = samewith($y, $x, $sa, $ca);
    return $cc unless $all;
    ( $cc, $sa[0], $ca[0] );
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

  proto method at_yx_cell (|)
    is also<at-yx-cell>
  { * }

  multi method at_yx_cell ($y, $x, :$all = False, :$raw = False) {
    my $c = nccell.new;

    my $rv = samewith($y, $x, $c);
    $c = Terminal::NotCurses::Cell.new($c) unless $raw;
    return $c unless $all;
    ($rv, $c);
  }
  multi method at_yx_cell (Int() $y, Int() $x, nccell() $c) {
    my int32 ($yy, $xx) = ($y, $x);

    ncplane_at_yx_cell($!p, $yy, $xx, $c);
  }

  method autogrow_p is also<autogrow-p> {
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

  method bg_alpha is also<bg-alpha> {
    ncplane_bg_alpha($!p);
  }

  method bg_default_p is also<bg-default-p> {
    ncplane_bg_default_p($!p);
  }

  proto method bg_rgb8 (|)
    is also<bg-rgb8>
  { * }

  multi method bg_rgb8 {
    samewith($, $, $);
  }
  multi method bg_rgb8 ($r is rw, $g is rw, $b is rw) {
    my int32 ($rr, $gg, $bb) = 0 xx 3;

    my $rv = ncplane_bg_rgb8($!p, $rr, $gg, $bb);
    return Nil unless $rv;
    ($r, $g, $b) = ($rr, $gg, $bb);
  }
  multi method bg_rgb is also<bg-rgb> {
    ncplane_bg_rgb($!p);
  }

  multi method box (
           $y,
           $x,
           $cword                  = 0,
          :$double    is required,
          :$ul        is copy,
          :$ur        is copy,
          :$ll        is copy,
          :$lr        is copy,
          :$hl        is copy,
          :$vl        is copy,
   Int() :$attr,
   Int() :$channels,
  ) {
    ($ul, $ur, $ll, $lr, $hl, $vl) //= $.double_box_cells($attr, $channels);

    samewith($ul, $ur, $ll, $lr, $hl, $vl, $y, $x, $cword);
  }
  multi method box (
           $y,
           $x,
           $cword                  = 0,
          :$round     is required,
          :$ul        is copy,
          :$ur        is copy,
          :$ll        is copy,
          :$lr        is copy,
          :$hl        is copy,
          :$vl        is copy,
    Int() :$attr,
    Int() :$channels,
  ) {
    ($ul, $ur, $ll, $lr, $hl, $vl) //= $.rounded_box_cells($attr, $channels);

    samewith($ul, $ur, $ll, $lr, $hl, $vl, $y, $x, $cword);
  }
  multi method box (
           $y,
           $x,
           $cword                  = 0,
          :$light     is required,
          :$ul        is copy,
          :$ur        is copy,
          :$ll        is copy,
          :$lr        is copy,
          :$hl        is copy,
          :$vl        is copy,
    Int() :$attr,
    Int() :$channels,
  ) {
    ($ul, $ur, $ll, $lr, $hl, $vl) //= $.light_box_cells($attr, $channels
    );

    samewith($ul, $ur, $ll, $lr, $hl, $vl, $y, $x, $cword);
  }
  multi method box (
           $y,
           $x,
           $cword                  = 0,
          :$heavy     is required,
          :$ul        is copy    ,
          :$ur        is copy    ,
          :$ll        is copy    ,
          :$lr        is copy    ,
          :$hl        is copy    ,
          :$vl        is copy    ,
    Int() :$attr                 ,
    Int() :$channels
  ) {
    ($ul, $ur, $ll, $lr, $hl, $vl) //= $.heavy_box_cells($attr, $channels);

    samewith($ul, $ur, $ll, $lr, $hl, $vl, $y, $x, $cword);
  }
  multi method box (
    nccell() $ul,
    nccell() $ur,
    nccell() $ll,
    nccell() $lr,
    nccell() $hl,
    nccell() $vl,
    Int()    $ystop,
    Int()    $xstop,
    Int()    $ctlword = 0
  ) {
    my uint32 ($yy, $xx, $cc) = ($ystop, $xstop, $ctlword);

    ncplane_box($!p, $ul, $ur, $ll, $lr, $hl, $vl, $yy, $xx, $cc);
  }

  method box_sized (
    nccell() $ul,
    nccell() $ur,
    nccell() $ll,
    nccell() $lr,
    nccell() $hline,
    nccell() $vline
  )
    is also<box-sized>
  {
    ncplane_box_sized($!p, $ul, $ur, $ll, $lr, $hline, $vline);
  }

  proto method center_abs (|)
    is also<center-abs>
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

  method cursor_move_rel (Int() $y, Int() $x) is also<cursor-move-rel> {
    my int32 ($yy, $xx) = ($y, $x);

    ncplane_cursor_move_rel($!p, $yy, $xx);
  }

  method cursor_move_yx (Int() $y, Int() $x) is also<cursor-move-yx> {
    my int32 ($yy, $xx) = ($y, $x);

    ncplane_cursor_move_yx($!p, $yy, $xx);
  }

  method cursor_x is also<cursor-x> {
    ncplane_cursor_x($!p);
  }

  proto method cursor_yx (|)
    is also<cursor-yx>
  { * }

  multi method cursor_yx {
    samewith($, $);
  }
  multi method cursor_yx ($y is rw, $x is rw) {
    my uint32 ($yy, $xx) = (0, 0);

    ncplane_cursor_yx($!p, $yy, $xx);
    ($y = $yy, $x = $xx);
  }

  method cursor_y is also<cursor-y> {
    ncplane_cursor_y($!p);
  }

  method descendant_p (ncplane() $ancestor) is also<descendant-p> {
    so ncplane_descendant_p($!p, $ancestor);
  }

  method destroy {
    ncplane_destroy($!p);
  }

  method dim {
    ($.dim_x, $.dim_y)
  }

  method dim_x is also<dim-x> {
    ncplane_dim_x($!p);
  }

  method dim_y is also<dim-y> {
    ncplane_dim_y($!p);
  }

  proto method dim_yx (|)
    is also<dim-yx>
  { * }

  multi method dim_yx {
    samewith($, $);
  }
  multi method dim_yx ($y is rw, $x is rw) {
    my int32 ($yy, $xx) = 0 xx 2;

    ncplane_dim_yx($!p, $yy, $xx);
    ($y, $x) = ($yy, $xx);
  }

  method double_box (
    Int() $styles,
    Int() $channels,
    Int() $ystop,
    Int() $xstop,
    Int() $ctlword    = 0
  )
    is also<double-box>
  {
    my uint16  $s          =  $styles;
    my uint64  $c          =  $channels;
    my uint32 ($y, $x, $w) = ($ystop, $xstop, $ctlword);

    ncplane_double_box($!p, $s, $c, $y, $x, $w);
  }

  method double_box_sized (
    Int() $styles,
    Int() $channels,
    Int() $ylen,
    Int() $xlen,
    Int() $ctlword
  )
    is also<double-box-sized>
  {
    my uint16  $s          =  $styles;
    my uint64  $c          =  $channels;
    my uint32 ($y, $x, $w) = ($ylen, $xlen, $ctlword);

    ncplane_double_box_sized($!p, $s, $c, $y, $x, $w);
  }

  method dup (Pointer $opaque = Pointer) {
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
  )
    is also<erase-region>
  {
    my int32 ($yy, $xx, $yl, $xl) = ($ystart, $xstart, $ylen, $xlen);

    ncplane_erase_region($!p, $yy, $xx, $yl, $xl);
  }

  multi method fadein (Int $t, &fader) {
    samewith($t.Num, &fader);
  }
  multi method fadein (Num $t, &fader) {
    my $ts = timespec.new;
    ($ts.tv_sec, $ts.tv_usec) = ( $ts.Int, $ts.&infix:<mod>(1) * 1e6 );

    samewith($ts, &fader);
  }
  multi method fadein (
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
  )
    is also<fadein-iteration>
  {
    my int32 $i = $iter;

    ncplane_fadein_iteration($!p, $nctx, $iter, &fader, $curry);
  }

  multi method fadeout (Int $t, &fader) {
    samewith($t.Num, &fader);
  }
  multi method fadeout (Num $t, &fader) {
    my $ts = timespec.new;
    ($ts.tv_sec, $ts.tv_usec) = ( $ts.Int, ($ts - $ts.Int) * 1e6 );

    samewith($ts, &fader);
  }
  multi method fadeout (
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
  )
    is also<fadeout-iteration>
  {
    my int32 $i = $iter;

    ncplane_fadeout_iteration($!p, $nctx, $iter, &fader, $curry);
  }

  method fchannel {
    ncplane_fchannel($!p);
  }

  method fg_alpha is also<fg-alpha> {
    ncplane_fg_alpha($!p);
  }

  method fg_default_p is also<fg-default-p> {
    ncplane_fg_default_p($!p);
  }

  proto method fg_rgb8 (|)
    is also<fg-rgb8>
  { * }

  multi method fg_rgb8 {
    samewith($, $, $);
  }
  multi method fg_rgb8 ($r is rw, $g is rw, $b is rw) {
    my int32 ($rr, $gg, $bb) = 0 xx 3;

    my $rv = ncplane_fg_rgb8($!p, $rr, $gg, $bb);
    return Nil unless $rv;
    ($r, $g, $b) = ($rr, $gg, $bb);
  }

  method fg_rgb is also<fg-rgb> {
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

  multi method gradient (
    Int()  $y,
    Int()  $x,
    Int()  $ylen,
    Int()  $xlen,
    Str()  $egc,
    Int()  $styles,
    Int()  $c
  ) {
    samewith(
      $y,
      $x,
      $ylen,
      $xlen,
      $egc,
      $styles,
      $c,
      $c,
      $c,
      $c
    );
  }
  multi method gradient (
    Int()  $y,
    Int()  $x,
    Int()  $ylen,
    Int()  $xlen,
    Str()  $egc,
    Int()  $styles,
    Int()  $c1,
    Int()  $c2
  ) {
    samewith(
      $y,
      $x,
      $ylen,
      $xlen,
      $egc,
      $styles,
      $c1,
      $c1,
      $c2,
      $c2
    );
  }
  multi method gradient (
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
    my uint16  $s                      =  $styles;
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
    my int32     $cc = $c;

    ncplane_halign($!p, $a, $cc);
  }

  method hline (nccell() $c, Int() $len) {
    my uint32 $l = $len;

    ncplane_hline($!p, $c, $l);
  }

  method hline_interp (
    nccell() $c,
    Int()    $len,
    Int()    $c1,
    Int()    $c2
  )
    is also<hline-interp>
  {
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
    my int32  ($sy, $sx, $dy, $dx) = ($begsrcy, $begsrcx, $dsty, $dstx);
    my uint32 ($ly, $lx)           = ($leny, $lenx);

    ncplane_mergedown($!p, $dst, $sy, $sx, $ly, $lx, $dy, $dx);
  }

  method mergedown_simple (ncplane() $dst) is also<mergedown-simple> {
    ncplane_mergedown_simple($!p, $dst);
  }

  method move_above (ncplane() $above) is also<move-above> {
    ncplane_move_above($!p, $above);
  }

  method move_below (ncplane() $below) is also<move-below> {
    ncplane_move_below($!p, $below);
  }

  method move_bottom is also<move-bottom> {
    ncplane_move_bottom($!p);
  }

  method move_family_above (ncplane() $targ) is also<move-family-above> {
    ncplane_move_family_above($!p, $targ);
  }

  method move_family_below (ncplane() $targ) is also<move-family-below> {
    ncplane_move_family_below($!p, $targ);
  }

  method move_family_bottom is also<move-family-bottom> {
    ncplane_move_family_bottom($!p);
  }

  method move_family_top is also<move-family-top> {
    ncplane_move_family_top($!p);
  }

  method move_rel (Int() $y, Int() $x) is also<move-rel> {
    my int32 ($yy, $xx) = ($y, $x);

    ncplane_move_rel($!p, $yy, $xx);
  }

  method move_top is also<move-top> {
    ncplane_move_top($!p);
  }

  method move_yx (Int() $y, Int() $x) is also<move-yx> {
    my int32 ($yy, $xx) = ($y, $x);

    ncplane_move_yx($!p, $yy, $xx);
  }

  method name {
    ncplane_name($!p);
  }

  method notcurses {
    ncplane_notcurses($!p);
  }

  method notcurses_const is also<notcurses-const> {
    ncplane_notcurses_const($!p);
  }

  method off_styles is also<off-styles> {
    ncplane_off_styles($!p);
  }

  method on_styles is also<on-styles> {
    ncplane_on_styles($!p);
  }

  method parent {
    ncplane_parent($!p);
  }

  method parent_const is also<parent-const> {
    ncplane_parent_const($!p);
  }

  method perimeter_double (
    Int() $stylemask,
    Int() $channels,
    Int() $ctlword    = 0
  )
    is also<perimeter-double>
  {
    my uint16 $s = $stylemask;
    my uint64 $c = $channels;
    my uint32 $w = $ctlword;

    ncplane_perimeter_double($!p, $s, $c, $w);
  }

  method perimeter_rounded (
    Int() $stylemask,
    Int() $channels,
    Int() $ctlword    = 0
  )
    is also<perimeter-rounded>
  {
    my uint16 $s = $stylemask;
    my uint64 $c = $channels;
    my uint32 $w = $ctlword;

    ncplane_perimeter_rounded($!p, $s, $c, $w);
  }

  method perimeter (
    nccell() $ul,
    nccell() $ur,
    nccell() $ll,
    nccell() $lr,
    nccell() $hline,
    nccell() $vline,
    Int()    $ctlword = 0
  ) {
    my uint32 $w = $ctlword;

    ncplane_perimeter($!p, $ul, $ur, $ll, $lr, $hline, $vline, $w);
  }

  proto method pixel_geom (|)
    is also<pixel-geom>
  { * }

  multi method pixel_geom {
    samewith($, $, $, $, $, $);
  }
  multi method pixel_geom (
    $pxy      is rw,
    $pxx      is rw,
    $celldimy is rw,
    $celldimx is rw,
    $maxbmapy is rw,
    $maxbmapx is rw
  ) {
    my uint32 ($px, $py, $cx, $cy, $mx, $my) = 0 xx 6;

    ncplane_pixel_geom($!p, $px, $py, $cx, $cy, $mx, $my);

    ($pxy, $pxx, $celldimy, $celldimx, $maxbmapy, $maxbmapx) =
      ($px, $py, $cx, $cy, $mx, $my)
  }

  method polyfill_yx (Int() $y, Int() $x, nccell() $c) is also<polyfill-yx> {
    my int32 ($yy, $xx) = ($y, $x);

    ncplane_polyfill_yx($!p, $yy, $xx, $c);
  }

  method printf_aligned (Int() $y, Int() $align, Str() $format) is also<printf-aligned> {
    my int32     $yy = $y;
    my ncalign_e $a  = $align;

    ncplane_printf_aligned($!p, $y, $a, $format, Str);
  }

  method printf_stained (Str() $format) is also<printf-stained> {
    ncplane_printf_stained($!p, $format, Str);
  }

  method printf_yx (Int() $y, Int() $x, Str() $format) is also<printf-yx> {
    my int32 ($yy, $xx) = ($y, $x);

    ncplane_printf_yx($!p, $y, $x, $format, Str);
  }

  method printf (Str() $format) {
    ncplane_printf($!p, $format, Str);
  }

  multi method pulse (Int $time, &fader) {
    samewith($time.Num, &fader);
  }
  multi method pulse (Rat $time, &fader) {
    samewith($time.Num, &fader);
  }
  multi method pulse (Num $time, &fader) {
    my $ts = timespec.new(
      tv_sec  => $time.Int,
      tv_usec => $time.&infix:<mod>(1) * 1e6
    );
    samewith($ts, &fader);
  }
  multi method pulse (
    timespec() $ts,
               &fader,
    Pointer    $curry  = Pointer
  ) {
    ncplane_pulse($!p, $ts, &fader, $curry);
  }

  method putc (nccell() $c) {
    ncplane_putc($!p, $c);
  }

  method putc_yx (Int() $y, Int() $x, nccell() $c) is also<putc-yx> {
    my int32 ($yy, $xx) = ($y, $x);

    ncplane_putc_yx($!p, $yy, $xx, $c);
  }

  method putchar (Str() $c) {
    ncplane_putchar($!p, $c);
  }

  method putchar_stained (Str() $c) is also<putchar-stained> {
    ncplane_putchar_stained($!p, $c);
  }

  method putegc_stained (
    Str() $gclust,
    Int() $sbytes = $gclust.encode.bytes
  )
    is also<putegc-stained>
  {
    my size_t $s = $sbytes;

    ncplane_putegc_stained($!p, $gclust, $s);
  }

  proto method putegc_yx (|)
    is also<putegc-yx>
  { * }

  multi method putegc_yx ($y, $x, $gclust, :$all = False) {
    my $sb;
    my $rv = samewith($y, $x, $gclust, $sb);
    $all.not ?? $rv !! ($rv, $sb);
  }
  multi method putegc_yx (
    Int() $y,
    Int() $x,
    Str() $gclust,
          $sbytes  is rw
  ) {
    my int32  ($yy, $xx) = ($y, $x);
    my size_t  $s        =  0;

    my $rv = ncplane_putegc_yx($!p, $yy, $xx, $gclust, $s);
    $sbytes = $s;
    $rv;
  }

  proto method putnstr_aligned (|)
    is also<putnstr-aligned>
  { * }

  multi method putnstr_aligned (
     $y,
     $str,
    :$align,
    :$encoding = 'utf8',
    :$size     = $str.encode($encoding).bytes
  ) {
    samewith($y, $align, $size, $str);
  }
  multi method putnstr_aligned (
    Int() $y,
    Int() $align,
    Int() $s,
    Str() $str
  ) {
    my int32     $yy = $y;
    my ncalign_e $a  = $align,
    my size_t    $ss = $s;

    ncplane_putnstr_aligned($!p, $y, $align, $s, $str);
  }

  method putstr_aligned (
    Int() $y,
    Int() $align,
    Str() $s
  )
    is also<putstr-aligned>
  {
    my int32     $yy = $y;
    my ncalign_e $a  = $align;

    ncplane_putstr_aligned($!p, $yy, $a, $s);
  }

  method putstr_stained (Str() $gclusters) is also<putstr-stained> {
    ncplane_putstr_stained($!p, $gclusters);
  }

  method putstr_yx (Int() $y, Int() $x, Str() $gclusters) is also<putstr-yx> {
    my int32 ($yy, $xx) = ($y, $x);

    ncplane_putstr_yx($!p, $yy, $xx, $gclusters);
  }

  method putstr (Str() $gclustarr) {
    ncplane_putstr($!p, $gclustarr);
  }

  multi method puttext (
     $y,
     $align,
     $text,
    :$encoding     = 'utf8',
    :size(:$bytes) = $text.encode($encoding).bytes
  ) {
    samewith($y, $align, $text, $bytes);
  }
  multi method puttext (Int() $y, Int() $align, Str() $text, Int() $bytes) {
    my int32     $yy = $y;
    my ncalign_e $a  = $align;
    my size_t    $b  = $bytes,

    ncplane_puttext($!p, $y, $a, $text, $b);
  }

  method ncplane_pututf32_yx (Int() $y, Int() $x, Int() $u) is also<ncplane-pututf32-yx> {
    my int32  ($yy, $xx) = ($y, $x);
    my uint32  $uu       =  $u;

    ncplane_pututf32_yx($!p, $y, $x, $u);
  }

  proto method ncplane_putwc_stained (|)
    is also<ncplane-putwc-stained>
  { * }

  multi method ncplane_putwc_stained (Str $s) {
    samewith( $s.comb.head.ord );
  }
  multi method ncplane_putwc_stained (Int $w)  {
    my wchar_t $ww = $w;

    ncplane_putwc_stained($!p, $ww);
  }

  proto method putwc_utf32 (|)
    is also<putwc-utf32>
  { * }

  multi method putwc_utf32 ($s is copy) {
    unless $s ~~ Str {
      X::Proto::InvalidType.new(
        ":Argument to { &?ROUTINE.name } MUST be Str-compatible!"
      ).throw unless $s.^can('Str');
      $s .= Str
    }
    samewith( $s.&utf8to32, $ )
  }
  multi method putwc_utf32 (
    CArray[wchar_t] $w,
                    $wchars is rw
  ) {
    my uint32 $ww = 0;

    my $r = ncplane_putwc_utf32($!p, $w, $ww);

    $r ?? ($wchars = $ww) !! Nil;
  }

  method putwc_yx (Int() $y, Int() $x, Int() $w)
    is also<putwc-yx>
  {
    my int32   ($yy, $xx) = ($y, $x);
    my wchar_t  $ww       =  $w;

    ncplane_putwc_yx($!p, $yy, $xx, $ww);
  }


  multi method putwc ($s)  {
    unless $s ~~ Str {
      X::Proto::InvalidType.new(
        ":Argument to { &?ROUTINE.name } MUST be Str-compatible!"
      ).throw unless $s.^can('Str');
      $s .= Str
    }
    nextsame($s.comb.head.ord);
  }
  multi method putwc (Int $w)  {
    my wchar_t $ww = $w;

    ncplane_putwc($!p, $ww);
  }

  proto method putwegc_stained (|)
    is also<putwegc-stained>
  { * }

  multi method putwegc_stained (
     $s,
    :$size     is copy,
    :$encoding          = 'utf8',
    :$auto              = False
  ) {
    unless $s ~~ Str {
      X::Proto::InvalidType.new(
        ":Argument to { &?ROUTINE.name } MUST be Str-compatible!"
      ).throw unless $s.^can('Str');
      $s .= Str
    }

    $s = $s.&utf8to32;
    $size //= $s.&nullTerminatedArraySize;

    samewith($s, $size);
  }
  multi method putwegc_stained (
    CArray[wchar_t] $gclust,
    Int()           $sbytes
  ) {
    my size_t $s = $sbytes;

    ncplane_putwegc_stained($!p, $gclust, $s);
  }

  proto method putwegc (|)
    is also<ncplane-putwegc>
  { * }

  multi method putwegc ($s) {
    unless $s ~~ Str {
      X::Proto::InvalidType.new(
        ":Argument to { &?ROUTINE.name } MUST be Str-compatible!"
      ).throw unless $s.^can('Str');
      $s .= Str
    }

    samewith($s.&utf8to32, $);
  }
  multi method putwegc (
    CArray[wchar_t] $gclust,
                    $sbytes is rw
  ) {
    my size_t $s = 0;

    my $r = ncplane_putwegc($!p, $gclust, $s);

    $r ?? ($sbytes = $s) !! Nil;
  }

  proto method putwstr_stained (|)
    is also<putwstr-stained>
  { * }

  multi method putwstr_stained (Str $str) {
    samewith( $str.&utf8to32 );
  }
  multi method putwstr_stained (CArray[wchar_t] $gclustarr) {
    ncplane_putwstr_stained($!p, $gclustarr);
  }

  proto method putwstr_aligned (|)
    is also<putwstr-aligned>
  { * }

  multi method putwstr_aligned (
           $y,
    Str()  $str,
          :$align,
          :$size   is copy
  ) {
    my $wstr = $str.&utf8to32;

    samewith($y, $align, $size, $wstr);
  }
  multi method putwstr_aligned (
    Int()           $y,
    Int()           $align,
    CArray[wchar_t] $str
  ) {
    my int32     $yy = $y;
    my ncalign_e $a  = $align;

    ncplane_putwstr_aligned($!p, $yy, $a, $str);
  }

  proto method putwstr_yx (|)
    is also<putwstr-yx>
  { * }

  multi method putwstr_yx ($y, $x, $str) {
    samewith($y, $x, $str.&utf8to32)
  }
  multi method putwstr_yx (Int() $y, Int() $x, CArray[wchar_t] $wstr) {
    my int32 ($yy, $xx) = ($y, $x);

    ncplane_putwstr_yx($!p, $yy, $xx, $wstr);
  }

  proto method putwstr (|)
  { * }

  multi method putwstr (Str() $str) {
    samewith( $str.&utf8to32 );
  }
  multi method putwstr (CArray[wchar_t] $gclustarr) {
    ncplane_putwstr($!p, $gclustarr);
  }

  multi method qrcode (
    Str    $data,
    Int    $ymax       is rw,
    Int    $xmax       is rw,
          :$encoding          = 'utf8',
    Int() :size(:$len)        = $data.encode($encoding).bytes
  ) {
    my $b  = $data.encode($encoding);
    my $ca = nativecast(
      Pointer,
      CArray[uint8].new( |$b, 0 )
    );

    samewith($ymax, $xmax, $ca, $len, :buf);
  }
  multi method qrcode (
    Int      $ymax is rw,
    Int      $xmax is rw,
    Pointer  $data,
    Int      $len,
            :buf(:$buffer) is required
  ) {
    my size_t  $l      =  $len;
    my uint32 ($y, $x) = ($ymax, $xmax);

    my $r = ncplane_qrcode($!p, $y, $x, $data, $len);
    ($ymax, $xmax) = ($x, $y);
    $r;
  }

  method reparent (ncplane() $newparent) {
    ncplane_reparent($!p, $newparent);
  }

  method ncplane_reparent_family (ncplane() $newparent)
    is also<ncplane-reparent-family>
  {
    ncplane_reparent_family($!p, $newparent);
  }

  # method ncplane_resize (
  #   int32    $keepy,
  #   int32    $keepx,
  #   uint32   $keepleny,
  #   uint32   $keeplenx,
  #   uint32   $yoff,
  #   uint32   $xoff,
  #   uint32   $ylen,
  #   uint32   $xlen
  # ) {
  #   ncplane_resize($!p, $keepy, $keepx, $keepleny, $keeplenx, $yoff, $xoff, $ylen, $xlen);
  # }

  method resize_marginalized is also<resize-marginalized> {
    ncplane_resize_marginalized($!p);
  }

  method resize_maximize is also<resize-maximize> {
    ncplane_resize_maximize($!p);
  }

  method resize_placewithin is also<resize-placewithin> {
    ncplane_resize_placewithin($!p);
  }

  #
  # method ncplane_rotate_ccw (ncplane $n) {
  #   ncplane_rotate_ccw($!p);
  # }

  # method ncplane_rotate_cw (ncplane $n) {
  #   ncplane_rotate_cw($!p);
  # }
  #
  # method ncplane_scrolling_p (ncplane $n) {
  #   ncplane_scrolling_p($!p);
  # }
  #
  # method ncplane_scrollup (
  #   ncplane $n,
  #   gint    $r
  # ) {
  #   ncplane_scrollup($!p, $r);
  # }
  #
  # method ncplane_scrollup_child (
  #   ncplane $n,
  #   ncplane $child
  # ) {
  #   ncplane_scrollup_child($!p, $child);
  # }
  #
  # method ncplane_set_autogrow (ncplane $n) {
  #   ncplane_set_autogrow($!p);
  # }
  #
  # method ncplane_set_base (
  #   ncplane  $n,
  #   Str      $egc,
  #   uint16_t $stylemask,
  #   uint64_t $channels
  # ) {
  #   ncplane_set_base($!p, $egc, $stylemask, $channels);
  # }
  #
  method set_base_cell (nccell() $c) {
    ncplane_set_base_cell($!p, $c);
  }
  #
  method set_scrolling (Int() $s) is also<set-scrolling> {
    my uint32 $ss = $s;

    ncplane_set_scrolling($!p, $s);
  }
  #
  # method ncplane_set_userptr (Pointer $opaque) {
  #   ncplane_set_userptr($!p, $opaque);
  # }
  #
  # method ncplane_styles (ncplane $n) {
  #   ncplane_styles($!p);
  # }
  #
  # method ncplane_translate (
  #   ncplane $src,
  #   ncplane $dst,
  #   gint    $y is rw,
  #   gint    $x is rw
  # ) {
  #   ncplane_translate($src, $dst, $y, $x);
  # }
  #
  # method ncplane_translate_abs (
  #   ncplane $n,
  #   gint    $y is rw,
  #   gint    $x is rw
  # ) {
  #   ncplane_translate_abs($!p, $y, $x);
  # }
  #
  # method ncplane_userptr (ncplane $n) {
  #   ncplane_userptr($!p);
  # }
  #
  # method ncplane_x (ncplane $n) {
  #   ncplane_x($!p);
  # }
  #
  # method ncplane_y (ncplane $n) {
  #   ncplane_y($!p);
  # }
  #
  # method ncplane_yx (
  #   ncplane $n,
  #   gint    $y is rw,
  #   gint    $x is rw
  # ) {
  #   ncplane_yx($!p, $y, $x);
  # }
  #
  # method ncplane_set_bchannel (
  #   ncplane  $n,
  #   uint32_t $channel
  # ) {
  #   ncplane_set_bchannel($!p, $channel);
  # }
  #
  # method ncplane_set_bg_alpha (
  #   ncplane $n,
  #   gint    $alpha
  # ) {
  #   ncplane_set_bg_alpha($!p, $alpha);
  # }
  #
  # method ncplane_set_bg_default (ncplane $n) {
  #   ncplane_set_bg_default($!p);
  # }
  #
  # method ncplane_set_bg_palindex (ncplane $n) {
  #   ncplane_set_bg_palindex($!p);
  # }
  #

  method set_bg_rgb (Int() $channel) {
    my uint32 $c = $channel;

    ncplane_set_bg_rgb($!p, $c);
  }

  #
  # method ncplane_set_bg_rgb8 (ncplane $n) {
  #   ncplane_set_bg_rgb8($!p);
  # }
  #
  # method ncplane_set_bg_rgb8_clipped (
  #   ncplane $n,
  #   gint    $r,
  #   gint    $g,
  #   gint    $b
  # ) {
  #   ncplane_set_bg_rgb8_clipped($!p, $r, $g, $b);
  # }
  #
  # method ncplane_set_channels (
  #   ncplane  $n,
  #   uint64_t $channels
  # ) {
  #   ncplane_set_channels($!p, $channels);
  # }
  #
  # method ncplane_set_fchannel (
  #   ncplane  $n,
  #   uint32_t $channel
  # ) {
  #   ncplane_set_fchannel($!p, $channel);
  # }
  #
  # method ncplane_set_fg_alpha (
  #   ncplane $n,
  #   gint    $alpha
  # ) {
  #   ncplane_set_fg_alpha($!p, $alpha);
  # }
  #
  # method ncplane_set_fg_default (ncplane $n) {
  #   ncplane_set_fg_default($!p);
  # }
  #
  # method ncplane_set_fg_palindex (ncplane $n) {
  #   ncplane_set_fg_palindex($!p);
  # }
  #
  method set_fg_rgb (Int() $channel) is also<set-fg-rgb> {
    my uint32 $c = $channel;

    ncplane_set_fg_rgb($!p, $c);
  }

  method set_fg_rgb8 (Int() $r, Int() $g, Int() $b) is also<set-fg-rgb8> {
    my uint32 ($rr, $gg, $bb) = ($r, $g, $b);

    ncplane_set_fg_rgb8($!p, $rr, $gg, $bb);
  }

  # method ncplane_set_fg_rgb8_clipped (
  #   ncplane $n,
  #   gint    $r,
  #   gint    $g,
  #   gint    $b
  # ) {
  #   ncplane_set_fg_rgb8_clipped($!p, $r, $g, $b);
  # }
  #
  # method ncplane_set_styles (ncplane $n) {
  #   ncplane_set_styles($!p);
  # }
  #
  multi method stain ($y, $x, $ylen, $xlen, $ul) {
    samewith($y, $x, $ylen, $xlen, $ul, $ul, $ul, $ul);
  }
  multi method stain (
    Int() $y,
    Int() $x,
    Int() $ylen,
    Int() $xlen,
    Int() $ul,
    Int() $ur,
    Int() $ll,
    Int() $lr
  ) {
    my int32  ($yy, $xx) = ($y, $x);
    my uint32 ($yl, $xl) = ($ylen, $xlen);

    my uint64 ($u1, $u2, $l1, $l2) = ($ul, $ur, $ll, $lr);

    ncplane_stain($!p, $yy, $xx, $yl, $xl, $u1, $u2, $l1, $l2);
  }
  #
  # method ncplane_vline_interp (
  #   ncplane  $n,
  #   nccell   $c,
  #   len      $c1,
  #   uint64_t $c2
  # ) {
  #   ncplane_vline_interp($!p, $c, $c1, $c2);
  # }
  #
  # method ncplane_vprintf_yx (
  #   ncplane $n,
  #   gint    $y,
  #   gint    $x,
  #   Str     $format,
  #   va_list $ap
  # ) {
  #   ncplane_vprintf_yx($!p, $y, $x, $format, $ap);
  # }
  #
  # method ncplane_dim_y (ncplane $n) {
  #   ncplane_dim_yexport($!p);
  # }
  #

  #
  # method ncplane_putchar_yxexport (
  #   ncplane $n,
  #   gint    $y,
  #   gint    $x,
  #   Str     $c
  # ) {
  #   ncplane_putchar_yxexport($!p, $y, $x, $c);
  # }
  #
  multi method putegc (Str() $gclust, :$all = False) {
    my $sb;

    my $rv = samewith($gclust, $sb);
    $all.not ?? $rv !! ($rv, $sb);
  }
  multi method putegc (Str() $gclust, $sbytes is rw) {
    my size_t $s = 0;

    my $rv = ncplane_putegc($!p, $gclust, $s);
    $sbytes = $s;
    $rv;
  }
  #
  # method ncplane_putnstr_yxexport (
  #   ncplane $n,
  #   gint    $y,
  #   gint    $x,
  #   size_t  $s,
  #   Str     $gclusters
  # ) {
  #   ncplane_putnstr_yxexport($!p, $y, $x, $s, $gclusters);
  # }
  #
  # method ncplane_putnstrexport (
  #   ncplane $n,
  #   size_t  $s,
  #   Str     $gclustarr
  # ) {
  #   ncplane_putnstrexport($!p, $s, $gclustarr);
  # }
  #
  # method ncplane_putwegc_yxexport (
  #   ncplane $n,
  #   gint    $y,
  #   gint    $x,
  #   wchar_t $gclust,
  #   size_t  $sbytes
  # ) {
  #   ncplane_putwegc_yxexport($!p, $y, $x, $gclust, $sbytes);
  # }
  #
  # method ncplane_resize_simpleexport (ncplane $n) {
  #   ncplane_resize_simpleexport($!p);
  # }
  #
  method rounded_box_sized (
    Int() $styles,
    Int() $channels,
    Int() $ylen,
    Int() $xlen,
    Int() $ctlword
  )
    is also<rounded-box-sized>
  {
    my uint16 $s = $styles;
    my uint64 $c = $channels;

    my uint32 ($y, $x, $cc) = ($ylen, $xlen, $ctlword);

    ncplane_rounded_box_sized($!p, $s, $c, $y, $x, $cc);
  }
  #
  method rounded_box (
    Int() $styles,
    Int() $channels,
    Int() $ystop,
    Int() $xstop,
    Int() $ctlword   = 0
  )
    is also<rounded-box>
  {
    my uint16 $s = $styles;
    my uint64 $c = $channels;

    my uint32 ($y, $x, $ctl) = ($ystop, $xstop, $ctlword);

    ncplane_rounded_box($!p, $s, $c, $y, $s, $ctl);
  }
  #
  # method ncplane_valignexport (
  #   ncplane   $n,
  #   ncalign_e $align,
  #   gint      $r
  # ) {
  #   ncplane_valignexport($!p, $align, $r);
  # }
  #
  # method ncplane_vlineexport (
  #   ncplane $n,
  #   nccell  $c
  # ) {
  #   ncplane_vlineexport($!p, $c);
  # }
  #
  # method ncplane_vprintf_aligned (
  #   gint      $y,
  #   ncalign_e $align,
  #   Str       $format,
  # ) {
  #   ncplane_vprintf_aligned($!p, $y, $align, $format, Str);
  # }
  #
  # method ncplane_vprintf_stained (
  #   ncplane $n,
  #   Str     $format,
  # ) {
  #   ncplane_vprintf_stained($!p, $format, $ap, Str);
  # }
  #
  # method ncplane_vprintfexport (
  #   ncplane $n,
  #   Str     $format,
  #   va_list $ap
  # ) {
  #   ncplane_vprintfexport($!p, $format, $ap);
  # }

  method set_name (Str() $name) is also<set-name> {
    ncplane_set_name($!p, $name);
  }

  method vline (nccell() $c, Int() $len) {
    my uint32 $l = $len;

    ncplane_vline($!p, $c, $l);
  }

  # cw: QoL imports from Terminal::NotCurses::Cells since they require a Plane
  #     argument

  use Terminal::NotCurses::Cells;

  constant CC = Terminal::NotCurses::Cells;

  method ascii_box_cells ($attr, $channels, :$raw = False) {
    CC.ascii_box($!p, $attr, $channels, :$raw);
  }

  method double_box_cells ($attr, $channels, :$raw = False) {
    CC.double_box($!p, $attr, $channels, :$raw);
  }

  method heavy_box_cells ($attr, $channels, :$raw = False) {
    CC.heavy_box($!p, $attr, $channels, :$raw);
  }

  method light_box_cells ($attr, $channels, :$raw = False) {
    CC.light_box($!p, $attr, $channels, :$raw);
  }

  # method load_box ($attr, $channels, :$raw = False) {
  #   CC.load_box($!p, $attr, $channels, :$raw);
  # }

  method rounded_box_cells ($attr, $channels, :$raw = False) {
    CC.rounded_box($!p, $attr, $channels, :$raw);
  }
}
