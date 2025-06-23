use v6.c;

use NativeCall;

use Terminal::NotCurses::Raw::Definitions;
use Terminal::NotCurses::Raw::Enums;
use Terminal::NotCurses::Raw::Structs;

unit package Terminal::NotCurses::Raw::Menu;

sub ncmenu_create (ncplane $n, ncmenu_options $opts)
  returns ncmenu
  is      native(&notcurses)
  is      export
{ * }

sub ncmenu_destroy (ncmenu $n)
  is      native(&notcurses)
  is      export
{ * }

sub ncmenu_item_set_status (
  ncmenu $n,
  Str    $section,
  Str    $item,
  bool   $enabled
)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncmenu_mouse_selected (ncmenu $n, ncinput $click, ncinput $ni)
  returns Str
  is      native(&notcurses)
  is      export
{ * }

sub ncmenu_nextitem (ncmenu $n)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncmenu_nextsection (ncmenu $n)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncmenu_offer_input (ncmenu $n, ncinput $nc)
  returns bool
  is      native(&notcurses)
  is      export
{ * }

sub ncmenu_plane (ncmenu $n)
  returns ncplane
  is      native(&notcurses)
  is      export
{ * }

sub ncmenu_previtem (ncmenu $n)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncmenu_prevsection (ncmenu $n)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncmenu_rollup (ncmenu $n)
  returns int32
  is      native(&notcurses)
  is      export
{ * }

sub ncmenu_selected (ncmenu $n, ncinput $ni)
  returns Str
  is      native(&notcurses)
  is      export
{ * }

sub ncmenu_unroll (ncmenu $n, int32 $sectionidx)
  returns int32
  is      native(&notcurses)
  is      export
{ * }
