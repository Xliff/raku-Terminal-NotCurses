use v6;

use NativeCall;
use Method::Also;

use Terminal::NotCurses::Raw::Types;
use Terminal::NotCurses::Raw::Cell;

use Terminal::NotCurses::Channel;

class Terminal::NotCurses::Cell {
  has nccell $!c handles<
    gcluster
    gcluster_backstop gcluster-backstop
    width
    stylemask
  >;

  submethod BUILD ( :$cell ) {
    $!c = $cell if $cell;
  }

  submethod TWEAK {
    $!c //= nccell.new;
  }

  method Terminal::NotCurses::Raw::Structs::nccell
    is also<nccell>
  { $!c }

  multi method new (nccell $cell) {
    $cell ?? self.bless( :$cell ) !! Nil;
  }
  multi method new {
    samewith(nccell.new);
  }

  # cw: Until a better alternative can be found.
  sub nc_wcwidth (uint32)
    returns uint32
    is      native("c",v6)
    is      export
    is      symbol('wcwidth')
  { * }

  multi method new (Str() $s) {
    my ($c, $o) = ($s.comb.head.ord, nccell.new);
    ( $o.gcluster, $o.width ) = ( $c, nc_wcwidth($c) );
    samewith($o);
  }

  method bchannel {
    nccell_bchannel($!c);
  }

  method bg_alpha is also<bg-alpha> {
    nccell_bg_alpha($!c);
  }

  method bg_default_p is also<bg-default-p> {
    nccell_bg_default_p($!c);
  }

  method bg_palindex_p is also<bg-palindex-p> {Terminal::NotCurses::Plane
    nccell_bg_palindex_p($!c);
  }

  method bg_palindex is also<bg-palindex> {
    nccell_bg_palindex($!c);
  }

  proto method bg_rgb8 (|)
    is also<bg-rgb8>
  { * }

  multi method bg_rgb8 {
    samewith($, $, $);
  }
  multi method bg_rgb8 ($r is rw, $g is rw, $b is rw) {
    my int32 ($rr, $gg, $bb) = 0 xx 3;

    nccell_bg_rgb8($!c, $rr, $gg, $bb);
    ($r, $g, $b) = ($rr, $gg, $bb)
  }

  method bg_rgb is also<bg-rgb> {
    nccell_bg_rgb($!c);
  }

  method cellcmp (ncplane() $n1, ncplane() $n2, nccell() $c2) {
    nccellcmp($n1, $!c, $n2, $c2);
  }

  method channels ( :$raw = False ) {
    my $c = nccell_channels($!c);
    return $c if $raw;
    Terminal::NotCurses::Channel($c);
  }

  method cols {
    nccell_cols($!c);
  }

  method double_wide_p is also<double-wide-p> {
    nccell_double_wide_p($!c);
  }

  multi method extract ($p) {
    samewith($p, $, $);
  }
  multi method extract (
    ncplane() $p,
              $stylemask is rw,
              $channels  is rw
  ) {
    my uint16 $s = 0;
    my uint64 $c = 0;

    my $rv = nccell_extract($p, $!c, $s, $c);

    $rv ?? ($stylemask = $s, $channels = $c) !! Nil
  }

  method fchannel {
    nccell_fchannel($!c);
  }

  method fg_alpha is also<fg-alpha> {
    nccell_fg_alpha($!c);
  }

  method fg_default_p is also<fg-default-p> {
    nccell_fg_default_p($!c);
  }

  method fg_palindex_p is also<fg-palindex-p> {
    nccell_fg_palindex_p($!c);
  }

  method fg_palindex is also<fg-palindex> {
    nccell_fg_palindex($!c);
  }

  proto method fg_rgb8 (|)
    is also<fg-rgb8>
  { * }

  multi method fg_rgb8 {
    samewith($, $, $);
  }
  multi method fg_rgb8 ($r is rw, $g is rw, $b is rw) {
    my int32 ($rr, $gg, $bb) = 0 xx 3;

    nccell_fg_rgb8($!c, $r, $g, $b);
  }

  method fg_rgb is also<fg-rgb> {
    nccell_fg_rgb($!c);
  }

  method init {
    nccell_init($!c);
  }

  method load (ncplane() $n, Str() $str) {
    nccell_load($n, $!c, $str);
  }

  method load_char (ncplane() $n, Str() $ch) is also<load-char> {
    nccell_load_char($n, $!c, $ch);
  }

