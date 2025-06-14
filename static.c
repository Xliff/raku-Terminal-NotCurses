
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

 unsigned
ncchannel_alpha_export (uint32_t channel){
  return channel & NC_BG_ALPHA_MASK;
}

 int
ncchannel_set_alpha_export (uint32_t* channel, unsigned alpha){
  if(alpha & ~NC_BG_ALPHA_MASK){
    return -1;
  }
  *channel = (uint32_t)alpha | (*channel & (uint32_t)~NC_BG_ALPHA_MASK);
  if(alpha != NCALPHA_OPAQUE){
    *channel |= NC_BGDEFAULT_MASK;
  }
  return 0;
}

 bool
ncchannel_default_p_export (uint32_t channel){
  return !(channel & NC_BGDEFAULT_MASK);
}

 uint32_t
ncchannel_set_default_export (uint32_t* channel){
  *channel &= (uint32_t)~NC_BGDEFAULT_MASK; // turn off not-default bit
  ncchannel_set_alpha(channel, NCALPHA_OPAQUE);
  return *channel;
}

 bool
ncchannel_palindex_p_export (uint32_t channel){
  return !ncchannel_default_p(channel) && (channel & NC_BG_PALETTE);
}

 unsigned
ncchannel_palindex_export (uint32_t channel){
  return channel & 0xff;
}

 int
ncchannel_set_palindex_export (uint32_t* channel, unsigned idx){
  if(idx >= NCPALETTESIZE){
    return -1;
  }
  ncchannel_set_alpha(channel, NCALPHA_OPAQUE);
  *channel &= 0xff000000ull;
  *channel |= NC_BGDEFAULT_MASK | NC_BG_PALETTE | idx;
  return 0;
}

 bool
ncchannel_rgb_p_export (uint32_t channel){
  // bitwise or is intentional (allows compiler more freedom)
  return !(ncchannel_default_p(channel) | ncchannel_palindex_p(channel));
}

 unsigned
ncchannel_r_export (uint32_t channel){
  return (channel & 0xff0000u) >> 16u;
}

 unsigned
ncchannel_g_export (uint32_t channel){
  return (channel & 0x00ff00u) >> 8u;
}

 unsigned
ncchannel_b_export (uint32_t channel){
  return (channel & 0x0000ffu);
}

 uint32_t
ncchannel_rgb_export (uint32_t channel){
  return channel & NC_BG_RGB_MASK;
}

 uint32_t
ncchannel_rgb8_export (uint32_t channel, unsigned* RESTRICT r, unsigned* RESTRICT g,
               unsigned* RESTRICT b){
  *r = ncchannel_r(channel);
  *g = ncchannel_g(channel);
  *b = ncchannel_b(channel);
  return channel;
}

 int
ncchannel_set_rgb8_export (uint32_t* channel, unsigned r, unsigned g, unsigned b){
  if(r >= 256 || g >= 256 || b >= 256){
    return -1;
  }
  uint32_t c = (r << 16u) | (g << 8u) | b;
  // clear the existing rgb bits, clear the palette index indicator, set
  // the not-default bit, and or in the new rgb.
  *channel = (uint32_t)((*channel & ~(NC_BG_RGB_MASK | NC_BG_PALETTE)) | NC_BGDEFAULT_MASK | c);
  return 0;
}

 int
ncchannel_set_export (uint32_t* channel, uint32_t rgb){
  if(rgb > 0xffffffu){
    return -1;
  }
  *channel = (uint32_t)((*channel & ~(NC_BG_RGB_MASK | NC_BG_PALETTE)) | NC_BGDEFAULT_MASK | rgb);
  return 0;
}

 void
ncchannel_set_rgb8_clipped_export (uint32_t* channel, int r, int g, int b){
  if(r >= 256){
    r = 255;
  }
  if(g >= 256){
    g = 255;
  }
  if(b >= 256){
    b = 255;
  }
  if(r <= -1){
    r = 0;
  }
  if(g <= -1){
    g = 0;
  }
  if(b <= -1){
    b = 0;
  }
  uint32_t c = (uint32_t)((r << 16u) | (g << 8u) | b);
  *channel = (uint32_t)((*channel & ~(NC_BG_RGB_MASK | NC_BG_PALETTE)) | NC_BGDEFAULT_MASK | c);
}

 uint32_t
ncchannels_bchannel_export (uint64_t channels){
  return channels & (NC_BG_RGB_MASK | NC_BG_PALETTE |
                     NC_BGDEFAULT_MASK | NC_BG_ALPHA_MASK);
}

 uint32_t
ncchannels_fchannel_export (uint64_t channels){
  return ncchannels_bchannel(channels >> 32u);
}

 uint64_t
ncchannels_channels_export (uint64_t channels){
  return ncchannels_bchannel(channels) |
         ((uint64_t)ncchannels_fchannel(channels) << 32u);
}

 bool
ncchannels_bg_rgb_p_export (uint64_t channels){
  return ncchannel_rgb_p(ncchannels_bchannel(channels));
}

 bool
ncchannels_fg_rgb_p_export (uint64_t channels){
  return ncchannel_rgb_p(ncchannels_fchannel(channels));
}

 unsigned
ncchannels_bg_alpha_export (uint64_t channels){
  return ncchannel_alpha(ncchannels_bchannel(channels));
}

 uint64_t
ncchannels_set_bchannel_export (uint64_t* channels, uint32_t channel){
  // drop the background color and alpha bit
  *channels &= ((0xffffffffllu << 32u) | NC_NOBACKGROUND_MASK);
  *channels |= (uint32_t)(channel & ~NC_NOBACKGROUND_MASK);
  return *channels;
}

 uint64_t
ncchannels_set_fchannel_export (uint64_t* channels, uint32_t channel){
  // drop the foreground color and alpha bit
  *channels &= (0xffffffffllu | ((uint64_t)NC_NOBACKGROUND_MASK << 32u));
  *channels |= (uint64_t)(channel & ~NC_NOBACKGROUND_MASK) << 32u;
  return *channels;
}

 uint64_t
ncchannels_set_channels_export (uint64_t* dst, uint64_t channels){
  ncchannels_set_bchannel(dst, channels & 0xffffffffull);
  ncchannels_set_fchannel(dst, (uint32_t)((channels >> 32u) & 0xffffffffull));
  return *dst;
}

 int
ncchannels_set_bg_alpha_export (uint64_t* channels, unsigned alpha){
  if(alpha == NCALPHA_HIGHCONTRAST){ // forbidden for background alpha
    return -1;
  }
  uint32_t channel = ncchannels_bchannel(*channels);
  if(ncchannel_set_alpha(&channel, alpha) < 0){
    return -1;
  }
  ncchannels_set_bchannel(channels, channel);
  return 0;
}

 unsigned
ncchannels_fg_alpha_export (uint64_t channels){
  return ncchannel_alpha(ncchannels_fchannel(channels));
}

 int
ncchannels_set_fg_alpha_export (uint64_t* channels, unsigned alpha){
  uint32_t channel = ncchannels_fchannel(*channels);
  if(ncchannel_set_alpha(&channel, alpha) < 0){
    return -1;
  }
  *channels = ((uint64_t)channel << 32llu) | (*channels & 0xffffffffllu);
  return 0;
}

 uint64_t
