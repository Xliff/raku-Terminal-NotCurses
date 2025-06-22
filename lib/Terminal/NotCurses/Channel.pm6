use v6;

use Terminal::NotCurses::Raw::Channel;

class Terminal::NotCurses::Channel {
  has CArray[uint32] $!c;

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

  method new (Int() $c) {
    return Nil unless $c.defined;

    self.bless( :$c )
  }

  method new (Int() $r, Int() $g, Int() $b) {
    my uint32 $c = 0;

    my $o = self.bless( :$c );
    $o.rgb8($r, $g, $b);
  }

  multi method a ( :$shift = True )  is rw {
    return Nil unless ncchannel_a_p(self);

    Proxy.new:
      FETCH => -> $ {
        my uint32 $s = self;

        ncchannel_a( $!c[0] ) +> ( $s ?? NCALPHA_SHIFT !! 0 )
      },

      STORE => -> $, \v {
        my CArray[uint32]Terminal::Roles::NotCurses::Channel; $s  = self;
        my uint32         $vv =
          (v +< ( $shift ?? NCALPHA_SHIFT !! 0 )) +& NC_BG_ALPHA_MASH);

        ncchannel_set_a($!c, $vv);
        self
      }
  }

  method palindex is rw {
    return Nil unless ncchannel_palindex_p(self);

    Proxy.new:
      FETCH => -> $ {
        my uint32 $s = self;

        ncchannel_palindex( $!c[0] );
      },

      STORE => -> $, \v {
        my CArray[uint32] $s  = self;
        my uint32         $vv = v;

        ncchannel_set_palindex($!c, $vv);
      };
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
      FETCH => -> $        { ncchannel_g( $!c[0] )  },
      STORE => -> $, Int() { ::?CLASS.set_g($!c, v) }
  }

  method r is rw {
    Proxy.new:
      FETCH => -> $           { ncchannel_r( $!c[0] )  },
      STORE => -> $, Int() $v { ::?CLASS.set_r($!c, v) }
  }

  method b-offset {
    Proxy.new:
      FETCH => -> $           { ncchannel_b( $!c[0] )        },
      STORE => -> $, Int() $v { ::?CLASS.set_b($!c, $.r + v) }
  }

  method g-offset {
    Proxy.new:
      FETCH => -> $           { ncchannel_g( $!c[0] )        },
      STORE => -> $, Int() $v { ::?CLASS.set_g($!c, $.g + v) }
  }

  method r-offset {
    Proxy.new:
      FETCH => -> $           { ncchannel_r( $!c[0] )              },
      STORE => -> $, Int() $v { ::?CLASS.set_r($!c, $.r + v); self }
  }

  method rgb8 {
    ncchannel_rgb8(self);
  }

  method default {
    Proxy.new:
      FETCH => $ {
        ncchannel_default_p( $!c[0] );
      },

      STORE => $, Int() $v {
        my uint32 $vv = v;

        ncchannel_set_default($!c, $vv);
      }
  }

  method set_palindex (Int() $vv) {
    my uint32 $v = $vv;

    nchannel_set_palindex($!c, $v);
    self
  }

  method set_r (Int() $vv) {
    my uint32 $v = $vv;

    my $ca = newCArray(uint32, first => self);

    nchannel_set_rgb8_clipped($!c, $v, $s.g, $s.b);
    self
  }

  method set_g (Int() $vv) {
    my uint32 $v = $vv;

    my $ca = newCArray(uint32, first => $s);

    nchannel_set_rgb8_clipped($!c, $s.r, $v, $s.b);
    self;
  }

  method set_b (Int() $vv) {
    my uint32 $v = $vv;

    my $ca = newCArray(uint32, first => $s);

    nchannel_set_rgb8_clipped($!c, $s.r, $s.g, $vv);
    self
  }

  method set_rgb8 (Int() $r, Int() $g, Int() $b) {
    my uint32 ($rr, $gg, $bb) = ($r, $g, $b);

    my $ca = newCArray(uint32, first => $s);

    nchannel_set_rgb8_clipped($!c, $rr, $gg, $bb);
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
