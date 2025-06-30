use v6.c;

use Terminal::NotCurses::Raw::Types;
use Terminal::NotCurses::Raw::Cells;

use Terminal::NotCurses::Cell;

class Terminal::NotCurses::Cells {

  proto method ascii_box (|)
  { * }

  multi method ascii_box (
    ncplane()  $n,
    Int()      $attr,
    Int()      $channels,
              :$raw       = False
  ) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = Terminal::NotCurses::Cell.new xx 6;

    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
  }
  multi method ascii_box (
    ncplane()  $n,
    Int()      $attr,
    Int()      $channels,
    nccell()   $ul,
    nccell()   $ur,
    nccell()   $ll,
    nccell()   $lr,
    nccell()   $hl,
    nccell()   $vl,
              :$raw       = False
  ) {
    my uint16 $a = $attr;
    my uint64 $c = $channels;

    my $rv = nccells_ascii_box($n, $a, $c, $ul, $ur, $ll, $lr, $hl, $vl);
    return -1 if $rv == -1;
    my @c = ($ul, $ur, $ll, $lr, $hl, $vl);
    return @c if $raw;
    @c.map({  Terminal::NotCurses::Cell.new($_) }).cache;
  }

  proto method double_box (|)
  { * }

  multi method double_box (
    ncplane()  $n,
    Int()      $attr,
    Int()      $channels,
              :$raw       = False
  ) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = Terminal::NotCurses::Cell.new xx 6;

    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
  }
  multi method double_box (
    ncplane()  $n,
    Int()      $attr,
    Int()      $channels,
    nccell()   $ul,
    nccell()   $ur,
    nccell()   $ll,
    nccell()   $lr,
    nccell()   $hl,
    nccell()   $vl,
              :$raw       = False
  ) {
    my uint16 $a = $attr;
    my uint64 $c = $channels;

    my $rv = nccells_double_box($n, $a, $c, $ul, $ur, $ll, $lr, $hl, $vl);
    return -1 if $rv == -1;
    my @c = ($ul, $ur, $ll, $lr, $hl, $vl);
    return @c if $raw;
    @c.map({  Terminal::NotCurses::Cell.new($_) }).cache;
  }

  proto method heavy_box (|)
  { * }

  multi method heavy_box (
    ncplane()  $n,
    Int()      $attr,
    Int()      $channels,
              :$raw       = False
  ) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = Terminal::NotCurses::Cell.new xx 6;

    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
  }
  multi method heavy_box (
    ncplane()  $n,
    Int()      $attr,
    Int()      $channels,
    nccell()   $ul,
    nccell()   $ur,
    nccell()   $ll,
    nccell()   $lr,
    nccell()   $hl,
    nccell()   $vl,
              :$raw       = False
  ) {
    my uint16 $a = $attr;
    my uint64 $c = $channels;

    my $rv = nccells_heavy_box($n, $a, $c, $ul, $ur, $ll, $lr, $hl, $vl);
    return -1 if $rv == -1;
    my @c = ($ul, $ur, $ll, $lr, $hl, $vl);
    return @c if $raw;
    @c.map({  Terminal::NotCurses::Cell.new($_) }).cache;
  }

  proto method light_box (|)
  { * }

  multi method light_box (
    ncplane()  $n,
    Int()      $attr,
    Int()      $channels,
              :$raw       = False
  ) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = Terminal::Curses::NotCell.new xx 6;

    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
  }
  multi method light_box (
    ncplane()  $n,
    Int()      $attr,
    Int()      $channels,
    nccell()   $ul,
    nccell()   $ur,
    nccell()   $ll,
    nccell()   $lr,
    nccell()   $hl,
    nccell()   $vl,
              :$raw       = False
  ) {
    my uint16 $a = $attr;
    my uint64 $c = $channels;

    my $rv = nccells_light_box($n, $a, $c, $ul, $ur, $ll, $lr, $hl, $vl);
    return -1 if $rv == -1;
    my @c = ($ul, $ur, $ll, $lr, $hl, $vl);
    return @c if $raw;
    @c.map({  Terminal::NotCurses::Cell.new($_) }).cache
  }

  # cw: Verify load_box is supposed to work this way.
  proto method load_box (|)
  { * }

  multi method load_box (
    ncplane() $n,
    Int()     $attr,
    Int()     $channels,
    Str()     $s
  ) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = Terminal::NotCurses::Cell.new xx 6;
    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl, $s);
    [ $ul, $ur, $ll, $lr, $hl, $vl ]
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

  multi method rounded_box (
    ncplane()  $n,
    Int()      $attr,
    Int()      $channels,
              :$raw       = False
  ) {
    my ($ul, $ur, $ll, $lr, $hl, $vl) = Terminal::NotCurses::Cell.new xx 6;

    samewith($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
  }
  multi method rounded_box (
    ncplane()  $n,
    Int()      $attr,
    Int()      $channels,
    nccell()   $ul,
    nccell()   $ur,
    nccell()   $ll,
    nccell()   $lr,
    nccell()   $hl,
    nccell()   $vl,
              :$raw       = False
  ) {
    my uint16 $a = $attr;
    my uint64 $c = $channels;

    my $rv = nccells_rounded_box($n, $a, $c, $ul, $ur, $ll, $lr, $hl, $vl);
    return -1 if $rv == -1;
    my @c = ($ul, $ur, $ll, $lr, $hl, $vl);
    return @c if $raw;
    @c.map({  Terminal::NotCurses::Cell.new($_) }).cache;
  }

}
