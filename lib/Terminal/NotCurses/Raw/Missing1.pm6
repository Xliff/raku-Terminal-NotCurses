

### /home/cbwood/Projects/raku-Terminal-Notcurses/notcurses-missing1.h

sub ncpalette_new (notcurses $nc)
  returns ncpalette
  is      native(notcurses)
  is      export
{ * }

sub ncpalette_use (
  notcurses $nc,
  ncpalette $p
)
  is      native(notcurses)
  is      export
{ * }


sub notcurses_canopen_images (notcurses $nc)
  returns bool
  is      native(notcurses)
  is      export
{ * }

sub notcurses_canopen_videos (notcurses $nc)
  returns bool
  is      native(notcurses)
  is      export
{ * }

sub notcurses_capabilities (notcurses $n)
  returns nccapabilities
  is      native(notcurses)
  is      export
{ * }

sub notcurses_check_pixel_support (notcurses $nc)
  returns ncpixelimpl_e
  is      native(notcurses)
  is      export
{ * }

sub notcurses_detected_terminal (notcurses $nc)
  returns Str
  is      native(notcurses)
  is      export
{ * }

sub notcurses_palette_size (notcurses $nc)
  is      native(notcurses)
  is      export
{ * }

sub notcurses_stats (
  notcurses $nc,
  ncstats   $stats
)
  is      native(notcurses)
  is      export
{ * }

sub notcurses_stats_alloc (notcurses $nc)
  returns ncstats
  is      native(notcurses)
  is      export
{ * }

sub notcurses_stats_reset (
  notcurses $nc,
  ncstats   $stats
)
  is      native(notcurses)
  is      export
{ * }

sub notcurses_supported_styles (notcurses $nc)
  returns uint16_t
  is      native(notcurses)
  is      export
{ * }