ncchannels_reverse_export (uint64_t channels){
  const uint64_t raw = ((uint64_t)ncchannels_bchannel(channels) << 32u) +
                       ncchannels_fchannel(channels);
  const uint64_t statemask = ((NC_NOBACKGROUND_MASK | NC_BG_ALPHA_MASK) << 32u) |
                             NC_NOBACKGROUND_MASK | NC_BG_ALPHA_MASK;
  uint64_t ret = raw & ~statemask;
  ret |= channels & statemask;
  if(ncchannels_bg_alpha(ret) != NCALPHA_OPAQUE){
    if(!ncchannels_bg_rgb_p(ret)){
      ncchannels_set_bg_alpha(&ret, NCALPHA_OPAQUE);
    }
  }
  if(ncchannels_fg_alpha(ret) != NCALPHA_OPAQUE){
    if(!ncchannels_fg_rgb_p(ret)){
      ncchannels_set_fg_alpha(&ret, NCALPHA_OPAQUE);
    }
  }
  return ret;
}

 uint64_t
ncchannels_combine_export (uint32_t fchan, uint32_t bchan){
  uint64_t channels = 0;
  ncchannels_set_fchannel(&channels, fchan);
  ncchannels_set_bchannel(&channels, bchan);
  return channels;
}

 unsigned
ncchannels_fg_palindex_export (uint64_t channels){
  return ncchannel_palindex(ncchannels_fchannel(channels));
}

 unsigned
ncchannels_bg_palindex_export (uint64_t channels){
  return ncchannel_palindex(ncchannels_bchannel(channels));
}

 uint32_t
ncchannels_fg_rgb_export (uint64_t channels){
  return ncchannel_rgb(ncchannels_fchannel(channels));
}

 uint32_t
ncchannels_bg_rgb_export (uint64_t channels){
  return ncchannel_rgb(ncchannels_bchannel(channels));
}

 uint32_t
ncchannels_fg_rgb8_export (uint64_t channels, unsigned* r, unsigned* g, unsigned* b){
  return ncchannel_rgb8(ncchannels_fchannel(channels), r, g, b);
}

 uint32_t
ncchannels_bg_rgb8_export (uint64_t channels, unsigned* r, unsigned* g, unsigned* b){
  return ncchannel_rgb8(ncchannels_bchannel(channels), r, g, b);
}

 int
ncchannels_set_fg_rgb8_export (uint64_t* channels, unsigned r, unsigned g, unsigned b){
  uint32_t channel = ncchannels_fchannel(*channels);
  if(ncchannel_set_rgb8(&channel, r, g, b) < 0){
    return -1;
  }
  *channels = ((uint64_t)channel << 32llu) | (*channels & 0xffffffffllu);
  return 0;
}

 void
ncchannels_set_fg_rgb8_clipped_export (uint64_t* channels, int r, int g, int b){
  uint32_t channel = ncchannels_fchannel(*channels);
  ncchannel_set_rgb8_clipped(&channel, r, g, b);
  *channels = ((uint64_t)channel << 32llu) | (*channels & 0xffffffffllu);
}

 int
ncchannels_set_fg_palindex_export (uint64_t* channels, unsigned idx){
  uint32_t channel = ncchannels_fchannel(*channels);
  if(ncchannel_set_palindex(&channel, idx) < 0){
    return -1;
  }
  *channels = ((uint64_t)channel << 32llu) | (*channels & 0xffffffffllu);
  return 0;
}

 int
ncchannels_set_fg_rgb_export (uint64_t* channels, unsigned rgb){
  uint32_t channel = ncchannels_fchannel(*channels);
  if(ncchannel_set(&channel, rgb) < 0){
    return -1;
  }
  *channels = ((uint64_t)channel << 32llu) | (*channels & 0xffffffffllu);
  return 0;
}

 int
ncchannels_set_bg_rgb8_export (uint64_t* channels, unsigned r, unsigned g, unsigned b){
  uint32_t channel = ncchannels_bchannel(*channels);
  if(ncchannel_set_rgb8(&channel, r, g, b) < 0){
    return -1;
  }
  ncchannels_set_bchannel(channels, channel);
  return 0;
}

 void
ncchannels_set_bg_rgb8_clipped_export (uint64_t* channels, int r, int g, int b){
  uint32_t channel = ncchannels_bchannel(*channels);
  ncchannel_set_rgb8_clipped(&channel, r, g, b);
  ncchannels_set_bchannel(channels, channel);
}

 int
ncchannels_set_bg_palindex_export (uint64_t* channels, unsigned idx){
  uint32_t channel = ncchannels_bchannel(*channels);
  if(ncchannel_set_palindex(&channel, idx) < 0){
    return -1;
  }
  ncchannels_set_bchannel(channels, channel);
  return 0;
}

 int
ncchannels_set_bg_rgb_export (uint64_t* channels, unsigned rgb){
  uint32_t channel = ncchannels_bchannel(*channels);
  if(ncchannel_set(&channel, rgb) < 0){
    return -1;
  }
  ncchannels_set_bchannel(channels, channel);
  return 0;
}

 bool
ncchannels_fg_default_p_export (uint64_t channels){
  return ncchannel_default_p(ncchannels_fchannel(channels));
}

 bool
ncchannels_fg_palindex_p_export (uint64_t channels){
  return ncchannel_palindex_p(ncchannels_fchannel(channels));
}

 bool
ncchannels_bg_default_p_export (uint64_t channels){
  return ncchannel_default_p(ncchannels_bchannel(channels));
}

 bool
ncchannels_bg_palindex_p_export (uint64_t channels){
  return ncchannel_palindex_p(ncchannels_bchannel(channels));
}

 uint64_t
ncchannels_set_fg_default_export (uint64_t* channels){
  uint32_t channel = ncchannels_fchannel(*channels);
  ncchannel_set_default(&channel);
  ncchannels_set_fchannel(channels, channel);
  return *channels;
}

 uint64_t
ncchannels_set_bg_default_export (uint64_t* channels){
  uint32_t channel = ncchannels_bchannel(*channels);
  ncchannel_set_default(&channel);
  ncchannels_set_bchannel(channels, channel);
  return *channels;
}

 void
nccell_init_export (nccell* c){
  memset(c, 0, sizeof(*c));
}

 int
nccell_prime_export (struct ncplane* n, nccell* c, const char* gcluster,
             uint16_t stylemask, uint64_t channels){
  c->stylemask = stylemask;
  c->channels = channels;
  int ret = nccell_load(n, c, gcluster);
  return ret;
}

 void
nccell_set_styles_export (nccell* c, unsigned stylebits){
  c->stylemask = stylebits & NCSTYLE_MASK;
}

 uint16_t
nccell_styles_export (const nccell* c){
  return c->stylemask;
}

 void
nccell_on_styles_export (nccell* c, unsigned stylebits){
  c->stylemask |= (uint16_t)(stylebits & NCSTYLE_MASK);
}

 void
nccell_off_styles_export (nccell* c, unsigned stylebits){
  c->stylemask &= (uint16_t)~(stylebits & NCSTYLE_MASK);
}

 void
nccell_set_fg_default_export (nccell* c){
  ncchannels_set_fg_default(&c->channels);
}

 void
