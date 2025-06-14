package Parse::Rules {

  our token my-static-inline-func is export  {
    $<a>='A'+ $<b>='B'*
  }

}

import Parse::Rules;

our role Parse::Rules::Actions is export {

  method match ($str, :$rule = 'TOP', :$package) {
    my &finish;

    if $package !=:= Nil {
      my @uw;

      for $package.WHO.grep({ .value ~~ Regex }) {
        my $r = .key.substr(1);

        if self.^can($r) -> $m {
          @uw.push: .value.wrap(
            sub (|) {
              my $r = callsame;
              $m.head.(self, $r) if $r;
              $r;
            }
          )
        }

      }
      &finish = sub { .restore for @uw }
    }

    my $r = $str.match(::('&' ~ $rule), :g);
    &finish() if &finish;
    |$r;
  }

}

class PR does Parse::Rules::Actions {
  method my-static-inline-func ($/) {
    say "FOUND! { $/.gist }";
  }
}

.gist.say for
  PR.match("A" , rule => 'my-static-inline-func', package => Parse::Rules ),
  PR.match("AB", rule => 'my-static-inline-func', package => Parse::Rules ),
  PR.match("C" , rule => 'my-static-inline-func', package => Parse::Rules )
