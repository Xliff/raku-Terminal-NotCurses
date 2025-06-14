
#include <time.h>             
#include <ctype.h>            
#include <wchar.h>            
#include <stdio.h>            
#include <stdint.h>           
#include <stdlib.h>           
#include <stdarg.h>           
#include <string.h>           
#include <signal.h>           
#include <limits.h>           
#include <stdbool.h>          
#include <notcurses/notcurses.h>


unsigned ncchannel_alphaexport (uint32_t channel);

int ncchannel_set_alphaexport (uint32_t* channel, unsigned alpha);

bool ncchannel_default_pexport (uint32_t channel);

uint32_t ncchannel_set_defaultexport (uint32_t* channel);

bool ncchannel_palindex_pexport (uint32_t channel);

unsigned ncchannel_palindexexport (uint32_t channel);

int ncchannel_set_palindexexport (uint32_t* channel, unsigned idx);

bool ncchannel_rgb_pexport (uint32_t channel);

unsigned ncchannel_rexport (uint32_t channel);

unsigned ncchannel_gexport (uint32_t channel);

unsigned ncchannel_bexport (uint32_t channel);

uint32_t ncchannel_rgbexport (uint32_t channel);

uint32_t ncchannel_rgb8export (uint32_t channel, unsigned* RESTRICT r, unsigned* RESTRICT g,                unsigned* RESTRICT b);

int ncchannel_set_rgb8export (uint32_t* channel, unsigned r, unsigned g, unsigned b);

int ncchannel_setexport (uint32_t* channel, uint32_t rgb);

void ncchannel_set_rgb8_clippedexport (uint32_t* channel, int r, int g, int b);

uint32_t ncchannels_bchannelexport (uint64_t channels);

uint32_t ncchannels_fchannelexport (uint64_t channels);

uint64_t ncchannels_channelsexport (uint64_t channels);

bool ncchannels_bg_rgb_pexport (uint64_t channels);

bool ncchannels_fg_rgb_pexport (uint64_t channels);

unsigned ncchannels_bg_alphaexport (uint64_t channels);

uint64_t ncchannels_set_bchannelexport (uint64_t* channels, uint32_t channel);

uint64_t ncchannels_set_fchannelexport (uint64_t* channels, uint32_t channel);

uint64_t ncchannels_set_channelsexport (uint64_t* dst, uint64_t channels);

int ncchannels_set_bg_alphaexport (uint64_t* channels, unsigned alpha);

unsigned ncchannels_fg_alphaexport (uint64_t channels);

int ncchannels_set_fg_alphaexport (uint64_t* channels, unsigned alpha);

uint64_t ncchannels_reverseexport (uint64_t channels);

uint64_t ncchannels_combineexport (uint32_t fchan, uint32_t bchan);

unsigned ncchannels_fg_palindexexport (uint64_t channels);

unsigned ncchannels_bg_palindexexport (uint64_t channels);

uint32_t ncchannels_fg_rgbexport (uint64_t channels);

uint32_t ncchannels_bg_rgbexport (uint64_t channels);

uint32_t ncchannels_fg_rgb8export (uint64_t channels, unsigned* r, unsigned* g, unsigned* b);

uint32_t ncchannels_bg_rgb8export (uint64_t channels, unsigned* r, unsigned* g, unsigned* b);

int ncchannels_set_fg_rgb8export (uint64_t* channels, unsigned r, unsigned g, unsigned b);

void ncchannels_set_fg_rgb8_clippedexport (uint64_t* channels, int r, int g, int b);

int ncchannels_set_fg_palindexexport (uint64_t* channels, unsigned idx);

int ncchannels_set_fg_rgbexport (uint64_t* channels, unsigned rgb);

int ncchannels_set_bg_rgb8export (uint64_t* channels, unsigned r, unsigned g, unsigned b);

void ncchannels_set_bg_rgb8_clippedexport (uint64_t* channels, int r, int g, int b);