nccell_set_bg_default_export (nccell* c){
  ncchannels_set_bg_default(&c->channels);
}

 int
nccell_set_fg_alpha_export (nccell* c, unsigned alpha){
  return ncchannels_set_fg_alpha(&c->channels, alpha);
}

 int
nccell_set_bg_alpha_export (nccell* c, unsigned alpha){
  return ncchannels_set_bg_alpha(&c->channels, alpha);
}

 uint64_t
nccell_set_bchannel_export (nccell* c, uint32_t channel){
  return ncchannels_set_bchannel(&c->channels, channel);
}

 uint64_t
nccell_set_fchannel_export (nccell* c, uint32_t channel){
  return ncchannels_set_fchannel(&c->channels, channel);
}

 uint64_t
nccell_set_channels_export (nccell* c, uint64_t channels){
  return ncchannels_set_channels(&c->channels, channels);
}

 bool
nccell_double_wide_p_export (const nccell* c){
  return (c->width >= 2);
}

 bool
nccell_wide_right_p_export (const nccell* c){
  return nccell_double_wide_p(c) && c->gcluster == 0;
}

 bool
nccell_wide_left_p_export (const nccell* c){
  return nccell_double_wide_p(c) && c->gcluster;
}

 uint64_t
nccell_channels_export (const nccell* c){
  return ncchannels_channels(c->channels);
}

 uint32_t
nccell_bchannel_export (const nccell* cl){
  return ncchannels_bchannel(cl->channels);
}

 uint32_t
nccell_fchannel_export (const nccell* cl){
  return ncchannels_fchannel(cl->channels);
}

 unsigned
nccell_cols_export (const nccell* c){
  return c->width ? c->width : 1;
}

  char*
nccell_strdup_export (const struct ncplane* n, const nccell* c){
  return strdup(nccell_extended_gcluster(n, c));
}

 char*
nccell_extract_export (const struct ncplane* n, const nccell* c,
               uint16_t* stylemask, uint64_t* channels){
  if(stylemask){
    *stylemask = c->stylemask;
  }
  if(channels){
    *channels = c->channels;
  }
  return nccell_strdup(n, c);
}

 bool
nccellcmp_export (const struct ncplane* n1, const nccell* RESTRICT c1,
          const struct ncplane* n2, const nccell* RESTRICT c2){
  if(c1->stylemask != c2->stylemask){
    return true;
  }
  if(c1->channels != c2->channels){
    return true;
  }
  return strcmp(nccell_extended_gcluster(n1, c1), nccell_extended_gcluster(n2, c2));
}

 int
nccell_load_char_export (struct ncplane* n, nccell* c, char ch){
  char gcluster[2];
  gcluster[0] = ch;
  gcluster[1] = '\0';
  return nccell_load(n, c, gcluster);
}

 int
nccell_load_egc32_export (struct ncplane* n, nccell* c, uint32_t egc){
  char gcluster[sizeof(egc) + 1];
  egc = htole(egc);
  memcpy(gcluster, &egc, sizeof(egc));
  gcluster[4] = '\0';
  return nccell_load(n, c, gcluster);
}

 int
nccell_load_ucs32_export (struct ncplane* n, nccell* c, uint32_t u){
  unsigned char utf8[WCHAR_MAX_UTF8BYTES];
  if(notcurses_ucs32_to_utf8(&u, 1, utf8, sizeof(utf8)) < 0){
    return -1;
  }
  uint32_t utf8asegc;
  _Static_assert(WCHAR_MAX_UTF8BYTES == sizeof(utf8asegc),
                 "WCHAR_MAX_UTF8BYTES didn't equal sizeof(uint32_t)");
  memcpy(&utf8asegc, utf8, sizeof(utf8));
  return nccell_load_egc32(n, c, utf8asegc);
}

 struct ncplane*
notcurses_top_export (struct notcurses* n){
  return ncpile_top(notcurses_stdplane(n));
}

 struct ncplane*
notcurses_bottom_export (struct notcurses* n){
  return ncpile_bottom(notcurses_stdplane(n));
}

 int
notcurses_render_export (struct notcurses* nc){
  struct ncplane* stdn = notcurses_stdplane(nc);
  if(ncpile_render(stdn)){
    return -1;
  }
  return ncpile_rasterize(stdn);
}

 bool
nckey_mouse_p_export (uint32_t r){
  return r >= NCKEY_MOTION && r <= NCKEY_BUTTON11;
}

 bool
ncinput_shift_p_export (const ncinput* n){
  return (n->modifiers & NCKEY_MOD_SHIFT);
}

 bool
ncinput_ctrl_p_export (const ncinput* n){
  return (n->modifiers & NCKEY_MOD_CTRL);
}

 bool
ncinput_alt_p_export (const ncinput* n){
  return (n->modifiers & NCKEY_MOD_ALT);
}

 bool
ncinput_meta_p_export (const ncinput* n){
  return (n->modifiers & NCKEY_MOD_META);
}

 bool
ncinput_super_p_export (const ncinput* n){
  return (n->modifiers & NCKEY_MOD_SUPER);
}

 bool
ncinput_hyper_p_export (const ncinput* n){
  return (n->modifiers & NCKEY_MOD_HYPER);
}

 bool
ncinput_capslock_p_export (const ncinput* n){
  return (n->modifiers & NCKEY_MOD_CAPSLOCK);
}

 bool
ncinput_numlock_p_export (const ncinput* n){
  return (n->modifiers & NCKEY_MOD_NUMLOCK);
}

 bool
ncinput_equal_p_export (const ncinput* n1, const ncinput* n2){
  // don't need to check ->utf8; it's derived from id
  if(n1->id != n2->id){
    return false;
  }
  if(n1->y != n2->y || n1->x != n2->x){
    return false;
  }
  // don't need to check deprecated alt, ctrl, shift
  if((n1->modifiers & ~(unsigned)(NCKEY_MOD_CAPSLOCK | NCKEY_MOD_NUMLOCK))
      != (n2->modifiers & ~(unsigned)(NCKEY_MOD_CAPSLOCK | NCKEY_MOD_NUMLOCK))){
    return false;
  }
  if(n1->evtype != n2->evtype){
    if((n1->evtype != NCTYPE_UNKNOWN && n1->evtype != NCTYPE_PRESS) ||
       (n2->evtype != NCTYPE_UNKNOWN && n2->evtype != NCTYPE_PRESS)){
      return false;
    }
  }
  if(n1->ypx != n2->ypx || n1->xpx != n2->xpx){
    return false;
  }
  return true;
}

 uint32_t
notcurses_get_nblock_export (struct notcurses* n, ncinput* ni){
  struct timespec ts = { .tv_sec = 0, .tv_nsec = 0 };
  return notcurses_get(n, &ts, ni);
}

 uint32_t
notcurses_get_blocking_export (struct notcurses* n, ncinput* ni){
  return notcurses_get(n, NULL, ni);
}

 bool
ncinput_nomod_p_export (const ncinput* ni){
  return !(ni->modifiers);
}

 int
notcurses_mice_disable_export (struct notcurses* n){
  return notcurses_mice_enable(n, NCMICE_NO_EVENTS);
}

 struct ncplane*
