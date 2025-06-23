use v6.c;

use NativeCall;

use Terminal::NotCurses::Raw::Definitions;
use Terminal::NotCurses::Raw::Structs;

unit package Ternminal::NotCurses::Raw::Cells;

sub nccells_ascii_box (
  ncplane  $n,
  uint16   $attr,
  uint64   $channels,
  nccell   $ul,
  nccell   $ur,
  nccell   $ll,
  nccell   $lr,
  nccell   $hl,
  nccell   $vl
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('nccells_ascii_box_export')
{ * }

sub nccells_double_box (
  ncplane  $n,
  uint16   $attr,
  uint64   $channels,
  nccell   $ul,
  nccell   $ur,
  nccell   $ll,
  nccell   $lr,
  nccell   $hl,
  nccell   $vl
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('nccells_double_box_export')
{ * }

sub nccells_heavy_box (
  ncplane  $n,
  uint16   $attr,
  uint64   $channels,
  nccell   $ul,
  nccell   $ur,
  nccell   $ll,
  nccell   $lr,
  nccell   $hl,
  nccell   $vl
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('nccells_heavy_box_export')
{ * }

sub nccells_light_box (
  ncplane  $n,
  uint16   $attr,
  uint64   $channels,
  nccell   $ul,
  nccell   $ur,
  nccell   $ll,
  nccell   $lr,
  nccell   $hl,
  nccell   $vl
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('nccells_light_box_export')
{ * }

sub nccells_load_box (
  ncplane  $n,
  uint16   $styles,
  uint64   $channels,
  nccell   $ul,
  nccell   $ur,
  nccell   $ll,
  nccell   $lr,
  nccell   $hl,
  nccell   $vl,
  Str      $gclusters
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('nccells_load_box_export')
{ * }

sub nccells_rounded_box (
  ncplane  $n,
  uint16   $attr,
  uint64   $channels,
  nccell   $ul,
  nccell   $ur,
  nccell   $ll,
  nccell   $lr,
  nccell   $hl,
  nccell   $vl
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('nccells_rounded_box_export')
{ * }
