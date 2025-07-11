#ifndef NOTCURSES_NOTCURSES
#define NOTCURSES_NOTCURSES

// Get a human-readable string describing the running Notcurses version.
API const char* notcurses_version(void);
// Cannot be inline, as we want to get the versions of the actual Notcurses
// library we loaded, not what we compile against.
API void notcurses_version_components(int* major, int* minor, int* patch, int* tweak);

// These lowest-level functions manipulate a channel encodings directly. Users
// will typically manipulate ncplanes' and nccells' channels through their
// APIs, rather than calling these explicitly.


// Returns the number of columns occupied by the longest valid prefix of a
// multibyte (UTF-8) string. If an invalid character is encountered, -1 will be
// returned, and the number of valid bytes and columns will be written into
// *|validbytes| and *|validwidth| (assuming them non-NULL). If the entire
// string is valid, *|validbytes| and *|validwidth| reflect the entire string.
API int ncstrwidth(const char* egcs, int* validbytes, int* validwidth);

// input functions like notcurses_get() return ucs32-encoded uint32_t. convert
// a series of uint32_t to utf8. result must be at least 4 bytes per input
// uint32_t (6 bytes per uint32_t will future-proof against Unicode expansion).
// the number of bytes used is returned, or -1 if passed illegal ucs32, or too
// small of a buffer.
API int notcurses_ucs32_to_utf8(const uint32_t* ucs32, unsigned ucs32count,
                                unsigned char* resultbuf, size_t buflen);

// An nccell corresponds to a single character cell on some plane, which can be
// occupied by a single grapheme cluster (some root spacing glyph, along with
// possible combining characters, which might span multiple columns). At any
// cell, we can have a theoretically arbitrarily long UTF-8 EGC, a foreground
// color, a background color, and an attribute set. Valid grapheme cluster
// contents include:
//
//  * A NUL terminator,
//  * A single control character, followed by a NUL terminator,
//  * At most one spacing character, followed by zero or more nonspacing
//    characters, followed by a NUL terminator.
//
// Multi-column characters can only have a single style/color throughout.
// Existence is suffering, and thus wcwidth() is not reliable. It's just
// quoting whether or not the EGC contains a "Wide Asian" double-width
// character. This is set for some things, like most emoji, and not set for
// other things, like cuneiform. True display width is a *function of the
// font and terminal*. Among the longest Unicode codepoints is
//
//    U+FDFD ARABIC LIGATURE BISMILLAH AR-RAHMAN AR-RAHEEM ﷽
//
// wcwidth() rather optimistically claims this most exalted glyph to occupy
// a single column. BiDi text is too complicated for me to even get into here.
// Be assured there are no easy answers; ours is indeed a disturbing Universe.
//
// Each nccell occupies 16 static bytes (128 bits). The surface is thus ~1.6MB
// for a (pretty large) 500x200 terminal. At 80x43, it's less than 64KB.
// Dynamic requirements (the egcpool) can add up to 16MB to an ncplane, but
// such large pools are unlikely in common use.
//
// We implement some small alpha compositing. Foreground and background both
// have two bits of inverted alpha. The actual grapheme written to a cell is
// the topmost non-zero grapheme. If its alpha is 00, its foreground color is
// used unchanged. If its alpha is 10, its foreground color is derived entirely
// from cells underneath it. Otherwise, the result will be a composite.
// Likewise for the background. If the bottom of a coordinate's zbuffer is
// reached with a cumulative alpha of zero, the default is used. In this way,
// a terminal configured with transparent background can be supported through
// multiple occluding ncplanes. A foreground alpha of 11 requests high-contrast
// text (relative to the computed background). A background alpha of 11 is
// currently forbidden.
//
// Default color takes precedence over palette or RGB, and cannot be used with
// transparency. Indexed palette takes precedence over RGB. It cannot
// meaningfully set transparency, but it can be mixed into a cascading color.
// RGB is used if neither default terminal colors nor palette indexing are in
// play, and fully supports all transparency options.
//
// This structure is exposed only so that most functions can be inlined. Do not
// directly modify or access the fields of this structure; use the API.

// do *not* load invalid EGCs using these macros! there is no way for us to
// protect against such misuse here. problems *will* ensue. similarly, do not
// set channel flags other than colors/alpha. we assign non-printing glyphs
// a width of 1 to match utf8_egc_len()'s behavior for whitespace/NUL.
// FIXME can we enforce this with static_assert?
#define NCCELL_INITIALIZER(c, s, chan) { .gcluster = (htole(c)), .gcluster_backstop = 0,\
  .width = (uint8_t)((wcwidth(c) < 0 || !c) ? 1 : wcwidth(c)), .stylemask = (s), .channels = (chan), }
// python fails on #define CELL_CHAR_INITIALIZER(c) CELL_INITIALIZER(c, 0, 0)
#define NCCELL_CHAR_INITIALIZER(c) { .gcluster = (htole(c)), .gcluster_backstop = 0,\
  .width = (uint8_t)((wcwidth(c) < 0 || !c) ? 1 : wcwidth(c)), .stylemask = 0, .channels = 0, }
// python fails on #define CELL_TRIVIAL_INITIALIZER CELL_CHAR_INITIALIZER(0)
#define NCCELL_TRIVIAL_INITIALIZER { .gcluster = 0, .gcluster_backstop = 0,\
                                     .width = 1, .stylemask = 0, .channels = 0, }



// Breaks the UTF-8 string in 'gcluster' down, setting up the nccell 'c'.
// Returns the number of bytes copied out of 'gcluster', or -1 on failure. The
// styling of the cell is left untouched, but any resources are released.
API int nccell_load(struct ncplane* n, nccell* c, const char* gcluster);



// Duplicate 'c' into 'targ'; both must be/will be bound to 'n'. Returns -1 on
// failure, and 0 on success.
API int nccell_duplicate(struct ncplane* n, nccell* targ, const nccell* c);

// Release resources held by the nccell 'c'.
API void nccell_release(struct ncplane* n, nccell* c);




// return a pointer to the NUL-terminated EGC referenced by 'c'. this pointer
// can be invalidated by any further operation on the plane 'n', so...watch out!
const char*
nccell_extended_gcluster(const struct ncplane* n, const nccell* c);






// Lex a margin argument according to the standard Notcurses definition. There
// can be either a single number, which will define all margins equally, or
// there can be four numbers separated by commas.
API int notcurses_lex_margins(const char* op, notcurses_options* opts);

// Lex a blitter.
API int notcurses_lex_blitter(const char* op, ncblitter_e* blitter);

// Get the name of a blitter.
API const char* notcurses_str_blitter(ncblitter_e blitter);

// Lex a scaling mode (one of "none", "stretch", "scale", "hires",
// "scalehi", or "inflate").
API int notcurses_lex_scalemode(const char* op, ncscale_e* scalemode);

// Get the name of a scaling mode.
API const char* notcurses_str_scalemode(ncscale_e scalemode);

// Initialize a Notcurses context on the connected terminal at 'fp'. 'fp' must
// be a tty. You'll usually want stdout. NULL can be supplied for 'fp', in
// which case /dev/tty will be opened. Returns NULL on error, including any
// failure initializing terminfo.
API ALLOC struct notcurses* notcurses_init(const notcurses_options* opts, FILE* fp);

// The same as notcurses_init(), but without any multimedia functionality,
// allowing for a svelter binary. Link with notcurses-core if this is used.
API ALLOC struct notcurses* notcurses_core_init(const notcurses_options* opts, FILE* fp);

// Destroy a Notcurses context. A NULL 'nc' is a no-op.
API int notcurses_stop(struct notcurses* nc);

// Shift to the alternate screen, if available. If already using the alternate
// screen, this returns 0 immediately. If the alternate screen is not
// available, this returns -1 immediately. Entering the alternate screen turns
// off scrolling for the standard plane.
API int notcurses_enter_alternate_screen(struct notcurses* nc);

// Exit the alternate screen. Immediately returns 0 if not currently using the
// alternate screen.
API int notcurses_leave_alternate_screen(struct notcurses* nc);

// Get a reference to the standard plane (one matching our current idea of the
// terminal size) for this terminal. The standard plane always exists, and its
// origin is always at the uppermost, leftmost cell of the terminal.
API struct ncplane* notcurses_stdplane(struct notcurses* nc);
API const struct ncplane* notcurses_stdplane_const(const struct notcurses* nc);

// Return the topmost plane of the pile containing 'n'.
API struct ncplane* ncpile_top(struct ncplane* n);

// Return the bottommost plane of the pile containing 'n'.
API struct ncplane* ncpile_bottom(struct ncplane* n);



// Renders the pile of which 'n' is a part. Rendering this pile again will blow
// away the render. To actually write out the render, call ncpile_rasterize().
API int ncpile_render(struct ncplane* n);

// Make the physical screen match the last rendered frame from the pile of
// which 'n' is a part. This is a blocking call. Don't call this before the
// pile has been rendered (doing so will likely result in a blank screen).
API int ncpile_rasterize(struct ncplane* n);


// Perform the rendering and rasterization portion of ncpile_render() and
// ncpile_rasterize(), but do not write the resulting buffer out to the
// terminal. Using this function, the user can control the writeout process.
// The returned buffer must be freed by the caller.
API int ncpile_render_to_buffer(struct ncplane* p, char** buf, size_t* buflen);

// Write the last rendered frame, in its entirety, to 'fp'. If a frame has
// not yet been rendered, nothing will be written.
API int ncpile_render_to_file(struct ncplane* p, FILE* fp);

// Destroy all ncplanes other than the stdplane.
API void notcurses_drop_planes(struct notcurses* nc);


// Read a UTF-32-encoded Unicode codepoint from input. This might only be part
// of a larger EGC. Provide a NULL 'ts' to block at length, and otherwise a
// timespec specifying an absolute deadline calculated using CLOCK_MONOTONIC.
// Returns a single Unicode code point, or a synthesized special key constant,
// or (uint32_t)-1 on error. Returns 0 on a timeout. If an event is processed,
// the return value is the 'id' field from that event. 'ni' may be NULL.
API uint32_t notcurses_get(struct notcurses* n, const struct timespec* ts,
                           ncinput* ni);

// Acquire up to 'vcount' ncinputs at the vector 'ni'. The number read will be
// returned, or -1 on error without any reads, 0 on timeout.
API int notcurses_getvec(struct notcurses* n, const struct timespec* ts,
                         ncinput* ni, int vcount);

// Get a file descriptor suitable for input event poll()ing. When this
// descriptor becomes available, you can call notcurses_get_nblock(),
// and input ought be ready. This file descriptor is *not* necessarily
// the file descriptor associated with stdin (but it might be!).
API int notcurses_inputready_fd(struct notcurses* n);


// Enable mice events according to 'eventmask'; an eventmask of 0 will disable
// all mice tracking. On failure, -1 is returned. On success, 0 is returned, and
// mouse events will be published to notcurses_get().
API int notcurses_mice_enable(struct notcurses* n, unsigned eventmask);

// Disable mouse events. Any events in the input queue can still be delivered.;
notcurses_mice_disable(struct notcurses* n){
  return notcurses_mice_enable(n, NCMICE_NO_EVENTS);
}

// Disable signals originating from the terminal's line discipline, i.e.
// SIGINT (^C), SIGQUIT (^\), and SIGTSTP (^Z). They are enabled by default.
API int notcurses_linesigs_disable(struct notcurses* n);

// Restore signals originating from the terminal's line discipline, i.e.
// SIGINT (^C), SIGQUIT (^\), and SIGTSTP (^Z), if disabled.
API int notcurses_linesigs_enable(struct notcurses* n);

// Refresh the physical screen to match what was last rendered (i.e., without
// reflecting any changes since the last call to notcurses_render()). This is
// primarily useful if the screen is externally corrupted, or if an
// NCKEY_RESIZE event has been read and you're not yet ready to render. The
// current screen geometry is returned in 'y' and 'x', if they are not NULL.
API int notcurses_refresh(struct notcurses* n, unsigned* RESTRICT y, unsigned* RESTRICT x);

// Extract the Notcurses context to which this plane is attached.
API struct notcurses* ncplane_notcurses(const struct ncplane* n);