int ncchannels_set_bg_palindexexport (uint64_t* channels, unsigned idx);

int ncchannels_set_bg_rgbexport (uint64_t* channels, unsigned rgb);

bool ncchannels_fg_default_pexport (uint64_t channels);

bool ncchannels_fg_palindex_pexport (uint64_t channels);

bool ncchannels_bg_default_pexport (uint64_t channels);

bool ncchannels_bg_palindex_pexport (uint64_t channels);

uint64_t ncchannels_set_fg_defaultexport (uint64_t* channels);

uint64_t ncchannels_set_bg_defaultexport (uint64_t* channels);

void nccell_initexport (nccell* c);

int nccell_primeexport (struct ncplane* n, nccell* c, const char* gcluster,              uint16_t stylemask, uint64_t channels);

void nccell_set_stylesexport (nccell* c, unsigned stylebits);

uint16_t nccell_stylesexport (const nccell* c);

void nccell_on_stylesexport (nccell* c, unsigned stylebits);

void nccell_off_stylesexport (nccell* c, unsigned stylebits);

void nccell_set_fg_defaultexport (nccell* c);

void nccell_set_bg_defaultexport (nccell* c);

int nccell_set_fg_alphaexport (nccell* c, unsigned alpha);

int nccell_set_bg_alphaexport (nccell* c, unsigned alpha);

uint64_t nccell_set_bchannelexport (nccell* c, uint32_t channel);

uint64_t nccell_set_fchannelexport (nccell* c, uint32_t channel);

uint64_t nccell_set_channelsexport (nccell* c, uint64_t channels);

bool nccell_double_wide_pexport (const nccell* c);

bool nccell_wide_right_pexport (const nccell* c);

bool nccell_wide_left_pexport (const nccell* c);

uint64_t nccell_channelsexport (const nccell* c);

uint32_t nccell_bchannelexport (const nccell* cl);

uint32_t nccell_fchannelexport (const nccell* cl);

unsigned nccell_colsexport (const nccell* c);

char* nccell_strdupexport (const struct ncplane* n, const nccell* c);

char* nccell_extractexport (const struct ncplane* n, const nccell* c,                uint16_t* stylemask, uint64_t* channels);

bool nccellcmpexport (const struct ncplane* n1, const nccell* RESTRICT c1,           const struct ncplane* n2, const nccell* RESTRICT c2);

int nccell_load_charexport (struct ncplane* n, nccell* c, char ch);

int nccell_load_egc32export (struct ncplane* n, nccell* c, uint32_t egc);

int nccell_load_ucs32export (struct ncplane* n, nccell* c, uint32_t u);

struct ncplane* notcurses_topexport (struct notcurses* n);

struct ncplane* notcurses_bottomexport (struct notcurses* n);

int notcurses_renderexport (struct notcurses* nc);

bool nckey_mouse_pexport (uint32_t r);

bool ncinput_shift_pexport (const ncinput* n);

bool ncinput_ctrl_pexport (const ncinput* n);

bool ncinput_alt_pexport (const ncinput* n);

bool ncinput_meta_pexport (const ncinput* n);

bool ncinput_super_pexport (const ncinput* n);

bool ncinput_hyper_pexport (const ncinput* n);

bool ncinput_capslock_pexport (const ncinput* n);

bool ncinput_numlock_pexport (const ncinput* n);

bool ncinput_equal_pexport (const ncinput* n1, const ncinput* n2);

uint32_t notcurses_get_nblockexport (struct notcurses* n, ncinput* ni);

uint32_t notcurses_get_blockingexport (struct notcurses* n, ncinput* ni);

bool ncinput_nomod_pexport (const ncinput* ni);

int notcurses_mice_disableexport (struct notcurses* n);

struct ncplane* notcurses_stddim_yxexport (struct notcurses* nc, unsigned* RESTRICT y, unsigned* RESTRICT x);