notcurses_stddim_yx_export (struct notcurses* nc, unsigned* RESTRICT y, unsigned* RESTRICT x){
  struct ncplane* s = notcurses_stdplane(nc); // can't fail
  ncplane_dim_yx(s, y, x); // accepts NULL
  return s;
}

 const struct ncplane*
notcurses_stddim_yx_const_export (const struct notcurses* nc, unsigned* RESTRICT y, unsigned* RESTRICT x){
  const struct ncplane* s = notcurses_stdplane_const(nc); // can't fail
  ncplane_dim_yx(s, y, x); // accepts NULL
  return s;
}

 unsigned
ncplane_dim_y_export (const struct ncplane* n){
  unsigned dimy;
  ncplane_dim_yx(n, &dimy, NULL);
  return dimy;
}

 unsigned
ncplane_dim_x_export (const struct ncplane* n){
  unsigned dimx;
  ncplane_dim_yx(n, NULL, &dimx);
  return dimx;
}

 void
notcurses_term_dim_yx_export (const struct notcurses* n, unsigned* RESTRICT rows, unsigned* RESTRICT cols){
  ncplane_dim_yx(notcurses_stdplane_const(n), rows, cols);
}

 int
ncpalette_set_rgb8_export (ncpalette* p, int idx, unsigned r, unsigned g, unsigned b){
  if(idx < 0 || (size_t)idx > sizeof(p->chans) / sizeof(*p->chans)){
    return -1;
  }
  return ncchannel_set_rgb8(&p->chans[idx], r, g, b);
}

 int
ncpalette_set_export (ncpalette* p, int idx, unsigned rgb){
  if(idx < 0 || (size_t)idx > sizeof(p->chans) / sizeof(*p->chans)){
    return -1;
  }
  return ncchannel_set(&p->chans[idx], rgb);
}

 int
ncpalette_get_export (const ncpalette* p, int idx, uint32_t* palent){
  if(idx < 0 || (size_t)idx > sizeof(p->chans) / sizeof(*p->chans)){
    return -1;
  }
  *palent = ncchannel_rgb(p->chans[idx]);
  return 0;
}

 int
ncpalette_get_rgb8_export (const ncpalette* p, int idx, unsigned* RESTRICT r, unsigned* RESTRICT g, unsigned* RESTRICT b){
  if(idx < 0 || (size_t)idx > sizeof(p->chans) / sizeof(*p->chans)){
    return -1;
  }
  return (int)ncchannel_rgb8(p->chans[idx], r, g, b);
}

 bool
nccapability_canchangecolor_export (const nccapabilities* caps){
  if(!caps->can_change_colors){
    return false;
  }
  ncpalette* p;
  if(caps->colors < sizeof(p->chans) / sizeof(*p->chans)){
    return false;
  }
  return true;
}

 bool
notcurses_cantruecolor_export (const struct notcurses* nc){
  return notcurses_capabilities(nc)->rgb;
}

 bool
notcurses_canchangecolor_export (const struct notcurses* nc){
  return nccapability_canchangecolor(notcurses_capabilities(nc));
}

 bool
notcurses_canfade_export (const struct notcurses* n){
  return notcurses_canchangecolor(n) || notcurses_cantruecolor(n);
}

 bool
notcurses_canutf8_export (const struct notcurses* nc){
  return notcurses_capabilities(nc)->utf8;
}

 bool
notcurses_canhalfblock_export (const struct notcurses* nc){
  return notcurses_canutf8(nc);
}

 bool
notcurses_canquadrant_export (const struct notcurses* nc){
  return notcurses_canutf8(nc) && notcurses_capabilities(nc)->quadrants;
}

 bool
notcurses_cansextant_export (const struct notcurses* nc){
  return notcurses_canutf8(nc) && notcurses_capabilities(nc)->sextants;
}

 bool
notcurses_canbraille_export (const struct notcurses* nc){
  return notcurses_canutf8(nc) && notcurses_capabilities(nc)->braille;
}

 bool
notcurses_canpixel_export (const struct notcurses* nc){
  return notcurses_check_pixel_support(nc) != NCPIXEL_NONE;
}

 int
ncplane_resize_simple_export (struct ncplane* n, unsigned ylen, unsigned xlen){
  unsigned oldy, oldx;
  ncplane_dim_yx(n, &oldy, &oldx); // current dimensions of 'n'
  unsigned keepleny = oldy > ylen ? ylen : oldy;
  unsigned keeplenx = oldx > xlen ? xlen : oldx;
  return ncplane_resize(n, 0, 0, keepleny, keeplenx, 0, 0, ylen, xlen);
}

 int
ncplane_move_rel_export (struct ncplane* n, int y, int x){
  int oy, ox;
  ncplane_yx(n, &oy, &ox);
  return ncplane_move_yx(n, oy + y, ox + x);
}

 int
ncplane_descendant_p_export (const struct ncplane* n, const struct ncplane* ancestor){
  for(const struct ncplane* parent = ncplane_parent_const(n) ; parent != ancestor ; parent = ncplane_parent_const(parent)){
    if(ncplane_parent_const(parent) == parent){ // reached a root plane
      return 0;
    }
  }
  return 1;
}

 void
ncplane_move_top_export (struct ncplane* n){
  ncplane_move_below(n, NULL);
}

 void
ncplane_move_bottom_export (struct ncplane* n){
  ncplane_move_above(n, NULL);
}

 void
ncplane_move_family_top_export (struct ncplane* n){
  ncplane_move_family_below(n, NULL);
}

 void
ncplane_move_family_bottom_export (struct ncplane* n){
  ncplane_move_family_above(n, NULL);
}

 int
notcurses_align_export (int availu, ncalign_e align, int u){
  if(align == NCALIGN_LEFT || align == NCALIGN_TOP){
    return 0;
  }
  if(align == NCALIGN_CENTER){
    return (availu - u) / 2;
  }
  if(align == NCALIGN_RIGHT || align == NCALIGN_BOTTOM){
    return availu - u;
  }
  return -INT_MAX; // invalid |align|
}

 int
ncplane_halign_export (const struct ncplane* n, ncalign_e align, int c){
  return notcurses_align((int)ncplane_dim_x(n), align, c);
}

 int
ncplane_valign_export (const struct ncplane* n, ncalign_e align, int r){
  return notcurses_align((int)ncplane_dim_y(n), align, r);
}

 unsigned
ncplane_cursor_y_export (const struct ncplane* n){
  unsigned y;
  ncplane_cursor_yx(n, &y, NULL);
  return y;
}

 unsigned
ncplane_cursor_x_export (const struct ncplane* n){
  unsigned x;
  ncplane_cursor_yx(n, NULL, &x);
  return x;
}

 int
ncplane_putc_export (struct ncplane* n, const nccell* c){
  return ncplane_putc_yx(n, -1, -1, c);
}

 int
ncplane_putchar_yx_export (struct ncplane* n, int y, int x, char c){
  nccell ce = NCCELL_INITIALIZER((uint32_t)c, ncplane_styles(n), ncplane_channels(n));
  return ncplane_putc_yx(n, y, x, &ce);
}

 int
ncplane_putchar_export (struct ncplane* n, char c){
  return ncplane_putchar_yx(n, -1, -1, c);
}

 int
