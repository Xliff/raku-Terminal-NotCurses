use v6.c;

use NativeCall;

use Terminal::NotCurses::Raw::Definitions;
use Terminal::NotCurses::Raw::Enums;
use Terminal::NotCurses::Raw::Structs;

unit package Terminal::NotCurses::Raw::Input;

sub ncinput_alt_p (ncinput $n)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncinput_alt_p_export')
{ * }

sub ncinput_capslock_p (ncinput $n)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncinput_capslock_p_export')
{ * }

sub ncinput_ctrl_p (ncinput $n)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncinput_ctrl_p_export')
{ * }

sub ncinput_equal_p (
  ncinput $n1,
  ncinput $n2
)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncinput_equal_p_export')
{ * }

sub ncinput_hyper_p (ncinput $n)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncinput_hyper_p_export')
{ * }

sub ncinput_meta_p (ncinput $n)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncinput_meta_p_export')
{ * }

sub ncinput_nomod_p (ncinput $ni)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncinput_nomod_p_export')
{ * }

sub ncinput_numlock_p (ncinput $n)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncinput_numlock_p_export')
{ * }

sub ncinput_shift_p (ncinput $n)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncinput_shift_p_export')
{ * }

sub ncinput_super_p (ncinput $n)
  returns bool
  is      native(notcurses-export)
  is      export
  is      symbol('ncinput_super_p_export')
{ * }
