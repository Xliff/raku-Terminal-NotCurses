use v6.c;

use NativeCall;

use Terminal::NotCurses::Raw::Definitions;
use Terminal::NotCurses::Raw::Structs;

unit package Terminal::NotCurses::Raw::Channels;

sub ncchannels_bchannel (uint64 $channels)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_bchannel_export')
{ * }

sub ncchannels_bg_alpha (uint64 $channels)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_bg_alpha_export')
{ * }

sub ncchannels_bg_default_p (uint64 $channels)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_bg_default_p_export')
{ * }

sub ncchannels_bg_palindex_p (uint64 $channels)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_bg_palindex_p_export')
{ * }

sub ncchannels_bg_palindex (uint64 $channels)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_bg_palindex_export')
{ * }

sub ncchannels_bg_rgb8 (
  uint64 $channels,
  int32  $r         is rw,
  int32  $g         is rw,
  int32  $b         is rw
)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_bg_rgb8_export')
{ * }

sub ncchannels_bg_rgb_p (uint64 $channels)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_bg_rgb_p_export')
{ * }

sub ncchannels_bg_rgb (uint64 $channels)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_bg_rgb_export')
{ * }

sub ncchannels_channels (uint64 $channels)
  returns uint64
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_channels_export')
{ * }

sub ncchannels_combine (
  uint32 $fchan,
  uint32 $bchan
)
  returns uint64
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_combine_export')
{ * }

sub ncchannels_fchannel (uint64 $channels)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_fchannel_export')
{ * }

sub ncchannels_fg_alpha (uint64 $channels)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_fg_alpha_export')
{ * }

sub ncchannels_fg_default_p (uint64 $channels)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_fg_default_p_export')
{ * }

sub ncchannels_fg_palindex_p (uint64 $channels)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_fg_palindex_p_export')
{ * }

sub ncchannels_fg_palindex (uint64 $channels)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_fg_palindex_export')
{ * }

sub ncchannels_fg_rgb8 (
  uint64 $channels,
  uint32 $r         is rw,
  uint32 $g         is rw,
  uint32 $b         is rw
)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_fg_rgb8_export')
{ * }

sub ncchannels_fg_rgb_p (uint64 $channels)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_fg_rgb_p_export')
{ * }

sub ncchannels_fg_rgb (uint64 $channels)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_fg_rgb_export')
{ * }

sub ncchannels_reverse (uint64 $channels)
  returns uint64
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_reverse_export')
{ * }

sub ncchannels_set_bchannel (
  CArray[uint64] $channels,
  uint32         $channel
)
  returns uint64
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_set_bchannel_export')
{ * }

sub ncchannels_set_bg_alpha (CArray[uint64] $channels, uint32 $a)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_set_bg_alpha_export')
{ * }

sub ncchannels_set_bg_default (CArray[uint64] $channels)
  returns uint64
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_set_bg_default_export')
{ * }

sub ncchannels_set_bg_palindex (CArray[uint64] $channels, uint32 $v)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_set_bg_palindex_export')
{ * }

sub ncchannels_set_bg_rgb8_clipped (
  CArray[uint64] $channels,
  uint32         $r,
  uint32         $g,
  uint32         $b
)
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_set_bg_rgb8_clipped_export')
{ * }

sub ncchannels_set_bg_rgb8 (
  CArray[uint64] $channels,
  uint32         $r,
  uint32         $g,
  uint32         $b
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_set_bg_rgb8_export')
{ * }

sub ncchannels_set_bg_rgb (CArray[uint64] $channels, uint32 $p)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_set_bg_rgb_export')
{ * }

sub ncchannels_set_channels (
  CArray[uint64] $dst,
  uint64         $channels
)
  returns uint64
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_set_channels_export')
{ * }

sub ncchannels_set_fchannel (
  CArray[uint64] $channels,
  uint32         $channel
)
  returns uint64
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_set_fchannel_export')
{ * }

sub ncchannels_set_fg_alpha (CArray[uint64] $channels, uint32 $v)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_set_fg_alpha_export')
{ * }

sub ncchannels_set_fg_default (CArray[uint64] $channels)
  returns uint64
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_set_fg_default_export')
{ * }

sub ncchannels_set_fg_palindex (CArray[uint64] $channels, uint32 $v)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_set_fg_palindex_export')
{ * }

sub ncchannels_set_fg_rgb8_clipped (
  CArray[uint64] $channels,
  uint32         $r,
  uint32         $g,
  uint32         $b
)
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_set_fg_rgb8_clipped_export')
{ * }

sub ncchannels_set_fg_rgb8 (
  CArray[uint64] $channels,
  uint32         $r,
  uint32         $g,
  uint32         $b
)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_set_fg_rgb8_export')
{ * }

sub ncchannels_set_fg_rgb (CArray[uint64] $channels, uint32 $p)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannels_set_fg_rgb_export')
{ * }