ncplane_putegc_export (struct ncplane* n, const char* gclust, size_t* sbytes){
  return ncplane_putegc_yx(n, -1, -1, gclust, sbytes);
}

  char*
ncwcsrtombs_export (const wchar_t* src){
  mbstate_t ps;
  memset(&ps, 0, sizeof(ps));
  size_t mbytes = wcsrtombs(NULL, &src, 0, &ps);
  if(mbytes == (size_t)-1){
    return NULL;
  }
  ++mbytes;
  char* mbstr = (char*)malloc(mbytes); // need cast for c++ callers
  if(mbstr == NULL){
    return NULL;
  }
  size_t s = wcsrtombs(mbstr, &src, mbytes, &ps);
  if(s == (size_t)-1){
    free(mbstr);
    return NULL;
  }
  return mbstr;
}

 int
ncplane_putwegc_export (struct ncplane* n, const wchar_t* gclust, size_t* sbytes){
  char* mbstr = ncwcsrtombs(gclust);
  if(mbstr == NULL){
    return -1;
  }
  int ret = ncplane_putegc(n, mbstr, sbytes);
  free(mbstr);
  return ret;
}

 int
ncplane_putwegc_yx_export (struct ncplane* n, int y, int x, const wchar_t* gclust,
                   size_t* sbytes){
  if(ncplane_cursor_move_yx(n, y, x)){
    return -1;
  }
  return ncplane_putwegc(n, gclust, sbytes);
}

 int
ncplane_putstr_yx_export (struct ncplane* n, int y, int x, const char* gclusters){
  int ret = 0;
  while(*gclusters){
    size_t wcs;
    int cols = ncplane_putegc_yx(n, y, x, gclusters, &wcs);
//fprintf(stderr, "wrote %.*s %d cols %zu bytes\n", (int)wcs, gclusters, cols, wcs);
    if(cols < 0){
      return -ret;
    }
    if(wcs == 0){
      break;
    }
    // after the first iteration, just let the cursor code control where we
    // print, so that scrolling is taken into account
    y = -1;
    x = -1;
    gclusters += wcs;
    ret += cols;
  }
  return ret;
}

 int
ncplane_putstr_export (struct ncplane* n, const char* gclustarr){
  return ncplane_putstr_yx(n, -1, -1, gclustarr);
}

 int
ncplane_putstr_aligned_export (struct ncplane* n, int y, ncalign_e align, const char* s){
  int validbytes, validwidth;
  // we'll want to do the partial write if there's an error somewhere within
  ncstrwidth(s, &validbytes, &validwidth);
  int xpos = ncplane_halign(n, align, validwidth);
  if(xpos < 0){
    xpos = 0;
  }
  return ncplane_putstr_yx(n, y, xpos, s);
}

 int
ncplane_putstr_stained_export (struct ncplane* n, const char* gclusters){
  int ret = 0;
  while(*gclusters){
    size_t wcs;
    int cols = ncplane_putegc_stained(n, gclusters, &wcs);
    if(cols < 0){
      return -ret;
    }
    if(wcs == 0){
      break;
    }
    gclusters += wcs;
    ret += cols;
  }
  return ret;
}

 int
ncplane_putnstr_yx_export (struct ncplane* n, int y, int x, size_t s, const char* gclusters){
  int ret = 0;
  size_t offset = 0;
//fprintf(stderr, "PUT %zu at %d/%d [%.*s]\n", s, y, x, (int)s, gclusters);
  while(offset < s && gclusters[offset]){
    size_t wcs;
    int cols = ncplane_putegc_yx(n, y, x, gclusters + offset, &wcs);
    if(cols < 0){
      return -ret;
    }
    if(wcs == 0){
      break;
    }
    // after the first iteration, just let the cursor code control where we
    // print, so that scrolling is taken into account
    y = -1;
    x = -1;
    offset += wcs;
    ret += cols;
  }
  return ret;
}

 int
ncplane_putnstr_export (struct ncplane* n, size_t s, const char* gclustarr){
  return ncplane_putnstr_yx(n, -1, -1, s, gclustarr);
}

 int
ncplane_putwstr_yx_export (struct ncplane* n, int y, int x, const wchar_t* gclustarr){
  // maximum of six UTF8-encoded bytes per wchar_t
  const size_t mbytes = (wcslen(gclustarr) * WCHAR_MAX_UTF8BYTES) + 1;
  char* mbstr = (char*)malloc(mbytes); // need cast for c++ callers
  if(mbstr == NULL){
    return -1;
  }
  mbstate_t ps;
  memset(&ps, 0, sizeof(ps));
  const wchar_t** gend = &gclustarr;
  size_t s = wcsrtombs(mbstr, gend, mbytes, &ps);
  if(s == (size_t)-1){
    free(mbstr);
    return -1;
  }
  int ret = ncplane_putstr_yx(n, y, x, mbstr);
  free(mbstr);
  return ret;
}

 int
ncplane_putwstr_aligned_export (struct ncplane* n, int y, ncalign_e align,
                        const wchar_t* gclustarr){
  int width = wcswidth(gclustarr, INT_MAX);
  int xpos = ncplane_halign(n, align, width);
  if(xpos < 0){
    xpos = 0;
  }
  return ncplane_putwstr_yx(n, y, xpos, gclustarr);
}

 int
ncplane_putwstr_export (struct ncplane* n, const wchar_t* gclustarr){
  return ncplane_putwstr_yx(n, -1, -1, gclustarr);
}


size_t sizeof_wchar (void) {
	sizeof(wchar_t);
}

 int
ncplane_pututf32_yx_export (struct ncplane* n, int y, int x, uint32_t u){
  if(u > WCHAR_MAX){
    return -1;
  }
  // we use MB_LEN_MAX (and potentially "waste" a few stack bytes to avoid
  // the greater sin of a VLA (and to be locale-independent).
  char utf8c[MB_LEN_MAX + 1];
  mbstate_t ps;
  memset(&ps, 0, sizeof(ps));
  // this isn't going to be valid for reconstructued surrogate pairs...
  // we need our own, or to use unistring or something.
  size_t s = wcrtomb(utf8c, (wchar_t)u, &ps);
  if(s == (size_t)-1){
    return -1;
  }
  utf8c[s] = '\0';
  return ncplane_putegc_yx(n, y, x, utf8c, NULL);
}

 int
ncplane_putwc_yx_export (struct ncplane* n, int y, int x, wchar_t w){
  return ncplane_pututf32_yx(n, y, x, (uint32_t)w);
}

 int
ncplane_putwc_export (struct ncplane* n, wchar_t w){
  return ncplane_putwc_yx(n, -1, -1, w);
}

 int
ncplane_putwc_utf32_export (struct ncplane* n, const wchar_t* w, unsigned* wchars){
  uint32_t utf32;
  if(*w >= 0xd000 && *w <= 0xdbff){
    *wchars = 2;
    if(w[1] < 0xdc00 || w[1] > 0xdfff){
      return -1; // invalid surrogate pairing
    }
    utf32 = (w[0] & 0x3fflu) << 10lu;
    utf32 += (w[1] & 0x3fflu);
  }else{
    *wchars = 1;
    utf32 = (uint32_t)*w;
  }
  return ncplane_pututf32_yx(n, -1, -1, utf32);
}

 int