const struct ncplane* notcurses_stddim_yx_constexport (const struct notcurses* nc, unsigned* RESTRICT y, unsigned* RESTRICT x);

unsigned ncplane_dim_yexport (const struct ncplane* n);

unsigned ncplane_dim_xexport (const struct ncplane* n);

void notcurses_term_dim_yxexport (const struct notcurses* n, unsigned* RESTRICT rows, unsigned* RESTRICT cols);

int ncpalette_set_rgb8export (ncpalette* p, int idx, unsigned r, unsigned g, unsigned b);

int ncpalette_setexport (ncpalette* p, int idx, unsigned rgb);

int ncpalette_getexport (const ncpalette* p, int idx, uint32_t* palent);

int ncpalette_get_rgb8export (const ncpalette* p, int idx, unsigned* RESTRICT r, unsigned* RESTRICT g, unsigned* RESTRICT b);

bool nccapability_canchangecolorexport (const nccapabilities* caps);

bool notcurses_cantruecolorexport (const struct notcurses* nc);

bool notcurses_canchangecolorexport (const struct notcurses* nc);

bool notcurses_canfadeexport (const struct notcurses* n);

bool notcurses_canutf8export (const struct notcurses* nc);

bool notcurses_canhalfblockexport (const struct notcurses* nc);

bool notcurses_canquadrantexport (const struct notcurses* nc);

bool notcurses_cansextantexport (const struct notcurses* nc);

bool notcurses_canbrailleexport (const struct notcurses* nc);

bool notcurses_canpixelexport (const struct notcurses* nc);

int ncplane_resize_simpleexport (struct ncplane* n, unsigned ylen, unsigned xlen);

int ncplane_move_relexport (struct ncplane* n, int y, int x);

int ncplane_descendant_pexport (const struct ncplane* n, const struct ncplane* ancestor);

void ncplane_move_topexport (struct ncplane* n);

void ncplane_move_bottomexport (struct ncplane* n);

void ncplane_move_family_topexport (struct ncplane* n);

void ncplane_move_family_bottomexport (struct ncplane* n);

int notcurses_alignexport (int availu, ncalign_e align, int u);

int ncplane_halignexport (const struct ncplane* n, ncalign_e align, int c);

int ncplane_valignexport (const struct ncplane* n, ncalign_e align, int r);

unsigned ncplane_cursor_yexport (const struct ncplane* n);

unsigned ncplane_cursor_xexport (const struct ncplane* n);

int ncplane_putcexport (struct ncplane* n, const nccell* c);

int ncplane_putchar_yxexport (struct ncplane* n, int y, int x, char c);

int ncplane_putcharexport (struct ncplane* n, char c);

int ncplane_putegcexport (struct ncplane* n, const char* gclust, size_t* sbytes);

char* ncwcsrtombsexport (const wchar_t* src);

int ncplane_putwegcexport (struct ncplane* n, const wchar_t* gclust, size_t* sbytes);

int ncplane_putwegc_yxexport (struct ncplane* n, int y, int x, const wchar_t* gclust,                    size_t* sbytes);

int ncplane_putstr_yxexport (struct ncplane* n, int y, int x, const char* gclusters);

int ncplane_putstrexport (struct ncplane* n, const char* gclustarr);

int ncplane_putstr_alignedexport (struct ncplane* n, int y, ncalign_e align, const char* s);

int ncplane_putstr_stainedexport (struct ncplane* n, const char* gclusters);

int ncplane_putnstr_yxexport (struct ncplane* n, int y, int x, size_t s, const char* gclusters);

int ncplane_putnstrexport (struct ncplane* n, size_t s, const char* gclustarr);

int ncplane_putwstr_yxexport (struct ncplane* n, int y, int x, const wchar_t* gclustarr);

int ncplane_putwstr_alignedexport (struct ncplane* n, int y, ncalign_e align,                         const wchar_t* gclustarr);

int ncplane_putwstrexport (struct ncplane* n, const wchar_t* gclustarr);