  method load_egc32 (ncplane() $n, Int() $egc) is also<load-egc32> {
    my uint32 $e = $egc;

    nccell_load_egc32($n, $!c, $e);
  }

  method load_ucs32 (ncplane() $n, Int() $ucs) is also<load-ucs32> {
    my uint32 $u = $ucs;

    nccell_load_ucs32($n, $!c, $u);
  }

  method off_styles (Int() $bits) is also<off-styles> {
    my uint32 $b = $bits;

    nccell_off_styles($!c, $b);
  }

  method on_styles (Int() $bits) is also<on-styles> {
    my uint32 $b = $bits;

    nccell_on_styles($!c, $b);
  }

  method prime (
    ncplane()  $n,
    Str()      $gcluster,
    Int()      $stylemask,
    Int()      $channels
  ) {
    my uint16 $s = $stylemask;
    my uint64 $c = $channels;

    nccell_prime($n, $!c, $gcluster, $s, $c);
  }

  method release (ncplane() $p) {
    nccell_release($p, $!c);
  }

  method set_bchannel (Int() $channel) is also<set-bchannel> {
    my uint32 $c = $channel;

    nccell_set_bchannel($!c, $c);
  }

  method set_bg_alpha (Int() $val) is also<set-bg-alpha> {
    my uint32 $v = $val;

    nccell_set_bg_alpha($!c, $v);
  }

  method set_bg_default is also<set-bg-default> {
    nccell_set_bg_default($!c);
  }

  method set_bg_palindex (Int() $val) is also<set-bg-palindex> {
    my uint32 $v = $val;

    nccell_set_bg_palindex($!c, $v);
  }

  method set_bg_rgb8_clipped (Int() $r, Int() $g, Int() $b) is also<set-bg-rgb8-clipped> {
    my uint32 ($rr, $gg, $bb) = ($r, $g, $b);

    nccell_set_bg_rgb8_clipped($!c, $rr, $gg, $bb);
  }

  method set_bg_rgb8 (Int() $r, Int() $g, Int() $b) is also<set-bg-rgb8> {
    my uint32 ($rr, $gg, $bb) = ($r, $g, $b);

    nccell_set_bg_rgb8($!c, $rr, $gg, $bb);
  }

  method set_bg_rgb (Int() $channel) is also<set-bg-rgb> {
    my uint32 $c = $channel;

    nccell_set_bg_rgb($!c, $c);
  }

  method set_channels (Int() $channels) is also<set-channels> {
    my uint64 $c = $channels;

    nccell_set_channels($!c, $c);
  }

  method set_fchannel (Int() $channel) is also<set-fchannel> {
    my uint32 $c = $channel;

    nccell_set_fchannel($!c, $c);
  }

  method set_fg_alpha (Int() $val) is also<set-fg-alpha> {
    my uint32 $v = $val;

    nccell_set_fg_alpha($!c, $v);
  }

  method set_fg_default is also<set-fg-default> {
    nccell_set_fg_default($!c);
  }

  method set_fg_palindex (Int() $val) is also<set-fg-palindex> {
    my uint32 $v = $val;

    nccell_set_fg_palindex($!c, $v);
  }

  method set_fg_rgb8_clipped (Int() $r, Int() $g, Int() $b) is also<set-fg-rgb8-clipped> {
    my uint32 ($rr, $gg, $bb) = ($r, $g, $b);

    nccell_set_fg_rgb8_clipped($!c, $rr, $gg, $bb);
  }

  method set_fg_rgb8 (Int() $r, Int() $g, Int() $b) is also<set-fg-rgb8> {
    my uint32 ($rr, $gg, $bb) = ($r, $g, $b);

    nccell_set_fg_rgb8($!c, $rr, $gg, $bb);
  }

  method set_fg_rgb (Int() $channel) is also<set-fg-rgb> {
    my uint32 $c = $channel;

    nccell_set_fg_rgb($!c, $channel);
  }

  method set_styles (Int() $bits) is also<set-styles> {
    my uint32 $b = $bits;

    nccell_set_styles($!c, $b);
  }

  method strdup (ncplane() $n) {
    nccell_strdup($n, $!c);
  }

  method styles {
    nccell_styles($!c);
  }

  method wide_left_p is also<wide-left-p> {
    nccell_wide_left_p($!c);
  }

  method wide_right_p is also<wide-right-p> {
    nccell_wide_right_p($!c);
  }

}
