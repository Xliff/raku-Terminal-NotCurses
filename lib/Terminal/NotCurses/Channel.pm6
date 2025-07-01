use v6;

use NativeCall;
use Method::Also;

use Terminal::NotCurses::Raw::Types;
use Terminal::NotCurses::Raw::Channel;

use Proto::Roles::Implementor;

class Terminal::NotCurses::Channel {
  also does Proto::Roles::Implementor;

  has CArray[uint32] $!c is implementor;

  submethod BUILD ( :channel(:$c ) ) {
    given $c {
      when CArray[uint32] { $!c = $_;           }

      $!c = CArray[uint32].allocate(1);

      when .^can('Int')   { $_ .= Int; proceed; }
      when Num            { $_ .= Int; proceed  }
      when Int | uint32   { $!c[0] = $_         }

      default {
        X::Proto::InvalidType.new(
          message =>
            "A channel must be given uint32-compatible value on creation, {
              ''}not a { .^name }"
        ).throw;
      }

    }
  }

  method Int { $!c[0] }

  method Terminal::NotCurses::Raw::Definitions::ncchannel {
    $!c
  }

  multi method new {
    self.new(0);
  }
  multi method new (Int() $c) {
    return Nil unless $c.defined;

    self.bless( :$c )
  }
  multi method new (Int() $r, Int() $g, Int() $b) {
    my $o = self.new;
    $o.set_rgb8($r, $g, $b);
    $o;
  }

  multi method a ( :$shift = False )  is rw {
    return 0 unless ncchannel_alpha( $!c[0] );

    Proxy.new:
      FETCH => -> $ {
        my $a = ncchannel_alpha( $!c[0] );

        $a +> ( $shift ?? NCALPHA_SHIFT !! 0 )
      },

      STORE => -> $, \v {
        my uint32         $vv =
          (v +< ( $shift ?? NCALPHA_SHIFT !! 0 )) +& NC_BG_ALPHA_MASK;

        ncchannel_set_alpha($!c, $vv);
        self
      }
  }

  method default
    is also<
      is-default
      is_default
    >
  {
    ncchannel_default_p ( $!c[0] )
  }

  method palindex is rw {
    return Nil unless ncchannel_palindex_p( $!c[0] );

    Proxy.new:
      FETCH => -> $ {
        ncchannel_palindex( $!c[0] );
      },

      STORE => -> $, \v {
        my uint32 $vv = v;

        ncchannel_set_palindex($!c, $vv);
      };
  }

  multi method rgb8 ( :$all = True ) {
    samewith($, $, $, :$all);
  }
  multi method rgb8 ( $r is rw, $g is rw, $b is rw, :$all = True) {
    my uint32 ($rr, $gg, $bb) = 0 xx 3;

    my $c = ncchannel_rgb8($!c[0], $rr, $gg, $bb);
    my @r = ($c, $r = $rr, $g = $gg, $g = $bb);
    return @r if $all;
    @r.skip(1);
  }

  method rgb is rw {
    return Nil unless $.is-rgb8;

    Proxy.new:
      FETCH => -> $     { ($.r, $.g, $.b)   },
      STORE => -> $, $v { $.set_rgb8( |$v ) };
  }

  method b is rw {
    Proxy.new:
      FETCH => -> $      { ncchannel_b( $!c[0] )  },
      STORE => -> $, \v  { ::?CLASS.set_b($!c, v) }
  }

  method g is rw {
    Proxy.new:
      FETCH => -> $           { ncchannel_g( $!c[0] )  },
      STORE => -> $, Int() $v { ::?CLASS.set_g($!c, $v) }
  }

  method r is rw {
    Proxy.new:
      FETCH => -> $           { ncchannel_r( $!c[0] )  },
      STORE => -> $, Int() $v { ::?CLASS.set_r($!c, $v) }
  }

  method b-offset {
    Proxy.new:
      FETCH => -> $           { ncchannel_b( $!c[0] )        },
      STORE => -> $, Int() $v { ::?CLASS.set_b($!c, $.r + $v) }
  }

  method g-offset {
    Proxy.new:
      FETCH => -> $           { ncchannel_g( $!c[0] )        },
      STORE => -> $, Int() $v { ::?CLASS.set_g($!c, $.g + $v) }
  }

  method r-offset {
    Proxy.new:
      FETCH => -> $           { ncchannel_r( $!c[0] )              },
      STORE => -> $, Int() $v { ::?CLASS.set_r($!c, $.r + $v); self }
  }

  method set_default {
    ncchannel_set_default($!c);
  }

  method set_palindex (Int() $vv) {
    my uint32 $v = $vv;

    ncchannel_set_palindex($!c, $v);
    self
  }

  method set_r (Int() $vv) {
    my uint32 $v = $vv;

    ncchannel_set_rgb8_clipped($!c, $v, $.g, $.b);
    self
  }

  method set_g (Int() $vv) {
    my uint32 $v = $vv;

    ncchannel_set_rgb8_clipped($!c, $.r, $v, $.b);
    self;
  }

  method set_b (Int() $vv) {
    my uint32 $v = $vv;

    ncchannel_set_rgb8_clipped($!c, $.r, $.g, $vv);
    self
  }

  method set_rgb8 (Int() $r, Int() $g, Int() $b) {
    my int32 ($rr, $gg, $bb) = ($r, $g, $b);

    ncchannel_set_rgb8_clipped($!c, $rr, $gg, $bb);
    self;
  }

}

sub EXPORT ( $channel-name? ) {
  do if $channel-name {
    %(
      "{ $channel-name }" => Terminal::NotCurses::Channel
    ).Map;
  } else {
    %().Map;
  }
}