int ncplane_pututf32_yxexport (struct ncplane* n, int y, int x, uint32_t u);

int ncplane_putwc_yxexport (struct ncplane* n, int y, int x, wchar_t w);

int ncplane_putwcexport (struct ncplane* n, wchar_t w);

int ncplane_putwc_utf32export (struct ncplane* n, const wchar_t* w, unsigned* wchars);

int ncplane_putwc_stainedexport (struct ncplane* n, wchar_t w);

int ncplane_vprintfexport (struct ncplane* n, const char* format, va_list ap);

int ncplane_printfexport (struct ncplane* n, const char* format, ...);

int ncplane_printf_yxexport (struct ncplane* n, int y, int x, const char* format, ...);

int ncplane_printf_alignedexport (struct ncplane* n, int y, ncalign_e align, const char* format, ...);

int ncplane_printf_stainedexport (struct ncplane* n, const char* format, ...);

int ncplane_hlineexport (struct ncplane* n, const nccell* c, unsigned len);

int ncplane_vlineexport (struct ncplane* n, const nccell* c, unsigned len);

int ncplane_box_sizedexport (struct ncplane* n, const nccell* ul, const nccell* ur,                   const nccell* ll, const nccell* lr, const nccell* hline,                   const nccell* vline, unsigned ystop, unsigned xstop,                   unsigned ctlword);

int ncplane_perimeterexport (struct ncplane* n, const nccell* ul, const nccell* ur,                   const nccell* ll, const nccell* lr, const nccell* hline,                   const nccell* vline, unsigned ctlword);

uint32_t nccell_fg_rgbexport (const nccell* cl);

uint32_t nccell_bg_rgbexport (const nccell* cl);

uint32_t nccell_fg_alphaexport (const nccell* cl);

uint32_t nccell_bg_alphaexport (const nccell* cl);

uint32_t nccell_fg_rgb8export (const nccell* cl, unsigned* r, unsigned* g, unsigned* b);

uint32_t nccell_bg_rgb8export (const nccell* cl, unsigned* r, unsigned* g, unsigned* b);

int nccell_set_fg_rgb8export (nccell* cl, unsigned r, unsigned g, unsigned b);

void nccell_set_fg_rgb8_clippedexport (nccell* cl, int r, int g, int b);

int nccell_set_fg_rgbexport (nccell* c, uint32_t channel);

int nccell_set_fg_palindexexport (nccell* cl, unsigned idx);

uint32_t nccell_fg_palindexexport (const nccell* cl);

int nccell_set_bg_rgb8export (nccell* cl, unsigned r, unsigned g, unsigned b);

void nccell_set_bg_rgb8_clippedexport (nccell* cl, int r, int g, int b);

int nccell_set_bg_rgbexport (nccell* c, uint32_t channel);

int nccell_set_bg_palindexexport (nccell* cl, unsigned idx);

uint32_t nccell_bg_palindexexport (const nccell* cl);

bool nccell_fg_default_pexport (const nccell* cl);

bool nccell_fg_palindex_pexport (const nccell* cl);

bool nccell_bg_default_pexport (const nccell* cl);

bool nccell_bg_palindex_pexport (const nccell* cl);

uint32_t ncplane_bchannelexport (const struct ncplane* n);

uint32_t ncplane_fchannelexport (const struct ncplane* n);

uint32_t ncplane_fg_rgbexport (const struct ncplane* n);

uint32_t ncplane_bg_rgbexport (const struct ncplane* n);

uint32_t ncplane_fg_alphaexport (const struct ncplane* n);

bool ncplane_fg_default_pexport (const struct ncplane* n);

uint32_t ncplane_bg_alphaexport (const struct ncplane* n);

bool ncplane_bg_default_pexport (const struct ncplane* n);

uint32_t ncplane_fg_rgb8export (const struct ncplane* n, unsigned* r, unsigned* g, unsigned* b);

uint32_t ncplane_bg_rgb8export (const struct ncplane* n, unsigned* r, unsigned* g, unsigned* b);

