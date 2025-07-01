use v6;

use Method::Also;

use Terminal::NotCurses::Raw::Types;
use Terminal::NotCurses::Raw::Input;

use Proto::Roles::Implementor;

class Terminal::NotCurses::Input {
  also does Proto::Roles::Implementor;

  has ncinput $!i is implementor;

  submethod BUILD ( :$input ) {
    $!i = $input if $input;
  }

  method Terminal::NotCurses::Raw::Definitions::ncinput
    is also<ncinput>
  { $!i }

  multi method new (ncinput $input) {
    $input ?? self.bless( :$input ) !! Nil;
  }
  multi method new {
    self.create;
  }

  method create {
    my $input = ncinput_create;

    $input ?? self.bless( :$input ) !! Nil;
  }

  method alt_p is also<alt> {
    ncinput_alt_p($!i);
  }

  method capslock_p is also<capslock> {
    ncinput_capslock_p($!i);
  }

  method ctrl_p is also<ctrl> {
    ncinput_ctrl_p($!i);
  }

  method equal_p (ncinput() $i2) is also<equal> {
    ncinput_equal_p($!i, $i2);
  }

  method hyper_p is also<hyper> {
    ncinput_hyper_p($!i);
  }

  method meta_p is also<meta> {
    ncinput_meta_p($!i);
  }

  method nomod_p is also<nomod> {
    ncinput_nomod_p($!i);
  }

  method numlock_p is also<numlock> {
    ncinput_numlock_p($!i);
  }

  method shift_p is also<shift> {
    ncinput_shift_p($!i);
  }

  method super_p is also<super> {
    ncinput_super_p($!i);
  }

}
