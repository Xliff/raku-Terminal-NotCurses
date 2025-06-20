use v6;

use Terminal::NotCurses::Raw::Channel;

role Terminal::NotCurses::Roles::Channel {

  X::Proto::InvalidType.new(
    message => 'Terminal::Notcurses::Roles::Channel is only for Ints!'
  ).throw unless self ~~

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
        $s[0] but ::?ROLE;
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
        $s[0] but ::?ROLE;
      };
  }

  method b is rw {
    Proxy.new:
      FETCH => -> $      { ncchannel_b(self)       but ::?ROLE },
      STORE => -> $, \v  { ::?CLASS.set_b(self, v) but ::?ROLE }
  }

  method g is rw {
    Proxy.new:
      FETCH => -> $      { ncchannel_g(self)       but ::?ROLE },
      STORE => -> $, \v  { ::?CLASS.set_g(self, v) but ::?ROLE }
  }

  method r is rw {
    Proxy.new:
      FETCH => -> $      { ncchannel_r(self)       but ::?ROLE },
      STORE => -> $, \v  { ::?CLASS.set_r(self, v) but ::?ROLE }
  }

  method b-offset {
    Proxy.new:
      FETCH => -> $      { ncchannel_b(self)             but ::?ROLE },
      STORE => -> $, \v  { ::?CLASS.set_b(self, $.r + v) but ::?ROLE }
  }

  method g-offset {
    Proxy.new:
      FETCH => -> $      { ncchannel_g(self)             but ::?ROLE },
      STORE => -> $, \v  { ::?CLASS.set_g(self, $.g + v) but ::?ROLE }
  }

  method r-offset {
    Proxy.new:
      FETCH => -> $      { ncchannel_r(self)             but ::?ROLE },
      STORE => -> $, \v  { ::?CLASS.set_r(self, $.r + v) but ::?ROLE }
  }

  method rgb8 {
    ncchannel_rgb8(self) but ::?ROLE;
  }

  method default {
    Proxy.new:but ::?ROLE;
      FETCH => $ {
        my uint32 $s = self;

        ncchannel_default_p($s) but Terminal::Roles::NotCurses::Channel;
      },

      STORE => $, \v {
        my CArray[uint32] $s  = self;
        my uint32         $vv = v;

        ncchannel_set_default($s, $vv);
        $s[0] but ::?ROLE;
      }
  }

  method set_palindex (Int() $s, Int() $vv) is static {
    my uint32 $v = $vv;

    my $ca = newCArray(uint32, first => $s);

    nchannel_set_palindex($ca, $v);
    $s[0] but ::?ROLE;
  }

  method set_r (Int() $s, Int() $vv) is static {
    my uint32 $v = $vv;

    my $ca = newCArray(uint32, first => self);

    nchannel_set_rgb8_clipped($s, $v, $s.g, $s.b);
    $s[0]
  }

  method set_g (Int() $s, Int() $vv) is static {
    my uint32 $v = $vv;

    my $ca = newCArray(uint32, first => $s);

    nchannel_set_rgb8_clipped($s, $s.r, $v, $s.b);
    $s[0]
  }

  method set_b (Int() $s, Int() $vv) is static {
    my uint32 $v = $vv;

    my $ca = newCArray(uint32, first => $s);

    nchannel_set_rgb8_clipped($s, $s.r, $s.g, $vv);
    $s[0]
  }

  method set_rgb8 (Int() $s, Int() $r, Int() $g, Int() $b) is static {
    my uint32 ($rr, $gg, $bb) = ($r, $g, $b);

    my $ca = newCArray(uint32, first => $s);

    nchannel_set_rgb8_clipped($s, $rr, $gg, $bb);
    $s[0]
  }

}

class Terminal::NotCurses::Channel {
  does Terminal::NotCurses::Roles::Channel;

  method new (Int() $v) {
    $v but Terminal::NotCurses::Roles::Channel;
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