API const struct notcurses* ncplane_notcurses_const(const struct ncplane* n);

// Return the dimensions of this ncplane. y or x may be NULL.
API void ncplane_dim_yx(const struct ncplane* n, unsigned* RESTRICT y, unsigned* RESTRICT x);

// Get a reference to the standard plane (one matching our current idea of the
// terminal size) for this terminal. The standard plane always exists, and its
// origin is always at the uppermost, leftmost cell of the terminal.
API struct ncplane* notcurses_stdplane(struct notcurses* nc);
API const struct ncplane* notcurses_stdplane_const(const struct notcurses* nc);



// Retrieve pixel geometry for the display region ('pxy', 'pxx'), each cell
// ('celldimy', 'celldimx'), and the maximum displayable bitmap ('maxbmapy',
// 'maxbmapx'). If bitmaps are not supported, or if there is no artificial
// limit on bitmap size, 'maxbmapy' and 'maxbmapx' will be 0. Any of the
// geometry arguments may be NULL.
API void ncplane_pixel_geom(const struct ncplane* n,
                           unsigned* RESTRICT pxy, unsigned* RESTRICT pxx,
                           unsigned* RESTRICT celldimy, unsigned* RESTRICT celldimx,
                           unsigned* RESTRICT maxbmapy, unsigned* RESTRICT maxbmapx);

// Return our current idea of the terminal dimensions in rows and cols.
static inline void
notcurses_term_dim_yx(const struct notcurses* n, unsigned* RESTRICT rows, unsigned* RESTRICT cols){
  ncplane_dim_yx(notcurses_stdplane_const(n), rows, cols);
}

// Retrieve the contents of the specified cell as last rendered. Returns the EGC
// or NULL on error. This EGC must be free()d by the caller. The stylemask and
// channels are written to 'stylemask' and 'channels', respectively.
API char* notcurses_at_yx(struct notcurses* nc, unsigned yoff, unsigned xoff,
                          uint16_t* stylemask, uint64_t* channels);





// Create a new ncplane bound to plane 'n', at the offset 'y'x'x' (relative to
// the origin of 'n') and the specified size. The number of 'rows' and 'cols'
// must both be positive. This plane is initially at the top of the z-buffer,
// as if ncplane_move_top() had been called on it. The void* 'userptr' can be
// retrieved (and reset) later. A 'name' can be set, used in debugging.
API ALLOC struct ncplane* ncplane_create(struct ncplane* n, const ncplane_options* nopts);

// Same as ncplane_create(), but creates a new pile. The returned plane will
// be the top, bottom, and root of this new pile.
API ALLOC struct ncplane* ncpile_create(struct notcurses* nc, const ncplane_options* nopts);

// Utility resize callbacks. When a parent plane is resized, it invokes each
// child's resize callback. Any logic can be run in a resize callback, but
// these are some generically useful ones.

// resize the plane to the visual region's size (used for the standard plane).
API int ncplane_resize_maximize(struct ncplane* n);

// resize the plane to its parent's size, attempting to enforce the margins
// supplied along with NCPLANE_OPTION_MARGINALIZED.
API int ncplane_resize_marginalized(struct ncplane* n);

// realign the plane 'n' against its parent, using the alignments specified
// with NCPLANE_OPTION_HORALIGNED and/or NCPLANE_OPTION_VERALIGNED.
API int ncplane_resize_realign(struct ncplane* n);

// move the plane such that it is entirely within its parent, if possible.
// no resizing is performed.
API int ncplane_resize_placewithin(struct ncplane* n);

// Replace the ncplane's existing resizecb with 'resizecb' (which may be NULL).
// The standard plane's resizecb may not be changed.
API void ncplane_set_resizecb(struct ncplane* n, int(*resizecb)(struct ncplane*));

// Returns the ncplane's current resize callback.
API int (*ncplane_resizecb(const struct ncplane* n))(struct ncplane*);

// Set the plane's name (may be NULL), replacing any current name.
API int ncplane_set_name(struct ncplane* n, const char* name);

// Return a heap-allocated copy of the plane's name, or NULL if it has none.
API ALLOC char* ncplane_name(const struct ncplane* n);

// Plane 'n' will be unbound from its parent plane, and will be made a bound
// child of 'newparent'. It is an error if 'n' or 'newparent' are NULL. If
// 'newparent' is equal to 'n', 'n' becomes the root of a new pile, unless 'n'
// is already the root of a pile, in which case this is a no-op. Returns 'n'.
// The standard plane cannot be reparented. Any planes bound to 'n' are
// reparented to the previous parent of 'n'.
API struct ncplane* ncplane_reparent(struct ncplane* n, struct ncplane* newparent);

// The same as ncplane_reparent(), except any planes bound to 'n' come along
// with it to its new destination. Their z-order is maintained. If 'newparent'
// is an ancestor of 'n', NULL is returned, and no changes are made.
API struct ncplane* ncplane_reparent_family(struct ncplane* n, struct ncplane* newparent);

// Duplicate an existing ncplane. The new plane will have the same geometry,
// will duplicate all content, and will start with the same rendering state.
// The new plane will be immediately above the old one on the z axis, and will
// be bound to the same parent (unless 'n' is a root plane, in which case the
// new plane will be bound to it). Bound planes are *not* duplicated; the new
// plane is bound to the parent of 'n', but has no bound planes.
API ALLOC struct ncplane* ncplane_dup(const struct ncplane* n, void* opaque);

// provided a coordinate relative to the origin of 'src', map it to the same
// absolute coordinate relative to the origin of 'dst'. either or both of 'y'
// and 'x' may be NULL. if 'dst' is NULL, it is taken to be the standard plane.
API void ncplane_translate(const struct ncplane* src, const struct ncplane* dst,
                           int* RESTRICT y, int* RESTRICT x);

// Fed absolute 'y'/'x' coordinates, determine whether that coordinate is
// within the ncplane 'n'. If not, return false. If so, return true. Either
// way, translate the absolute coordinates relative to 'n'. If the point is not
// within 'n', these coordinates will not be within the dimensions of the plane.
API bool ncplane_translate_abs(const struct ncplane* n, int* RESTRICT y, int* RESTRICT x);

// All planes are created with scrolling disabled. Scrolling can be dynamically
// controlled with ncplane_set_scrolling(). Returns true if scrolling was
// previously enabled, or false if it was disabled.
API bool ncplane_set_scrolling(struct ncplane* n, unsigned scrollp);

API bool ncplane_scrolling_p(const struct ncplane* n);

// By default, planes are created with autogrow disabled. Autogrow can be
// dynamically controlled with ncplane_set_autogrow(). Returns true if
// autogrow was previously enabled, or false if it was disabled.
API bool ncplane_set_autogrow(struct ncplane* n, unsigned growp);

API bool ncplane_autogrow_p(const struct ncplane* n);


// Create a new palette store. It will be initialized with notcurses' best
// knowledge of the currently configured palette.
API ALLOC ncpalette* ncpalette_new(struct notcurses* nc);

// Attempt to configure the terminal with the provided palette 'p'. Does not
// transfer ownership of 'p'; ncpalette_free() can (ought) still be called.
API int ncpalette_use(struct notcurses* nc, const ncpalette* p);

// Free the palette store 'p'.
API void ncpalette_free(ncpalette* p);


// Returns a 16-bit bitmask of supported curses-style attributes
// (NCSTYLE_UNDERLINE, NCSTYLE_BOLD, etc.) The attribute is only
// indicated as supported if the terminal can support it together with color.
// For more information, see the "ncv" capability in terminfo(5).
API uint16_t notcurses_supported_styles(const struct notcurses* nc);

// Returns the number of simultaneous colors claimed to be supported, or 1 if
// there is no color support. Note that several terminal emulators advertise
// more colors than they actually support, downsampling internally.
API unsigned notcurses_palette_size(const struct notcurses* nc);

// Returns the name (and sometimes version) of the terminal, as Notcurses
// has been best able to determine.
ALLOC API char* notcurses_detected_terminal(const struct notcurses* nc);

API const nccapabilities* notcurses_capabilities(const struct notcurses* n);



// Can we blit pixel-accurate bitmaps?
API ncpixelimpl_e notcurses_check_pixel_support(const struct notcurses* nc);


// Can we load images? This requires being built against FFmpeg/OIIO.
API bool notcurses_canopen_images(const struct notcurses* nc);

// Can we load videos? This requires being built against FFmpeg.
API bool notcurses_canopen_videos(const struct notcurses* nc);





