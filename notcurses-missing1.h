int nccell_load(struct ncplane* n, nccell* c, const char* gcluster);
int nccell_duplicate(struct ncplane* n, nccell* targ, const nccell* c);
void nccell_release(struct ncplane* n, nccell* c);
char *nccell_extended_gcluster(const struct ncplane* n, const nccell* c);

char* ncplane_name(const struct ncplane* n);
ncplane* ncplane_reparent(struct ncplane* n, struct ncplane* newparent);
ncplane* ncplane_reparent_family(struct ncplane* n, struct ncplane* newparent);
ncplane* ncplane_dup(const struct ncplane* n, void* opaque);
void ncplane_translate(const struct ncplane* src, const struct ncplane* dst, int*  y, int* x);
bool ncplane_translate_abs(const struct ncplane* n, int* y, int* x);
bool ncplane_set_scrolling(struct ncplane* n, unsigned scrollp);
bool ncplane_scrolling_p(const struct ncplane* n);
bool ncplane_set_autogrow(struct ncplane* n, unsigned growp);
bool ncplane_autogrow_p(const struct ncplane* n);
ncpalette* ncpalette_new(struct notcurses* nc);
void ncpalette_use(struct notcurses* nc, const ncpalette* p);
uint16_t notcurses_supported_styles(const struct notcurses* nc);
unsigned notcurses_palette_size(const struct notcurses* nc);
char* notcurses_detected_terminal(const struct notcurses* nc);
char* notcurses_detected_terminal(const struct notcurses* nc);
nccapabilities* notcurses_capabilities(const struct notcurses* n);
ncpixelimpl_e notcurses_check_pixel_support(const struct notcurses* nc);
bool notcurses_canopen_images(const struct notcurses* nc);
bool notcurses_canopen_videos(const struct notcurses* nc);
ncstats *notcurses_stats_alloc(const struct notcurses* nc);
void notcurses_stats(struct notcurses* nc, ncstats* stats);
void notcurses_stats_reset(struct notcurses* nc, ncstats* stats);
void ncplane_resize(struct ncplane* n, int keepy, int keepx,
                       unsigned keepleny, unsigned keeplenx,
                       int yoff, int xoff,
                       unsigned ylen, unsigned xlen);
int ncplane_destroy(struct ncplane* n);
int ncplane_set_base_cell(struct ncplane* n, const nccell* c);
int ncplane_set_base(struct ncplane* n, const char* egc,
                         uint16_t stylemask, uint64_t channels);
int ncplane_base(struct ncplane* n, nccell* c);
void ncplane_yx(struct ncplane* n, int* y, int* x);
int ncplane_y(struct ncplane* n);
int ncplane_x(struct ncplane* n);
int ncplane_move_yx(struct ncplane* n, int y, int x);
int ncplane_abs_y(struct ncplane* n);
int ncplane_abs_x(struct ncplane* n);
ncplane* ncplane_parent(struct ncplane* n);
ncplane* ncplane_parent_const(const struct ncplane* n);
int ncplane_move_above(struct ncplane* n, struct ncplane* above);
int ncplane_move_below(struct ncplane* n, struct ncplane* below);
int ncplane_move_family_above(struct ncplane* n, struct ncplane* targ);
int ncplane_move_family_below(struct ncplane* n, struct ncplane* targ);
struct ncplane* ncplane_below(struct ncplane* n);
struct ncplane* ncplane_above(struct ncplane* n);
int ncplane_scrollup(struct ncplane* n, int r);
int ncplane_scrollup_child(struct ncplane* n, const struct ncplane* child);
int ncplane_rotate_cw(struct ncplane* n);
int ncplane_rotate_ccw(struct ncplane* n);
char* ncplane_at_cursor(struct ncplane* n, uint16_t* stylemask, uint64_t* channels);
int ncplane_at_cursor_cell(struct ncplane* n, nccell* c);
char* ncplane_at_yx(const struct ncplane* n, int y, int x,
                        uint16_t* stylemask, uint64_t* channels);
char* ncplane_contents(struct ncplane* n, int begy, int begx,
        unsigned leny, unsigned lenx);
void* ncplane_set_userptr(struct ncplane* n, void* opaque);
void* ncplane_userptr(struct ncplane* n);
void ncplane_center_abs(const struct ncplane* n, int* y, int* x);
uint32_t *ncplane_as_rgba(const struct ncplane* n, ncblitter_e blit,
                                    int begy, int begx,
                                    unsigned leny, unsigned lenx,
                                    unsigned* pxdimy, unsigned* pxdimx);
int ncplane_cursor_move_rel(struct ncplane* n, int y, int x);
void ncplane_cursor_yx(const struct ncplane* n, unsigned* y, unsigned* x);
uint64_t ncplane_channels(const struct ncplane* n);
uint16_t ncplane_styles(const struct ncplane* n);
int ncplane_putc_yx(struct ncplane* n, int y, int x, const nccell* c);
int ncplane_putchar_stained(struct ncplane* n, char c);
int ncplane_putegc_yx(struct ncplane* n, int y, int x, const char* gclust,
                          size_t* sbytes);
int ncplane_putegc_stained(struct ncplane* n, const char* gclust, size_t* sbytes);
int ncplane_putwegc_stained(struct ncplane* n, const wchar_t* gclust, size_t* sbytes);
int ncplane_putnstr_aligned(struct ncplane* n, int y, ncalign_e align, size_t s, const char* str);
int ncplane_putwstr_stained(struct ncplane* n, const wchar_t* gclustarr);
