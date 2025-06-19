  method ncbprefixexport (
    uintmax_t $val,
    uintmax_t $decimal,
    Str       $buf,
    gint      $omitdec
  ) {
    ncbprefixexport($val, $decimal, $buf, $omitdec);
  }

  method nccapability_canchangecolorexport (nccapabilities $caps) {
    nccapability_canchangecolorexport($caps);
  }


  method nccells_ascii_boxexport (
    ncplane  $n,
    uint16_t $attr,
    uint64_t $channels,
    nccell   $ul,
    nccell   $ur,
    nccell   $ll,
    nccell   $lr,
    nccell   $hl,
    nccell   $vl
  ) {
    nccells_ascii_boxexport($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
  }

  method nccells_double_boxexport (
    ncplane  $n,
    uint16_t $attr,
    uint64_t $channels,
    nccell   $ul,
    nccell   $ur,
    nccell   $ll,
    nccell   $lr,
    nccell   $hl,
    nccell   $vl
  ) {
    nccells_double_boxexport($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
  }

  method nccells_heavy_boxexport (
    ncplane  $n,
    uint16_t $attr,
    uint64_t $channels,
    nccell   $ul,
    nccell   $ur,
    nccell   $ll,
    nccell   $lr,
    nccell   $hl,
    nccell   $vl
  ) {
    nccells_heavy_boxexport($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
  }

  method nccells_light_boxexport (
    ncplane  $n,
    uint16_t $attr,
    uint64_t $channels,
    nccell   $ul,
    nccell   $ur,
    nccell   $ll,
    nccell   $lr,
    nccell   $hl,
    nccell   $vl
  ) {
    nccells_light_boxexport($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
  }

  method nccells_load_boxexport (
    ncplane  $n,
    uint16_t $styles,
    uint64_t $channels,
    nccell   $ul,
    nccell   $ur,
    nccell   $ll,
    nccell   $lr,
    nccell   $hl,
    nccell   $vl,
    Str      $gclusters
  ) {
    nccells_load_boxexport($n, $styles, $channels, $ul, $ur, $ll, $lr, $hl, $vl, $gclusters);
  }

  method nccells_rounded_boxexport (
    ncplane  $n,
    uint16_t $attr,
    uint64_t $channels,
    nccell   $ul,
    nccell   $ur,
    nccell   $ll,
    nccell   $lr,
    nccell   $hl,
    nccell   $vl
  ) {
    nccells_rounded_boxexport($n, $attr, $channels, $ul, $ur, $ll, $lr, $hl, $vl);
  }

  method ncchannel_alphaexport (uint32_t $channel) {
    ncchannel_alphaexport($channel);
  }

  method ncchannel_bexport (uint32_t $channel) {
    ncchannel_bexport($channel);
  }

  method ncchannel_default_pexport (uint32_t $channel) {
    ncchannel_default_pexport($channel);
  }

  method ncchannel_gexport (uint32_t $channel) {
    ncchannel_gexport($channel);
  }

  method ncchannel_palindex_pexport (uint32_t $channel) {
    ncchannel_palindex_pexport($channel);
  }

  method ncchannel_palindexexport (uint32_t $channel) {
    ncchannel_palindexexport($channel);
  }

  method ncchannel_rexport (uint32_t $channel) {
    ncchannel_rexport($channel);
  }

  method ncchannel_rgb8export (
    uint32_t $channel,
    gint     $r is rw,
    gint     $g is rw,
    gint     $b is rw
  ) {
    ncchannel_rgb8export($channel, $r, $g, $b);
  }

  method ncchannel_rgb_pexport (uint32_t $channel) {
    ncchannel_rgb_pexport($channel);
  }

  method ncchannel_rgbexport (uint32_t $channel) {
    ncchannel_rgbexport($channel);
  }

  method ncchannel_set_alphaexport (uint32_t $channel) {
    ncchannel_set_alphaexport($channel);
  }

  method ncchannel_set_defaultexport (uint32_t $channel) {
    ncchannel_set_defaultexport($channel);
  }

  method ncchannel_set_palindexexport (uint32_t $channel) {
    ncchannel_set_palindexexport($channel);
  }

  method ncchannel_set_rgb8_clippedexport (
    uint32_t $channel,
    gint     $r,
    gint     $g,
    gint     $b
  ) {
    ncchannel_set_rgb8_clippedexport($channel, $r, $g, $b);
  }

  method ncchannel_set_rgb8export (uint32_t $channel) {
    ncchannel_set_rgb8export($channel);
  }

  method ncchannel_setexport (
    uint32_t $channel,
    uint32_t $rgb
  ) {
    ncchannel_setexport($channel, $rgb);
  }

  method ncchannels_bchannelexport (uint64_t $channels) {
    ncchannels_bchannelexport($channels);
  }

  method ncchannels_bg_alphaexport (uint64_t $channels) {
    ncchannels_bg_alphaexport($channels);
  }

  method ncchannels_bg_default_pexport (uint64_t $channels) {
    ncchannels_bg_default_pexport($channels);
  }

  method ncchannels_bg_palindex_pexport (uint64_t $channels) {
    ncchannels_bg_palindex_pexport($channels);
  }

  method ncchannels_bg_palindexexport (uint64_t $channels) {
    ncchannels_bg_palindexexport($channels);
  }

  method ncchannels_bg_rgb8export (
    uint64_t $channels,
    gint     $r is rw,
    gint     $g is rw,
    gint     $b is rw
  ) {
    ncchannels_bg_rgb8export($channels, $r, $g, $b);
  }

  method ncchannels_bg_rgb_pexport (uint64_t $channels) {
    ncchannels_bg_rgb_pexport($channels);
  }

  method ncchannels_bg_rgbexport (uint64_t $channels) {
    ncchannels_bg_rgbexport($channels);
  }

  method ncchannels_channelsexport (uint64_t $channels) {
    ncchannels_channelsexport($channels);
  }

  method ncchannels_combineexport (
    uint32_t $fchan,
    uint32_t $bchan
  ) {
    ncchannels_combineexport($fchan, $bchan);
  }

  method ncchannels_fchannelexport (uint64_t $channels) {
    ncchannels_fchannelexport($channels);
  }

  method ncchannels_fg_alphaexport (uint64_t $channels) {
    ncchannels_fg_alphaexport($channels);
  }

  method ncchannels_fg_default_pexport (uint64_t $channels) {
    ncchannels_fg_default_pexport($channels);
  }

  method ncchannels_fg_palindex_pexport (uint64_t $channels) {
    ncchannels_fg_palindex_pexport($channels);
  }

  method ncchannels_fg_palindexexport (uint64_t $channels) {
    ncchannels_fg_palindexexport($channels);
  }

  method ncchannels_fg_rgb8export (
    uint64_t $channels,
    gint     $r is rw,
    gint     $g is rw,
    gint     $b is rw
  ) {
    ncchannels_fg_rgb8export($channels, $r, $g, $b);
  }

  method ncchannels_fg_rgb_pexport (uint64_t $channels) {
    ncchannels_fg_rgb_pexport($channels);
  }

  method ncchannels_fg_rgbexport (uint64_t $channels) {
    ncchannels_fg_rgbexport($channels);
  }

  method ncchannels_reverseexport (uint64_t $channels) {
    ncchannels_reverseexport($channels);
  }

  method ncchannels_set_bchannelexport (
    uint64_t $channels,
    uint32_t $channel
  ) {
    ncchannels_set_bchannelexport($channels, $channel);
  }

  method ncchannels_set_bg_alphaexport (uint64_t $channels) {
    ncchannels_set_bg_alphaexport($channels);
  }

  method ncchannels_set_bg_defaultexport (uint64_t $channels) {
    ncchannels_set_bg_defaultexport($channels);
  }

  method ncchannels_set_bg_palindexexport (uint64_t $channels) {
    ncchannels_set_bg_palindexexport($channels);
  }

  method ncchannels_set_bg_rgb8_clippedexport (
    uint64_t $channels,
    gint     $r,
    gint     $g,
    gint     $b
  ) {
    ncchannels_set_bg_rgb8_clippedexport($channels, $r, $g, $b);
  }

  method ncchannels_set_bg_rgb8export (uint64_t $channels) {
    ncchannels_set_bg_rgb8export($channels);
  }

  method ncchannels_set_bg_rgbexport (uint64_t $channels) {
    ncchannels_set_bg_rgbexport($channels);
  }

  method ncchannels_set_channelsexport (
    uint64_t $dst,
    uint64_t $channels
  ) {
    ncchannels_set_channelsexport($dst, $channels);
  }

  method ncchannels_set_fchannelexport (
    uint64_t $channels,
    uint32_t $channel
  ) {
    ncchannels_set_fchannelexport($channels, $channel);
  }

  method ncchannels_set_fg_alphaexport (uint64_t $channels) {
    ncchannels_set_fg_alphaexport($channels);
  }

  method ncchannels_set_fg_defaultexport (uint64_t $channels) {
    ncchannels_set_fg_defaultexport($channels);
  }

  method ncchannels_set_fg_palindexexport (uint64_t $channels) {
    ncchannels_set_fg_palindexexport($channels);
  }

  method ncchannels_set_fg_rgb8_clippedexport (
    uint64_t $channels,
    gint     $r,
    gint     $g,
    gint     $b
  ) {
    ncchannels_set_fg_rgb8_clippedexport($channels, $r, $g, $b);
  }

  method ncchannels_set_fg_rgb8export (uint64_t $channels) {
    ncchannels_set_fg_rgb8export($channels);
  }

  method ncchannels_set_fg_rgbexport (uint64_t $channels) {
    ncchannels_set_fg_rgbexport($channels);
  }

  method ncinput_alt_pexport (ncinput $n) {
    ncinput_alt_pexport($n);
  }

  method ncinput_capslock_pexport (ncinput $n) {
    ncinput_capslock_pexport($n);
  }

  method ncinput_ctrl_pexport (ncinput $n) {
    ncinput_ctrl_pexport($n);
  }

  method ncinput_equal_pexport (
    ncinput $n1,
    ncinput $n2
  ) {
    ncinput_equal_pexport($n1, $n2);
  }

  method ncinput_hyper_pexport (ncinput $n) {
    ncinput_hyper_pexport($n);
  }

  method ncinput_meta_pexport (ncinput $n) {
    ncinput_meta_pexport($n);
  }

  method ncinput_nomod_pexport (ncinput $ni) {
    ncinput_nomod_pexport($ni);
  }

  method ncinput_numlock_pexport (ncinput $n) {
    ncinput_numlock_pexport($n);
  }

  method ncinput_shift_pexport (ncinput $n) {
    ncinput_shift_pexport($n);
  }

  method ncinput_super_pexport (ncinput $n) {
    ncinput_super_pexport($n);
  }

  method nciprefixexport (
    uintmax_t $val,
    uintmax_t $decimal,
    Str       $buf,
    gint      $omitdec
  ) {
    nciprefixexport($val, $decimal, $buf, $omitdec);
  }

  method nckey_mouse_pexport (uint32_t $r) {
    nckey_mouse_pexport($r);
  }

  method ncpalette_get_rgb8export (
    ncpalette $p,
    gint      $idx,
    gint      $r is rw,
    gint      $g is rw,
    gint      $b is rw
  ) {
    ncpalette_get_rgb8export($p, $idx, $r, $g, $b);
  }

  method ncpalette_getexport (
    ncpalette $p,
    gint      $idx,
    uint32_t  $palent
  ) {
    ncpalette_getexport($p, $idx, $palent);
  }

  method ncpalette_set_rgb8export (
    ncpalette $p,
    gint      $idx
  ) {
    ncpalette_set_rgb8export($p, $idx);
  }

  method ncpalette_setexport (
    ncpalette $p,
    gint      $idx
  ) {
    ncpalette_setexport($p, $idx);
  }

  method ncpixel_aexport (uint32_t $pixel) {
    ncpixel_aexport($pixel);
  }

  method ncpixel_bexport (uint32_t $pixel) {
    ncpixel_bexport($pixel);
  }

  method ncpixel_gexport (uint32_t $pixel) {
    ncpixel_gexport($pixel);
  }

  method ncpixel_rexport (uint32_t $pixel) {
    ncpixel_rexport($pixel);
  }

  method ncpixel_set_aexport (uint32_t $pixel) {
    ncpixel_set_aexport($pixel);
  }

  method ncpixel_set_bexport (uint32_t $pixel) {
    ncpixel_set_bexport($pixel);
  }

  method ncpixel_set_gexport (uint32_t $pixel) {
    ncpixel_set_gexport($pixel);
  }

  method ncpixel_set_rexport (uint32_t $pixel) {
    ncpixel_set_rexport($pixel);
  }

  method ncpixel_set_rgb8export (uint32_t $pixel) {
    ncpixel_set_rgb8export($pixel);
  }

  method ncpixelexport {
    ncpixelexport();
  }

  method ncplane_ascii_boxexport (
    ncplane  $n,
    uint16_t $styles,
    uint64_t $channels
  ) {
    ncplane_ascii_boxexport($n, $styles, $channels);
  }

  method ncplane_bchannelexport (ncplane $n) {
    ncplane_bchannelexport($n);
  }

  method ncplane_bg_alphaexport (ncplane $n) {
    ncplane_bg_alphaexport($n);
  }

  method ncplane_bg_default_pexport (ncplane $n) {
    ncplane_bg_default_pexport($n);
  }

  method ncplane_bg_rgb8export (
    ncplane $n,
    gint    $r is rw,
    gint    $g is rw,
    gint    $b is rw
  ) {
    ncplane_bg_rgb8export($n, $r, $g, $b);
  }

  method ncplane_bg_rgbexport (ncplane $n) {
    ncplane_bg_rgbexport($n);
  }

  method ncplane_box_sizedexport (
    ncplane $n,
    nccell  $ul,
    nccell  $ur,
    nccell  $ll,
    nccell  $lr,
    nccell  $hline,
    nccell  $vline
  ) {
    ncplane_box_sizedexport($n, $ul, $ur, $ll, $lr, $hline, $vline);
  }

  method ncplane_cursor_xexport (ncplane $n) {
    ncplane_cursor_xexport($n);
  }

  method ncplane_cursor_yexport (ncplane $n) {
    ncplane_cursor_yexport($n);
  }

  method ncplane_descendant_pexport (
    ncplane $n,
    ncplane $ancestor
  ) {
    ncplane_descendant_pexport($n, $ancestor);
  }

  method ncplane_dim_xexport (ncplane $n) {
    ncplane_dim_xexport($n);
  }

  method ncplane_dim_yexport (ncplane $n) {
    ncplane_dim_yexport($n);
  }

  method ncplane_double_box_sizedexport (
    ncplane  $n,
    uint16_t $styles,
    uint64_t $channels
  ) {
    ncplane_double_box_sizedexport($n, $styles, $channels);
  }

  method ncplane_double_boxexport (
    ncplane  $n,
    uint16_t $styles,
    uint64_t $channels
  ) {
    ncplane_double_boxexport($n, $styles, $channels);
  }

  method ncplane_fchannelexport (ncplane $n) {
    ncplane_fchannelexport($n);
  }

  method ncplane_fg_alphaexport (ncplane $n) {
    ncplane_fg_alphaexport($n);
  }

  method ncplane_fg_default_pexport (ncplane $n) {
    ncplane_fg_default_pexport($n);
  }

  method ncplane_fg_rgb8export (
    ncplane $n,
    gint    $r is rw,
    gint    $g is rw,
    gint    $b is rw
  ) {
    ncplane_fg_rgb8export($n, $r, $g, $b);
  }

  method ncplane_fg_rgbexport (ncplane $n) {
    ncplane_fg_rgbexport($n);
  }

  method ncplane_halignexport (
    ncplane   $n,
    ncalign_e $align,
    gint      $c
  ) {
    ncplane_halignexport($n, $align, $c);
  }

  method ncplane_hlineexport (
    ncplane $n,
    nccell  $c
  ) {
    ncplane_hlineexport($n, $c);
  }

  method ncplane_move_bottomexport (ncplane $n) {
    ncplane_move_bottomexport($n);
  }

  method ncplane_move_family_bottomexport (ncplane $n) {
    ncplane_move_family_bottomexport($n);
  }

  method ncplane_move_family_topexport (ncplane $n) {
    ncplane_move_family_topexport($n);
  }

  method ncplane_move_relexport (
    ncplane $n,
    gint    $y,
    gint    $x
  ) {
    ncplane_move_relexport($n, $y, $x);
  }

  method ncplane_move_topexport (ncplane $n) {
    ncplane_move_topexport($n);
  }

  method ncplane_perimeter_doubleexport (
    ncplane  $n,
    uint16_t $stylemask,
    uint64_t $channels
  ) {
    ncplane_perimeter_doubleexport($n, $stylemask, $channels);
  }

  method ncplane_perimeter_roundedexport (
    ncplane  $n,
    uint16_t $stylemask,
    uint64_t $channels
  ) {
    ncplane_perimeter_roundedexport($n, $stylemask, $channels);
  }

  method ncplane_perimeterexport (
    ncplane $n,
    nccell  $ul,
    nccell  $ur,
    nccell  $ll,
    nccell  $lr,
    nccell  $hline,
    nccell  $vline
  ) {
    ncplane_perimeterexport($n, $ul, $ur, $ll, $lr, $hline, $vline);
  }

  method ncplane_printf_alignedexport (
    ncplane   $n,
    gint      $y,
    ncalign_e $align,
    Str       $format
  ) {
    ncplane_printf_alignedexport($n, $y, $align, $format);
  }

  method ncplane_printf_stainedexport (
    ncplane $n,
    Str     $format
  ) {
    ncplane_printf_stainedexport($n, $format);
  }

  method ncplane_printf_yxexport (
    ncplane $n,
    gint    $y,
    gint    $x,
    Str     $format
  ) {
    ncplane_printf_yxexport($n, $y, $x, $format);
  }

  method ncplane_printfexport (
    ncplane $n,
    Str     $format
  ) {
    ncplane_printfexport($n, $format);
  }

  method ncplane_putcexport (
    ncplane $n,
    nccell  $c
  ) {
    ncplane_putcexport($n, $c);
  }

  method ncplane_putchar_yxexport (
    ncplane $n,
    gint    $y,
    gint    $x,
    Str     $c
  ) {
    ncplane_putchar_yxexport($n, $y, $x, $c);
  }

  method ncplane_putcharexport (
    ncplane $n,
    Str     $c
  ) {
    ncplane_putcharexport($n, $c);
  }

  method ncplane_putegcexport (
    ncplane $n,
    Str     $gclust,
    size_t  $sbytes
  ) {
    ncplane_putegcexport($n, $gclust, $sbytes);
  }

  method ncplane_putnstr_yxexport (
    ncplane $n,
    gint    $y,
    gint    $x,
    size_t  $s,
    Str     $gclusters
  ) {
    ncplane_putnstr_yxexport($n, $y, $x, $s, $gclusters);
  }

  method ncplane_putnstrexport (
    ncplane $n,
    size_t  $s,
    Str     $gclustarr
  ) {
    ncplane_putnstrexport($n, $s, $gclustarr);
  }

  method ncplane_putstr_alignedexport (
    ncplane   $n,
    gint      $y,
    ncalign_e $align,
    Str       $s
  ) {
    ncplane_putstr_alignedexport($n, $y, $align, $s);
  }

  method ncplane_putstr_stainedexport (
    ncplane $n,
    Str     $gclusters
  ) {
    ncplane_putstr_stainedexport($n, $gclusters);
  }

  method ncplane_putstr_yxexport (
    ncplane $n,
    gint    $y,
    gint    $x,
    Str     $gclusters
  ) {
    ncplane_putstr_yxexport($n, $y, $x, $gclusters);
  }

  method ncplane_putstrexport (
    ncplane $n,
    Str     $gclustarr
  ) {
    ncplane_putstrexport($n, $gclustarr);
  }

  method ncplane_pututf32_yxexport (
    ncplane  $n,
    gint     $y,
    gint     $x,
    uint32_t $u
  ) {
    ncplane_pututf32_yxexport($n, $y, $x, $u);
  }

  method ncplane_putwc_stainedexport (
    ncplane $n,
    wchar_t $w
  ) {
    ncplane_putwc_stainedexport($n, $w);
  }

  method ncplane_putwc_utf32export (
    ncplane $n,
    wchar_t $w,
    gint    $wchars is rw
  ) {
    ncplane_putwc_utf32export($n, $w, $wchars);
  }

  method ncplane_putwc_yxexport (
    ncplane $n,
    gint    $y,
    gint    $x,
    wchar_t $w
  ) {
    ncplane_putwc_yxexport($n, $y, $x, $w);
  }

  method ncplane_putwcexport (
    ncplane $n,
    wchar_t $w
  ) {
    ncplane_putwcexport($n, $w);
  }

  method ncplane_putwegc_yxexport (
    ncplane $n,
    gint    $y,
    gint    $x,
    wchar_t $gclust,
    size_t  $sbytes
  ) {
    ncplane_putwegc_yxexport($n, $y, $x, $gclust, $sbytes);
  }

  method ncplane_putwegcexport (
    ncplane $n,
    wchar_t $gclust,
    size_t  $sbytes
  ) {
    ncplane_putwegcexport($n, $gclust, $sbytes);
  }

  method ncplane_putwstr_alignedexport (
    ncplane   $n,
    gint      $y,
    ncalign_e $align,
    wchar_t   $gclustarr
  ) {
    ncplane_putwstr_alignedexport($n, $y, $align, $gclustarr);
  }

  method ncplane_putwstr_yxexport (
    ncplane $n,
    gint    $y,
    gint    $x,
    wchar_t $gclustarr
  ) {
    ncplane_putwstr_yxexport($n, $y, $x, $gclustarr);
  }

  method ncplane_putwstrexport (
    ncplane $n,
    wchar_t $gclustarr
  ) {
    ncplane_putwstrexport($n, $gclustarr);
  }

  method ncplane_resize_simpleexport (ncplane $n) {
    ncplane_resize_simpleexport($n);
  }

  method ncplane_rounded_box_sizedexport (
    ncplane  $n,
    uint16_t $styles,
    uint64_t $channels
  ) {
    ncplane_rounded_box_sizedexport($n, $styles, $channels);
  }

  method ncplane_rounded_boxexport (
    ncplane  $n,
    uint16_t $styles,
    uint64_t $channels
  ) {
    ncplane_rounded_boxexport($n, $styles, $channels);
  }

  method ncplane_valignexport (
    ncplane   $n,
    ncalign_e $align,
    gint      $r
  ) {
    ncplane_valignexport($n, $align, $r);
  }

  method ncplane_vlineexport (
    ncplane $n,
    nccell  $c
  ) {
    ncplane_vlineexport($n, $c);
  }

  method ncplane_vprintfexport (
    ncplane $n,
    Str     $format,
    va_list $ap
  ) {
    ncplane_vprintfexport($n, $format, $ap);
  }

  method ncqprefixexport (
    uintmax_t $val,
    uintmax_t $decimal,
    Str       $buf,
    gint      $omitdec
  ) {
    ncqprefixexport($val, $decimal, $buf, $omitdec);
  }

  method nctabbed_hdrchanexport (nctabbed $nt) {
    nctabbed_hdrchanexport($nt);
  }

  method nctabbed_selchanexport (nctabbed $nt) {
    nctabbed_selchanexport($nt);
  }

  method nctabbed_sepchanexport (nctabbed $nt) {
    nctabbed_sepchanexport($nt);
  }

  method ncvisualplane_createexport (
    notcurses        $nc,
    ncplane_options  $opts,
    ncvisual         $ncv,
    ncvisual_options $vopts
  ) {
    ncvisualplane_createexport($nc, $opts, $ncv, $vopts);
  }

  method ncwcsrtombsexport (wchar_t $src) {
    ncwcsrtombsexport($src);
  }

  method notcurses_alignexport (
    gint      $availu,
    ncalign_e $align,
    gint      $u
  ) {
    notcurses_alignexport($availu, $align, $u);
  }

  method notcurses_bottomexport (notcurses $n) {
    notcurses_bottomexport($n);
  }

  method notcurses_canbrailleexport (notcurses $nc) {
    notcurses_canbrailleexport($nc);
  }

  method notcurses_canchangecolorexport (notcurses $nc) {
    notcurses_canchangecolorexport($nc);
  }

  method notcurses_canfadeexport (notcurses $n) {
    notcurses_canfadeexport($n);
  }

  method notcurses_canhalfblockexport (notcurses $nc) {
    notcurses_canhalfblockexport($nc);
  }

  method notcurses_canpixelexport (notcurses $nc) {
    notcurses_canpixelexport($nc);
  }

  method notcurses_canquadrantexport (notcurses $nc) {
    notcurses_canquadrantexport($nc);
  }

  method notcurses_cansextantexport (notcurses $nc) {
    notcurses_cansextantexport($nc);
  }

  method notcurses_cantruecolorexport (notcurses $nc) {
    notcurses_cantruecolorexport($nc);
  }

  method notcurses_canutf8export (notcurses $nc) {
    notcurses_canutf8export($nc);
  }

  method notcurses_get_blockingexport (
    notcurses $n,
    ncinput   $ni
  ) {
    notcurses_get_blockingexport($n, $ni);
  }

  method notcurses_get_nblockexport (
    notcurses $n,
    ncinput   $ni
  ) {
    notcurses_get_nblockexport($n, $ni);
  }

  method notcurses_mice_disableexport (notcurses $n) {
    notcurses_mice_disableexport($n);
  }

  method notcurses_renderexport (notcurses $nc) {
    notcurses_renderexport($nc);
  }

  method notcurses_stddim_yx_constexport (
    notcurses $nc,
    gint      $y is rw,
    gint      $x is rw
  ) {
    notcurses_stddim_yx_constexport($nc, $y, $x);
  }

  method notcurses_stddim_yxexport (
    notcurses $nc,
    gint      $y is rw,
    gint      $x is rw
  ) {
    notcurses_stddim_yxexport($nc, $y, $x);
  }

  method notcurses_term_dim_yxexport (
    notcurses $n,
    gint      $rows is rw,
    gint      $cols is rw
  ) {
    notcurses_term_dim_yxexport($n, $rows, $cols);
  }

  method notcurses_topexport (notcurses $n) {
    notcurses_topexport($n);
  }
