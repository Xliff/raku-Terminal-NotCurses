use v6;

use NativeCall;

#use Terminal::NotCurses::Raw::Types;
use Terminal::NotCurses::Raw::Definitions;
use Terminal::NotCurses::Raw::Enums;
use Terminal::NotCurses::Raw::Structs;

use Terminal::NotCurses::Raw::Visual;

class Terminal::NotCurses::Visual {
  has ncvisual $!v;

  submethod BUILD ( :visual(:$!v) ) { }

  method Terminal::NotCurses::Raw::Definitions::ncvisual
  { $!v }

  method new (ncvisual $visual) {
    $visual ?? self.bless( :$visual ) !! Nil;
  }

  proto method from_bgra (|)
  { * }

  multi method from_bgra (@data, $rows, $rowstride, $cols) {
    samewith(ArrayToCArray(@data), $rows, $rowstride);
  }
  multi method from_bgra (
    CArray[uint32] $bgra,
    Int()          $rows,
    Int()          $rowstride,
    Int()          $cols
  ) {
    my int32 ($r, $rs, $c) = ($rows, $rowstride, $cols);

    my $visual = ncvisual_from_bgra($bgra, $r, $rs, $c);

    $visual ?? self.bless( :$visual ) !! Nil
  }

  method ncvisual_from_file (Str() $file) {
    my $visual = ncvisual_from_file($file);

    $visual ?? self.bless( :$visual ) !! Nil
  }

  method ncvisual_from_palidx (
    CArray[uint8]  $data,
    Int()          $rows,
    Int()          $rowstride,
    Int()          $cols,
    Int()          $palsize,
    Int()          $pstride,
    CArray[uint32] $palette
  ) {
    my int32 ($r, $rs, $c, $p, $ps) =
      ($rows, $rowstride, $cols, $palsize, $pstride);

    my $visual = ncvisual_from_palidx($data, $r, $rs, $c, $p, $ps);

    $visual ?? self.bless( :$visual ) !! Nil
  }

  method from_plane (
    ncplane() $n,
    Int()     $blit,
    Int()     $begy,
    Int()     $begx
  ) {
    my ncblitter_e $b = $blit;

    my int32 ($y, $x) = ($begy, $begx);

    my $visual = ncvisual_from_plane($n, $b, $y, $x);

    $visual ?? self.bless( :$visual ) !! Nil
  }

  proto method ncvisual_from_rgb_loose (|)
  { * }

  multi method ncvisual_from_rgb_loose (
    @rgba,
    $rows,
    $rowstride,
    $cols,
    $alpha
  ) {
    samewith(
      ArrayToCArray(uint8, @rgba),
      $rows,
      $rowstride,
      $cols,
      $alpha
    );
  }
  multi method ncvisual_from_rgb_loose (
    CArray[uint8] $rgba,
    Int()         $rows,
    Int()         $rowstride,
    Int()         $cols,
    Int()         $alpha
  ) {
    my int32 ($r, $rs, $c, $a) = ($rows, $rowstride, $cols, $alpha);

    my $visual = ncvisual_from_rgb_loose($rgba, $r, $rs, $c, $a);

    $visual ?? self.bless( :$visual ) !! Nil
  }

  method ncvisual_from_rgb_packed (
    CArray[uint8] $rgba,
    Int()         $rows,
    Int()         $rowstride,
    Int()         $cols,
    Int()         $alpha
  ) {
    my int32 ($r, $rs, $c, $a) = ($rows, $rowstride, $cols, $alpha);

    my $visual = ncvisual_from_rgb_packed($rgba, $r, $rs, $c, $a);

    $visual ?? self.bless( :$visual ) !! Nil
  }

  proto method from_rgba (|)
  { * }

  multi method from_rgba (@data, $rows, $rowstride, $cols) {
    samewith( ArrayToCArray(uint32, $rows, $rowstride, $cols) );
  }
  multi method from_rgba (
    CArray[uint32] $rgba,
    Int()          $rows,
    Int()          $rowstride,
    Int()          $cols
  ) {
    my int32 ($r, $rs, $c) = ($rows, $rowstride, $cols);

    my $visual = ncvisual_from_rgba($rgba, $r, $rs, $c);

    $visual ?? self.bless( :$visual ) !! Nil
  }

  method from_sixel (Str() $s) {
    my $visual = ncvisual_from_sixel($s);

    $visual ?? self.bless( :$visual ) !! Nil
  }

  proto method at_yx (|)
  { * }

  multi method at_yx ($y, $x) {
    samewith($y, $x, $);
  }
  multi method at_yx (Int() $y, Int() $x, $pixel is rw) {
    my int32  ($yy, $xx) = ($y, $x);
    my uint32  $p        =  0;

    my $rv = ncvisual_at_yx($!v, $y, $x, $p);

    $rv ?? ($pixel = $p) !! Nil;
  }

  method blit (notcurses() $nc, ncvisual_options() $vopts) {
    ncvisual_blit($nc, $!v, $vopts);
  }

  method decode {
    ncvisual_decode($!v);
  }

  method decode_loop {
    ncvisual_decode_loop($!v);
  }

  method destroy {
    ncvisual_destroy($!v);
  }

  method geom (notcurses() $nc, ncvisual_options() $vopts, ncvgeom() $geom) {
    ncvisual_geom($!v, $nc, $vopts, $geom);
  }

  method media_defblitter (Int() $scale) {
    my ncscale_e $s = $scale;

    ncvisual_media_defblitter($!v, $s);
  }

  method polyfill_yx (Int() $y, Int() $x, Int() $rgba) {
    my int32   ($yy, $xx) = ($y, $x);
    my uint32  $r        =  $rgba;

    ncvisual_polyfill_yx($!v, $yy, $xx, $r);
  }

  method resize (Int() $rows, Int() $cols) {
    my int32   ($r, $c) = ($rows, $cols);

    ncvisual_resize($!v, $rows, $cols);
  }

  method resize_noninterpolative (Int() $rows, Int() $cols) {
    my int32   ($r, $c) = ($rows, $cols);

    ncvisual_resize_noninterpolative($!v, $rows, $cols);
  }

  method rotate (Num() $rads) {
    my num32 $r = $rads;

    ncvisual_rotate($!v, $r);
  }

  method set_yx (Int() $y, Int() $x, Int() $pixel) {
    my int32   ($yy, $xx) = ($y, $x);
    my uint32  $p        =   $pixel;

    ncvisual_set_yx($!v, $yy, $xx, $pixel);
  }

  method stream (
    notcurses()        $nc,
    Num()              $timescale,
                       &streamer,
    ncvisual_options() $vopts,
    Pointer            $curry
  ) {
    my num32 $t = $timescale;

    ncvisual_stream($nc, $!v, $t, &streamer, $vopts, $curry);
  }

  method subtitle_plane (ncplane() $parent) {
    ncvisual_subtitle_plane($parent, $!v);
  }

}