int nccells_load_boxexport (struct ncplane* n, uint16_t styles, uint64_t channels,                  nccell* ul, nccell* ur, nccell* ll, nccell* lr,                  nccell* hl, nccell* vl, const char* gclusters);

int nccells_ascii_boxexport (struct ncplane* n, uint16_t attr, uint64_t channels,                   nccell* ul, nccell* ur, nccell* ll, nccell* lr, nccell* hl, nccell* vl);

int nccells_double_boxexport (struct ncplane* n, uint16_t attr, uint64_t channels,                    nccell* ul, nccell* ur, nccell* ll, nccell* lr, nccell* hl, nccell* vl);

int nccells_rounded_boxexport (struct ncplane* n, uint16_t attr, uint64_t channels,                     nccell* ul, nccell* ur, nccell* ll, nccell* lr, nccell* hl, nccell* vl);

int nccells_light_boxexport (struct ncplane* n, uint16_t attr, uint64_t channels,                   nccell* ul, nccell* ur, nccell* ll, nccell* lr, nccell* hl, nccell* vl);

int nccells_heavy_boxexport (struct ncplane* n, uint16_t attr, uint64_t channels,                   nccell* ul, nccell* ur, nccell* ll, nccell* lr, nccell* hl, nccell* vl);

int ncplane_rounded_boxexport (struct ncplane* n, uint16_t styles, uint64_t channels,                     unsigned ystop, unsigned xstop, unsigned ctlword);

int ncplane_perimeter_roundedexport (struct ncplane* n, uint16_t stylemask,                           uint64_t channels, unsigned ctlword);

int ncplane_rounded_box_sizedexport (struct ncplane* n, uint16_t styles, uint64_t channels,                           unsigned ylen, unsigned xlen, unsigned ctlword);

int ncplane_double_boxexport (struct ncplane* n, uint16_t styles, uint64_t channels,                    unsigned ylen, unsigned xlen, unsigned ctlword);

int ncplane_ascii_boxexport (struct ncplane* n, uint16_t styles, uint64_t channels,                   unsigned ylen, unsigned xlen, unsigned ctlword);

int ncplane_perimeter_doubleexport (struct ncplane* n, uint16_t stylemask,                          uint64_t channels, unsigned ctlword);

int ncplane_double_box_sizedexport (struct ncplane* n, uint16_t styles, uint64_t channels,                          unsigned ylen, unsigned xlen, unsigned ctlword);

struct ncplane* ncvisualplane_createexport (struct notcurses* nc, const struct ncplane_options* opts,                      struct ncvisual* ncv, struct ncvisual_options* vopts);

unsigned ncpixel_aexport (uint32_t pixel);

unsigned ncpixel_rexport (uint32_t pixel);

unsigned ncpixel_gexport (uint32_t pixel);

unsigned ncpixel_bexport (uint32_t pixel);

int ncpixel_set_aexport (uint32_t* pixel, unsigned a);

int ncpixel_set_rexport (uint32_t* pixel, unsigned r);

int ncpixel_set_gexport (uint32_t* pixel, unsigned g);

int ncpixel_set_bexport (uint32_t* pixel, unsigned b);

uint32_t ncpixelexport (unsigned r, unsigned g, unsigned b);

int ncpixel_set_rgb8export (uint32_t* pixel, unsigned r, unsigned g, unsigned b);

const char* ncqprefixexport (uintmax_t val, uintmax_t decimal, char* buf, int omitdec);

const char* nciprefixexport (uintmax_t val, uintmax_t decimal, char* buf, int omitdec);

const char* ncbprefixexport (uintmax_t val, uintmax_t decimal, char* buf, int omitdec);

uint64_t nctabbed_hdrchanexport (struct nctabbed* nt);

uint64_t nctabbed_selchanexport (struct nctabbed* nt);

uint64_t nctabbed_sepchanexport (struct nctabbed* nt);

