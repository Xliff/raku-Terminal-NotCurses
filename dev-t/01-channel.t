use v6;

use Test;

use Terminal::NotCurses::Raw::Types;

use Terminal::NotCurses::Channel;
use Terminal::NotCurses::Channels;
use Terminal::NotCurses::Main;

my $nc = Terminal::NotCurses::Main.init;
my $n  = Terminal::NotCurses::Main.stdplane;

subtest {
  my @get-rgb = (
    { channel => 0x000000, r => 0x00, g => 0x00, b => 0x00 },
    { channel => 0x808080, r => 0x80, g => 0x80, b => 0x80 },
    { channel => 0x080808, r => 0x08, g => 0x08, b => 0x08 },
    { channel => 0xffffff, r => 0xff, g => 0xff, b => 0xff }
  );

  for @get-rgb {
    my $c = Terminal::NotCurses::Channel.new( .<channel> );

    ok $c.r == .<r>, "Channel red   is { .<r> }";
    ok $c.g == .<g>, "Channel green is { .<g> }";
    ok $c.b == .<b>, "Channel blue  is { .<b> }";

    my $cc    = $c.rgb8( :all );
    $cc.shift;

    ok [&&](
      $cc[0] == .<r>,
      $cc[1] == .<g>,
      $cc[2] == .<b>
    ), "Channel RGB is correct"
  }
}, 'RGB';

subtest {
  for [ 0x00000000, NCALPHA_OPAQUE       ],
      [ 0x10808080, NCALPHA_BLEND        ],
      [ 0x20080808, NCALPHA_TRANSPARENT  ],
      [ 0xe0080808, NCALPHA_TRANSPARENT  ],
      [ 0x3fffffff, NCALPHA_HIGHCONTRAST ],
      [ 0xffffffff, NCALPHA_HIGHCONTRAST ]
  {
    my $c = Terminal::NotCurses::Channel.new( .head );

    ok $c.a == .tail, "Channel alpha is { .tail }";
  }
}, 'Alpha';

subtest {
  for [ 0x00000000, True  ],
      [ 0x0fffffff, True  ],
      [ 0xbfffffff, True  ],
      [ 0x40000000, False ],
      [ 0x40080808, False ],
      [ 0xffffffff, False ]
  {
    my $c = Terminal::NotCurses::Channel.new( .head );

    ok $c.is-default == .tail, "Channel default status is { .Str }";
  }
}, 'Get Default';

subtest {
  for
    0x40000000, 0x4fffffff, 0xcfffffff, 0x40808080,
    0x40080808, 0xffffffff
  {
    my $c = Terminal::NotCurses::Channel.new($_);

    nok $c.is-default, "Channel is not set to default color";
    $c.set-default;
    ok  $c.is-default, "Channel is now set to default color";
  }
}, 'Set Default';

subtest {
  skip 'Blend not supported';
}, 'Blend 0';

subtest {
  skip 'Blend not supported';
}, 'Blend 1';

subtest {
  skip 'Blend not supported';
}, 'Blend 2';

subtest {
  skip 'Blend not supported';
}, 'Blend Default Left';

subtest {
  my $c = Terminal::NotCurses::Channels.new;

  nok $c.reverse.Int,                     'Reversing blank channels results in blank channels';
  $c.fg_palindex = 8;
  my $r = $c.reverse;
  ok $r.bg_palindex == 8,                 'Background palette index of reversed channels is 8';
  ok $r.fg_palindex == 0,                 'Foreground palette index of reversed channels is 0';
  $r = $r.set_fg_palindex(63).reverse;
  ok $r.fg_palindex == 8,                 'Foregrpund palette index is now 8';
  ok $r.bg_palindex == 63,                'Background palette index is now 63';
  $r = $r.set_fg_default.set_bg_alpha(NCALPHA_TRANSPARENT).reverse;
  ok $r.fg_palindex == 63,                'Foreground palette index is now 63';
  ok $r.bg_alpha == NC_ALPHA_TRANSPARENT, 'Background alpha is NC_ALPHA_TRANSPARENT';
  ok ($r = $r.set_bg_default),            'Background set to default';
  ok $r.bg_alpha == NCALPHA_OPAQUE,       'Background is opaque';
  $r = $r.set_fg_rgb(0x2288cc).reverse;
  ok $r.bg_rgb.Int == 0x2288cc,           'Background RGB is the proper value';
  ok $r.fg_is_default,                    'Foreground is default color';
}, 'Reverse';
