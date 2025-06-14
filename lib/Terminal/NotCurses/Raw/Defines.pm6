// we never blit full blocks, but instead spaces (more efficient) with the
// background set to the desired foreground. these need be kept in the same
// order as the blitters[] definition in lib/blit.c.
typedef enum {
  NCBLIT_DEFAULT, // let the ncvisual pick
  NCBLIT_1x1,     // space, compatible with ASCII
  NCBLIT_2x1,     // halves + 1x1 (space)     ▄▀
  NCBLIT_2x2,     // quadrants + 2x1          ▗▐ ▖▀▟▌▙
  NCBLIT_3x2,     // sextants (*NOT* 2x2)     🬀🬁🬂🬃🬄🬅🬆🬇🬈🬉🬊🬋🬌🬍🬎🬏🬐🬑🬒🬓🬔🬕🬖🬗🬘🬙🬚🬛🬜🬝🬞
  NCBLIT_BRAILLE, // 4 rows, 2 cols (braille) ⡀⡄⡆⡇⢀⣀⣄⣆⣇⢠⣠⣤⣦⣧⢰⣰⣴⣶⣷⢸⣸⣼⣾⣿
  NCBLIT_PIXEL,   // pixel graphics
  // these blitters are suitable only for plots, not general media
  NCBLIT_4x1,     // four vertical levels     █▆▄▂
  NCBLIT_8x1,     // eight vertical levels    █▇▆▅▄▃▂▁
} ncblitter_e;

// Alignment within a plane or terminal. Left/right-justified, or centered.
typedef enum {
  NCALIGN_UNALIGNED,
  NCALIGN_LEFT,
  NCALIGN_CENTER,
  NCALIGN_RIGHT,
} ncalign_e;

#define NCALIGN_TOP NCALIGN_LEFT
#define NCALIGN_BOTTOM NCALIGN_RIGHT

// How to scale an ncvisual during rendering. NCSCALE_NONE will apply no
// scaling. NCSCALE_SCALE scales a visual to the plane's size, maintaining
// aspect ratio. NCSCALE_STRETCH stretches and scales the image in an attempt
// to fill the entirety of the plane. NCSCALE_NONE_HIRES and
// NCSCALE_SCALE_HIRES behave like their counterparts, but admit blitters
// which don't preserve aspect ratio.
typedef enum {
  NCSCALE_NONE,
  NCSCALE_SCALE,
  NCSCALE_STRETCH,
  NCSCALE_NONE_HIRES,
  NCSCALE_SCALE_HIRES,
} ncscale_e;

// background cannot be highcontrast, only foreground
#define NCALPHA_HIGHCONTRAST    0x30000000ull
#define NCALPHA_TRANSPARENT     0x20000000ull
#define NCALPHA_BLEND           0x10000000ull
#define NCALPHA_OPAQUE          0x00000000ull

// we support palette-indexed color up to 8 bits.
#define NCPALETTESIZE 256

// Does this glyph completely obscure the background? If so, there's no need
// to emit a background when rasterizing, a small optimization. These are
// also used to track regions into which we must not cellblit.
#define NC_NOBACKGROUND_MASK  0x8700000000000000ull
// if this bit is set, we are *not* using the default background color
#define NC_BGDEFAULT_MASK     0x0000000040000000ull
// extract these bits to get the background RGB value
#define NC_BG_RGB_MASK        0x0000000000ffffffull
// if this bit *and* NC_BGDEFAULT_MASK are set, we're using a
// palette-indexed background color
#define NC_BG_PALETTE         0x0000000008000000ull
// extract these bits to get the background alpha mask
#define NC_BG_ALPHA_MASK      0x30000000ull

// initialize a 32-bit channel pair with specified RGB
#define NCCHANNEL_INITIALIZER(r, g, b) \
  (((uint32_t)(r) << 16u) + ((uint32_t)(g) << 8u) + (b) + NC_BGDEFAULT_MASK)

// initialize a 64-bit channel pair with specified RGB fg/bg
#define NCCHANNELS_INITIALIZER(fr, fg, fb, br, bg, bb) \
  ((NCCHANNEL_INITIALIZER((fr), (fg), (fb)) << 32ull) + \
   (NCCHANNEL_INITIALIZER((br), (bg), (bb))))

