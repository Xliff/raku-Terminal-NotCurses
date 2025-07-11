use v6.c;

use NativeCall;

unit package Terminal::NotCurses::Raw::Enums;

constant ncalpha is export := uint64;
our enum ncalpha_e is export (
  NCALPHA_HIGHCONTRAST        => 0x30000000,
  NCALPHA_TRANSPARENT         => 0x20000000,
  NC_ALPHA_TRANSPARENT        => 0x20000000,
  NCALPHA_BLEND               => 0x10000000,
  NCALPHA_OPAQUE              => 0x00000000,
  NCALPHA_SHIFT               => 28,
  NCALPHA_SHIFT_HIGHCONTRAST  => 0x3,
  NCALPHA_SHIFT_TRANSPARENT   => 0x2,
  NCALPHA_SHIFT_BLEND         => 0x1,
  NCALPHA_SHIFT_OPAQUE        => 0x0,
  NC_BG_ALPHA_MASK            => 0x30000000
);

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

constant ncstyle_e is export := uint32;
our enum ncstyle_e_enum is export (
  NCSTYLE_MASK      => 0xffff,
  NCSTYLE_ITALIC    => 0x0010,
  NCSTYLE_UNDERLINE => 0x0008,
  NCSTYLE_UNDERCURL => 0x0004,
  NCSTYLE_BOLD      => 0x0002,
  NCSTYLE_STRUCK    => 0x0001,
  NCSTYLE_NONE      => 0
);

constant nccboxmask_e is export := uint32;
our enum ncboxmask_e_enum is export (
  NCBOXMASK_TOP     => 0x0001,
  NCBOXMASK_RIGHT   => 0x0002,
  NCBOXMASK_BOTTOM  => 0x0004,
  NCBOXMASK_LEFT    => 0x0008,
  NCBOXGRAD_TOP     => 0x0010,
  NCBOXGRAD_RIGHT   => 0x0020,
  NCBOXGRAD_BOTTOM  => 0x0040,
  NCBOXGRAD_LEFT    => 0x0080,
  NCBOXCORNER_MASK  => 0x0300,
  NCBOXCORNER_SHIFT => 8
);

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
