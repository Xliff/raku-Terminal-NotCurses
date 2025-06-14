  method nccell_duplicate (
    ncplane $n,
    nccell  $targ,
    nccell  $c
  ) {
    nccell_duplicate($n, $targ, $c);
  }

  method nccell_extended_gcluster (
    ncplane $n,
    nccell  $c
  ) {
    nccell_extended_gcluster($n, $c);
  }

  method nccell_load (
    ncplane $n,
    nccell  $c,
    Str     $gcluster
  ) {
    nccell_load($n, $c, $gcluster);
  }

  method nccell_release (
    ncplane $n,
    nccell  $c
  ) {
    nccell_release($n, $c);
  }

  method ncpalette_new (notcurses $nc) {
    ncpalette_new($nc);
  }

  method ncpalette_use (
    notcurses $nc,
    ncpalette $p
  ) {
    ncpalette_use($nc, $p);
  }

  method ncplane_above (ncplane $n) {
    ncplane_above($n);
  }

  method ncplane_abs_x (ncplane $n) {
    ncplane_abs_x($n);
  }

  method ncplane_abs_y (ncplane $n) {
    ncplane_abs_y($n);
  }

  method ncplane_as_rgba (
    ncplane     $n,
    ncblitter_e $blit,
    gint        $begy,
    gint        $begx,
    leny        $pxdimy,
    lenx        $pxdimx
  ) {
    ncplane_as_rgba($n, $blit, $begy, $begx, $pxdimy, $pxdimx);
  }

  method ncplane_at_cursor (
    ncplane  $n,
    uint16_t $stylemask,
    uint64_t $channels
  ) {
    ncplane_at_cursor($n, $stylemask, $channels);
  }

  method ncplane_at_cursor_cell (
    ncplane $n,
    nccell  $c
  ) {
    ncplane_at_cursor_cell($n, $c);
  }

  method ncplane_at_yx (
    ncplane  $n,
    gint     $y,
    gint     $x,
    uint16_t $stylemask,
    uint64_t $channels
  ) {
    ncplane_at_yx($n, $y, $x, $stylemask, $channels);
  }

  method ncplane_autogrow_p (ncplane $n) {
    ncplane_autogrow_p($n);
  }

  method ncplane_base (
    ncplane $n,
    nccell  $c
  ) {
    ncplane_base($n, $c);
  }

  method ncplane_below (ncplane $n) {
    ncplane_below($n);
  }

  method ncplane_center_abs (
    ncplane $n,
    gint    $y is rw,
    gint    $x is rw
  ) {
    ncplane_center_abs($n, $y, $x);
  }

  method ncplane_channels (ncplane $n) {
    ncplane_channels($n);
  }

  method ncplane_contents (
    ncplane $n,
    gint    $begy,
    gint    $begx
  ) {
    ncplane_contents($n, $begy, $begx);
  }

  method ncplane_cursor_move_rel (
    ncplane $n,
    gint    $y,
    gint    $x
  ) {
    ncplane_cursor_move_rel($n, $y, $x);
  }

  method ncplane_cursor_yx (
    ncplane $n,
    gint    $y is rw,
    gint    $x is rw
  ) {
    ncplane_cursor_yx($n, $y, $x);
  }

  method ncplane_destroy (ncplane $n) {
    ncplane_destroy($n);
  }

  method ncplane_dup (
    ncplane $n,
    Pointer $opaque
  ) {
    ncplane_dup($n, $opaque);
  }

  method ncplane_move_above (
    ncplane $n,
    ncplane $above
  ) {
    ncplane_move_above($n, $above);
  }

  method ncplane_move_below (
    ncplane $n,
    ncplane $below
  ) {
    ncplane_move_below($n, $below);
  }

  method ncplane_move_family_above (
    ncplane $n,
    ncplane $targ
  ) {
    ncplane_move_family_above($n, $targ);
  }

  method ncplane_move_family_below (
    ncplane $n,
    ncplane $targ
  ) {
    ncplane_move_family_below($n, $targ);
  }

  method ncplane_move_yx (
    ncplane $n,
    gint    $y,
    gint    $x
  ) {
    ncplane_move_yx($n, $y, $x);
  }

  method ncplane_name (ncplane $n) {
    ncplane_name($n);
  }

  method ncplane_parent (ncplane $n) {
    ncplane_parent($n);
  }

  method ncplane_parent_const (ncplane $n) {
    ncplane_parent_const($n);
  }

  method ncplane_putc_yx (
    ncplane $n,
    gint    $y,
    gint    $x,
    nccell  $c
  ) {
    ncplane_putc_yx($n, $y, $x, $c);
  }

  method ncplane_putchar_stained (
    ncplane $n,
    Str     $c
  ) {
    ncplane_putchar_stained($n, $c);
  }

  method ncplane_putegc_stained (
    ncplane $n,
    Str     $gclust,
    size_t  $sbytes
  ) {
    ncplane_putegc_stained($n, $gclust, $sbytes);
  }

  method ncplane_putegc_yx (
    ncplane $n,
    gint    $y,
    gint    $x,
    Str     $gclust,
    size_t  $sbytes
  ) {
    ncplane_putegc_yx($n, $y, $x, $gclust, $sbytes);
  }

  method ncplane_putnstr_aligned (
    ncplane   $n,
    gint      $y,
    ncalign_e $align,
    size_t    $s,
    Str       $str
  ) {
    ncplane_putnstr_aligned($n, $y, $align, $s, $str);
  }

  method ncplane_putwegc_stained (
    ncplane $n,
    wchar_t $gclust,
    size_t  $sbytes
  ) {
    ncplane_putwegc_stained($n, $gclust, $sbytes);
  }

  method ncplane_putwstr_stained (
    ncplane $n,
    wchar_t $gclustarr
  ) {
    ncplane_putwstr_stained($n, $gclustarr);
  }

  method ncplane_reparent (
    ncplane $n,
    ncplane $newparent
  ) {
    ncplane_reparent($n, $newparent);
  }

  method ncplane_reparent_family (
    ncplane $n,
    ncplane $newparent
  ) {
    ncplane_reparent_family($n, $newparent);
  }

  method ncplane_resize (
    ncplane  $n,
    gint     $keepy,
    gint     $keepx,
    keepleny $yoff,
    keeplenx $xoff
  ) {
    ncplane_resize($n, $keepy, $keepx, $yoff, $xoff);
  }

  method ncplane_rotate_ccw (ncplane $n) {
    ncplane_rotate_ccw($n);
  }

  method ncplane_rotate_cw (ncplane $n) {
    ncplane_rotate_cw($n);
  }

  method ncplane_scrolling_p (ncplane $n) {
    ncplane_scrolling_p($n);
  }

  method ncplane_scrollup (
    ncplane $n,
    gint    $r
  ) {
    ncplane_scrollup($n, $r);
  }

  method ncplane_scrollup_child (
    ncplane $n,
    ncplane $child
  ) {
    ncplane_scrollup_child($n, $child);
  }

  method ncplane_set_autogrow (ncplane $n) {
    ncplane_set_autogrow($n);
  }

  method ncplane_set_base (
    ncplane  $n,
    Str      $egc,
    uint16_t $stylemask,
    uint64_t $channels
  ) {
    ncplane_set_base($n, $egc, $stylemask, $channels);
  }

  method ncplane_set_base_cell (
    ncplane $n,
    nccell  $c
  ) {
    ncplane_set_base_cell($n, $c);
  }

  method ncplane_set_scrolling (ncplane $n) {
    ncplane_set_scrolling($n);
  }

  method ncplane_set_userptr (
    ncplane $n,
    Pointer $opaque
  ) {
    ncplane_set_userptr($n, $opaque);
  }

  method ncplane_styles (ncplane $n) {
    ncplane_styles($n);
  }

  method ncplane_translate (
    ncplane $src,
    ncplane $dst,
    gint    $y is rw,
    gint    $x is rw
  ) {
    ncplane_translate($src, $dst, $y, $x);
  }

  method ncplane_translate_abs (
    ncplane $n,
    gint    $y is rw,
    gint    $x is rw
  ) {
    ncplane_translate_abs($n, $y, $x);
  }

  method ncplane_userptr (ncplane $n) {
    ncplane_userptr($n);
  }

  method ncplane_x (ncplane $n) {
    ncplane_x($n);
  }

  method ncplane_y (ncplane $n) {
    ncplane_y($n);
  }

  method ncplane_yx (
    ncplane $n,
    gint    $y is rw,
    gint    $x is rw
  ) {
    ncplane_yx($n, $y, $x);
  }

  method notcurses_canopen_images (notcurses $nc) {
    notcurses_canopen_images($nc);
  }

  method notcurses_canopen_videos (notcurses $nc) {
    notcurses_canopen_videos($nc);
  }

  method notcurses_capabilities (notcurses $n) {
    notcurses_capabilities($n);
  }

  method notcurses_check_pixel_support (notcurses $nc) {
    notcurses_check_pixel_support($nc);
  }

  method notcurses_detected_terminal (notcurses $nc) {
    notcurses_detected_terminal($nc);
  }

  method notcurses_palette_size (notcurses $nc) {
    notcurses_palette_size($nc);
  }

  method notcurses_stats (
    notcurses $nc,
    ncstats   $stats
  ) {
    notcurses_stats($nc, $stats);
  }

  method notcurses_stats_alloc (notcurses $nc) {
    notcurses_stats_alloc($nc);
  }

  method notcurses_stats_reset (
    notcurses $nc,
    ncstats   $stats
  ) {
    notcurses_stats_reset($nc, $stats);
  }

  method notcurses_supported_styles (notcurses $nc) {
    notcurses_supported_styles($nc);
  }
