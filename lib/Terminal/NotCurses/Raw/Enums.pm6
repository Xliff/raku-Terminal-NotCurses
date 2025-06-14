use v6.c;

use NativeCall;

unit package Terminal::NotCurses::Raw::Enums;

constant ncalign_e is export := uint32;
our enum ncalign_e_enum is export <
  NCALIGN_UNALIGNED
  NCALIGN_LEFT
  NCALIGN_CENTER
  NCALIGN_RIGHT
>;

constant ncblitter_e is export := uint32;
our enum ncblitter_e_enum is export <
  NCBLIT_DEFAULT
  NCBLIT_1x1
  NCBLIT_2x1
  NCBLIT_2x2
  NCBLIT_3x2
  NCBLIT_BRAILLE
  NCBLIT_PIXEL
  NCBLIT_4x1
  NCBLIT_8x1
>;

constant ncintype_e is export := uint32;
our enum ncintype_e_enum is export <
  NCTYPE_UNKNOWN
  NCTYPE_PRESS
  NCTYPE_REPEAT
  NCTYPE_RELEASE
>;

constant ncloglevel_e is export := int32;
our enum ncloglevel_e_enum is export <
  NCLOGLEVEL_SILENT
  NCLOGLEVEL_PANIC
  NCLOGLEVEL_FATAL
  NCLOGLEVEL_ERROR
  NCLOGLEVEL_WARNING
  NCLOGLEVEL_INFO
  NCLOGLEVEL_VERBOSE
  NCLOGLEVEL_DEBUG
  NCLOGLEVEL_TRACE
>;

constant ncpixelimpl_e is export := uint32;
our enum ncpixelimpl_e_enum is export <
  NCPIXEL_NONE
  NCPIXEL_SIXEL
  NCPIXEL_LINUXFB
  NCPIXEL_ITERM2
  NCPIXEL_KITTY_STATIC
  NCPIXEL_KITTY_ANIMATED
  NCPIXEL_KITTY_SELFREF
>;

constant ncscale_e is export := uint32;
our enum ncscale_e_enum is export <
  NCSCALE_NONE
  NCSCALE_SCALE
  NCSCALE_STRETCH
  NCSCALE_NONE_HIRES
  NCSCALE_SCALE_HIRES
>;

constant ncoption_e is export := uint64;
our enum ncoption_e_enum is export (
  NCOPTION_INHIBIT_SETLOCALE   => 0x0001,
  NCOPTION_NO_CLEAR_BITMAPS    => 0x0002,
  NCOPTION_NO_WINCH_SIGHANDLER => 0x0004,
  NCOPTION_NO_QUIT_SIGHANDLERS => 0x0008,
  NCOPTION_PRESERVE_CURSOR     => 0x0010,
  NCOPTION_SUPPRESS_BANNERS    => 0x0020,
  NCOPTION_NO_ALTERNATE_SCREEN => 0x0040,
  NCOPTION_NO_FONT_CHANGES     => 0x0080,
  NCOPTION_DRAIN_INPUT         => 0x0100,
  NCOPTION_SCROLLING           => 0x0200,
  NCOPTION_CLI_MODE            => (
    0x0040 +| 0x0002 +| 0x0010 +| 0x0200
  )
);
