use v6.c;

use Terminal::NotCurses::Raw::Types;
use Terminal::NotCurses::Raw::Menu;

class Terminal::NotCurses::Menu {
  has ncmenu $!m;

  multi method new (ncmenu $menu) {
    $menu ?? self.bless( :$menu ) !! Nil;
  }
  multi method new ($!m, $opts) {
    self.create($!m, $opts);
  }

  method create (ncplane() $n, ncmenu_options() $opts) {
    my $menu = ncmenu_create($!m, $opts);

    $menu ?? self.bless( :$menu ) !! Nil;
  }

  method destroy {
    ncmenu_destroy($!m);
  }

  method item_set_status (Str() $section, Str() $item, Int() $enabled) {
    my int32 $e = $enabled;

    ncmenu_item_set_status($!m, $section, $item, $enabled);
  }

  method mouse_selected (ncinput() $click, ncinput() $ni) {
    ncmenu_mouse_selected($!m, $click, $ni);
  }

  method nextitem {
    ncmenu_nextitem($!m);
  }

  method nextsection {
    ncmenu_nextsection($!m);
  }

  method offer_input (ncinput() $nc) {
    ncmenu_offer_input($!m, $nc);
  }

  method plane ( :$raw = False ) {
    propReturnObject(
      ncmenu_plane($!m),
      :$raw,
      |Terminal::NotCurses::Menu.getTypePair
    );
  }

  method previtem {
    ncmenu_previtem($!m);
  }

  method prevsection {
    ncmenu_prevsection($!m);
  }

  method rollup {
    ncmenu_rollup($!m);
  }

  method selected (ncinput() $ni) {
    ncmenu_selected($!m, $ni);
  }

  method unroll (Int() $sectionidx) {
    my int32 $s = $sectionidx;

    ncmenu_unroll($!m, $s);
  }

}
