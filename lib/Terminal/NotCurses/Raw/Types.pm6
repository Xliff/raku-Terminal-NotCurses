use v6.c;

use Proto::Exports;
use Terminal::NotCurses::Raw::Exports;

my constant forced = 0;

unit package Terminal::NotCurses::Raw::Types;

need Proto::Debug;
need Proto::Exceptions;
need Proto::Subs;
need Terminal::NotCurses::Raw::Definitions;
need Terminal::NotCurses::Raw::Enums;
need Terminal::NotCurses::Raw::Structs;
need Terminal::NotCurses::Raw::Subs;

BEGIN {
  proto-re-export($_) for |@proto-exports, |@notcurses-exports;
}
