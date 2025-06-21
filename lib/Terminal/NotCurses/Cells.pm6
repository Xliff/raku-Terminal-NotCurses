use v6.c;

use Terminal::NotCurses::Raw::Types;
use Terminal::NotCurses::Raw::Cells;

class Terminal::NotCurses::Cells {

  proto method ascii_box (|)
  { * }

  multi method ascii_box (ncplane() $n, Int() $attr, Int() $channels) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = Terminal::Curses::Cell.new xx 6;
    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
    ($ul, $ur, $ll, $lr, $hl, $vl)
  }
  multi method ascii_box (
    ncplane()  $n,
    Int()      $attr,
    Int()      $channels,
              :$raw       is required where *.so
  ) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = nccell.new xx 6;
    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
    ($ul, $ur, $ll, $lr, $hl, $vl)
  }
  multi method ascii_box (
    ncplane() $n,
    Int()     $attr,
    Int()     $channels,
    nccell()  $ul,
    nccell()  $ur,
    nccell()  $ll,
    nccell()  $lr,
    nccell()  $hl,
    nccell()  $vl
  ) {
    my uint16 $a = $attr;
    my uint64 $c = $channels;

    nccells_ascii_box($n, $a, $c, $ul, $ur, $ll, $lr, $hl, $vl);
  }

  proto method double_box (|)
  { * }

  multi method double_box (ncplane() $n, Int() $attr, Int() $channels) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = Terminal::Curses::Cell.new xx 6;
    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
    ($ul, $ur, $ll, $lr, $hl, $vl)
  }
  multi method double_box (
    ncplane()  $n,
    Int()      $attr,
    Int()      $channels,
              :$raw       is required where *.so
  ) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = nccell.new xx 6;
    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
    ($ul, $ur, $ll, $lr, $hl, $vl)
  }
  multi method double_box (
    ncplane() $n,
    Int()     $attr,
    Int()     $channels,
    nccell()  $ul,
    nccell()  $ur,
    nccell()  $ll,
    nccell()  $lr,
    nccell()  $hl,
    nccell()  $vl
  ) {
    my uint16 $a = $attr;
    my uint64 $c = $channels;

    nccells_double_box($n, $a, $c, $ul, $ur, $ll, $lr, $hl, $vl);
  }

  proto method heavy_box (|)
  { * }

  multi method heavy_box (ncplane() $n, Int() $attr, Int() $channels) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = Terminal::Curses::Cell.new xx 6;
    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
    ($ul, $ur, $ll, $lr, $hl, $vl)
  }
  multi method heavy_box (
    ncplane()  $n,
    Int()      $attr,
    Int()      $channels,
              :$raw       is required where *.so
  ) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = nccell.new xx 6;
    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
    ($ul, $ur, $ll, $lr, $hl, $vl)
  }
  multi method heavy_box (
    ncplane() $n,
    Int()     $attr,
    Int()     $channels,
    nccell()  $ul,
    nccell()  $ur,
    nccell()  $ll,
    nccell()  $lr,
    nccell()  $hl,
    nccell()  $vl
  ) {
    my uint16 $a = $attr;
    my uint64 $c = $channels;

    nccells_heavy_box($n, $a, $c, $ul, $ur, $ll, $lr, $hl, $vl);
  }

  proto method light_box (|)
  { * }

  multi method light_box (ncplane() $n, Int() $attr, Int() $channels) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = Terminal::Curses::Cell.new xx 6;
    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
    ($ul, $ur, $ll, $lr, $hl, $vl)
  }
  multi method light_box (
    ncplane()  $n,
    Int()      $attr,
    Int()      $channels,
              :$raw       is required where *.so
  ) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = nccell.new xx 6;
    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
    ($ul, $ur, $ll, $lr, $hl, $vl)
  }
  multi method light_box (
    ncplane() $n,
    Int()     $attr,
    Int()     $channels,
    nccell()  $ul,
    nccell()  $ur,
    nccell()  $ll,
    nccell()  $lr,
    nccell()  $hl,
    nccell()  $vl
  ) {
    my uint16 $a = $attr;
    my uint64 $c = $channels;

    nccells_light_box($n, $a, $c, $ul, $ur, $ll, $lr, $hl, $vl);
  }

  proto method load_box (|)
  { * }

  multi method load_box (
    ncplane() $n,
    Int()     $attr,
    Int()     $channels,
    Str()     $s
  ) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = Terminal::Curses::Cell.new xx 6;
    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl, $s);
    ($ul, $ur, $ll, $lr, $hl, $vl)
  }
  multi method load_box (
    ncplane()  $n,
    Int()      $attr,
    Int()      $channels,
    Str()      $s,
              :$raw       is required where *.so
  ) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = nccell.new xx 6;
    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl, $s);
    ($ul, $ur, $ll, $lr, $hl, $vl)
  }
  multi method load_box (
    ncplane() $n,
    Int()     $attr,
    Int()     $channels,
    nccell()  $ul,
    nccell()  $ur,
    nccell()  $ll,
    nccell()  $lr,
    nccell()  $hl,
    nccell()  $vl,
    Str()     $gclusters
  ) {
    my uint16 $a = $attr;
    my uint64 $c = $channels;

    nccells_load_box($n, $a, $c, $ul, $ur, $ll, $lr, $hl, $vl, $gclusters);
  }

  proto method rounded_box (|)
  { * }

  multi method rounded_box (ncplane() $n, Int() $attr, Int() $channels) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = Terminal::Curses::Cell.new xx 6;
    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
    ($ul, $ur, $ll, $lr, $hl, $vl)
  }
  multi method rounded_box (
    ncplane()  $n,
    Int()      $attr,
    Int()      $channels,
              :$raw       is required where *.so
  ) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = nccell.new xx 6;
    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
    ($ul, $ur, $ll, $lr, $hl, $vl)
  }
  multi method rounded_box (
    ncplane() $n,
    Int()     $attr,
    Int()     $channels,
    nccell()  $ul,
    nccell()  $ur,
    nccell()  $ll,
    nccell()  $lr,
    nccell()  $hl,
    nccell()  $vl
  ) {
    my uint16 $a = $attr;
    my uint64 $c = $channels;

    nccells_rounded_box($n, $a, $c, $ul, $ur, $ll, $lr, $hl, $vl);
  }

}