// 0x0--0x10ffff can be UTF-8-encoded with only 4 bytes
#define WCHAR_MAX_UTF8BYTES 4

// if you want reverse video, try ncchannels_reverse(). if you want blink, try
// ncplane_pulse(). if you want protection, put things on a different plane.
#define NCSTYLE_MASK      0xffffu
#define NCSTYLE_ITALIC    0x0010u
#define NCSTYLE_UNDERLINE 0x0008u
#define NCSTYLE_UNDERCURL 0x0004u
#define NCSTYLE_BOLD      0x0002u
#define NCSTYLE_STRUCK    0x0001u
#define NCSTYLE_NONE      0

// These log levels consciously map cleanly to those of libav; Notcurses itself
// does not use this full granularity. The log level does not affect the opening
// and closing banners, which can be disabled via the notcurses_option struct's
// 'suppress_banner'. Note that if stderr is connected to the same terminal on
// which we're rendering, any kind of logging will disrupt the output (which is
// undesirable). The "default" zero value is NCLOGLEVEL_PANIC.
typedef enum {
  NCLOGLEVEL_SILENT = -1,// default. print nothing once fullscreen service begins
  NCLOGLEVEL_PANIC = 0,  // print diagnostics related to catastrophic failure
  NCLOGLEVEL_FATAL = 1,  // we're hanging around, but we've had a horrible fault
  NCLOGLEVEL_ERROR = 2,  // we can't keep doing this, but we can do other things
  NCLOGLEVEL_WARNING = 3,// you probably don't want what's happening to happen
  NCLOGLEVEL_INFO = 4,   // "standard information"
  NCLOGLEVEL_VERBOSE = 5,// "detailed information"
  NCLOGLEVEL_DEBUG = 6,  // this is honestly a bit much
  NCLOGLEVEL_TRACE = 7,  // there's probably a better way to do what you want
} ncloglevel_e;

// Bits for notcurses_options->flags.

// notcurses_init() will call setlocale() to inspect the current locale. If
// that locale is "C" or "POSIX", it will call setlocale(LC_ALL, "") to set
// the locale according to the LANG environment variable. Ideally, this will
// result in UTF8 being enabled, even if the client app didn't call
// setlocale() itself. Unless you're certain that you're invoking setlocale()
// prior to notcurses_init(), you should not set this bit. Even if you are
// invoking setlocale(), this behavior shouldn't be an issue unless you're
// doing something weird (setting a locale not based on LANG).
#define NCOPTION_INHIBIT_SETLOCALE   0x0001ull

// We typically try to clear any preexisting bitmaps. If we ought *not* try
// to do this, pass NCOPTION_NO_CLEAR_BITMAPS. Note that they might still
// get cleared even if this is set, and they might not get cleared even if
// this is not set. It's a tough world out there.
#define NCOPTION_NO_CLEAR_BITMAPS    0x0002ull

// We typically install a signal handler for SIGWINCH that generates a resize
// event in the notcurses_get() queue. Set to inhibit this handler.
#define NCOPTION_NO_WINCH_SIGHANDLER 0x0004ull

// We typically install a signal handler for SIG{INT, ILL, SEGV, ABRT, TERM,
// QUIT} that restores the screen, and then calls the old signal handler. Set
// to inhibit registration of these signal handlers.
#define NCOPTION_NO_QUIT_SIGHANDLERS 0x0008ull

// Initialize the standard plane's virtual cursor to match the physical cursor
// at context creation time. Together with NCOPTION_NO_ALTERNATE_SCREEN and a
// scrolling standard plane, this facilitates easy scrolling-style programs in
// rendered mode.
#define NCOPTION_PRESERVE_CURSOR     0x0010ull

// Notcurses typically prints version info in notcurses_init() and performance
// info in notcurses_stop(). This inhibits that output.
#define NCOPTION_SUPPRESS_BANNERS    0x0020ull

// If smcup/rmcup capabilities are indicated, Notcurses defaults to making use
// of the "alternate screen". This flag inhibits use of smcup/rmcup.
#define NCOPTION_NO_ALTERNATE_SCREEN 0x0040ull

