use v6.c;

use NativeCall;

use Terminal::NotCurses::Raw::Definitions;
use Terminal::NotCurses::Raw::Enums;

unit package Terminal::NotCurses::Raw::Structs;

class nccell is repr<CStruct> is export {
  has uint32 $.gcluster          is rw;
  has uint8  $.gcluster_backstop is rw;
  has uint8  $.width             is rw;
  has uint16 $.stylemask         is rw;
  has uint64 $.channels          is rw;
}

class notcurses_options is repr<CStruct> is export {
  has Str          $.termtype is rw;
  has ncloglevel_e $.loglevel is rw;
  has uint32       $.margin_t is rw;
  has uint32       $.margin_r is rw;
  has uint32       $.margin_b is rw;
  has uint32       $.margin_l is rw;
  has uint64       $.flags    is rw;
}

# cw: MUST be C-allocated!
class ncinput is repr<CStruct> is export {
  has uint32        $.id        is rw;
  has int32         $.y         is rw;
  has int32         $.x         is rw;
  HAS CArray[uint8] @.utf8[5]   is CArray;
  has uint32        $.alt       is rw;
  has uint32        $.shift     is rw;
  has uint32        $.ctrl      is rw;
  has ncintype_e    $.evtype    is rw;
  has uint32        $.modifiers is rw;
  has int32         $.ypx       is rw;
  has int32         $.xpx       is rw;
}

class ncplane_options is repr<CStruct> is export {
  has int      $.y         is rw;
  has int      $.x         is rw;
  has uint32   $.rows      is rw;
  has uint32   $.cols      is rw;
  has Pointer  $.userptr        ;
  has Str      $.name           ;
  has Pointer  $.resizecb       ; #= &(ncplane);
  has uint64   $.flags     is rw;
  has uint32   $.margin_b  is rw;
  has uint32   $.margin_r  is rw;
}

# cw: MUST be C-allocated!
class ncpalette is repr<CStruct> is export {
  has CArray[uint32] @.chans[NCPALETTESIZE] is CArray;
}

class nccapabilities is repr<CStruct> is export {
  has uint32 $.colors;
  has uint32 $.utf8;
  has uint32 $.rgb;
  has uint32 $.can_change_colors;
  has uint32 $.halfblocks;
  has uint32 $.quadrants;
  has uint32 $.sextants;
  has uint32 $.braille;
}

class ncstats is repr<CStruct> is export {
  has uint64 $.renders           is rw;
  has uint64 $.writeouts         is rw;
  has uint64 $.failed_renders    is rw;
  has uint64 $.failed_writeouts  is rw;
  has uint64 $.raster_bytes      is rw;
  has int64  $.raster_max_bytes  is rw;
  has int64  $.raster_min_bytes  is rw;
  has uint64 $.render_ns         is rw;
  has int64  $.render_max_ns     is rw;
  has int64  $.render_min_ns     is rw;
  has uint64 $.raster_ns         is rw;
  has int64  $.raster_max_ns     is rw;
  has int64  $.raster_min_ns     is rw;
  has uint64 $.writeout_ns       is rw;
  has int64  $.writeout_max_ns   is rw;
  has int64  $.writeout_min_ns   is rw;
  has uint64 $.cellelisions      is rw;
  has uint64 $.cellemissions     is rw;
  has uint64 $.fgelisions        is rw;
  has uint64 $.fgemissions       is rw;
  has uint64 $.bgelisions        is rw;
  has uint64 $.bgemissions       is rw;
  has uint64 $.defaultelisions   is rw;
  has uint64 $.defaultemissions  is rw;
  has uint64 $.refreshes         is rw;
  has uint64 $.sprixelemissions  is rw;
  has uint64 $.sprixelelisions   is rw;
  has uint64 $.sprixelbytes      is rw;
  has uint64 $.appsync_updates   is rw;
  has uint64 $.input_errors      is rw;
  has uint64 $.input_events      is rw;
  has uint64 $.hpa_gratuitous    is rw;
  has uint64 $.cell_geo_changes  is rw;
  has uint64 $.pixel_geo_changes is rw;
  has uint64 $.fbbytes           is rw;
  has uint32 $.planes            is rw;
}

#
# struct ncvisual_options {
#   struct ncplane* n;
#   ncscale_e scaling;
#   int y, x;
#   unsigned begy, begx;
#   unsigned leny, lenx;
#   ncblitter_e blitter;
#   uint64 flags;
#   uint32 transcolor;
#   unsigned pxoffy, pxoffx;
# };
#
# class ncvgeom is repr<CStruct> is export {
#   unsigned pixy, pixx;
#   unsigned cdimy, cdimx;
#   unsigned rpixy, rpixx;
#   unsigned rcelly, rcellx;
#   unsigned scaley, scalex;
#   unsigned begy, begx;
#   unsigned leny, lenx;
#   unsigned maxpixely, maxpixelx;
#   ncblitter_e blitter;
# }
#
#
# class ncreel_options is repr<CStruct> is export {
#   unsigned bordermask;
#   uint64 borderchan;
#   unsigned tabletmask;
#   uint64 tabletchan;
#   uint64 focusedchan;
#   uint64 flags;
# } ncreel_options;
#
# class ncselector_item is repr<CStruct> is export {
#   Str  option;
#   Str  desc;
# }
#
# class ncselector_options is repr<CStruct> is export {
#   Str  title;
#   Str  secondary;
#   Str  footer;
#   const struct ncselector_item* items;
#   unsigned defidx;
#   unsigned maxdisplay;
#   uint64 opchannels;
#   uint64 descchannels;
#   uint64 titlechannels;
#   uint64 footchannels;
#   uint64 boxchannels;
#   uint64 flags;
# }
#
# struct ncselector_item {
#   Str  option;
#   Str  desc;
# }
#
# class ncselector_options is repr<CStruct> is export {
#   Str  title;
#   Str  secondary;
#   Str  footer;
#   const struct ncselector_item* items;
#   unsigned defidx;
#   unsigned maxdisplay;
#   uint64 opchannels;
#   uint64 descchannels;
#   uint64 titlechannels;
#   uint64 footchannels;
#   uint64 boxchannels;
#   uint64 flags;
# }
