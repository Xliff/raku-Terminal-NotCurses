use v6;

use NativeCall;

use Terminal::NotCurses::Raw::Types;
use Terminal::NotCurses::Raw::Channels;

use Terminal::NotCurses::Channel;

use Proto::Roles::Implementor;

class Terminal::NotCurses::Channels {
  also does Proto::Roles::Implementor;

  has CArray[uint64] $!cc is implementor;

  submethod BUILD ( :$cc is copy, :$fg, :$bg ) {
    if $fg || $bg {
      my $CC = CArray[uint32].allocate(2);
      $CC[0] = $fg // 0;
      $CC[1] = $bg // 0;
      $!cc = cast(CArray[uint64], $_);
    } else {
      return unless $cc.defined;

      do given $cc {
        when .^can('Int')   { $_ .= Int; proceed }
        when Num            { $_ .= Int; proceed }

        when Int            {
          my $CC = $_;
          $_ = CArray[uint64].allocate(1);
          .[0] = $CC;
          $!cc = $_;
        }

        when CArray[uint32] { $!cc = cast(CArray[uint64], $cc) }
        when CArray[uint64] { $!cc = $_                        }

        default {
          X::Proto::InvalidType.new(
            message =>
              "Channels must be a uint64-compatible value on creation, {
                ''}not a { .^name }"
          ).throw;
        }
      }
    }

  }

  method Int {
    $!cc[0]
  }

  method Terminal::NotCurses::Raw::Definitions::ncchannels
  { $!cc }

  multi method new {
    self.new(0);
  }
  multi method new (
    Terminal::NotCurses::Channel $fg,
    Terminal::NotCurses::Channel $bg
  ) {
    self.bless( :$fg, :$bg );
  }
  multi method new (Int() $channels) {
    self.bless( cc => $channels );
  }

  method bchannel {
    Terminal::NotCurses::Channel.new( ncchannels_bchannel( $!cc[0] ) );
  }

  method bg_alpha {
    ncchannels_bg_alpha( $!cc[0] );
  }

  method bg_default_p {
    ncchannels_bg_default_p( $!cc[0] );
  }

  method bg_palindex is rw {
    Proxy.new:
      FETCH => -> $ { ncchannels_bg_palindex_p( $!cc[0] ) },
      STORE => -> $, \v { $.set_bg_palindex(v); v       }
  }

  method bg_rgb8 ($r is rw, $g is rw, $b is rw, :$raw = False) {
    my int32 ($rr, $gg, $bb) = 0 xx 3;

    ncchannels_bg_rgb8($!cc[0], $rr, $gg, $bb);
    ($r = $rr, $g = $gg, $b = $bb);
  }

  method bg_rgb_p {
    ncchannels_bg_rgb_p( $!cc[0] );
  }

  method bg_rgb {
    ncchannels_bg_rgb( $!cc[0] );
  }

  method channels {
    ncchannels_channels( $!cc[0] );
  }

  method combine (Int() $fchan, Int() $bchan) {
    my uint32 ($f, $b) = ($fchan, $bchan);

    ::?CLASS.new( ncchannels_combine($f, $b) );
  }

  method fchannel {
    Terminal::NotCurses::Channel.new( ncchannels_fchannel( $!cc[0] ) );
  }

  method fg_alpha {
    ncchannels_fg_alpha( $!cc[0] );
  }

  method fg_default_p {
    ncchannels_fg_default_p( $!cc[0] );
  }

  method fg_palindex_p {
    ncchannels_fg_palindex_p( $!cc[0] );
  }

  method fg_palindex is rw {
    Proxy.new:
      FETCH => -> $     { ncchannels_fg_palindex_p( $!cc[0] ) },
      STORE => -> $, \v { $.set_fg_palindex(v); v       }
  }

  method fg_rgb8 ($r is rw, $g is rw, $b is rw, :$raw = False) {
    my int32 ($rr, $gg, $bb) = 0 xx 3;

    ncchannels_fg_rgb8($!cc[0], $rr, $gg, $bb);
    my @rgb = ($r = $rr, $g = $gg, $b = $bb);
    return @rgb if $raw;
    self;
  }

  method fg_rgb_p {
    ncchannels_fg_rgb_p( $!cc[0] );
  }

  method fg_rgb {
    ncchannels_fg_rgb( $!cc[0] );
    self;
  }

  method reverse {
    ::?CLASS.new( ncchannels_reverse( $!cc[0] ) );
  }

  method set_bchannel (Int() $channel) {
    my uint32 $c = $channel;

    ncchannels_set_bchannel($!cc, $c);
    self;
  }

  method set_bg_alpha (Int() $v) {
    my uint32 $vv = $v;

    ncchannels_set_bg_alpha($!cc, $v);
    self;
  }

  method set_bg_default {
    ncchannels_set_bg_default($!cc);
    self;
  }

  method set_bg_palindex (Int() $v) {
    my uint32 $vv = $v;

    ncchannels_set_bg_palindex($!cc, $vv);
    self;
  }

  method set_bg_rgb8_clipped (Int() $r, Int() $g, Int() $b) {
    my int32 ($rr, $gg, $bb) = ($r, $g, $b);

    ncchannels_set_bg_rgb8_clipped($!cc, $rr, $gg, $bb);
    self;
  }

  method set_bg_rgb8 {
    ncchannels_set_bg_rgb8($!cc);
    self;
  }

  method set_bg_rgb {
    ncchannels_set_bg_rgb($!cc);
    self;
  }

  method set_channels (Int() $channels) {
    my uint64 $c = $channels;

    ncchannels_set_channels($!cc, $c);
    self;
  }

  method set_fchannel (Int() $channel) {
    my uint32 $c = $channel;

    ncchannels_set_fchannel($!cc, $c);
    self;
  }

  method set_fg_alpha (Int() $v) {
    my uint32 $vv = $v;

    ncchannels_set_fg_alpha($!cc, $v);
    self;
  }

  method set_fg_default {
    ncchannels_set_fg_default($!cc);
    self;
  }

  method set_fg_palindex (Int() $v) {
    my uint32 $vv = $v;

    ncchannels_set_fg_palindex($!cc, $v);
    self;
  }

  method set_fg_rgb8_clipped (Int() $r, Int() $g, Int() $b) {
    my int32 ($rr, $gg, $bb) = ($r, $g, $b);

    ncchannels_set_fg_rgb8_clipped($!cc, $rr, $gg, $bb);
    self;
  }

  method set_fg_rgb8 {
    ncchannels_set_fg_rgb8($!cc);
    self;
  }

  method set_fg_rgb {
    ncchannels_set_fg_rgb($!cc);
    self;
  }

}