// Do not modify the font. Notcurses might attempt to change the font slightly,
// to support certain glyphs (especially on the Linux console). If this is set,
// no such modifications will be made. Note that font changes will not affect
// anything but the virtual console/terminal in which Notcurses is running.
#define NCOPTION_NO_FONT_CHANGES     0x0080ull

// Input may be freely dropped. This ought be provided when the program does not
// intend to handle input. Otherwise, input can accumulate in internal buffers,
// eventually preventing Notcurses from processing terminal messages.
#define NCOPTION_DRAIN_INPUT         0x0100ull

// Prepare the standard plane in scrolling mode, useful for CLIs. This is
// equivalent to calling ncplane_set_scrolling(notcurses_stdplane(nc), true).
#define NCOPTION_SCROLLING           0x0200ull

// "CLI mode" is just setting these four options.
#define NCOPTION_CLI_MODE (NCOPTION_NO_ALTERNATE_SCREEN \
                           |NCOPTION_NO_CLEAR_BITMAPS \
                           |NCOPTION_PRESERVE_CURSOR \
                           |NCOPTION_SCROLLING)

typedef enum {
 NCTYPE_UNKNOWN,
 NCTYPE_PRESS,
 NCTYPE_REPEAT,
 NCTYPE_RELEASE,
} ncintype_e;


#define NCMICE_NO_EVENTS     0
#define NCMICE_MOVE_EVENT    0x1
#define NCMICE_BUTTON_EVENT  0x2
#define NCMICE_DRAG_EVENT    0x4
#define NCMICE_ALL_EVENTS    0x7

// Horizontal alignment relative to the parent plane. Use ncalign_e for 'x'.
#define NCPLANE_OPTION_HORALIGNED   0x0001ull
// Vertical alignment relative to the parent plane. Use ncalign_e for 'y'.
#define NCPLANE_OPTION_VERALIGNED   0x0002ull
// Maximize relative to the parent plane, modulo the provided margins. The
// margins are best-effort; the plane will always be at least 1 column by
// 1 row. If the margins can be effected, the plane will be sized to all
// remaining space. 'y' and 'x' are overloaded as the top and left margins
// when this flag is used. 'rows' and 'cols' must be 0 when this flag is
// used. This flag is exclusive with both of the alignment flags.
#define NCPLANE_OPTION_MARGINALIZED 0x0004ull
// If this plane is bound to a scrolling plane, it ought *not* scroll along
// with the parent (it will still move with the parent, maintaining its
// relative position, if the parent is moved to a new location).
#define NCPLANE_OPTION_FIXED        0x0008ull
// Enable automatic growth of the plane to accommodate output. Creating a
// plane with this flag is equivalent to immediately calling
// ncplane_set_autogrow(p, true) following plane creation.
#define NCPLANE_OPTION_AUTOGROW     0x0010ull
// Enable vertical scrolling of the plane to accommodate output. Creating a
// plane with this flag is equivalent to immediately calling
// ncplane_set_scrolling(p, true) following plane creation.
#define NCPLANE_OPTION_VSCROLL      0x0020ull

// pixel blitting implementations. informative only; don't special-case
// based off any of this information!
typedef enum {
  NCPIXEL_NONE = 0,
  NCPIXEL_SIXEL,           // sixel
  NCPIXEL_LINUXFB,         // linux framebuffer
  NCPIXEL_ITERM2,          // iTerm2
  // C=1 (disabling scrolling) was only introduced in 0.20.0, at the same
  // time as animation. prior to this, graphics had to be entirely redrawn
  // on any change, and it wasn't possible to use the bottom line.
  NCPIXEL_KITTY_STATIC,
  // until 0.22.0's introduction of 'a=c' for self-referential composition, we
  // had to keep a complete copy of the RGBA data, in case a wiped cell needed
  // to be rebuilt. we'd otherwise have to unpack the glyph and store it into
  // the auxvec on the fly.
  NCPIXEL_KITTY_ANIMATED,
  // with 0.22.0, we only ever write transparent cells after writing the
  // original image (which we now deflate, since we needn't unpack it later).
  // the only data we need keep is the auxvecs.
  NCPIXEL_KITTY_SELFREF,
} ncpixelimpl_e;