ncplane_putwc_stained_export (struct ncplane* n, wchar_t w){
  wchar_t warr[2] = { w, L'\0' };
  return ncplane_putwstr_stained(n, warr);
}

 int
ncplane_vprintf_export (struct ncplane* n, const char* format, va_list ap){
  return ncplane_vprintf_yx(n, -1, -1, format, ap);
}

 int
ncplane_printf_export (struct ncplane* n, const char* format, ...){
  va_list va;
  va_start(va, format);
  int ret = ncplane_vprintf(n, format, va);
  va_end(va);
  return ret;
}

 int
ncplane_printf_yx_export (struct ncplane* n, int y, int x, const char* format, ...){
  va_list va;
  va_start(va, format);
  int ret = ncplane_vprintf_yx(n, y, x, format, va);
  va_end(va);
  return ret;
}

 int
ncplane_printf_aligned_export (struct ncplane* n, int y, ncalign_e align, const char* format, ...){
  va_list va;
  va_start(va, format);
  int ret = ncplane_vprintf_aligned(n, y, align, format, va);
  va_end(va);
  return ret;
}

 int
ncplane_printf_stained_export (struct ncplane* n, const char* format, ...){
  va_list va;
  va_start(va, format);
  int ret = ncplane_vprintf_stained(n, format, va);
  va_end(va);
  return ret;
}

 int
ncplane_hline_export (struct ncplane* n, const nccell* c, unsigned len){
  return ncplane_hline_interp(n, c, len, c->channels, c->channels);
}

 int
ncplane_vline_export (struct ncplane* n, const nccell* c, unsigned len){
  return ncplane_vline_interp(n, c, len, c->channels, c->channels);
}

 int
ncplane_box_sized_export (struct ncplane* n, const nccell* ul, const nccell* ur,
                  const nccell* ll, const nccell* lr, const nccell* hline,
                  const nccell* vline, unsigned ystop, unsigned xstop,
                  unsigned ctlword){
  unsigned y, x;
  ncplane_cursor_yx(n, &y, &x);
  return ncplane_box(n, ul, ur, ll, lr, hline, vline, y + ystop - 1,
                     x + xstop - 1, ctlword);
}

 int
ncplane_perimeter_export (struct ncplane* n, const nccell* ul, const nccell* ur,
                  const nccell* ll, const nccell* lr, const nccell* hline,
                  const nccell* vline, unsigned ctlword){
  if(ncplane_cursor_move_yx(n, 0, 0)){
    return -1;
  }
  unsigned dimy, dimx;
  ncplane_dim_yx(n, &dimy, &dimx);
  return ncplane_box_sized(n, ul, ur, ll, lr, hline, vline, dimy, dimx, ctlword);
}

 uint32_t
nccell_fg_rgb_export (const nccell* cl){
  return ncchannels_fg_rgb(cl->channels);
}

 uint32_t
nccell_bg_rgb_export (const nccell* cl){
  return ncchannels_bg_rgb(cl->channels);
}

 uint32_t
nccell_fg_alpha_export (const nccell* cl){
  return ncchannels_fg_alpha(cl->channels);
}

 uint32_t
nccell_bg_alpha_export (const nccell* cl){
  return ncchannels_bg_alpha(cl->channels);
}

 uint32_t
nccell_fg_rgb8_export (const nccell* cl, unsigned* r, unsigned* g, unsigned* b){
  return ncchannels_fg_rgb8(cl->channels, r, g, b);
}

 uint32_t
nccell_bg_rgb8_export (const nccell* cl, unsigned* r, unsigned* g, unsigned* b){
  return ncchannels_bg_rgb8(cl->channels, r, g, b);
}

 int
nccell_set_fg_rgb8_export (nccell* cl, unsigned r, unsigned g, unsigned b){
  return ncchannels_set_fg_rgb8(&cl->channels, r, g, b);
}

 void
nccell_set_fg_rgb8_clipped_export (nccell* cl, int r, int g, int b){
  ncchannels_set_fg_rgb8_clipped(&cl->channels, r, g, b);
}

 int
nccell_set_fg_rgb_export (nccell* c, uint32_t channel){
  return ncchannels_set_fg_rgb(&c->channels, channel);
}

 int
nccell_set_fg_palindex_export (nccell* cl, unsigned idx){
  return ncchannels_set_fg_palindex(&cl->channels, idx);
}

 uint32_t
nccell_fg_palindex_export (const nccell* cl){
  return ncchannels_fg_palindex(cl->channels);
}

 int
nccell_set_bg_rgb8_export (nccell* cl, unsigned r, unsigned g, unsigned b){
  return ncchannels_set_bg_rgb8(&cl->channels, r, g, b);
}

 void
nccell_set_bg_rgb8_clipped_export (nccell* cl, int r, int g, int b){
  ncchannels_set_bg_rgb8_clipped(&cl->channels, r, g, b);
}

 int
nccell_set_bg_rgb_export (nccell* c, uint32_t channel){
  return ncchannels_set_bg_rgb(&c->channels, channel);
}

 int
nccell_set_bg_palindex_export (nccell* cl, unsigned idx){
  return ncchannels_set_bg_palindex(&cl->channels, idx);
}

 uint32_t
nccell_bg_palindex_export (const nccell* cl){
  return ncchannels_bg_palindex(cl->channels);
}

 bool
nccell_fg_default_p_export (const nccell* cl){
  return ncchannels_fg_default_p(cl->channels);
}

 bool
nccell_fg_palindex_p_export (const nccell* cl){
  return ncchannels_fg_palindex_p(cl->channels);
}

 bool
nccell_bg_default_p_export (const nccell* cl){
  return ncchannels_bg_default_p(cl->channels);
}

 bool
nccell_bg_palindex_p_export (const nccell* cl){
  return ncchannels_bg_palindex_p(cl->channels);
}

 uint32_t
ncplane_bchannel_export (const struct ncplane* n){
  return ncchannels_bchannel(ncplane_channels(n));
}

 uint32_t
ncplane_fchannel_export (const struct ncplane* n){
  return ncchannels_fchannel(ncplane_channels(n));
}

 uint32_t
ncplane_fg_rgb_export (const struct ncplane* n){
  return ncchannels_fg_rgb(ncplane_channels(n));
}

 uint32_t
ncplane_bg_rgb_export (const struct ncplane* n){
  return ncchannels_bg_rgb(ncplane_channels(n));
}

 uint32_t
ncplane_fg_alpha_export (const struct ncplane* n){
  return ncchannels_fg_alpha(ncplane_channels(n));
}

 bool
ncplane_fg_default_p_export (const struct ncplane* n){
  return ncchannels_fg_default_p(ncplane_channels(n));
}

 uint32_t
ncplane_bg_alpha_export (const struct ncplane* n){
  return ncchannels_bg_alpha(ncplane_channels(n));
}

 bool
ncplane_bg_default_p_export (const struct ncplane* n){
  return ncchannels_bg_default_p(ncplane_channels(n));
}

 uint32_t
ncplane_fg_rgb8_export (const struct ncplane* n, unsigned* r, unsigned* g, unsigned* b){
  return ncchannels_fg_rgb8(ncplane_channels(n), r, g, b);
}

 uint32_t
