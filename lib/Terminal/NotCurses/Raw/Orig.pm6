use v6;

use NativeCall;

use GLib::Raw::Definitions;
use Terminal::NotCurses::Raw::Definitions;
use Terminal::NotCurses::Raw::Structs;

unit package Termninal::NotCurses::Raw::Orig;

### /home/cbwood/Projects/raku-Terminal-Notcurses/notcurses-orig.h

# sub ncdplot_add_sample (
#   ncdplot  $n,
#   uint64_t $x,
#   gdouble  $y
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncdplot_create (
#   ncplane        $n,
#   ncplot_options $opts,
#   gdouble        $miny,
#   gdouble        $maxy
# )
#   returns ncdplot
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncdplot_destroy (ncdplot $n)
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncdplot_plane (ncdplot $n)
#   returns ncplane
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncdplot_sample (
#   ncdplot  $n,
#   uint64_t $x,
#   gdouble  $y is rw
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncdplot_set_sample (
#   ncdplot  $n,
#   uint64_t $x,
#   gdouble  $y
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncfadectx_free (ncfadectx $nctx)
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncfadectx_iterations (ncfadectx $nctx)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncfadectx_setup (ncplane $n)
#   returns ncfadectx
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncfdplane_create (
#   ncplane            $n,
#   ncfdplane_options  $opts,
#   gint               $fd,
#   ncfdplane_callback $cbfxn,
#   ncfdplane_done_cb  $donecbfxn
# )
#   returns ncfdplane
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncfdplane_destroy (ncfdplane $n)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncfdplane_plane (ncfdplane $n)
#   returns ncplane
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncmenu_create (
#   ncplane        $n,
#   ncmenu_options $opts
# )
#   returns ncmenu
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncmenu_destroy (ncmenu $n)
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncmenu_item_set_status (
#   ncmenu $n,
#   Str    $section,
#   Str    $item,
#   bool   $enabled
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncmenu_mouse_selected (
#   ncmenu  $n,
#   ncinput $click,
#   ncinput $ni
# )
#   returns Str
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncmenu_nextitem (ncmenu $n)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncmenu_nextsection (ncmenu $n)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncmenu_offer_input (
#   ncmenu  $n,
#   ncinput $nc
# )
#   returns bool
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncmenu_plane (ncmenu $n)
#   returns ncplane
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncmenu_previtem (ncmenu $n)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncmenu_prevsection (ncmenu $n)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncmenu_rollup (ncmenu $n)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncmenu_selected (
#   ncmenu  $n,
#   ncinput $ni
# )
#   returns Str
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncmenu_unroll (
#   ncmenu $n,
#   gint   $sectionidx
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#

#
# sub ncprogbar_create (
#   ncplane           $n,
#   ncprogbar_options $opts
# )
#   returns ncprogbar
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncprogbar_destroy (ncprogbar $n)
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncprogbar_plane (ncprogbar $n)
#   returns ncplane
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncprogbar_progress (ncprogbar $n)
#   returns double
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncprogbar_set_progress (
#   ncprogbar $n,
#   gdouble   $p
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncreader_clear (ncreader $n)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncreader_contents (ncreader $n)
#   returns Str
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncreader_create (
#   ncplane          $n,
#   ncreader_options $opts
# )
#   returns ncreader
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncreader_destroy (
#   ncreader    $n,
#   CArray[Str] $contents
# )
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncreader_move_down (ncreader $n)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncreader_move_left (ncreader $n)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncreader_move_right (ncreader $n)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncreader_move_up (ncreader $n)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncreader_offer_input (
#   ncreader $n,
#   ncinput  $ni
# )
#   returns bool
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncreader_plane (ncreader $n)
#   returns ncplane
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncreader_write_egc (
#   ncreader $n,
#   Str      $egc
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncstrwidth (
#   Str  $egcs,
#   gint $validbytes is rw,
#   gint $validwidth is rw
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncsubproc_createv (
#   ncplane            $n,
#   ncsubproc_options  $opts,
#   Str                $bin,
#   CArray[Str]        $arg,
#   ncfdplane_callback $cbfxn,
#   ncfdplane_done_cb  $donecbfxn
# )
#   returns ncsubproc
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncsubproc_createvp (
#   ncplane            $n,
#   ncsubproc_options  $opts,
#   Str                $bin,
#   CArray[Str]        $arg,
#   ncfdplane_callback $cbfxn,
#   ncfdplane_done_cb  $donecbfxn
# )
#   returns ncsubproc
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncsubproc_createvpe (
#   ncplane            $n,
#   ncsubproc_options  $opts,
#   Str                $bin,
#   CArray[Str]        $arg,
#   CArray[Str]        $env,
#   ncfdplane_callback $cbfxn,
#   ncfdplane_done_cb  $donecbfxn
# )
#   returns ncsubproc
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncsubproc_destroy (ncsubproc $n)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncsubproc_plane (ncsubproc $n)
#   returns ncplane
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctab_cb (nctab $t)
#   returns tabcb
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctab_move (
#   nctabbed $nt,
#   nctab    $t,
#   nctab    $after,
#   nctab    $before
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctab_move_left (
#   nctabbed $nt,
#   nctab    $t
# )
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctab_move_right (
#   nctabbed $nt,
#   nctab    $t
# )
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctab_name (nctab $t)
#   returns Str
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctab_name_width (nctab $t)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctab_next (nctab $t)
#   returns nctab
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctab_prev (nctab $t)
#   returns nctab
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctab_set_cb (
#   nctab $t,
#   tabcb $newcb
# )
#   returns tabcb
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctab_set_name (
#   nctab $t,
#   Str   $newname
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctab_set_userptr (
#   nctab   $t,
#   Pointer $newopaque
# )
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctab_userptr (nctab $t)
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_add (
#   nctabbed $nt,
#   nctab    $after,
#   nctab    $before,
#   tabcb    $tcb,
#   Str      $name,
#   Pointer  $opaque
# )
#   returns nctab
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_channels (
#   nctabbed $nt,
#   uint64_t $hdrchan,
#   uint64_t $selchan,
#   uint64_t $sepchan
# )
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_content_plane (nctabbed $nt)
#   returns ncplane
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_create (
#   ncplane          $n,
#   nctabbed_options $opts
# )
#   returns nctabbed
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_del (
#   nctabbed $nt,
#   nctab    $t
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_destroy (nctabbed $nt)
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_ensure_selected_header_visible (nctabbed $nt)
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_leftmost (nctabbed $nt)
#   returns nctab
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_next (nctabbed $nt)
#   returns nctab
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_plane (nctabbed $nt)
#   returns ncplane
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_prev (nctabbed $nt)
#   returns nctab
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_redraw (nctabbed $nt)
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_rotate (
#   nctabbed $nt,
#   gint     $amt
# )
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_select (
#   nctabbed $nt,
#   nctab    $t
# )
#   returns nctab
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_selected (nctabbed $nt)
#   returns nctab
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_separator (nctabbed $nt)
#   returns Str
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_separator_width (nctabbed $nt)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_set_hdrchan (
#   nctabbed $nt,
#   uint64_t $chan
# )
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_set_selchan (
#   nctabbed $nt,
#   uint64_t $chan
# )
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_set_separator (
#   nctabbed $nt,
#   Str      $separator
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_set_sepchan (
#   nctabbed $nt,
#   uint64_t $chan
# )
#   is      native(notcurses)
#   is      export
# { * }
#
# sub nctabbed_tabcount (nctabbed $nt)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncuplot_add_sample (
#   ncuplot  $n,
#   uint64_t $x,
#   uint64_t $y
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncuplot_create (
#   ncplane        $n,
#   ncplot_options $opts,
#   uint64_t       $miny,
#   uint64_t       $maxy
# )
#   returns ncuplot
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncuplot_destroy (ncuplot $n)
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncuplot_plane (ncuplot $n)
#   returns ncplane
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncuplot_sample (
#   ncuplot  $n,
#   uint64_t $x,
#   uint64_t $y
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncuplot_set_sample (
#   ncuplot  $n,
#   uint64_t $x,
#   uint64_t $y
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncvisual_from_bgra (
#   Pointer $bgra,
#   gint    $rows,
#   gint    $rowstride,
#   gint    $cols
# )
#   returns ncvisual
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncvisual_from_file (Str $file)
#   returns ncvisual
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncvisual_from_palidx (
#   Pointer  $data,
#   gint     $rows,
#   gint     $rowstride,
#   gint     $cols,
#   gint     $palsize,
#   gint     $pstride,
#   uint32_t $palette
# )
#   returns ncvisual
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncvisual_from_plane (
#   ncplane     $n,
#   ncblitter_e $blit,
#   gint        $begy,
#   gint        $begx
# )
#   returns ncvisual
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncvisual_from_rgb_loose (
#   Pointer $rgba,
#   gint    $rows,
#   gint    $rowstride,
#   gint    $cols,
#   gint    $alpha
# )
#   returns ncvisual
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncvisual_from_rgb_packed (
#   Pointer $rgba,
#   gint    $rows,
#   gint    $rowstride,
#   gint    $cols,
#   gint    $alpha
# )
#   returns ncvisual
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncvisual_from_rgba (
#   Pointer $rgba,
#   gint    $rows,
#   gint    $rowstride,
#   gint    $cols
# )
#   returns ncvisual
#   is      native(notcurses)
#   is      export
# { * }
#
# sub ncvisual_from_sixel (Str $s)
#   returns ncvisual
#   is      native(notcurses)
#   is      export
# { * }
#
# sub notcurses_accountname
#   returns Str
#   is      native(notcurses)
#   is      export
# { * }
#
# sub notcurses_at_yx (
#   notcurses $nc,
#   yoff      $stylemask,
#   xoff      $channels
# )
#   returns Str
#   is      native(notcurses)
#   is      export
# { * }
#
# sub notcurses_debug (
#   notcurses $nc,
#   FILE      $debugfp
# )
#   is      native(notcurses)
#   is      export
# { * }
#
# sub notcurses_hostname
#   returns Str
#   is      native(notcurses)
#   is      export
# { * }
#
# sub notcurses_linesigs_disable (notcurses $n)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub notcurses_linesigs_enable (notcurses $n)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub notcurses_mice_enable (notcurses $n)
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub notcurses_osversion
#   returns Str
#   is      native(notcurses)
#   is      export
# { * }
#
# sub notcurses_refresh (
#   notcurses $n,
#   gint      $y is rw,
#   gint      $x is rw
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
sub notcurses_stdplane (notcurses $nc)
  returns ncplane
  is      native(&notcurses)
  is      export
{ * }
#
# sub notcurses_stdplane_const (notcurses $nc)
#   returns ncplane
#   is      native(notcurses)
#   is      export
# { * }
#
# sub notcurses_ucs32_to_utf8 (
#   uint32_t   $ucs32,
#   ucs32count $resultbuf,
#   Str        $buflen
# )
#   returns gint
#   is      native(notcurses)
#   is      export
# { * }
#
# sub notcurses_version
#   returns Str
#   is      native(notcurses)
#   is      export
# { * }

sub notcurses_version_components (
  gint $major is rw,
  gint $minor is rw,
  gint $patch is rw,
  gint $tweak is rw
)
  is      native(&notcurses)
  is      export
{ * }

# cw: Missing from generation!

sub notcurses_init (notcurses_options $opts, Pointer $fp)
  returns notcurses
  is      native(&notcurses)
  is      export
{ * }

sub notcurses_core_init (notcurses_options $opts, Pointer $fp)
  returns notcurses
  is      native(&notcurses)
  is      export
{ * }


sub notcurses_stop (notcurses) 
  returns int32
  is      native(&notcurses)
  is      export
{ * }
