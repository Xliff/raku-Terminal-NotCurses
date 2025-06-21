use v6;

use Terminal::NotCurses::Raw::Channel;

class Terminal::NotCurses::Channel {
  has CArray[uint32] $!c;

  submethod BUILD ( :channel(:$c ) {
    given $c {
      when CArray[uint32] { $!c = $_;           }

      $!c = CArray[uint32].allocate(1);

      when .^can('Int')   { $_ .= Int; proceed; }
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

  multi method a ( :$shift = True )  is rw {
    return Nil unless ncchannel_a_p(self);

    Proxy.new:
      FETCH => -> $ {
        my uint32 $s = self;

        ncchannel_a($s) +> ( $s ?? NCALPHA_SHIFT !! 0 ) but ::?ROLE;
      },

      STORE => -> $, \v {
        my CArray[uint32]Terminal::Roles::NotCurses::Channel; $s  = self;
        my uint32         $vv =
          (v +< ( $shift ?? NCALPHA_SHIFT !! 0 )) +& NC_BG_ALPHA_MASH);

        ncchannel_set_a($s, $vv);
        self
      }
  }

  method palindex is rw {
    return Nil unless ncchannel_palindex_p(self);

    Proxy.new:
      FETCH => $ {
        my uint32 $s = self;
        ncchannel_palindex($s) but ::?ROLE;
      },
      STORE => $, \v {
        my CArray[uint32] $s  = self;
        my uint32         $vv = v;

        ncchannel_set_palindex($s, $vv)
        self
      };
  }

  method b is rw {
    Proxy.new:
      FETCH => -> $      { ncchannel_b(self)       },
      STORE => -> $, \v  { ::?CLASS.set_b(self, v) }
  }

  method g is rw {
    Proxy.new:
      FETCH => -> $      { ncchannel_g(self)       },
      STORE => -> $, \v  { ::?CLASS.set_g(self, v) }
  }

  method r is rw {
    Proxy.new:
      FETCH => -> $      { ncchannel_r(self)       },
      STORE => -> $, \v  { ::?CLASS.set_r(self, v) }
  }

  method b-offset {
    Proxy.new:
      FETCH => -> $      { ncchannel_b(self)             },
      STORE => -> $, \v  { ::?CLASS.set_b(self, $.r + v) }
  }

  method g-offset {
    Proxy.new:
      FETCH => -> $      { ncchannel_g(self)             },
      STORE => -> $, \v  { ::?CLASS.set_g(self, $.g + v) }
  }

  method r-offset {
    Proxy.new:
      FETCH => -> $      { ncchannel_r(self)              },
      STORE => -> $, \v  { ::?CLASS.set_r(self, $.r + v)  }
  }

  method rgb8 {
    ncchannel_rgb8(self);
  }

  method default {
    Proxy.new:but ::?ROLE;
      FETCH => $ {
        my uint32 $s = self;

        ncchannel_default_p($s);
      },

      STORE => $, \v {
        my CArray[uint32] $s  = self;
        my uint32         $vv = v;

        ncchannel_set_default($s, $vv);
      }
  }

  method set_palindex (Int() $s, Int() $vv) is static {
    my uint32 $v = $vv;

    my $ca = newCArray(uint32, first => $s);

    nchannel_set_palindex($ca, $v);
    self
  }

  method set_r (Int() $s, Int() $vv) is static {
    my uint32 $v = $vv;

    my $ca = newCArray(uint32, first => self);

    nchannel_set_rgb8_clipped($s, $v, $s.g, $s.b);
    self
  }

  method set_g (Int() $s, Int() $vv) is static {
    my uint32 $v = $vv;

    my $ca = newCArray(uint32, first => $s);

    nchannel_set_rgb8_clipped($s, $s.r, $v, $s.b);
    self;
  }

  method set_b (Int() $s, Int() $vv) is static {
    my uint32 $v = $vv;

    my $ca = newCArray(uint32, first => $s);

    nchannel_set_rgb8_clipped($s, $s.r, $s.g, $vv);
    self
  }

  method set_rgb8 (Int() $s, Int() $r, Int() $g, Int() $b) is static {
    my uint32 ($rr, $gg, $bb) = ($r, $g, $b);

    my $ca = newCArray(uint32, first => $s);

    nchannel_set_rgb8_clipped($s, $rr, $gg, $bb);
    self;
  }

}

sub EXPORT ( $channel-name? ) {
  do if $channel-name {
    %(
      "{ $channel-name }" => Terminal::NotCurses::Channel
    ).Map;
  } else
    %().Map;
  }
}
