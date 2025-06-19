use v6;

class Terminal::NotCurses::Cell {
  has nccell $!c;

  submethod BUILD ( :cell(:$!c) )
  { }

  method Terminal::NotCurses::Definitions::nccell
  { $!c }

  method bchannel {
    nccell_bchannel($!c);
  }

  method bg_alpha {
    nccell_bg_alpha($!c);
  }

  method bg_default_p {
    nccell_bg_default_p($!c);
  }

  method bg_palindex_p {
    nccell_bg_palindex_p($!c);
  }

  method bg_palindex {
    nccell_bg_palindex($!c);
  }

  proto method bg_rgb8 (|)
  { * }

  multi method bg_rgb8 {
    samewith($, $, $);
  }
  multi method bg_rgb8 ($r is rw, $g is rw, $b is rw) {
    my gint ($rr, $gg, $bb) = 0 xx 3;

    nccell_bg_rgb8($!c, $rr, $gg, $bb);
    ($r, $g, $b) = ($rr, $gg, $bb)
  }

  method bg_rgb {
    nccell_bg_rgb($!c);
  }

  method cellcmp (ncplane() $n1, ncplane() $n2, nccell() $c2) {
    nccellcmp($n1, $!c, $n2, $c2);
  }

  method channels {
    nccell_channels($!c);
  }

  method cols {
    nccell_cols($!c);
  }

  method double_wide_p {
    nccell_double_wide_p($!c);
  }

  method extract ($p) {
    samewith($p, $, $);
  }
  method extract (
    ncplane() $p
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

  method fg_alpha {
    nccell_fg_alpha($!c);
  }

  method fg_default_p {
    nccell_fg_default_p($!c);
  }

  method fg_palindex_p {
    nccell_fg_palindex_p($!c);
  }

  method fg_palindex {
    nccell_fg_palindex($!c);
  }

  multi method fg_rgb8 {
    samewith($, $, $);
  }
  multi method fg_rgb8 ($r is rw, $g is rw, $b is rw) {
    my gint ($rr, $gg, $bb) = 0 xx 3;

    nccell_fg_rgb8($!c, $r, $g, $b);
  }

  method fg_rgb {
    nccell_fg_rgb($!c);
  }

  method init {
    nccell_init($!c);
  }

  method load_char (ncplane() $n, Str() $ch) {
    nccell_load_char($n, $!c, $ch);
  }

  method load_egc32 (ncplane() $n, Int() $egc) {
    my uint32 $e = $egc;

    nccell_load_egc32($n, $!c, $e);
  }

  method load_ucs32 (ncplane() $n, Int() $ucs) {
    my uint32 $u = $ucs;

    nccell_load_ucs32($n, $!c, $u);
  }

  method off_styles (Int() $bits) {
    my uint32 $b = $bits;

    nccell_off_styles($!c, $b);
  }

  method on_styles (Int() $bits) {
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

  method set_bchannel (Int() $channel) {
    my uint32 $c = $channel;

    nccell_set_bchannel($!c, $c);
  }

  method set_bg_alpha (Int() $val) {
    my uint32 $v = $val;

    nccell_set_bg_alpha($!c, $v);
  }

  method set_bg_default {
    nccell_set_bg_default($!c);
  }

  method set_bg_palindex (Int() $val) {
    my uint32 $v = $val;

    nccell_set_bg_palindex($!c, $v);
  }

  method set_bg_rgb8_clipped (Int() $r, Int() $g, Int() $b) {
    my gint ($rr, $gg, $bb) = ($r, $g, $b);

    nccell_set_bg_rgb8_clipped($!c, $rr, $gg, $bb);
  }

  method set_bg_rgb8 {
    nccell_set_bg_rgb8($!c);
  }

  method set_bg_rgb (Int() $channel) {
    my uint32 $c = $channel;

    nccell_set_bg_rgb($!c, $c);
  }

  method set_channels (Int() $channels) {
    my uint64 $c = $channels

    nccell_set_channels($!c, $c);
  }

  method set_fchannel (Int() $channel) {
    my uint32 $c = $channel;

    nccell_set_fchannel($!c, $c);
  }

  method set_fg_alpha (Int() $val) {
    my uint32 $v = $val;

    nccell_set_fg_alpha($!c, $v);
  }

  method set_fg_default {
    nccell_set_fg_default($!c);
  }

  method set_fg_palindex (Int() $val) {
    my uint32 $v = $val;

    nccell_set_fg_palindex($!c, $v);
  }

  method set_fg_rgb8_clipped (Int() $r, Int() $g, Int() $b) {
    my gint ($rr, $gg, $bb) = ($r, $g, $b);

    nccell_set_fg_rgb8_clipped($!c, $rr, $gg, $bb);
  }

  method set_fg_rgb8 {
    nccell_set_fg_rgb8($!c);
  }

  method set_fg_rgb (Int() $channel) {
    my uint32 $c = $channel;

    nccell_set_fg_rgb($!c, $channel);
  }

  method set_styles (Int() $bits) {
    my uint32 $b = $bits;

    nccell_set_styles($!c, $b);
  }

  method strdup (ncplane() $n) {
    nccell_strdup($n, $!c);
  }

  method styles {
    nccell_styles($!c);
  }

  method wide_left_p {
    nccell_wide_left_p($!c);
  }

  method wide_right_p {
    nccell_wide_right_p($!c);
  }

}