#define NCBOXMASK_TOP    0x0001
#define NCBOXMASK_RIGHT  0x0002
#define NCBOXMASK_BOTTOM 0x0004
#define NCBOXMASK_LEFT   0x0008
#define NCBOXGRAD_TOP    0x0010
#define NCBOXGRAD_RIGHT  0x0020
#define NCBOXGRAD_BOTTOM 0x0040
#define NCBOXGRAD_LEFT   0x0080
#define NCBOXCORNER_MASK 0x0300
#define NCBOXCORNER_SHIFT 8u

#define NCVISUAL_OPTION_NODEGRADE     0x0001ull // fail rather than degrade
#define NCVISUAL_OPTION_BLEND         0x0002ull // use NCALPHA_BLEND with visual
#define NCVISUAL_OPTION_HORALIGNED    0x0004ull // x is an alignment, not absolute
#define NCVISUAL_OPTION_VERALIGNED    0x0008ull // y is an alignment, not absolute
#define NCVISUAL_OPTION_ADDALPHA      0x0010ull // transcolor is in effect
#define NCVISUAL_OPTION_CHILDPLANE    0x0020ull // interpret n as parent
#define NCVISUAL_OPTION_NOINTERPOLATE 0x0040ull // non-interpolative scaling

// An ncreel is a Notcurses region devoted to displaying zero or more
// line-oriented, contained tablets between which the user may navigate. If at
// least one tablets exists, there is a "focused tablet". As much of the focused
// tablet as is possible is always displayed. If there is space left over, other
// tablets are included in the display. Tablets can come and go at any time, and
// can grow or shrink at any time.
//
// This structure is amenable to line- and page-based navigation via keystrokes,
// scrolling gestures, trackballs, scrollwheels, touchpads, and verbal commands.

// is scrolling infinite (can one move down or up forever, or is an end
// reached?). if true, 'circular' specifies how to handle the special case of
// an incompletely-filled reel.
#define NCREEL_OPTION_INFINITESCROLL 0x0001ull
// is navigation circular (does moving down from the last tablet move to the
// first, and vice versa)? only meaningful when infinitescroll is true. if
// infinitescroll is false, this must be false.
#define NCREEL_OPTION_CIRCULAR       0x0002ull

// The number of columns is one fewer, as the STRLEN expressions must leave
// an extra byte open in case 'µ' (U+00B5, 0xC2 0xB5) shows up. NCPREFIXCOLUMNS
// is the maximum number of columns used by a mult == 1000 (standard)
// ncnmetric() call. NCIPREFIXCOLUMNS is the maximum number of columns used by a
// mult == 1024 (digital information) ncnmetric(). NCBPREFIXSTRLEN is the maximum
// number of columns used by a mult == 1024 call making use of the 'i' suffix.
// This is the true number of columns; to set up a printf()-style maximum
// field width, you should use NC[IB]PREFIXFMT (see below).
#define NCPREFIXCOLUMNS 7
#define NCIPREFIXCOLUMNS 8
#define NCBPREFIXCOLUMNS 9
#define NCPREFIXSTRLEN (NCPREFIXCOLUMNS + 1)  // Does not include a '\0' (xxx.xxU)
#define NCIPREFIXSTRLEN (NCIPREFIXCOLUMNS + 1) //  Does not include a '\0' (xxxx.xxU)
#define NCBPREFIXSTRLEN (NCBPREFIXCOLUMNS + 1) // Does not include a '\0' (xxxx.xxUi), i == prefix
// Used as arguments to a variable field width (i.e. "%*s" -- these are the *).
// We need this convoluted grotesquery to properly handle 'µ'.
#define NCMETRICFWIDTH(x, cols) \
    ((int)(strlen(x) - ncstrwidth(x, NULL, NULL) + (cols)))
#define NCPREFIXFMT(x) NCMETRICFWIDTH((x), NCPREFIXCOLUMNS), (x)
#define NCIPREFIXFMT(x) NCMETRIXFWIDTH((x), NCIPREFIXCOLUMNS), (x)
#define NCBPREFIXFMT(x) NCMETRICFWIDTH((x), NCBPREFIXCOLUMNS), (x)