ncplane_bg_rgb8_export (const struct ncplane* n, unsigned* r, unsigned* g, unsigned* b){
  return ncchannels_bg_rgb8(ncplane_channels(n), r, g, b);
}

 int
nccells_load_box_export (struct ncplane* n, uint16_t styles, uint64_t channels,
                 nccell* ul, nccell* ur, nccell* ll, nccell* lr,
                 nccell* hl, nccell* vl, const char* gclusters){
  int ulen;
  if((ulen = nccell_prime(n, ul, gclusters, styles, channels)) > 0){
    if((ulen = nccell_prime(n, ur, gclusters += ulen, styles, channels)) > 0){
      if((ulen = nccell_prime(n, ll, gclusters += ulen, styles, channels)) > 0){
        if((ulen = nccell_prime(n, lr, gclusters += ulen, styles, channels)) > 0){
          if((ulen = nccell_prime(n, hl, gclusters += ulen, styles, channels)) > 0){
            if(nccell_prime(n, vl, gclusters + ulen, styles, channels) > 0){
              return 0;
            }
            nccell_release(n, hl);
          }
          nccell_release(n, lr);
        }
        nccell_release(n, ll);
      }
      nccell_release(n, ur);
    }
    nccell_release(n, ul);
  }
  return -1;
}

 int
nccells_ascii_box_export (struct ncplane* n, uint16_t attr, uint64_t channels,
                  nccell* ul, nccell* ur, nccell* ll, nccell* lr, nccell* hl, nccell* vl){
  return nccells_load_box(n, attr, channels, ul, ur, ll, lr, hl, vl, NCBOXASCII);
}

 int
nccells_double_box_export (struct ncplane* n, uint16_t attr, uint64_t channels,
                   nccell* ul, nccell* ur, nccell* ll, nccell* lr, nccell* hl, nccell* vl){
  if(notcurses_canutf8(ncplane_notcurses(n))){
    return nccells_load_box(n, attr, channels, ul, ur, ll, lr, hl, vl, NCBOXDOUBLE);
  }
  return nccells_ascii_box(n, attr, channels, ul, ur, ll, lr, hl, vl);
}

 int
nccells_rounded_box_export (struct ncplane* n, uint16_t attr, uint64_t channels,
                    nccell* ul, nccell* ur, nccell* ll, nccell* lr, nccell* hl, nccell* vl){
  if(notcurses_canutf8(ncplane_notcurses(n))){
    return nccells_load_box(n, attr, channels, ul, ur, ll, lr, hl, vl, NCBOXROUND);
  }
  return nccells_ascii_box(n, attr, channels, ul, ur, ll, lr, hl, vl);
}

 int
nccells_light_box_export (struct ncplane* n, uint16_t attr, uint64_t channels,
                  nccell* ul, nccell* ur, nccell* ll, nccell* lr, nccell* hl, nccell* vl){
  if(notcurses_canutf8(ncplane_notcurses(n))){
    return nccells_load_box(n, attr, channels, ul, ur, ll, lr, hl, vl, NCBOXLIGHT);
  }
  return nccells_ascii_box(n, attr, channels, ul, ur, ll, lr, hl, vl);
}

 int
nccells_heavy_box_export (struct ncplane* n, uint16_t attr, uint64_t channels,
                  nccell* ul, nccell* ur, nccell* ll, nccell* lr, nccell* hl, nccell* vl){
  if(notcurses_canutf8(ncplane_notcurses(n))){
    return nccells_load_box(n, attr, channels, ul, ur, ll, lr, hl, vl, NCBOXHEAVY);
  }
  return nccells_ascii_box(n, attr, channels, ul, ur, ll, lr, hl, vl);
}

 int
ncplane_rounded_box_export (struct ncplane* n, uint16_t styles, uint64_t channels,
                    unsigned ystop, unsigned xstop, unsigned ctlword){
  int ret = 0;
  nccell ul = NCCELL_TRIVIAL_INITIALIZER, ur = NCCELL_TRIVIAL_INITIALIZER;
  nccell ll = NCCELL_TRIVIAL_INITIALIZER, lr = NCCELL_TRIVIAL_INITIALIZER;
  nccell hl = NCCELL_TRIVIAL_INITIALIZER, vl = NCCELL_TRIVIAL_INITIALIZER;
  if((ret = nccells_rounded_box(n, styles, channels, &ul, &ur, &ll, &lr, &hl, &vl)) == 0){
    ret = ncplane_box(n, &ul, &ur, &ll, &lr, &hl, &vl, ystop, xstop, ctlword);
  }
  nccell_release(n, &ul); nccell_release(n, &ur);
  nccell_release(n, &ll); nccell_release(n, &lr);
  nccell_release(n, &hl); nccell_release(n, &vl);
  return ret;
}

 int
ncplane_perimeter_rounded_export (struct ncplane* n, uint16_t stylemask,
                          uint64_t channels, unsigned ctlword){
  if(ncplane_cursor_move_yx(n, 0, 0)){
    return -1;
  }
  unsigned dimy, dimx;
  ncplane_dim_yx(n, &dimy, &dimx);
  nccell ul = NCCELL_TRIVIAL_INITIALIZER;
  nccell ur = NCCELL_TRIVIAL_INITIALIZER;
  nccell ll = NCCELL_TRIVIAL_INITIALIZER;
  nccell lr = NCCELL_TRIVIAL_INITIALIZER;
  nccell vl = NCCELL_TRIVIAL_INITIALIZER;
  nccell hl = NCCELL_TRIVIAL_INITIALIZER;
  if(nccells_rounded_box(n, stylemask, channels, &ul, &ur, &ll, &lr, &hl, &vl)){
    return -1;
  }
  int r = ncplane_box_sized(n, &ul, &ur, &ll, &lr, &hl, &vl, dimy, dimx, ctlword);
  nccell_release(n, &ul); nccell_release(n, &ur);
  nccell_release(n, &ll); nccell_release(n, &lr);
  nccell_release(n, &hl); nccell_release(n, &vl);
  return r;
}

 int
ncplane_rounded_box_sized_export (struct ncplane* n, uint16_t styles, uint64_t channels,
                          unsigned ylen, unsigned xlen, unsigned ctlword){
  unsigned y, x;
  ncplane_cursor_yx(n, &y, &x);
  return ncplane_rounded_box(n, styles, channels, y + ylen - 1,
                             x + xlen - 1, ctlword);
}

 int
ncplane_double_box_export (struct ncplane* n, uint16_t styles, uint64_t channels,
                   unsigned ylen, unsigned xlen, unsigned ctlword){
  int ret = 0;
  nccell ul = NCCELL_TRIVIAL_INITIALIZER, ur = NCCELL_TRIVIAL_INITIALIZER;
  nccell ll = NCCELL_TRIVIAL_INITIALIZER, lr = NCCELL_TRIVIAL_INITIALIZER;
  nccell hl = NCCELL_TRIVIAL_INITIALIZER, vl = NCCELL_TRIVIAL_INITIALIZER;
  if((ret = nccells_double_box(n, styles, channels, &ul, &ur, &ll, &lr, &hl, &vl)) == 0){
    ret = ncplane_box(n, &ul, &ur, &ll, &lr, &hl, &vl, ylen, xlen, ctlword);
  }
  nccell_release(n, &ul); nccell_release(n, &ur);
  nccell_release(n, &ll); nccell_release(n, &lr);
  nccell_release(n, &hl); nccell_release(n, &vl);
  return ret;
}

 int
