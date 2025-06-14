  method ncdplot_add_sample (
    ncdplot  $n,
    uint64_t $x,
    gdouble  $y
  ) {
    ncdplot_add_sample($n, $x, $y);
  }

  method ncdplot_create (
    ncplane        $n,
    ncplot_options $opts,
    gdouble        $miny,
    gdouble        $maxy
  ) {
    ncdplot_create($n, $opts, $miny, $maxy);
  }

  method ncdplot_destroy (ncdplot $n) {
    ncdplot_destroy($n);
  }

  method ncdplot_plane (ncdplot $n) {
    ncdplot_plane($n);
  }

  method ncdplot_sample (
    ncdplot  $n,
    uint64_t $x,
    gdouble  $y is rw
  ) {
    ncdplot_sample($n, $x, $y);
  }

  method ncdplot_set_sample (
    ncdplot  $n,
    uint64_t $x,
    gdouble  $y
  ) {
    ncdplot_set_sample($n, $x, $y);
  }

  method ncfadectx_free (ncfadectx $nctx) {
    ncfadectx_free($nctx);
  }

  method ncfadectx_iterations (ncfadectx $nctx) {
    ncfadectx_iterations($nctx);
  }

  method ncfadectx_setup (ncplane $n) {
    ncfadectx_setup($n);
  }

  method ncfdplane_create (
    ncplane            $n,
    ncfdplane_options  $opts,
    gint               $fd,
    ncfdplane_callback $cbfxn,
    ncfdplane_done_cb  $donecbfxn
  ) {
    ncfdplane_create($n, $opts, $fd, $cbfxn, $donecbfxn);
  }

  method ncfdplane_destroy (ncfdplane $n) {
    ncfdplane_destroy($n);
  }

  method ncfdplane_plane (ncfdplane $n) {
    ncfdplane_plane($n);
  }

  method ncmenu_create (
    ncplane        $n,
    ncmenu_options $opts
  ) {
    ncmenu_create($n, $opts);
  }

  method ncmenu_destroy (ncmenu $n) {
    ncmenu_destroy($n);
  }

  method ncmenu_item_set_status (
    ncmenu $n,
    Str    $section,
    Str    $item,
    bool   $enabled
  ) {
    ncmenu_item_set_status($n, $section, $item, $enabled);
  }

  method ncmenu_mouse_selected (
    ncmenu  $n,
    ncinput $click,
    ncinput $ni
  ) {
    ncmenu_mouse_selected($n, $click, $ni);
  }

  method ncmenu_nextitem (ncmenu $n) {
    ncmenu_nextitem($n);
  }

  method ncmenu_nextsection (ncmenu $n) {
    ncmenu_nextsection($n);
  }

  method ncmenu_offer_input (
    ncmenu  $n,
    ncinput $nc
  ) {
    ncmenu_offer_input($n, $nc);
  }

  method ncmenu_plane (ncmenu $n) {
    ncmenu_plane($n);
  }

  method ncmenu_previtem (ncmenu $n) {
    ncmenu_previtem($n);
  }

  method ncmenu_prevsection (ncmenu $n) {
    ncmenu_prevsection($n);
  }

  method ncmenu_rollup (ncmenu $n) {
    ncmenu_rollup($n);
  }

  method ncmenu_selected (
    ncmenu  $n,
    ncinput $ni
  ) {
    ncmenu_selected($n, $ni);
  }

  method ncmenu_unroll (
    ncmenu $n,
    gint   $sectionidx
  ) {
    ncmenu_unroll($n, $sectionidx);
  }

  method ncplane_box (
    ncplane $n,
    nccell  $ul,
    nccell  $ur,
    nccell  $ll,
    nccell  $lr,
    nccell  $hline,
    nccell  $vline
  ) {
    ncplane_box($n, $ul, $ur, $ll, $lr, $hline, $vline);
  }

  method ncplane_dim_yx (
    ncplane $n,
    gint    $y is rw,
    gint    $x is rw
  ) {
    ncplane_dim_yx($n, $y, $x);
  }

  method ncplane_erase (ncplane $n) {
    ncplane_erase($n);
  }

  method ncplane_erase_region (
    ncplane $n,
    gint    $ystart,
    gint    $xstart,
    gint    $ylen,
    gint    $xlen
  ) {
    ncplane_erase_region($n, $ystart, $xstart, $ylen, $xlen);
  }

  method ncplane_fadein (
    ncplane  $n,
    timespec $ts,
    fadecb   $fader,
    Pointer  $curry
  ) {
    ncplane_fadein($n, $ts, $fader, $curry);
  }

  method ncplane_fadein_iteration (
    ncplane   $n,
    ncfadectx $nctx,
    gint      $iter,
    fadecb    $fader,
    Pointer   $curry
  ) {
    ncplane_fadein_iteration($n, $nctx, $iter, $fader, $curry);
  }

  method ncplane_fadeout (
    ncplane  $n,
    timespec $ts,
    fadecb   $fader,
    Pointer  $curry
  ) {
    ncplane_fadeout($n, $ts, $fader, $curry);
  }

  method ncplane_fadeout_iteration (
    ncplane   $n,
    ncfadectx $nctx,
    gint      $iter,
    fadecb    $fader,
    Pointer   $curry
  ) {
    ncplane_fadeout_iteration($n, $nctx, $iter, $fader, $curry);
  }

  method ncplane_format (
    ncplane $n,
    gint    $y,
    gint    $x,
    ylen    $stylemask
  ) {
    ncplane_format($n, $y, $x, $stylemask);
  }

  method ncplane_gradient (
    ncplane  $n,
    gint     $y,
    gint     $x,
    ylen     $egc,
    xlen     $styles,
    Str      $ul,
    uint16_t $ur,
    uint64_t $ll,
    uint64_t $lr
  ) {
    ncplane_gradient($n, $y, $x, $egc, $styles, $ul, $ur, $ll, $lr);
  }

  method ncplane_gradient2x1 (
    ncplane  $n,
    gint     $y,
    gint     $x,
    ylen     $ul,
    xlen     $ur,
    uint32_t $ll,
    uint32_t $lr
  ) {
    ncplane_gradient2x1($n, $y, $x, $ul, $ur, $ll, $lr);
  }

  method ncplane_hline_interp (
    ncplane  $n,
    nccell   $c,
    len      $c1,
    uint64_t $c2
  ) {
    ncplane_hline_interp($n, $c, $c1, $c2);
  }

  method ncplane_mergedown (
    ncplane $src,
    ncplane $dst,
    gint    $begsrcy,
    gint    $begsrcx,
    leny    $dsty,
    lenx    $dstx
  ) {
    ncplane_mergedown($src, $dst, $begsrcy, $begsrcx, $dsty, $dstx);
  }

  method ncplane_mergedown_simple (
    ncplane $src,
    ncplane $dst
  ) {
    ncplane_mergedown_simple($src, $dst);
  }

  method ncplane_notcurses (ncplane $n) {
    ncplane_notcurses($n);
  }

  method ncplane_notcurses_const (ncplane $n) {
    ncplane_notcurses_const($n);
  }

  method ncplane_off_styles (ncplane $n) {
    ncplane_off_styles($n);
  }

  method ncplane_on_styles (ncplane $n) {
    ncplane_on_styles($n);
  }

  method ncplane_pixel_geom (
    ncplane $n,
    gint    $pxy is rw,
    gint    $pxx is rw,
    gint    $celldimy is rw,
    gint    $celldimx is rw,
    gint    $maxbmapy is rw,
    gint    $maxbmapx is rw
  ) {
    ncplane_pixel_geom($n, $pxy, $pxx, $celldimy, $celldimx, $maxbmapy, $maxbmapx);
  }

  method ncplane_polyfill_yx (
    ncplane $n,
    gint    $y,
    gint    $x,
    nccell  $c
  ) {
    ncplane_polyfill_yx($n, $y, $x, $c);
  }

  method ncplane_pulse (
    ncplane  $n,
    timespec $ts,
    fadecb   $fader,
    Pointer  $curry
  ) {
    ncplane_pulse($n, $ts, $fader, $curry);
  }

  method ncplane_puttext (
    ncplane   $n,
    gint      $y,
    ncalign_e $align,
    Str       $text,
    size_t    $bytes
  ) {
    ncplane_puttext($n, $y, $align, $text, $bytes);
  }

  method ncplane_qrcode (
    ncplane $n,
    gint    $ymax is rw,
    gint    $xmax is rw,
    Pointer $data,
    size_t  $len
  ) {
    ncplane_qrcode($n, $ymax, $xmax, $data, $len);
  }

  method ncplane_set_bchannel (
    ncplane  $n,
    uint32_t $channel
  ) {
    ncplane_set_bchannel($n, $channel);
  }

  method ncplane_set_bg_alpha (
    ncplane $n,
    gint    $alpha
  ) {
    ncplane_set_bg_alpha($n, $alpha);
  }

  method ncplane_set_bg_default (ncplane $n) {
    ncplane_set_bg_default($n);
  }

  method ncplane_set_bg_palindex (ncplane $n) {
    ncplane_set_bg_palindex($n);
  }

  method ncplane_set_bg_rgb (
    ncplane  $n,
    uint32_t $channel
  ) {
    ncplane_set_bg_rgb($n, $channel);
  }

  method ncplane_set_bg_rgb8 (ncplane $n) {
    ncplane_set_bg_rgb8($n);
  }

  method ncplane_set_bg_rgb8_clipped (
    ncplane $n,
    gint    $r,
    gint    $g,
    gint    $b
  ) {
    ncplane_set_bg_rgb8_clipped($n, $r, $g, $b);
  }

  method ncplane_set_channels (
    ncplane  $n,
    uint64_t $channels
  ) {
    ncplane_set_channels($n, $channels);
  }

  method ncplane_set_fchannel (
    ncplane  $n,
    uint32_t $channel
  ) {
    ncplane_set_fchannel($n, $channel);
  }

  method ncplane_set_fg_alpha (
    ncplane $n,
    gint    $alpha
  ) {
    ncplane_set_fg_alpha($n, $alpha);
  }

  method ncplane_set_fg_default (ncplane $n) {
    ncplane_set_fg_default($n);
  }

  method ncplane_set_fg_palindex (ncplane $n) {
    ncplane_set_fg_palindex($n);
  }

  method ncplane_set_fg_rgb (
    ncplane  $n,
    uint32_t $channel
  ) {
    ncplane_set_fg_rgb($n, $channel);
  }

  method ncplane_set_fg_rgb8 (ncplane $n) {
    ncplane_set_fg_rgb8($n);
  }

  method ncplane_set_fg_rgb8_clipped (
    ncplane $n,
    gint    $r,
    gint    $g,
    gint    $b
  ) {
    ncplane_set_fg_rgb8_clipped($n, $r, $g, $b);
  }

  method ncplane_set_styles (ncplane $n) {
    ncplane_set_styles($n);
  }

  method ncplane_stain (
    ncplane  $n,
    gint     $y,
    gint     $x,
    ylen     $ul,
    xlen     $ur,
    uint64_t $ll,
    uint64_t $lr
  ) {
    ncplane_stain($n, $y, $x, $ul, $ur, $ll, $lr);
  }

  method ncplane_vline_interp (
    ncplane  $n,
    nccell   $c,
    len      $c1,
    uint64_t $c2
  ) {
    ncplane_vline_interp($n, $c, $c1, $c2);
  }

  method ncplane_vprintf_aligned (
    ncplane   $n,
    gint      $y,
    ncalign_e $align,
    Str       $format,
    va_list   $ap
  ) {
    ncplane_vprintf_aligned($n, $y, $align, $format, $ap);
  }

  method ncplane_vprintf_stained (
    ncplane $n,
    Str     $format,
    va_list $ap
  ) {
    ncplane_vprintf_stained($n, $format, $ap);
  }

  method ncplane_vprintf_yx (
    ncplane $n,
    gint    $y,
    gint    $x,
    Str     $format,
    va_list $ap
  ) {
    ncplane_vprintf_yx($n, $y, $x, $format, $ap);
  }

  method ncprogbar_create (
    ncplane           $n,
    ncprogbar_options $opts
  ) {
    ncprogbar_create($n, $opts);
  }

  method ncprogbar_destroy (ncprogbar $n) {
    ncprogbar_destroy($n);
  }

  method ncprogbar_plane (ncprogbar $n) {
    ncprogbar_plane($n);
  }

  method ncprogbar_progress (ncprogbar $n) {
    ncprogbar_progress($n);
  }

  method ncprogbar_set_progress (
    ncprogbar $n,
    gdouble   $p
  ) {
    ncprogbar_set_progress($n, $p);
  }

  method ncreader_clear (ncreader $n) {
    ncreader_clear($n);
  }

  method ncreader_contents (ncreader $n) {
    ncreader_contents($n);
  }

  method ncreader_create (
    ncplane          $n,
    ncreader_options $opts
  ) {
    ncreader_create($n, $opts);
  }

  method ncreader_destroy (
    ncreader    $n,
    CArray[Str] $contents
  ) {
    ncreader_destroy($n, $contents);
  }

  method ncreader_move_down (ncreader $n) {
    ncreader_move_down($n);
  }

  method ncreader_move_left (ncreader $n) {
    ncreader_move_left($n);
  }

  method ncreader_move_right (ncreader $n) {
    ncreader_move_right($n);
  }

  method ncreader_move_up (ncreader $n) {
    ncreader_move_up($n);
  }

  method ncreader_offer_input (
    ncreader $n,
    ncinput  $ni
  ) {
    ncreader_offer_input($n, $ni);
  }

  method ncreader_plane (ncreader $n) {
    ncreader_plane($n);
  }

  method ncreader_write_egc (
    ncreader $n,
    Str      $egc
  ) {
    ncreader_write_egc($n, $egc);
  }

  method ncstrwidth (
    Str  $egcs,
    gint $validbytes is rw,
    gint $validwidth is rw
  ) {
    ncstrwidth($egcs, $validbytes, $validwidth);
  }

  method ncsubproc_createv (
    ncplane            $n,
    ncsubproc_options  $opts,
    Str                $bin,
    CArray[Str]        $arg,
    ncfdplane_callback $cbfxn,
    ncfdplane_done_cb  $donecbfxn
  ) {
    ncsubproc_createv($n, $opts, $bin, $arg, $cbfxn, $donecbfxn);
  }

  method ncsubproc_createvp (
    ncplane            $n,
    ncsubproc_options  $opts,
    Str                $bin,
    CArray[Str]        $arg,
    ncfdplane_callback $cbfxn,
    ncfdplane_done_cb  $donecbfxn
  ) {
    ncsubproc_createvp($n, $opts, $bin, $arg, $cbfxn, $donecbfxn);
  }

  method ncsubproc_createvpe (
    ncplane            $n,
    ncsubproc_options  $opts,
    Str                $bin,
    CArray[Str]        $arg,
    CArray[Str]        $env,
    ncfdplane_callback $cbfxn,
    ncfdplane_done_cb  $donecbfxn
  ) {
    ncsubproc_createvpe($n, $opts, $bin, $arg, $env, $cbfxn, $donecbfxn);
  }

  method ncsubproc_destroy (ncsubproc $n) {
    ncsubproc_destroy($n);
  }

  method ncsubproc_plane (ncsubproc $n) {
    ncsubproc_plane($n);
  }

  method nctab_cb (nctab $t) {
    nctab_cb($t);
  }

  method nctab_move (
    nctabbed $nt,
    nctab    $t,
    nctab    $after,
    nctab    $before
  ) {
    nctab_move($nt, $t, $after, $before);
  }

  method nctab_move_left (
    nctabbed $nt,
    nctab    $t
  ) {
    nctab_move_left($nt, $t);
  }

  method nctab_move_right (
    nctabbed $nt,
    nctab    $t
  ) {
    nctab_move_right($nt, $t);
  }

  method nctab_name (nctab $t) {
    nctab_name($t);
  }

  method nctab_name_width (nctab $t) {
    nctab_name_width($t);
  }

  method nctab_next (nctab $t) {
    nctab_next($t);
  }

  method nctab_prev (nctab $t) {
    nctab_prev($t);
  }

  method nctab_set_cb (
    nctab $t,
    tabcb $newcb
  ) {
    nctab_set_cb($t, $newcb);
  }

  method nctab_set_name (
    nctab $t,
    Str   $newname
  ) {
    nctab_set_name($t, $newname);
  }

  method nctab_set_userptr (
    nctab   $t,
    Pointer $newopaque
  ) {
    nctab_set_userptr($t, $newopaque);
  }

  method nctab_userptr (nctab $t) {
    nctab_userptr($t);
  }

  method nctabbed_add (
    nctabbed $nt,
    nctab    $after,
    nctab    $before,
    tabcb    $tcb,
    Str      $name,
    Pointer  $opaque
  ) {
    nctabbed_add($nt, $after, $before, $tcb, $name, $opaque);
  }

  method nctabbed_channels (
    nctabbed $nt,
    uint64_t $hdrchan,
    uint64_t $selchan,
    uint64_t $sepchan
  ) {
    nctabbed_channels($nt, $hdrchan, $selchan, $sepchan);
  }

  method nctabbed_content_plane (nctabbed $nt) {
    nctabbed_content_plane($nt);
  }

  method nctabbed_create (
    ncplane          $n,
    nctabbed_options $opts
  ) {
    nctabbed_create($n, $opts);
  }

  method nctabbed_del (
    nctabbed $nt,
    nctab    $t
  ) {
    nctabbed_del($nt, $t);
  }

  method nctabbed_destroy (nctabbed $nt) {
    nctabbed_destroy($nt);
  }

  method nctabbed_ensure_selected_header_visible (nctabbed $nt) {
    nctabbed_ensure_selected_header_visible($nt);
  }

  method nctabbed_leftmost (nctabbed $nt) {
    nctabbed_leftmost($nt);
  }

  method nctabbed_next (nctabbed $nt) {
    nctabbed_next($nt);
  }

  method nctabbed_plane (nctabbed $nt) {
    nctabbed_plane($nt);
  }

  method nctabbed_prev (nctabbed $nt) {
    nctabbed_prev($nt);
  }

  method nctabbed_redraw (nctabbed $nt) {
    nctabbed_redraw($nt);
  }

  method nctabbed_rotate (
    nctabbed $nt,
    gint     $amt
  ) {
    nctabbed_rotate($nt, $amt);
  }

  method nctabbed_select (
    nctabbed $nt,
    nctab    $t
  ) {
    nctabbed_select($nt, $t);
  }

  method nctabbed_selected (nctabbed $nt) {
    nctabbed_selected($nt);
  }

  method nctabbed_separator (nctabbed $nt) {
    nctabbed_separator($nt);
  }

  method nctabbed_separator_width (nctabbed $nt) {
    nctabbed_separator_width($nt);
  }

  method nctabbed_set_hdrchan (
    nctabbed $nt,
    uint64_t $chan
  ) {
    nctabbed_set_hdrchan($nt, $chan);
  }

  method nctabbed_set_selchan (
    nctabbed $nt,
    uint64_t $chan
  ) {
    nctabbed_set_selchan($nt, $chan);
  }

  method nctabbed_set_separator (
    nctabbed $nt,
    Str      $separator
  ) {
    nctabbed_set_separator($nt, $separator);
  }

  method nctabbed_set_sepchan (
    nctabbed $nt,
    uint64_t $chan
  ) {
    nctabbed_set_sepchan($nt, $chan);
  }

  method nctabbed_tabcount (nctabbed $nt) {
    nctabbed_tabcount($nt);
  }

  method ncuplot_add_sample (
    ncuplot  $n,
    uint64_t $x,
    uint64_t $y
  ) {
    ncuplot_add_sample($n, $x, $y);
  }

  method ncuplot_create (
    ncplane        $n,
    ncplot_options $opts,
    uint64_t       $miny,
    uint64_t       $maxy
  ) {
    ncuplot_create($n, $opts, $miny, $maxy);
  }

  method ncuplot_destroy (ncuplot $n) {
    ncuplot_destroy($n);
  }

  method ncuplot_plane (ncuplot $n) {
    ncuplot_plane($n);
  }

  method ncuplot_sample (
    ncuplot  $n,
    uint64_t $x,
    uint64_t $y
  ) {
    ncuplot_sample($n, $x, $y);
  }

  method ncuplot_set_sample (
    ncuplot  $n,
    uint64_t $x,
    uint64_t $y
  ) {
    ncuplot_set_sample($n, $x, $y);
  }

  method ncvisual_from_bgra (
    Pointer $bgra,
    gint    $rows,
    gint    $rowstride,
    gint    $cols
  ) {
    ncvisual_from_bgra($bgra, $rows, $rowstride, $cols);
  }

  method ncvisual_from_file (Str $file) {
    ncvisual_from_file($file);
  }

  method ncvisual_from_palidx (
    Pointer  $data,
    gint     $rows,
    gint     $rowstride,
    gint     $cols,
    gint     $palsize,
    gint     $pstride,
    uint32_t $palette
  ) {
    ncvisual_from_palidx($data, $rows, $rowstride, $cols, $palsize, $pstride, $palette);
  }

  method ncvisual_from_plane (
    ncplane     $n,
    ncblitter_e $blit,
    gint        $begy,
    gint        $begx
  ) {
    ncvisual_from_plane($n, $blit, $begy, $begx);
  }

  method ncvisual_from_rgb_loose (
    Pointer $rgba,
    gint    $rows,
    gint    $rowstride,
    gint    $cols,
    gint    $alpha
  ) {
    ncvisual_from_rgb_loose($rgba, $rows, $rowstride, $cols, $alpha);
  }

  method ncvisual_from_rgb_packed (
    Pointer $rgba,
    gint    $rows,
    gint    $rowstride,
    gint    $cols,
    gint    $alpha
  ) {
    ncvisual_from_rgb_packed($rgba, $rows, $rowstride, $cols, $alpha);
  }

  method ncvisual_from_rgba (
    Pointer $rgba,
    gint    $rows,
    gint    $rowstride,
    gint    $cols
  ) {
    ncvisual_from_rgba($rgba, $rows, $rowstride, $cols);
  }

  method ncvisual_from_sixel (Str $s) {
    ncvisual_from_sixel($s);
  }

  method notcurses_accountname {
    notcurses_accountname();
  }

  method notcurses_at_yx (
    notcurses $nc,
    yoff      $stylemask,
    xoff      $channels
  ) {
    notcurses_at_yx($nc, $stylemask, $channels);
  }

  method notcurses_debug (
    notcurses $nc,
    FILE      $debugfp
  ) {
    notcurses_debug($nc, $debugfp);
  }

  method notcurses_hostname {
    notcurses_hostname();
  }

  method notcurses_linesigs_disable (notcurses $n) {
    notcurses_linesigs_disable($n);
  }

  method notcurses_linesigs_enable (notcurses $n) {
    notcurses_linesigs_enable($n);
  }

  method notcurses_mice_enable (notcurses $n) {
    notcurses_mice_enable($n);
  }

  method notcurses_osversion {
    notcurses_osversion();
  }

  method notcurses_refresh (
    notcurses $n,
    gint      $y is rw,
    gint      $x is rw
  ) {
    notcurses_refresh($n, $y, $x);
  }

  method notcurses_stdplane (notcurses $nc) {
    notcurses_stdplane($nc);
  }

  method notcurses_stdplane_const (notcurses $nc) {
    notcurses_stdplane_const($nc);
  }

  method notcurses_ucs32_to_utf8 (
    uint32_t   $ucs32,
    ucs32count $resultbuf,
    Str        $buflen
  ) {
    notcurses_ucs32_to_utf8($ucs32, $resultbuf, $buflen);
  }

  method notcurses_version {
    notcurses_version();
  }

  method notcurses_version_components (
    gint $major is rw,
    gint $minor is rw,
    gint $patch is rw,
    gint $tweak is rw
  ) {
    notcurses_version_components($major, $minor, $patch, $tweak);
  }

