use v6.c;

use NativeCall;

use Terminal::NotCurses::Raw::Definitions;
use Terminal::NotCurses::Raw::Structs;

unit package Terminal::NotCurses::Raw::Channel;

sub ncchannel_alpha (uint32 $channel)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannel_alpha_export')
{ * }

sub ncchannel_b (uint32 $channel)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannel_b_export')
{ * }

sub ncchannel_default_p (uint32 $channel)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannel_default_p_export')
{ * }

sub ncchannel_g (uint32 $channel)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannel_g_export')
{ * }

sub ncchannel_palindex_p (uint32 $channel)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannel_palindex_p_export')
{ * }

sub ncchannel_palindex (uint32 $channel)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannel_palindex_export')
{ * }

sub ncchannel_r (uint32 $channel)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannel_r_export')
{ * }

sub ncchannel_rgb8 (
  uint32 $channel,
  int32  $r        is rw,
  int32  $g        is rw,
  int32  $b        is rw
)
  returns uint32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannel_rgb8_export')
{ * }

sub ncchannel_rgb_p (uint32 $channel)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannel_rgb_p_export')
{ * }

sub ncchannel_set_alpha (CArray[uint32] $channel)
  returns int32
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannel_set_alpha_export')
{ * }

sub ncchannel_set_default (CArray[uint32] $channel)
  returns uint32
  is      native(&notcurses)
  is      export

sub ncchannel_set_rgb8 (
  CArray[uint32] $channel,
  uint32         $r,
  uint32         $g,
  uint32         $b
)
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannel_set_rgb8_export')
{ * }

sub ncchannel_set_rgb8_clipped (
  CArray[uint32] $channel
  int32          $r,
  int32          $g,
  int32          $b
)
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannel_set_rgb8_clipped_export')
{ * }

sub ncchannel_set (CArray[uint32] $channel, uint32 $v)
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannel_set_export')
{ * }

sub ncchannel_set_palindex (CArray[uint32] $channel, uint32 $i)
  is      native(notcurses-export)
  is      export
  is      symbol('ncchannel_set_palindex_export')
{ * }