// Allocate an ncstats object. Use this rather than allocating your own, since
// future versions of Notcurses might enlarge this structure.
API ALLOC ncstats* notcurses_stats_alloc(const struct notcurses* nc;;

// Acquire an atomic snapshot of the Notcurses object's stats.
API void notcurses_stats(struct notcurses* nc, ncstats* stats);

// Reset all cumulative stats (immediate ones, such as fbbytes, are not reset),
// first copying them into |*stats| (if |stats| is not NULL).
API void notcurses_stats_reset(struct notcurses* nc, ncstats* stats);

// Resize the specified ncplane. The four parameters 'keepy', 'keepx',
// 'keepleny', and 'keeplenx' define a subset of the ncplane to keep,
// unchanged. This may be a region of size 0, though none of these four
// parameters may be negative. 'keepx' and 'keepy' are relative to the ncplane.
// They must specify a coordinate within the ncplane's totality. 'yoff' and
// 'xoff' are relative to 'keepy' and 'keepx', and place the upper-left corner
// of the resized ncplane. Finally, 'ylen' and 'xlen' are the dimensions of the
// ncplane after resizing. 'ylen' must be greater than or equal to 'keepleny',
// and 'xlen' must be greater than or equal to 'keeplenx'. It is an error to
// attempt to resize the standard plane. If either of 'keepleny' or 'keeplenx'
// is non-zero, both must be non-zero.
//
// Essentially, the kept material does not move. It serves to anchor the
// resized plane. If there is no kept material, the plane can move freely.
API int ncplane_resize(struct ncplane* n, int keepy, int keepx,
                       unsigned keepleny, unsigned keeplenx,
                       int yoff, int xoff,
                       unsigned ylen, unsigned xlen);

// Destroy the specified ncplane. None of its contents will be visible after
// the next call to notcurses_render(). It is an error to attempt to destroy
// the standard plane.
API int ncplane_destroy(struct ncplane* n);

// Set the ncplane's base nccell to 'c'. The base cell is used for purposes of
// rendering anywhere that the ncplane's gcluster is 0. Note that the base cell
// is not affected by ncplane_erase(). 'c' must not be a secondary cell from a
// multicolumn EGC.
API int ncplane_set_base_cell(struct ncplane* n, const nccell* c);

// Set the ncplane's base nccell. It will be used for purposes of rendering
// anywhere that the ncplane's gcluster is 0. Note that the base cell is not
// affected by ncplane_erase(). 'egc' must be an extended grapheme cluster.
// Returns the number of bytes copied out of 'gcluster', or -1 on failure.
API int ncplane_set_base(struct ncplane* n, const char* egc,
                         uint16_t stylemask, uint64_t channels);

// Extract the ncplane's base nccell into 'c'. The reference is invalidated if
// 'ncp' is destroyed.
API int ncplane_base(struct ncplane* n, nccell* c);

// Get the origin of plane 'n' relative to its bound plane, or pile (if 'n' is
// a root plane). To get absolute coordinates, use ncplane_abs_yx().
API void ncplane_yx(const struct ncplane* n, int* RESTRICT y, int* RESTRICT x);
API int ncplane_y(const struct ncplane* n) __attribute__ ((pure));
API int ncplane_x(const struct ncplane* n) __attribute__ ((pure));

// Move this plane relative to the standard plane, or the plane to which it is
// bound (if it is bound to a plane). It is an error to attempt to move the
// standard plane.
API int ncplane_move_yx(struct ncplane* n, int y, int x);



// Get the origin of plane 'n' relative to its pile. Either or both of 'x' and
// 'y' may be NULL.
API void ncplane_abs_yx(const struct ncplane* n, int* RESTRICT y, int* RESTRICT x);
API int ncplane_abs_y(const struct ncplane* n) __attribute__ ((pure));
API int ncplane_abs_x(const struct ncplane* n) __attribute__ ((pure));

// Get the plane to which the plane 'n' is bound, if any.
API struct ncplane* ncplane_parent(struct ncplane* n);
API const struct ncplane* ncplane_parent_const(const struct ncplane* n);



// Splice ncplane 'n' out of the z-buffer, and reinsert it above 'above'.
// Returns non-zero if 'n' is already in the desired location. 'n' and
// 'above' must not be the same plane. If 'above' is NULL, 'n' is moved
// to the bottom of its pile.
API int ncplane_move_above(struct ncplane* RESTRICT n,
                           struct ncplane* RESTRICT above);

// Splice ncplane 'n' out of the z-buffer, and reinsert it below 'below'.
// Returns non-zero if 'n' is already in the desired location. 'n' and
// 'below' must not be the same plane. If 'below' is NULL, 'n' is moved to
// the top of its pile.
API int ncplane_move_below(struct ncplane* RESTRICT n,
                           struct ncplane* RESTRICT below);


// Splice ncplane 'n' and its bound planes out of the z-buffer, and reinsert
// them above or below 'targ'. Relative order will be maintained between the
// reinserted planes. For a plane E bound to C, with z-ordering A B C D E,
// moving the C family to the top results in C E A B D, while moving it to
// the bottom results in A B D C E.
API int ncplane_move_family_above(struct ncplane* n, struct ncplane* targ);

API int ncplane_move_family_below(struct ncplane* n, struct ncplane* targ);;


// Return the plane below this one, or NULL if this is at the bottom.
API struct ncplane* ncplane_below(struct ncplane* n);

// Return the plane above this one, or NULL if this is at the top.
API struct ncplane* ncplane_above(struct ncplane* n);

// Effect |r| scroll events on the plane |n|. Returns an error if |n| is not
// a scrolling plane, and otherwise returns the number of lines scrolled.
API int ncplane_scrollup(struct ncplane* n, int r);

// Scroll |n| up until |child| is no longer hidden beneath it. Returns an
// error if |child| is not a child of |n|, or |n| is not scrolling, or |child|
// is fixed. Returns the number of scrolling events otherwise (might be 0).
// If the child plane is not fixed, it will likely scroll as well.
API int ncplane_scrollup_child(struct ncplane* n, const struct ncplane* child);

// Rotate the plane π/2 radians clockwise or counterclockwise. This cannot
// be performed on arbitrary planes, because glyphs cannot be arbitrarily
// rotated. The glyphs which can be rotated are limited: line-drawing
// characters, spaces, half blocks, and full blocks. The plane must have
// an even number of columns. Use the ncvisual rotation for a more
// flexible approach.
API int ncplane_rotate_cw(struct ncplane* n);
API int ncplane_rotate_ccw(struct ncplane* n);

// Retrieve the current contents of the cell under the cursor. The EGC is
// returned, or NULL on error. This EGC must be free()d by the caller. The
// stylemask and channels are written to 'stylemask' and 'channels', respectively.
API char* ncplane_at_cursor(struct ncplane* n, uint16_t* stylemask, uint64_t* channels);

// Retrieve the current contents of the cell under the cursor into 'c'. This
// cell is invalidated if the associated plane is destroyed. Returns the number
// of bytes in the EGC, or -1 on error.
API int ncplane_at_cursor_cell(struct ncplane* n, nccell* c);

// Retrieve the current contents of the specified cell. The EGC is returned, or
// NULL on error. This EGC must be free()d by the caller. The stylemask and
// channels are written to 'stylemask' and 'channels', respectively. The return
// represents how the cell will be used during rendering, and thus integrates
// any base cell where appropriate. If called upon the secondary columns of a
// wide glyph, the EGC will be returned (i.e. this function does not distinguish
// between the primary and secondary columns of a wide glyph). If called on a
// sprixel plane, its control sequence is returned for all valid locations.
API char* ncplane_at_yx(const struct ncplane* n, int y, int x,
                        uint16_t* stylemask, uint64_t* channels);

// Retrieve the current contents of the specified cell into 'c'. This cell is
// invalidated if the associated plane is destroyed. Returns the number of
// bytes in the EGC, or -1 on error. Unlike ncplane_at_yx(), when called upon
// the secondary columns of a wide glyph, the return can be distinguished from
// the primary column (nccell_wide_right_p(c) will return true). It is an
// error to call this on a sprixel plane (unlike ncplane_at_yx()).
API int ncplane_at_yx_cell(struct ncplane* n, int y, int x, nccell* c);

// Create a flat string from the EGCs of the selected region of the ncplane
// 'n'. Start at the plane's 'begy'x'begx' coordinate (which must lie on the
// plane), continuing for 'leny'x'lenx' cells. Either or both of 'leny' and
// 'lenx' can be specified as 0 to go through the boundary of the plane.
// -1 can be specified for 'begx'/'begy' to use the current cursor location.
API char* ncplane_contents(struct ncplane* n, int begy, int begx,
                           unsigned leny, unsigned lenx);

// Manipulate the opaque user pointer associated with this plane.
// ncplane_set_userptr() returns the previous userptr after replacing
// it with 'opaque'. the others simply return the userptr.
API void* ncplane_set_userptr(struct ncplane* n, void* opaque);
API void* ncplane_userptr(struct ncplane* n);

// Find the center coordinate of a plane, preferring the top/left in the
// case of an even number of rows/columns (in such a case, there will be one
// more cell to the bottom/right of the center than the top/left). The
// center is then modified relative to the plane's origin.
API void ncplane_center_abs(const struct ncplane* n, int* RESTRICT y,
                            int* RESTRICT x);

// Create an RGBA flat array from the selected region of the ncplane 'nc'.
// Start at the plane's 'begy'x'begx' coordinate (which must lie on the
// plane), continuing for 'leny'x'lenx' cells. Either or both of 'leny' and
// 'lenx' can be specified as 0 to go through the boundary of the plane.
// Only glyphs from the specified ncblitset may be present. If 'pxdimy' and/or
// 'pxdimx' are non-NULL, they will be filled in with the total pixel geometry.
API ALLOC uint32_t* ncplane_as_rgba(const struct ncplane* n, ncblitter_e blit,
                                    int begy, int begx,
                                    unsigned leny, unsigned lenx,
                                    unsigned* pxdimy, unsigned* pxdimx);



// Move the cursor to the specified position (the cursor needn't be visible).
// Pass -1 as either coordinate to hold that axis constant. Returns -1 if the
// move would place the cursor outside the plane.
API int ncplane_cursor_move_yx(struct ncplane* n, int y, int x);

// Move the cursor relative to the current cursor position (the cursor needn't
// be visible). Returns -1 on error, including target position exceeding the
// plane's dimensions.
API int ncplane_cursor_move_rel(struct ncplane* n, int y, int x);

// Move the cursor to 0, 0. Can't fail.
API void ncplane_home(struct ncplane* n);

// Get the current position of the cursor within n. y and/or x may be NULL.
API void ncplane_cursor_yx(const struct ncplane* n, unsigned* RESTRICT y, unsigned* RESTRICT x);

// Get the current colors and alpha values for ncplane 'n'.
API uint64_t ncplane_channels(const struct ncplane* n);

// Get the current styling for the ncplane 'n'.
API uint16_t ncplane_styles(const struct ncplane* n);

// Replace the cell at the specified coordinates with the provided cell 'c',
// and advance the cursor by the width of the cell (but not past the end of the
// plane). On success, returns the number of columns the cursor was advanced.
// 'c' must already be associated with 'n'. On failure, -1 is returned.
API int ncplane_putc_yx(struct ncplane* n, int y, int x, const nccell* c);



// Replace the EGC underneath us, but retain the styling. The current styling
// of the plane will not be changed.
API int ncplane_putchar_stained(struct ncplane* n, char c);

// Replace the cell at the specified coordinates with the provided EGC, and
// advance the cursor by the width of the cluster (but not past the end of the
// plane). On success, returns the number of columns the cursor was advanced.
// On failure, -1 is returned. The number of bytes converted from gclust is
// written to 'sbytes' if non-NULL.
API int ncplane_putegc_yx(struct ncplane* n, int y, int x, const char* gclust,
                          size_t* sbytes);


// Replace the EGC underneath us, but retain the styling. The current styling
// of the plane will not be changed.
API int ncplane_putegc_stained(struct ncplane* n, const char* gclust, size_t* sbytes);



// Replace the EGC underneath us, but retain the styling. The current styling
// of the plane will not be changed.
API int ncplane_putwegc_stained(struct ncplane* n, const wchar_t* gclust, size_t* sbytes);



API int ncplane_putnstr_aligned(struct ncplane* n, int y, ncalign_e align, size_t s, const char* str);



// The ncplane equivalents of printf(3) and vprintf(3).
API int ncplane_vprintf_aligned(struct ncplane* n, int y, ncalign_e align,
                                const char* format, va_list ap);;

API int ncplane_vprintf_yx(struct ncplane* n, int y, int x,
                           const char* format, va_list ap);;


API int ncplane_vprintf_stained(struct ncplane* n, const char* format, va_list ap);;



// Write the specified text to the plane, breaking lines sensibly, beginning at
// the specified line. Returns the number of columns written. When breaking a
// line, the line will be cleared to the end of the plane (the last line will
// *not* be so cleared). The number of bytes written from the input is written
// to '*bytes' if it is not NULL. Cleared columns are included in the return
// value, but *not* included in the number of bytes written. Leaves the cursor
// at the end of output. A partial write will be accomplished as far as it can;
// determine whether the write completed by inspecting '*bytes'. Can output to
// multiple rows even in the absence of scrolling, but not more rows than are
// available. With scrolling enabled, arbitrary amounts of data can be emitted.
// All provided whitespace is preserved -- ncplane_puttext() followed by an
// appropriate ncplane_contents() will read back the original output.
//
// If 'y' is -1, the first row of output is taken relative to the current
// cursor: it will be left-, right-, or center-aligned in whatever remains
// of the row. On subsequent rows -- or if 'y' is not -1 -- the entire row can
// be used, and alignment works normally.
//
// A newline at any point will move the cursor to the next row.
API int ncplane_puttext(struct ncplane* n, int y, ncalign_e align,
                        const char* text, size_t* bytes);

// Draw horizontal or vertical lines using the specified cell, starting at the
// current cursor position. The cursor will end at the cell following the last
// cell output (even, perhaps counter-intuitively, when drawing vertical
// lines), just as if ncplane_putc() was called at that spot. Return the
// number of cells drawn on success. On error, return the negative number of
// cells drawn. A length of 0 is an error, resulting in a return of -1.
API int ncplane_hline_interp(struct ncplane* n, const nccell* c,
                             unsigned len, uint64_t c1, uint64_t c2);;
ncplane_hline(struct ncplane* n, const nccell* c, unsigned len){
  return ncplane_hline_interp(n, c, len, c->channels, c->channels);
}

API int ncplane_vline_interp(struct ncplane* n, const nccell* c,
                             unsigned len, uint64_t c1, uint64_t c2);;
ncplane_vline(struct ncplane* n, const nccell* c, unsigned len){
  return ncplane_vline_interp(n, c, len, c->channels, c->channels);
}


// Draw a box with its upper-left corner at the current cursor position, and its
// lower-right corner at 'ystop'x'xstop'. The 6 cells provided are used to draw the
// upper-left, ur, ll, and lr corners, then the horizontal and vertical lines.
// 'ctlword' is defined in the least significant byte, where bits [7, 4] are a
// gradient mask, and [3, 0] are a border mask:
//  * 7, 3: top
//  * 6, 2: right
//  * 5, 1: bottom
//  * 4, 0: left
// If the gradient bit is not set, the styling from the hl/vl cells is used for
// the horizontal and vertical lines, respectively. If the gradient bit is set,
// the color is linearly interpolated between the two relevant corner cells.
//
// By default, vertexes are drawn whether their connecting edges are drawn or
// not. The value of the bits corresponding to NCBOXCORNER_MASK control this,
// and are interpreted as the number of connecting edges necessary to draw a
// given corner. At 0 (the default), corners are always drawn. At 3, corners
// are never drawn (since at most 2 edges can touch a box's corner).
API int ncplane_box(struct ncplane* n, const nccell* ul, const nccell* ur,
                    const nccell* ll, const nccell* lr, const nccell* hline,
                    const nccell* vline, unsigned ystop, unsigned xstop,
                    unsigned ctlword);



// Starting at the specified coordinate, if its glyph is different from that of
// 'c', 'c' is copied into it, and the original glyph is considered the fill
// target. We do the same to all cardinally-connected cells having this same
// fill target. Returns the number of cells polyfilled. An invalid initial y, x
// is an error. Returns the number of cells filled, or -1 on error.
API int ncplane_polyfill_yx(struct ncplane* n, int y, int x, const nccell* c);

// Draw a gradient with its upper-left corner at the position specified by 'y'/'x',
// where -1 means the current cursor position in that dimension. The area is
// specified by 'ylen'/'xlen', where 0 means "everything remaining below or
// to the right, respectively." The glyph composed of 'egc' and 'styles' is
// used for all cells. The channels specified by 'ul', 'ur', 'll', and 'lr'
// are composed into foreground and background gradients. To do a vertical
// gradient, 'ul' ought equal 'ur' and 'll' ought equal 'lr'. To do a
// horizontal gradient, 'ul' ought equal 'll' and 'ur' ought equal 'ul'. To
// color everything the same, all four channels should be equivalent. The
// resulting alpha values are equal to incoming alpha values. Returns the
// number of cells filled on success, or -1 on failure.
// Palette-indexed color is not supported.
//
// Preconditions for gradient operations (error otherwise):
//
//  all: only RGB colors, unless all four channels match as default
//  all: all alpha values must be the same
//  1x1: all four colors must be the same
//  1xN: both top and both bottom colors must be the same (vertical gradient)
//  Nx1: both left and both right colors must be the same (horizontal gradient)
API int ncplane_gradient(struct ncplane* n, int y, int x, unsigned ylen,
                         unsigned xlen, const char* egc, uint16_t styles,
                         uint64_t ul, uint64_t ur, uint64_t ll, uint64_t lr);

// Do a high-resolution gradient using upper blocks and synced backgrounds.
// This doubles the number of vertical gradations, but restricts you to
// half blocks (appearing to be full blocks). Returns the number of cells
// filled on success, or -1 on error.
API int ncplane_gradient2x1(struct ncplane* n, int y, int x, unsigned ylen,
                            unsigned xlen, uint32_t ul, uint32_t ur,
                            uint32_t ll, uint32_t lr);

// Set the given style throughout the specified region, keeping content and
// channels unchanged. The upper left corner is at 'y', 'x', and -1 may be
// specified to indicate the cursor's position in that dimension. The area
// is specified by 'ylen', 'xlen', and 0 may be specified to indicate everything
// remaining to the right and below, respectively. It is an error for any
// coordinate to be outside the plane. Returns the number of cells set,
// or -1 on failure.
API int ncplane_format(struct ncplane* n, int y, int x, unsigned ylen,
                       unsigned xlen, uint16_t stylemask);

// Set the given channels throughout the specified region, keeping content and
// channels unchanged. The upper left corner is at 'y', 'x', and -1 may be
// specified to indicate the cursor's position in that dimension. The area
// is specified by 'ylen', 'xlen', and 0 may be specified to indicate everything
// remaining to the right and below, respectively. It is an error for any
// coordinate to be outside the plane. Returns the number of cells set,
// or -1 on failure.
API int ncplane_stain(struct ncplane* n, int y, int x, unsigned ylen,
                      unsigned xlen, uint64_t ul, uint64_t ur,
                      uint64_t ll, uint64_t lr);

// Merge the entirety of 'src' down onto the ncplane 'dst'. If 'src' does not
// intersect with 'dst', 'dst' will not be changed, but it is not an error.
API int ncplane_mergedown_simple(struct ncplane* RESTRICT src,
                                 struct ncplane* RESTRICT dst);

// Merge the ncplane 'src' down onto the ncplane 'dst'. This is most rigorously
// defined as "write to 'dst' the frame that would be rendered were the entire
// stack made up only of the specified subregion of 'src' and, below it, the
// subregion of 'dst' having the specified origin. Supply -1 to indicate the
// current cursor position in the relevant dimension. Merging is independent of
// the position of 'src' viz 'dst' on the z-axis. It is an error to define a
// subregion that is not entirely contained within 'src'. It is an error to
// define a target origin such that the projected subregion is not entirely
// contained within 'dst'.  Behavior is undefined if 'src' and 'dst' are
// equivalent. 'dst' is modified, but 'src' remains unchanged. Neither 'src'
// nor 'dst' may have sprixels. Lengths of 0 mean "everything left".
API int ncplane_mergedown(struct ncplane* RESTRICT src,
                          struct ncplane* RESTRICT dst,
                          int begsrcy, int begsrcx,
                          unsigned leny, unsigned lenx,
                          int dsty, int dstx);

// Erase every cell in the ncplane (each cell is initialized to the null glyph
// and the default channels/styles). All cells associated with this ncplane are
// invalidated, and must not be used after the call, *excluding* the base cell.
// The cursor is homed. The plane's active attributes are unaffected.
API void ncplane_erase(struct ncplane* n);

// Erase every cell in the region starting at {ystart, xstart} and having size
// {|ylen|x|xlen|} for non-zero lengths. If ystart and/or xstart are -1, the current
// cursor position along that axis is used; other negative values are an error. A
// negative ylen means to move up from the origin, and a negative xlen means to move
// left from the origin. A positive ylen moves down, and a positive xlen moves right.
// A value of 0 for the length erases everything along that dimension. It is an error
// if the starting coordinate is not in the plane, but the ending coordinate may be
// outside the plane.
//
// For example, on a plane of 20 rows and 10 columns, with the cursor at row 10 and
// column 5, the following would hold:
//
//  (-1, -1, 0, 1): clears the column to the right of the cursor (column 6)
//  (-1, -1, 0, -1): clears the column to the left of the cursor (column 4)
//  (-1, -1, INT_MAX, 0): clears all rows with or below the cursor (rows 10--19)
//  (-1, -1, -INT_MAX, 0): clears all rows with or above the cursor (rows 0--10)
//  (-1, 4, 3, 3): clears from row 5, column 4 through row 7, column 6
//  (-1, 4, -3, -3): clears from row 5, column 4 through row 3, column 2
//  (4, -1, 0, 3): clears columns 5, 6, and 7
//  (-1, -1, 0, 0): clears the plane *if the cursor is in a legal position*
//  (0, 0, 0, 0): clears the plane in all cases
API int ncplane_erase_region(struct ncplane* n, int ystart, int xstart,
                             int ylen, int xlen);

// Set the alpha and coloring bits of the plane's current channels from a
// 64-bit pair of channels.
API void ncplane_set_channels(struct ncplane* n, uint64_t channels);

// Set the background alpha and coloring bits of the plane's current
// channels from a single 32-bit value.
API uint64_t ncplane_set_bchannel(struct ncplane* n, uint32_t channel);

// Set the foreground alpha and coloring bits of the plane's current
// channels from a single 32-bit value.
API uint64_t ncplane_set_fchannel(struct ncplane* n, uint32_t channel);

// Set the specified style bits for the ncplane 'n', whether they're actively
// supported or not.
API void ncplane_set_styles(struct ncplane* n, unsigned stylebits);

// Add the specified styles to the ncplane's existing spec.
API void ncplane_on_styles(struct ncplane* n, unsigned stylebits);

// Remove the specified styles from the ncplane's existing spec.
API void ncplane_off_styles(struct ncplane* n, unsigned stylebits);

// Set the current fore/background color using RGB specifications. If the
// terminal does not support directly-specified 3x8b cells (24-bit "TrueColor",
// indicated by the "RGB" terminfo capability), the provided values will be
// interpreted in some lossy fashion. None of r, g, or b may exceed 255.
// "HP-like" terminals require setting foreground and background at the same
// time using "color pairs"; Notcurses will manage color pairs transparently.
API int ncplane_set_fg_rgb8(struct ncplane* n, unsigned r, unsigned g, unsigned b);
API int ncplane_set_bg_rgb8(struct ncplane* n, unsigned r, unsigned g, unsigned b);

// Same, but clipped to [0..255].
API void ncplane_set_bg_rgb8_clipped(struct ncplane* n, int r, int g, int b);
API void ncplane_set_fg_rgb8_clipped(struct ncplane* n, int r, int g, int b);

// Same, but with rgb assembled into a channel (i.e. lower 24 bits).
API int ncplane_set_fg_rgb(struct ncplane* n, uint32_t channel);
API int ncplane_set_bg_rgb(struct ncplane* n, uint32_t channel);

// Use the default color for the foreground/background.
API void ncplane_set_fg_default(struct ncplane* n);
API void ncplane_set_bg_default(struct ncplane* n);

// Set the ncplane's foreground palette index, set the foreground palette index
// bit, set it foreground-opaque, and clear the foreground default color bit.
API int ncplane_set_fg_palindex(struct ncplane* n, unsigned idx);
API int ncplane_set_bg_palindex(struct ncplane* n, unsigned idx);

// Set the alpha parameters for ncplane 'n'.
API int ncplane_set_fg_alpha(struct ncplane* n, int alpha);
API int ncplane_set_bg_alpha(struct ncplane* n, int alpha);

// Called for each fade iteration on 'ncp'. If anything but 0 is returned,
// the fading operation ceases immediately, and that value is propagated out.
// The recommended absolute display time target is passed in 'tspec'.
typedef int (*fadecb)(struct notcurses* nc, struct ncplane* n,
                      const struct timespec*, void* curry);

// Fade the ncplane out over the provided time, calling 'fader' at each
// iteration. Requires a terminal which supports truecolor, or at least palette
// modification (if the terminal uses a palette, our ability to fade planes is
// limited, and affected by the complexity of the rest of the screen).
API int ncplane_fadeout(struct ncplane* n, const struct timespec* ts,
                        fadecb fader, void* curry);

// Fade the ncplane in over the specified time. Load the ncplane with the
// target cells without rendering, then call this function. When it's done, the
// ncplane will have reached the target levels, starting from zeroes.
API int ncplane_fadein(struct ncplane* n, const struct timespec* ts,
                       fadecb fader, void* curry);

// Rather than the simple ncplane_fade{in/out}(), ncfadectx_setup() can be
// paired with a loop over ncplane_fade{in/out}_iteration() + ncfadectx_free().
API ALLOC struct ncfadectx* ncfadectx_setup(struct ncplane* n);

// Return the number of iterations through which 'nctx' will fade.
API int ncfadectx_iterations(const struct ncfadectx* nctx);

// Fade out through 'iter' iterations, where
// 'iter' < 'ncfadectx_iterations(nctx)'.
API int ncplane_fadeout_iteration(struct ncplane* n, struct ncfadectx* nctx,
                                  int iter, fadecb fader, void* curry);

// Fade in through 'iter' iterations, where
// 'iter' < 'ncfadectx_iterations(nctx)'.
API int ncplane_fadein_iteration(struct ncplane* n, struct ncfadectx* nctx,
                                  int iter, fadecb fader, void* curry);

// Pulse the plane in and out until the callback returns non-zero, relying on
// the callback 'fader' to initiate rendering. 'ts' defines the half-period
// (i.e. the transition from black to full brightness, or back again). Proper
// use involves preparing (but not rendering) an ncplane, then calling
// ncplane_pulse(), which will fade in from black to the specified colors.
API int ncplane_pulse(struct ncplane* n, const struct timespec* ts, fadecb fader, void* curry);

// Release the resources associated with 'nctx'.
API void ncfadectx_free(struct ncfadectx* nctx);

// Open a visual at 'file', extract a codec and parameters, decode the first
// image to memory.
API ALLOC struct ncvisual* ncvisual_from_file(const char* file);

// Prepare an ncvisual, and its underlying plane, based off RGBA content in
// memory at 'rgba'. 'rgba' is laid out as 'rows' lines, each of which is
// 'rowstride' bytes in length. Each line has 'cols' 32-bit 8bpc RGBA pixels
// followed by possible padding (there will be 'rowstride' - 'cols' * 4 bytes
// of padding). The total size of 'rgba' is thus (rows * rowstride) bytes, of
// which (rows * cols * 4) bytes are actual non-padding data.
API ALLOC struct ncvisual* ncvisual_from_rgba(const void* rgba, int rows,
                                              int rowstride, int cols);

// ncvisual_from_rgba(), but the pixels are 3-byte RGB. A is filled in
// throughout using 'alpha'.
API ALLOC struct ncvisual* ncvisual_from_rgb_packed(const void* rgba, int rows,
                                                    int rowstride, int cols,
                                                    int alpha);

// ncvisual_from_rgba(), but the pixels are 4-byte RGBx. A is filled in
// throughout using 'alpha'. rowstride must be a multiple of 4.
API ALLOC struct ncvisual* ncvisual_from_rgb_loose(const void* rgba, int rows,
                                                   int rowstride, int cols,
                                                   int alpha);

// ncvisual_from_rgba(), but 'bgra' is arranged as BGRA. note that this is a
// byte-oriented layout, despite being bunched in 32-bit pixels; the lowest
// memory address ought be B, and A is reached by adding 3 to that address.
API ALLOC struct ncvisual* ncvisual_from_bgra(const void* bgra, int rows,
                                              int rowstride, int cols);

// ncvisual_from_rgba(), but 'data' is 'pstride'-byte palette-indexed pixels,
// arranged in 'rows' lines of 'rowstride' bytes each, composed of 'cols'
// pixels. 'palette' is an array of at least 'palsize' ncchannels.
API ALLOC struct ncvisual* ncvisual_from_palidx(const void* data, int rows,
                                                int rowstride, int cols,
                                                int palsize, int pstride,
                                                const uint32_t* palette);

// Promote an ncplane 'n' to an ncvisual. The plane may contain only spaces,
// half blocks, and full blocks. The latter will be checked, and any other
// glyph will result in a NULL being returned. This function exists so that
// planes can be subjected to ncvisual transformations. If possible, it's
// better to create the ncvisual from memory using ncvisual_from_rgba().
// Lengths of 0 are interpreted to mean "all available remaining area".
API ALLOC struct ncvisual* ncvisual_from_plane(const struct ncplane* n,
                                               ncblitter_e blit,
                                               int begy, int begx,
                                               unsigned leny, unsigned lenx);

// Construct an ncvisual from a nul-terminated Sixel control sequence.
API ALLOC struct ncvisual* ncvisual_from_sixel(const char* s, unsigned leny, unsigned lenx);



// all-purpose ncvisual geometry solver. one or both of 'nc' and 'n' must be
// non-NULL. if 'nc' is NULL, only pixy/pixx will be filled in, with the true
// pixel geometry of 'n'. if 'n' is NULL, only cdimy/cdimx, blitter,
// scaley/scalex, and maxpixely/maxpixelx are filled in. cdimy/cdimx and
// maxpixely/maxpixelx are only ever filled in if we know them.
API int ncvisual_geom(const struct notcurses* nc, const struct ncvisual* n,
                      const struct ncvisual_options* vopts, ncvgeom* geom);

// Destroy an ncvisual. Rendered elements will not be disrupted, but the visual
// can be neither decoded nor rendered any further.
API void ncvisual_destroy(struct ncvisual* ncv);

// extract the next frame from an ncvisual. returns 1 on end of file, 0 on
// success, and -1 on failure.
API int ncvisual_decode(struct ncvisual* nc);

// decode the next frame ala ncvisual_decode(), but if we have reached the end,
// rewind to the first frame of the ncvisual. a subsequent 'ncvisual_blit()'
// will render the first frame, as if the ncvisual had been closed and reopened.
// the return values remain the same as those of ncvisual_decode().
API int ncvisual_decode_loop(struct ncvisual* nc);

// Rotate the visual 'rads' radians. Only M_PI/2 and -M_PI/2 are supported at
// the moment, but this might change in the future.
API int ncvisual_rotate(struct ncvisual* n, double rads);

// Scale the visual to 'rows' X 'columns' pixels, using the best scheme
// available. This is a lossy transformation, unless the size is unchanged.
API int ncvisual_resize(struct ncvisual* n, int rows, int cols);

// Scale the visual to 'rows' X 'columns' pixels, using non-interpolative
// (naive) scaling. No new colors will be introduced as a result.
API int ncvisual_resize_noninterpolative(struct ncvisual* n, int rows, int cols);

// Polyfill at the specified location within the ncvisual 'n', using 'rgba'.
API int ncvisual_polyfill_yx(struct ncvisual* n, unsigned y, unsigned x, uint32_t rgba);

// Get the specified pixel from the specified ncvisual.
API int ncvisual_at_yx(const struct ncvisual* n, unsigned y, unsigned x,
                       uint32_t* pixel);

// Set the specified pixel in the specified ncvisual.
API int ncvisual_set_yx(const struct ncvisual* n, unsigned y, unsigned x,
                        uint32_t pixel);

// Render the decoded frame according to the provided options (which may be
// NULL). The plane used for rendering depends on vopts->n and vopts->flags.
// If NCVISUAL_OPTION_CHILDPLANE is set, vopts->n must not be NULL, and the
// plane will always be created as a child of vopts->n. If this flag is not
// set, and vopts->n is NULL, a new plane is created as root of a new pile.
// If the flag is not set and vopts->n is not NULL, we render to vopts->n.
// A subregion of the visual can be rendered using 'begx', 'begy', 'lenx', and
// 'leny'. Negative values for any of these are an error. It is an error to
// specify any region beyond the boundaries of the frame. Returns the (possibly
// newly-created) plane to which we drew. Pixels may not be blitted to the
// standard plane.
API struct ncplane* ncvisual_blit(struct notcurses* nc, struct ncvisual* ncv,
                                  const struct ncvisual_options* vopts);



// If a subtitle ought be displayed at this time, return a new plane (bound
// to 'parent' containing the subtitle, which might be text or graphics
// (depending on the input format).
API ALLOC struct ncplane* ncvisual_subtitle_plane(struct ncplane* parent,
                                                  const struct ncvisual* ncv);

// Get the default *media* (not plot) blitter for this environment when using
// the specified scaling method. Currently, this means:
//  - if lacking UTF-8, NCBLIT_1x1
//  - otherwise, if not NCSCALE_STRETCH, NCBLIT_2x1
//  - otherwise, if sextants are not known to be good, NCBLIT_2x2
//  - otherwise NCBLIT_3x2
// NCBLIT_2x2 and NCBLIT_3x2 both distort the original aspect ratio, thus
// NCBLIT_2x1 is used outside of NCSCALE_STRETCH.
API ncblitter_e ncvisual_media_defblitter(const struct notcurses* nc, ncscale_e scale);

// Called for each frame rendered from 'ncv'. If anything but 0 is returned,
// the streaming operation ceases immediately, and that value is propagated out.
// The recommended absolute display time target is passed in 'tspec'.
typedef int (*ncstreamcb)(struct ncvisual*, struct ncvisual_options*,
                          const struct timespec*, void*);

// Shut up and display my frames! Provide as an argument to ncvisual_stream().
// If you'd like subtitles to be decoded, provide an ncplane as the curry. If the
// curry is NULL, subtitles will not be displayed.
API int ncvisual_simple_streamer(struct ncvisual* ncv, struct ncvisual_options* vopts,
                                 const struct timespec* tspec, void* curry);

// Stream the entirety of the media, according to its own timing. Blocking,
// obviously. streamer may be NULL; it is otherwise called for each frame, and
// its return value handled as outlined for streamcb. If streamer() returns
// non-zero, the stream is aborted, and that value is returned. By convention,
// return a positive number to indicate intentional abort from within
// streamer(). 'timescale' allows the frame duration time to be scaled. For a
// visual naturally running at 30FPS, a 'timescale' of 0.1 will result in
// 300FPS, and a 'timescale' of 10 will result in 3FPS. It is an error to
// supply 'timescale' less than or equal to 0.
API int ncvisual_stream(struct notcurses* nc, struct ncvisual* ncv,
                        float timescale, ncstreamcb streamer,
                        const struct ncvisual_options* vopts, void* curry);

// Blit a flat array 'data' of RGBA 32-bit values to the ncplane 'vopts->n',
// which mustn't be NULL. the blit begins at 'vopts->y' and 'vopts->x' relative
// to the specified plane. Each source row ought occupy 'linesize' bytes (this
// might be greater than 'vopts->lenx' * 4 due to padding or partial blits). A
// subregion of the input can be specified with the 'begy'x'begx' and
// 'leny'x'lenx' fields from 'vopts'. Returns the number of pixels blitted, or
// -1 on error.
API int ncblit_rgba(const void* data, int linesize,
                    const struct ncvisual_options* vopts);

// Same as ncblit_rgba(), but for BGRx.
API int ncblit_bgrx(const void* data, int linesize,
                    const struct ncvisual_options* vopts);

// Supply an alpha value [0..255] to be applied throughout.
API int ncblit_rgb_packed(const void* data, int linesize,
                          const struct ncvisual_options* vopts, int alpha);

// Supply an alpha value [0..255] to be applied throughout. linesize must be
// a multiple of 4 for this RGBx data.
API int ncblit_rgb_loose(const void* data, int linesize,
                         const struct ncvisual_options* vopts, int alpha);

// The ncpixel API facilitates direct management of the pixels within an
// ncvisual (ncvisuals keep a backing store of 32-bit RGBA pixels, and render
// them down to terminal graphics in ncvisual_blit()).
//
// Per libav, we "store as BGRA on little-endian, and ARGB on big-endian".
// This is an RGBA *byte-order* scheme. libav emits bytes, not words. Those
// bytes are R-G-B-A. When read as words, on little endian this will be ABGR,
// and on big-endian this will be RGBA. force everything to LE ABGR, a no-op
// on (and thus favoring) little-endian. Take that, big-endian mafia!






// Take over the ncplane 'nc' and use it to draw a reel according to 'popts'.
// The plane will be destroyed by ncreel_destroy(); this transfers ownership.
API ALLOC struct ncreel* ncreel_create(struct ncplane* n, const ncreel_options* popts);

// Returns the ncplane on which this ncreel lives.
API struct ncplane* ncreel_plane(struct ncreel* nr);

// Tablet draw callback, provided a tablet (from which the ncplane and userptr
// may be extracted), and a bool indicating whether output ought be drawn from
// the top (true) or bottom (false). Returns non-negative count of output lines,
// which must be less than or equal to ncplane_dim_y(nctablet_plane(t)).
typedef int (*tabletcb)(struct nctablet* t, bool drawfromtop);

// Add a new nctablet to the provided ncreel 'nr', having the callback object
// 'opaque'. Neither, either, or both of 'after' and 'before' may be specified.
// If neither is specified, the new tablet can be added anywhere on the reel.
// If one or the other is specified, the tablet will be added before or after
// the specified tablet. If both are specified, the tablet will be added to the
// resulting location, assuming it is valid (after->next == before->prev); if
// it is not valid, or there is any other error, NULL will be returned.
API ALLOC struct nctablet* ncreel_add(struct ncreel* nr, struct nctablet* after,
                                      struct nctablet* before, tabletcb cb,
                                      void* opaque);

// Return the number of nctablets in the ncreel 'nr'.
API int ncreel_tabletcount(const struct ncreel* nr);

// Delete the tablet specified by t from the ncreel 'nr'. Returns -1 if the
// tablet cannot be found.
API int ncreel_del(struct ncreel* nr, struct nctablet* t);

// Redraw the ncreel 'nr' in its entirety. The reel will be cleared, and
// tablets will be lain out, using the focused tablet as a fulcrum. Tablet
// drawing callbacks will be invoked for each visible tablet.
API int ncreel_redraw(struct ncreel* nr);

// Offer input 'ni' to the ncreel 'nr'. If it's relevant, this function returns
// true, and the input ought not be processed further. If it's irrelevant to
// the reel, false is returned. Relevant inputs include:
//  * a mouse click on a tablet (focuses tablet)
//  * a mouse scrollwheel event (rolls reel)
//  * up, down, pgup, or pgdown (navigates among items)
API bool ncreel_offer_input(struct ncreel* nr, const ncinput* ni);

// Return the focused tablet, if any tablets are present. This is not a copy;
// be careful to use it only for the duration of a critical section.
API struct nctablet* ncreel_focused(struct ncreel* nr);

// Change focus to the next tablet, if one exists
API struct nctablet* ncreel_next(struct ncreel* nr);

// Change focus to the previous tablet, if one exists
API struct nctablet* ncreel_prev(struct ncreel* nr);

// Destroy an ncreel allocated with ncreel_create().
API void ncreel_destroy(struct ncreel* nr);

// Returns a pointer to a user pointer associated with this nctablet.
API void* nctablet_userptr(struct nctablet* t);

// Access the ncplane associated with nctablet 't', if one exists.
API struct ncplane* nctablet_plane(struct nctablet* t);

// Takes an arbitrarily large number, and prints it into a fixed-size buffer by
// adding the necessary SI suffix. Usually, pass a |NC[IB]?PREFIXSTRLEN+1|-sized
// buffer to generate up to |NC[IB]?PREFIXCOLUMNS| columns' worth of EGCs. The
// characteristic can occupy up through |mult-1| characters (3 for 1000, 4 for
// 1024). The mantissa can occupy either zero or two characters.

// snprintf(3) is used internally, with 's' as its size bound. If the output
// requires more size than is available, NULL will be returned.
//
// Floating-point is never used, because an IEEE758 double can only losslessly
// represent integers through 2^53-1.
//
// 2^64-1 is 18446744073709551615, 18.45E(xa). KMGTPEZY thus suffice to handle
// an 89-bit uintmax_t. Beyond Z(etta) and Y(otta) lie lands unspecified by SI.
// 2^-63 is 0.000000000000000000108, 1.08a(tto).
// val: value to print
// s: maximum output size; see snprintf(3)
// decimal: scaling. '1' if none has taken place.
// buf: buffer in which string will be generated
// omitdec: inhibit printing of all-0 decimal portions
// mult: base of suffix system (almost always 1000 or 1024)
// uprefix: character to print following suffix ('i' for kibibytes basically).
//   only printed if suffix is actually printed (input >= mult).
//
// You are encouraged to consult notcurses_metric(3).
API const char* ncnmetric(uintmax_t val, size_t s, uintmax_t decimal,
                          char* buf, int omitdec, uintmax_t mult,
                          int uprefix);


// Get the default foreground color, if it is known. Returns -1 on error
// (unknown foreground). On success, returns 0, writing the RGB value to
// 'fg' (if non-NULL)
API int notcurses_default_foreground(const struct notcurses* nc, uint32_t* fg);

// Get the default background color, if it is known. Returns -1 on error
// (unknown background). On success, returns 0, writing the RGB value to
// 'bg' (if non-NULL) and setting 'bgtrans' high iff the background color
// is treated as transparent.
API int notcurses_default_background(const struct notcurses* nc, uint32_t* bg);

// Enable or disable the terminal's cursor, if supported, placing it at
// 'y', 'x'. Immediate effect (no need for a call to notcurses_render()).
// It is an error if 'y', 'x' lies outside the standard plane. Can be
// called while already visible to move the cursor.
API int notcurses_cursor_enable(struct notcurses* nc, int y, int x);

// Disable the hardware cursor. It is an error to call this while the
// cursor is already disabled.
API int notcurses_cursor_disable(struct notcurses* nc);

// Get the current location of the terminal's cursor, whether visible or not.
API int notcurses_cursor_yx(const struct notcurses* nc, int* y, int* x);

// Convert the plane's content to greyscale.
API void ncplane_greyscale(struct ncplane* n);


API ALLOC struct ncselector* ncselector_create(struct ncplane* n, const ncselector_options* opts);

// Dynamically add or delete items. It is usually sufficient to supply a static
// list of items via ncselector_options->items.
API int ncselector_additem(struct ncselector* n, const struct ncselector_item* item);
API int ncselector_delitem(struct ncselector* n, const char* item);

// Return reference to the selected option, or NULL if there are no items.
API const char* ncselector_selected(const struct ncselector* n);

// Return a reference to the ncselector's underlying ncplane.
API struct ncplane* ncselector_plane(struct ncselector* n);

// Move up or down in the list. A reference to the newly-selected item is
// returned, or NULL if there are no items in the list.
API const char* ncselector_previtem(struct ncselector* n);
API const char* ncselector_nextitem(struct ncselector* n);

// Offer the input to the ncselector. If it's relevant, this function returns
// true, and the input ought not be processed further. If it's irrelevant to
// the selector, false is returned. Relevant inputs include:
//  * a mouse click on an item
//  * a mouse scrollwheel event
//  * a mouse click on the scrolling arrows
//  * up, down, pgup, or pgdown on an unrolled menu (navigates among items)
API bool ncselector_offer_input(struct ncselector* n, const ncinput* nc);

// Destroy the ncselector.
API void ncselector_destroy(struct ncselector* n, char** item);

struct ncmselector_item {
  const char* option;
  const char* desc;
  bool selected;
};

//                                                   ╭───────────────────╮
//                                                   │ short round title │
//╭now this secondary is also very, very, very outlandishly long, you see┤
//│  ↑                                                                   │
//│ ☐ Pa231 Protactinium-231 (162kg)                                     │
//│ ☐ U233 Uranium-233 (15kg)                                            │
//│ ☐ U235 Uranium-235 (50kg)                                            │
//│ ☐ Np236 Neptunium-236 (7kg)                                          │
//│ ☐ Np237 Neptunium-237 (60kg)                                         │
//│ ☐ Pu238 Plutonium-238 (10kg)                                         │
//│ ☐ Pu239 Plutonium-239 (10kg)                                         │
//│ ☐ Pu240 Plutonium-240 (40kg)                                         │
//│ ☐ Pu241 Plutonium-241 (13kg)                                         │
//│ ☐ Am241 Americium-241 (100kg)                                        │
//│  ↓                                                                   │
//╰────────────────────────press q to exit (there is sartrev("no exit"))─╯

// multiselection widget -- a selector supporting multiple selections.
//
// Unlike the selector widget, zero to all of the items can be selected, but
// also the widget does not support adding or removing items at runtime.
typedef struct ncmultiselector_options {
  const char* title; // title may be NULL, inhibiting riser, saving two rows.
  const char* secondary; // secondary may be NULL
  const char* footer; // footer may be NULL
  const struct ncmselector_item* items; // initial items, descriptions, and statuses
  // maximum number of options to display at once, 0 to use all available space
  unsigned maxdisplay;
  // exhaustive styling options
  uint64_t opchannels;   // option channels
  uint64_t descchannels; // description channels
  uint64_t titlechannels;// title channels
  uint64_t footchannels; // secondary and footer channels
  uint64_t boxchannels;  // border channels
  uint64_t flags;        // bitfield of NCMULTISELECTOR_OPTION_*
} ncmultiselector_options;

API ALLOC struct ncmultiselector* ncmultiselector_create(struct ncplane* n, const ncmultiselector_options* opts);

// Return selected vector. An array of bools must be provided, along with its
// length. If that length doesn't match the itemcount, it is an error.
API int ncmultiselector_selected(struct ncmultiselector* n, bool* selected, unsigned count);

// Return a reference to the ncmultiselector's underlying ncplane.
API struct ncplane* ncmultiselector_plane(struct ncmultiselector* n);

// Offer the input to the ncmultiselector. If it's relevant, this function
// returns true, and the input ought not be processed further. If it's
// irrelevant to the multiselector, false is returned. Relevant inputs include:
//  * a mouse click on an item
//  * a mouse scrollwheel event
//  * a mouse click on the scrolling arrows
//  * up, down, pgup, or pgdown on an unrolled menu (navigates among items)
API bool ncmultiselector_offer_input(struct ncmultiselector* n, const ncinput* nc);

// Destroy the ncmultiselector.
API void ncmultiselector_destroy(struct ncmultiselector* n);

// nctree widget -- a vertical browser supporting line-based hierarchies.
//
// each item can have subitems, and has a curry. there is one callback for the
// entirety of the nctree. visible items have the callback invoked upon their
// curry and an ncplane. the ncplane can be reused across multiple invocations
// of the callback.

// each item has a curry, and zero or more subitems.
struct nctree_item {
  void* curry;
  struct nctree_item* subs;
  unsigned subcount;
};

typedef struct nctree_options {
  const struct nctree_item* items; // top-level nctree_item array
  unsigned count;           // size of |items|
  int (*nctreecb)(struct ncplane*, void*, int); // item callback function
  int indentcols;           // columns to indent per level of hierarchy
  uint64_t flags;           // bitfield of NCTREE_OPTION_*
} nctree_options;

// |opts| may *not* be NULL, since it is necessary to define a callback
// function.
API ALLOC struct nctree* nctree_create(struct ncplane* n, const nctree_options* opts);

// Returns the ncplane on which this nctree lives.
API struct ncplane* nctree_plane(struct nctree* n);

// Redraw the nctree 'n' in its entirety. The tree will be cleared, and items
// will be lain out, using the focused item as a fulcrum. Item-drawing
// callbacks will be invoked for each visible item.
API int nctree_redraw(struct nctree* n);

// Offer input 'ni' to the nctree 'n'. If it's relevant, this function returns
// true, and the input ought not be processed further. If it's irrelevant to
// the tree, false is returned. Relevant inputs include:
//  * a mouse click on an item (focuses item)
//  * a mouse scrollwheel event (srolls tree)
//  * up, down, pgup, or pgdown (navigates among items)
API bool nctree_offer_input(struct nctree* n, const ncinput* ni);

// Return the focused item, if any items are present. This is not a copy;
// be careful to use it only for the duration of a critical section.
API void* nctree_focused(struct nctree* n) __attribute__ ((nonnull (1)));

// Change focus to the next item.
API void* nctree_next(struct nctree* n) __attribute__ ((nonnull (1)));

// Change focus to the previous item.
API void* nctree_prev(struct nctree* n) __attribute__ ((nonnull (1)));

// Go to the item specified by the array |spec| (a spec is a series of unsigned
// values, each identifying a subelement in the hierarchy thus far, terminated
// by UINT_MAX). If the spec is invalid, NULL is returned, and the depth of the
// first invalid spec is written to *|failspec|. Otherwise, the true depth is
// written to *|failspec|, and the curry is returned (|failspec| is necessary
// because the curry could itself be NULL).
API void* nctree_goto(struct nctree* n, const unsigned* spec, int* failspec);

// Insert |add| into the nctree |n| at |spec|. The path up to the last element
// must already exist. If an item already exists at the path, it will be moved
// to make room for |add|.
API int nctree_add(struct nctree* n, const unsigned* spec, const struct nctree_item* add);

// Delete the item at |spec|, including any subitems.
API int nctree_del(struct nctree* n, const unsigned* spec);

// Destroy the nctree.
API void nctree_destroy(struct nctree* n);

// Menus. Horizontal menu bars are supported, on the top and/or bottom rows.
// If the menu bar is longer than the screen, it will be only partially
// visible. Menus may be either visible or invisible by default. In the event of
// a plane resize, menus will be automatically moved/resized. Elements can be
// dynamically enabled or disabled at all levels (menu, section, and item),
struct ncmenu_item {
  const char* desc;     // utf-8 menu item, NULL for horizontal separator
  ncinput shortcut;     // shortcut, all should be distinct
};

struct ncmenu_section {
  const char* name;       // utf-8 c string
  int itemcount;
  struct ncmenu_item* items;
  ncinput shortcut;       // shortcut, will be underlined if present in name
};

#define NCMENU_OPTION_BOTTOM 0x0001ull // bottom row (as opposed to top row)
#define NCMENU_OPTION_HIDING 0x0002ull // hide the menu when not unrolled

typedef struct ncmenu_options {
  struct ncmenu_section* sections; // array of 'sectioncount' menu_sections
  int sectioncount;                // must be positive
  uint64_t headerchannels;         // styling for header
  uint64_t sectionchannels;        // styling for sections
  uint64_t flags;                  // flag word of NCMENU_OPTION_*
} ncmenu_options;

// Create a menu with the specified options, bound to the specified plane.
API ALLOC struct ncmenu* ncmenu_create(struct ncplane* n, const ncmenu_options* opts);

// Unroll the specified menu section, making the menu visible if it was
// invisible, and rolling up any menu section that is already unrolled.
API int ncmenu_unroll(struct ncmenu* n, int sectionidx);

// Roll up any unrolled menu section, and hide the menu if using hiding.
API int ncmenu_rollup(struct ncmenu* n) __attribute__ ((nonnull (1)));

// Unroll the previous/next section (relative to current unrolled). If no
// section is unrolled, the first section will be unrolled.
API int ncmenu_nextsection(struct ncmenu* n) __attribute__ ((nonnull (1)));
API int ncmenu_prevsection(struct ncmenu* n) __attribute__ ((nonnull (1)));

// Move to the previous/next item within the currently unrolled section. If no
// section is unrolled, the first section will be unrolled.
API int ncmenu_nextitem(struct ncmenu* n) __attribute__ ((nonnull (1)));
API int ncmenu_previtem(struct ncmenu* n) __attribute__ ((nonnull (1)));

// Disable or enable a menu item. Returns 0 if the item was found.
API int ncmenu_item_set_status(struct ncmenu* n, const char* section,
                               const char* item, bool enabled);

// Return the selected item description, or NULL if no section is unrolled. If
// 'ni' is not NULL, and the selected item has a shortcut, 'ni' will be filled
// in with that shortcut--this can allow faster matching.
API const char* ncmenu_selected(const struct ncmenu* n, ncinput* ni);

// Return the item description corresponding to the mouse click 'click'. The
// item must be on an actively unrolled section, and the click must be in the
// area of a valid item. If 'ni' is not NULL, and the selected item has a
// shortcut, 'ni' will be filled in with the shortcut.
API const char* ncmenu_mouse_selected(const struct ncmenu* n,
                                      const ncinput* click, ncinput* ni);

// Return the ncplane backing this ncmenu.
API struct ncplane* ncmenu_plane(struct ncmenu* n);

// Offer the input to the ncmenu. If it's relevant, this function returns true,
// and the input ought not be processed further. If it's irrelevant to the
// menu, false is returned. Relevant inputs include:
//  * mouse movement over a hidden menu
//  * a mouse click on a menu section (the section is unrolled)
//  * a mouse click outside of an unrolled menu (the menu is rolled up)
//  * left or right on an unrolled menu (navigates among sections)
//  * up or down on an unrolled menu (navigates among items)
//  * escape on an unrolled menu (the menu is rolled up)
API bool ncmenu_offer_input(struct ncmenu* n, const ncinput* nc);

// Destroy a menu created with ncmenu_create().
API void ncmenu_destroy(struct ncmenu* n);

// Progress bars. They proceed linearly in any of four directions. The entirety
// of the plane will be used -- any border should be provided by the caller on
// another plane. The plane will not be erased; text preloaded into the plane
// will be consumed by the progress indicator. The bar is redrawn for each
// provided progress report (a double between 0 and 1), and can regress with
// lower values. The procession will take place along the longer dimension (at
// the time of each redraw), with the horizontal length scaled by 2 for
// purposes of comparison. I.e. for a plane of 20 rows and 50 columns, the
// progress will be to the right (50 > 40) or left with OPTION_RETROGRADE.

#define NCPROGBAR_OPTION_RETROGRADE        0x0001u // proceed left/down

typedef struct ncprogbar_options {
  uint32_t ulchannel; // upper-left channel. in the context of a progress bar,
  uint32_t urchannel; // "up" is the direction we are progressing towards, and
  uint32_t blchannel; // "bottom" is the direction of origin. for monochromatic
  uint32_t brchannel; // bar, all four channels ought be the same.
  uint64_t flags;
} ncprogbar_options;

// Takes ownership of the ncplane 'n', which will be destroyed by
// ncprogbar_destroy(). The progress bar is initially at 0%.
API ALLOC struct ncprogbar* ncprogbar_create(struct ncplane* n, const ncprogbar_options* opts);

// Return a reference to the ncprogbar's underlying ncplane.
API struct ncplane* ncprogbar_plane(struct ncprogbar* n);

// Set the progress bar's completion, a double 0 <= 'p' <= 1.
API int ncprogbar_set_progress(struct ncprogbar* n, double p);

// Get the progress bar's completion, a double on [0, 1].
API double ncprogbar_progress(const struct ncprogbar* n);

// Destroy the progress bar and its underlying ncplane.
API void ncprogbar_destroy(struct ncprogbar* n);

// Tabbed widgets. The tab list is displayed at the top or at the bottom of the
// plane, and only one tab is visible at a time.

// Display the tab list at the bottom instead of at the top of the plane
#define NCTABBED_OPTION_BOTTOM 0x0001ull

typedef struct nctabbed_options {
  uint64_t selchan; // channel for the selected tab header
  uint64_t hdrchan; // channel for unselected tab headers
  uint64_t sepchan; // channel for the tab separator
  const char* separator;  // separator string (copied by nctabbed_create())
  uint64_t flags;   // bitmask of NCTABBED_OPTION_*
} nctabbed_options;

// Tab content drawing callback. Takes the tab it was associated to, the ncplane
// on which tab content is to be drawn, and the user pointer of the tab.
// It is called during nctabbed_redraw().
typedef void (*tabcb)(struct nctab* t, struct ncplane* ncp, void* curry);

// Creates a new nctabbed widget, associated with the given ncplane 'n', and with
// additional options given in 'opts'. When 'opts' is NULL, it acts as if it were
// called with an all-zero opts. The widget takes ownership of 'n', and destroys
// it when the widget is destroyed. Returns the newly created widget. Returns
// NULL on failure, also destroying 'n'.
API ALLOC struct nctabbed* nctabbed_create(struct ncplane* n, const nctabbed_options* opts)
  __attribute ((nonnull (1)));

// Destroy an nctabbed widget. All memory belonging to 'nt' is deallocated,
// including all tabs and their names. The plane associated with 'nt' is also
// destroyed. Calling this with NULL does nothing.
API void nctabbed_destroy(struct nctabbed* nt);

// Redraw the widget. This calls the tab callback of the currently selected tab
// to draw tab contents, and draws tab headers. The tab content plane is not
// modified by this function, apart from resizing the plane is necessary.
API void nctabbed_redraw(struct nctabbed* nt);

// Make sure the tab header of the currently selected tab is at least partially
// visible. (by rotating tabs until at least one column is displayed)
// Does nothing if there are no tabs.
API void nctabbed_ensure_selected_header_visible(struct nctabbed* nt);

// Returns the currently selected tab, or NULL if there are no tabs.
API struct nctab* nctabbed_selected(struct nctabbed* nt);

// Returns the leftmost tab, or NULL if there are no tabs.
API struct nctab* nctabbed_leftmost(struct nctabbed* nt);

// Returns the number of tabs in the widget.
API int nctabbed_tabcount(struct nctabbed* nt);

// Returns the plane associated to 'nt'.
API struct ncplane* nctabbed_plane(struct nctabbed* nt);

// Returns the tab content plane.
API struct ncplane* nctabbed_content_plane(struct nctabbed* nt);

// Returns the tab callback.
API tabcb nctab_cb(struct nctab* t);

// Returns the tab name. This is not a copy and it should not be stored.
API const char* nctab_name(struct nctab* t);

// Returns the width (in columns) of the tab's name.
API int nctab_name_width(struct nctab* t);

// Returns the tab's user pointer.
API void* nctab_userptr(struct nctab* t);

// Returns the tab to the right of 't'. This does not change which tab is selected.
API struct nctab* nctab_next(struct nctab* t);

// Returns the tab to the left of 't'. This does not change which tab is selected.
API struct nctab* nctab_prev(struct nctab* t);

// Add a new tab to 'nt' with the given tab callback, name, and user pointer.
// If both 'before' and 'after' are NULL, the tab is inserted after the selected
// tab. Otherwise, it gets put after 'after' (if not NULL) and before 'before'
// (if not NULL). If both 'after' and 'before' are given, they must be two
// neighboring tabs (the tab list is circular, so the last tab is immediately
// before the leftmost tab), otherwise the function returns NULL. If 'name' is
// NULL or a string containing illegal characters, the function returns NULL.
// On all other failures the function also returns NULL. If it returns NULL,
// none of the arguments are modified, and the widget state is not altered.
API ALLOC struct nctab* nctabbed_add(struct nctabbed* nt, struct nctab* after,
                                     struct nctab* before, tabcb tcb,
                                     const char* name, void* opaque);

// Remove a tab 't' from 'nt'. Its neighboring tabs become neighbors to each
// other. If 't' if the selected tab, the tab after 't' becomes selected.
// Likewise if 't' is the leftmost tab, the tab after 't' becomes leftmost.
// If 't' is the only tab, there will no more be a selected or leftmost tab,
// until a new tab is added. Returns -1 if 't' is NULL, and 0 otherwise.
API int nctabbed_del(struct nctabbed* nt, struct nctab* t);

// Move 't' after 'after' (if not NULL) and before 'before' (if not NULL).
// If both 'after' and 'before' are NULL, the function returns -1, otherwise
// it returns 0.
API int nctab_move(struct nctabbed* nt, struct nctab* t, struct nctab* after,
                   struct nctab* before);

// Move 't' to the right by one tab, looping around to become leftmost if needed.
API void nctab_move_right(struct nctabbed* nt, struct nctab* t);

// Move 't' to the right by one tab, looping around to become the last tab if needed.
API void nctab_move_left(struct nctabbed* nt, struct nctab* t);

// Rotate the tabs of 'nt' right by 'amt' tabs, or '-amt' tabs left if 'amt' is
// negative. Tabs are rotated only by changing the leftmost tab; the selected tab
// stays the same. If there are no tabs, nothing happens.
API void nctabbed_rotate(struct nctabbed* nt, int amt);

// Select the tab after the currently selected tab, and return the newly selected
// tab. Returns NULL if there are no tabs.
API struct nctab* nctabbed_next(struct nctabbed* nt);

// Select the tab before the currently selected tab, and return the newly selected
// tab. Returns NULL if there are no tabs.
API struct nctab* nctabbed_prev(struct nctabbed* nt);

// Change the selected tab to be 't'. Returns the previously selected tab.
API struct nctab* nctabbed_select(struct nctabbed* nt, struct nctab* t);

// Write the channels for tab headers, the selected tab header, and the separator
// to '*hdrchan', '*selchan', and '*sepchan' respectively.
API void nctabbed_channels(struct nctabbed* nt, uint64_t* RESTRICT hdrchan,
                           uint64_t* RESTRICT selchan, uint64_t* RESTRICT sepchan);

static inline uint64_t
nctabbed_hdrchan(struct nctabbed* nt){
  uint64_t ch;
  nctabbed_channels(nt, &ch, NULL, NULL);
  return ch;
}

static inline uint64_t
nctabbed_selchan(struct nctabbed* nt){
  uint64_t ch;
  nctabbed_channels(nt, NULL, &ch, NULL);
  return ch;
}

static inline uint64_t
nctabbed_sepchan(struct nctabbed* nt){
  uint64_t ch;
  nctabbed_channels(nt, NULL, NULL, &ch);
  return ch;
}

// Returns the tab separator. This is not a copy and it should not be stored.
// This can be NULL, if the separator was set to NULL in ncatbbed_create() or
// nctabbed_set_separator().
API const char* nctabbed_separator(struct nctabbed* nt);

// Returns the tab separator width, or zero if there is no separator.
API int nctabbed_separator_width(struct nctabbed* nt);

// Set the tab headers channel for 'nt'.
API void nctabbed_set_hdrchan(struct nctabbed* nt, uint64_t chan);

// Set the selected tab header channel for 'nt'.
API void nctabbed_set_selchan(struct nctabbed* nt, uint64_t chan);

// Set the tab separator channel for 'nt'.
API void nctabbed_set_sepchan(struct nctabbed* nt, uint64_t chan);

// Set the tab callback function for 't'. Returns the previous tab callback.
API tabcb nctab_set_cb(struct nctab* t, tabcb newcb);

// Change the name of 't'. Returns -1 if 'newname' is NULL, and 0 otherwise.
API int nctab_set_name(struct nctab* t, const char* newname);

// Set the user pointer of 't'. Returns the previous user pointer.
API void* nctab_set_userptr(struct nctab* t, void* newopaque);

// Change the tab separator for 'nt'. Returns -1 if 'separator' is not NULL and
// is not a valid string, and 0 otherwise.
API int nctabbed_set_separator(struct nctabbed* nt, const char* separator);

// Plots. Given a rectilinear area, an ncplot can graph samples along some axis.
// There is some underlying independent variable--this could be e.g. measurement
// sequence number, or measurement time. Samples are tagged with this variable, which
// should never fall, but may grow non-monotonically. The desired range in terms
// of the underlying independent variable is provided at creation time. The
// desired domain can be specified, or can be autosolved. Granularity of the
// dependent variable depends on glyph selection.
//
// For instance, perhaps we're sampling load as a time series. We want to
// display an hour's worth of samples in 40 columns and 5 rows. We define the
// x-axis to be the independent variable, time. We'll stamp at second
// granularity. In this case, there are 60 * 60 == 3600 total elements in the
// range. Each column will thus cover a 90s span. Using vertical blocks (the
// most granular glyph), we have 8 * 5 == 40 levels of domain. If we report the
// following samples, starting at 0, using autosolving, we will observe:
//
// 60   -- 1%       |domain:   1--1, 0: 20 levels
// 120  -- 50%      |domain:  1--50, 0: 0 levels, 1: 40 levels
// 180  -- 50%      |domain:  1--50, 0: 0 levels, 1: 40 levels, 2: 40 levels
// 240  -- 100%     |domain:  1--75, 0: 1, 1: 27, 2: 40
// 271  -- 100%     |domain: 1--100, 0: 0, 1: 20, 2: 30, 3: 40
// 300  -- 25%      |domain:  1--75, 0: 0, 1: 27, 2: 40, 3: 33
//
// At the end, we have data in 4 90s spans: [0--89], [90--179], [180--269], and
// [270--359]. The first two spans have one sample each, while the second two
// have two samples each. Samples within a span are averaged (FIXME we could
// probably do better), so the results are 0, 50, 75, and 62.5. Scaling each of
// these out of 90 and multiplying by 40 gets our resulting levels. The final
// domain is 75 rather than 100 due to the averaging of 100+25/2->62.5 in the
// third span, at which point the maximum span value is once again 75.
//
// The 20 levels at first is a special case. When the domain is only 1 unit,
// and autoscaling is in play, assign 50%.
//
// This options structure works for both the ncuplot (uint64_t) and ncdplot
// (double) types.
#define NCPLOT_OPTION_LABELTICKSD   0x0001u // show labels for dependent axis
#define NCPLOT_OPTION_EXPONENTIALD  0x0002u // exponential dependent axis
#define NCPLOT_OPTION_VERTICALI     0x0004u // independent axis is vertical
#define NCPLOT_OPTION_NODEGRADE     0x0008u // fail rather than degrade blitter
#define NCPLOT_OPTION_DETECTMAXONLY 0x0010u // use domain detection only for max
#define NCPLOT_OPTION_PRINTSAMPLE   0x0020u // print the most recent sample

typedef struct ncplot_options {
  // channels for the maximum and minimum levels. linear or exponential
  // interpolation will be applied across the domain between these two.
  uint64_t maxchannels;
  uint64_t minchannels;
  // styling used for the legend, if NCPLOT_OPTION_LABELTICKSD is set
  uint16_t legendstyle;
  // if you don't care, pass NCBLIT_DEFAULT and get NCBLIT_8x1 (assuming
  // UTF8) or NCBLIT_1x1 (in an ASCII environment)
  ncblitter_e gridtype; // number of "pixels" per row x column
  // independent variable can either be a contiguous range, or a finite set
  // of keys. for a time range, say the previous hour sampled with second
  // resolution, the independent variable would be the range [0..3600): 3600.
  // if rangex is 0, it is dynamically set to the number of columns.
  int rangex;
  const char* title;   // optional, printed by the labels
  uint64_t flags;      // bitfield over NCPLOT_OPTION_*
} ncplot_options;

// Use the provided plane 'n' for plotting according to the options 'opts'. The
// plot will make free use of the entirety of the plane. For domain
// autodiscovery, set miny == maxy == 0. ncuplot holds uint64_ts, while
// ncdplot holds doubles.
API ALLOC struct ncuplot* ncuplot_create(struct ncplane* n, const ncplot_options* opts,
                                         uint64_t miny, uint64_t maxy);

API ALLOC struct ncdplot* ncdplot_create(struct ncplane* n, const ncplot_options* opts,
                                         double miny, double maxy);

// Return a reference to the ncplot's underlying ncplane.
API struct ncplane* ncuplot_plane(struct ncuplot* n);

API struct ncplane* ncdplot_plane(struct ncdplot* n);

// Add to or set the value corresponding to this x. If x is beyond the current
// x window, the x window is advanced to include x, and values passing beyond
// the window are lost. The first call will place the initial window. The plot
// will be redrawn, but notcurses_render() is not called.
API int ncuplot_add_sample(struct ncuplot* n, uint64_t x, uint64_t y);
API int ncdplot_add_sample(struct ncdplot* n, uint64_t x, double y);
API int ncuplot_set_sample(struct ncuplot* n, uint64_t x, uint64_t y);
API int ncdplot_set_sample(struct ncdplot* n, uint64_t x, double y);

API int ncuplot_sample(const struct ncuplot* n, uint64_t x, uint64_t* y);
API int ncdplot_sample(const struct ncdplot* n, uint64_t x, double* y);

API void ncuplot_destroy(struct ncuplot* n);
API void ncdplot_destroy(struct ncdplot* n);

typedef int(*ncfdplane_callback)(struct ncfdplane* n, const void* buf, size_t s, void* curry);
typedef int(*ncfdplane_done_cb)(struct ncfdplane* n, int fderrno, void* curry);

// read from an fd until EOF (or beyond, if follow is set), invoking the user's
// callback each time. runs in its own context. on EOF or error, the finalizer
// callback will be invoked, and the user ought destroy the ncfdplane. the
// data is *not* guaranteed to be nul-terminated, and may contain arbitrary
// zeroes.
typedef struct ncfdplane_options {
  void* curry;    // parameter provided to callbacks
  bool follow;    // keep reading after hitting end? (think tail -f)
  uint64_t flags; // bitfield over NCOPTION_FDPLANE_*
} ncfdplane_options;

// Create an ncfdplane around the fd 'fd'. Consider this function to take
// ownership of the file descriptor, which will be closed in ncfdplane_destroy().
API ALLOC struct ncfdplane* ncfdplane_create(struct ncplane* n, const ncfdplane_options* opts,
                                             int fd, ncfdplane_callback cbfxn, ncfdplane_done_cb donecbfxn);

API struct ncplane* ncfdplane_plane(struct ncfdplane* n);

API int ncfdplane_destroy(struct ncfdplane* n);

typedef struct ncsubproc_options {
  void* curry;
  uint64_t restart_period; // restart this many seconds after an exit (watch)
  uint64_t flags;          // bitfield over NCOPTION_SUBPROC_*
} ncsubproc_options;

// see exec(2). p-types use $PATH. e-type passes environment vars.
API ALLOC struct ncsubproc* ncsubproc_createv(struct ncplane* n, const ncsubproc_options* opts,
                                              const char* bin, const char* const arg[],
                                              ncfdplane_callback cbfxn, ncfdplane_done_cb donecbfxn);

API ALLOC struct ncsubproc* ncsubproc_createvp(struct ncplane* n, const ncsubproc_options* opts,
                                               const char* bin, const char* const arg[],
                                               ncfdplane_callback cbfxn, ncfdplane_done_cb donecbfxn);

API ALLOC struct ncsubproc* ncsubproc_createvpe(struct ncplane* n, const ncsubproc_options* opts,
                                                const char* bin, const char* const arg[],
                                                const char* const env[],
                                                ncfdplane_callback cbfxn, ncfdplane_done_cb donecbfxn);

API struct ncplane* ncsubproc_plane(struct ncsubproc* n);

API int ncsubproc_destroy(struct ncsubproc* n);

// Draw a QR code at the current position on the plane. If there is insufficient
// room to draw the code here, or there is any other error, non-zero will be
// returned. Otherwise, the QR code "version" (size) is returned. The QR code
// is (version * 4 + 17) columns wide, and ⌈version * 4 + 17⌉ rows tall (the
// properly-scaled values are written back to '*ymax' and '*xmax').
API int ncplane_qrcode(struct ncplane* n, unsigned* ymax, unsigned* xmax,
                       const void* data, size_t len);

// Enable horizontal scrolling. Virtual lines can then grow arbitrarily long.
#define NCREADER_OPTION_HORSCROLL 0x0001ull
// Enable vertical scrolling. You can then use arbitrarily many virtual lines.
#define NCREADER_OPTION_VERSCROLL 0x0002ull
// Disable all editing shortcuts. By default, emacs-style keys are available.
#define NCREADER_OPTION_NOCMDKEYS 0x0004ull
// Make the terminal cursor visible across the lifetime of the ncreader, and
// have the ncreader manage the cursor's placement.
#define NCREADER_OPTION_CURSOR    0x0008ull

typedef struct ncreader_options {
  uint64_t tchannels; // channels used for input
  uint32_t tattrword; // attributes used for input
  uint64_t flags;     // bitfield of NCREADER_OPTION_*
} ncreader_options;

// ncreaders provide freeform input in a (possibly multiline) region, supporting
// optional readline keybindings. takes ownership of 'n', destroying it on any
// error (ncreader_destroy() otherwise destroys the ncplane).
API ALLOC struct ncreader* ncreader_create(struct ncplane* n, const ncreader_options* opts);

// empty the ncreader of any user input, and home the cursor.
API int ncreader_clear(struct ncreader* n);

API struct ncplane* ncreader_plane(struct ncreader* n);

// Offer the input to the ncreader. If it's relevant, this function returns
// true, and the input ought not be processed further. Almost all inputs
// are relevant to an ncreader, save synthesized ones.
API bool ncreader_offer_input(struct ncreader* n, const ncinput* ni);

// Atttempt to move in the specified direction. Returns 0 if a move was
// successfully executed, -1 otherwise. Scrolling is taken into account.
API int ncreader_move_left(struct ncreader* n);
API int ncreader_move_right(struct ncreader* n);
API int ncreader_move_up(struct ncreader* n);
API int ncreader_move_down(struct ncreader* n);

// Destructively write the provided EGC to the current cursor location. Move
// the cursor as necessary, scrolling if applicable.
API int ncreader_write_egc(struct ncreader* n, const char* egc);

// return a heap-allocated copy of the current (UTF-8) contents.
API char* ncreader_contents(const struct ncreader* n);

// destroy the reader and its bound plane. if 'contents' is not NULL, the
// UTF-8 input will be heap-duplicated and written to 'contents'.
API void ncreader_destroy(struct ncreader* n, char** contents);

// Returns a heap-allocated copy of the user name under which we are running.
API ALLOC char* notcurses_accountname(void);

// Returns a heap-allocated copy of the local host name.
API ALLOC char* notcurses_hostname(void);

// Returns a heap-allocated copy of human-readable OS name and version.
API ALLOC char* notcurses_osversion(void);

// Dump selected Notcurses state to the supplied 'debugfp'. Output is freeform,
// newline-delimited, and subject to change. It includes geometry of all
// planes, from all piles. No line has more than 80 columns' worth of output.
API void notcurses_debug(const struct notcurses* nc, FILE* debugfp);

#undef API
#undef ALLOC

#ifdef __cplusplus
} // extern "C"
#endif

#endif