ncplane_ascii_box_export (struct ncplane* n, uint16_t styles, uint64_t channels,
                  unsigned ylen, unsigned xlen, unsigned ctlword){
  int ret = 0;
  nccell ul = NCCELL_TRIVIAL_INITIALIZER, ur = NCCELL_TRIVIAL_INITIALIZER;
  nccell ll = NCCELL_TRIVIAL_INITIALIZER, lr = NCCELL_TRIVIAL_INITIALIZER;
  nccell hl = NCCELL_TRIVIAL_INITIALIZER, vl = NCCELL_TRIVIAL_INITIALIZER;
  if((ret = nccells_ascii_box(n, styles, channels, &ul, &ur, &ll, &lr, &hl, &vl)) == 0){
    ret = ncplane_box(n, &ul, &ur, &ll, &lr, &hl, &vl, ylen, xlen, ctlword);
  }
  nccell_release(n, &ul); nccell_release(n, &ur);
  nccell_release(n, &ll); nccell_release(n, &lr);
  nccell_release(n, &hl); nccell_release(n, &vl);
  return ret;
}

 int
ncplane_perimeter_double_export (struct ncplane* n, uint16_t stylemask,
                         uint64_t channels, unsigned ctlword){
  if(ncplane_cursor_move_yx(n, 0, 0)){
    return -1;
  }
  unsigned dimy, dimx;
  ncplane_dim_yx(n, &dimy, &dimx);
  nccell ul = NCCELL_TRIVIAL_INITIALIZER;
  nccell ur = NCCELL_TRIVIAL_INITIALIZER;
  nccell ll = NCCELL_TRIVIAL_INITIALIZER;
  nccell lr = NCCELL_TRIVIAL_INITIALIZER;
  nccell vl = NCCELL_TRIVIAL_INITIALIZER;
  nccell hl = NCCELL_TRIVIAL_INITIALIZER;
  if(nccells_double_box(n, stylemask, channels, &ul, &ur, &ll, &lr, &hl, &vl)){
    return -1;
  }
  int r = ncplane_box_sized(n, &ul, &ur, &ll, &lr, &hl, &vl, dimy, dimx, ctlword);
  nccell_release(n, &ul); nccell_release(n, &ur);
  nccell_release(n, &ll); nccell_release(n, &lr);
  nccell_release(n, &hl); nccell_release(n, &vl);
  return r;
}

 int
ncplane_double_box_sized_export (struct ncplane* n, uint16_t styles, uint64_t channels,
                         unsigned ylen, unsigned xlen, unsigned ctlword){
  unsigned y, x;
  ncplane_cursor_yx(n, &y, &x);
  return ncplane_double_box(n, styles, channels, y + ylen - 1,
                            x + xlen - 1, ctlword);
}

 struct ncplane*
ncvisualplane_create_export (struct notcurses* nc, const struct ncplane_options* opts,
                     struct ncvisual* ncv, struct ncvisual_options* vopts){
  struct ncplane* newn;
  if(vopts && vopts->n){
    if(vopts->flags & NCVISUAL_OPTION_CHILDPLANE){
      return NULL; // the whole point is to create a new plane
    }
    newn = ncplane_create(vopts->n, opts);
  }else{
    newn = ncpile_create(nc, opts);
  }
  if(newn == NULL){
    return NULL;
  }
  struct ncvisual_options v;
  if(!vopts){
    vopts = &v;
    memset(vopts, 0, sizeof(*vopts));
  }
  vopts->n = newn;
  if(ncvisual_blit(nc, ncv, vopts) == NULL){
    ncplane_destroy(newn);
    vopts->n = NULL;
    return NULL;
  }
  return newn;
}

 unsigned
ncpixel_a_export (uint32_t pixel){
  return (htole(pixel) & 0xff000000u) >> 24u;
}

 unsigned
ncpixel_r_export (uint32_t pixel){
  return (htole(pixel) & 0x000000ffu);
}

 unsigned
ncpixel_g_export (uint32_t pixel){
  return (htole(pixel) & 0x0000ff00u) >> 8u;
}

 unsigned
ncpixel_b_export (uint32_t pixel){
  return (htole(pixel) & 0x00ff0000u) >> 16u;
}

 int
ncpixel_set_a_export (uint32_t* pixel, unsigned a){
  if(a > 255){
    return -1;
  }
  *pixel = htole((htole(*pixel) & 0x00ffffffu) | (a << 24u));
  return 0;
}

 int
ncpixel_set_r_export (uint32_t* pixel, unsigned r){
  if(r > 255){
    return -1;
  }
  *pixel = htole((htole(*pixel) & 0xffffff00u) | r);
  return 0;
}

 int
ncpixel_set_g_export (uint32_t* pixel, unsigned g){
  if(g > 255){
    return -1;
  }
  *pixel = htole((htole(*pixel) & 0xffff00ffu) | (g << 8u));
  return 0;
}

 int
ncpixel_set_b_export (uint32_t* pixel, unsigned b){
  if(b > 255){
    return -1;
  }
  *pixel = htole((htole(*pixel) & 0xff00ffffu) | (b << 16u));
  return 0;
}

 uint32_t
ncpixel_export (unsigned r, unsigned g, unsigned b){
  uint32_t pixel = 0;
  ncpixel_set_a(&pixel, 0xff);
  if(r > 255) r = 255;
  ncpixel_set_r(&pixel, r);
  if(g > 255) g = 255;
  ncpixel_set_g(&pixel, g);
  if(b > 255) b = 255;
  ncpixel_set_b(&pixel, b);
  return pixel;
}

 int
ncpixel_set_rgb8_export (uint32_t* pixel, unsigned r, unsigned g, unsigned b){
  if(ncpixel_set_r(pixel, r) || ncpixel_set_g(pixel, g) || ncpixel_set_b(pixel, b)){
    return -1;
  }
  return 0;
}

 const char*
ncqprefix_export (uintmax_t val, uintmax_t decimal, char* buf, int omitdec){
  return ncnmetric(val, NCPREFIXSTRLEN + 1, decimal, buf, omitdec, 1000, '\0');
}

 const char*
nciprefix_export (uintmax_t val, uintmax_t decimal, char* buf, int omitdec){
  return ncnmetric(val, NCIPREFIXSTRLEN + 1, decimal, buf, omitdec, 1024, '\0');
}

 const char*
ncbprefix_export (uintmax_t val, uintmax_t decimal, char* buf, int omitdec){
  return ncnmetric(val, NCBPREFIXSTRLEN + 1, decimal, buf, omitdec, 1024, 'i');
}

 uint64_t
nctabbed_hdrchan_export (struct nctabbed* nt){
  uint64_t ch;
  nctabbed_channels(nt, &ch, NULL, NULL);
  return ch;
}

 uint64_t
nctabbed_selchan_export (struct nctabbed* nt){
  uint64_t ch;
  nctabbed_channels(nt, NULL, &ch, NULL);
  return ch;
}

 uint64_t
nctabbed_sepchan_export (struct nctabbed* nt){
  uint64_t ch;
  nctabbed_channels(nt, NULL, NULL, &ch);
  return ch;
}

