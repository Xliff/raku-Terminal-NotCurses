use v6;

use Test;

use Terminal::NotCurses::Main;

unit package Terminal::NotCurses::Testing;

our $NC is export;
our ($nc-output-file, $nc-output) is export;

sub render ($d = 0.5) is export {
  ok $NC.render.not, 'Changes rendered with no errors';
  sleep $d;
}

sub nc-subtest (&block, $desc) is export {
  CATCH {
    default {
      $nc-output.say: .message;
      $nc-output.say: .backtrace.concise;
    }
  }

  subtest(&block, $desc, :!diag);
}

END {
  if $nc-output {
    $nc-output.close;
    $nc-output-file.IO.slurp( :close ).say;
  }
}
