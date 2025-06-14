use Terminal::NotCurses::Raw::Plane;

my $subs  = MY::.pairs.grep({ .value ~~ Callable }).cache;
my $file  = $subs.head.value.file.split(/ \s+ /).head.IO;
my @lines = $file.slurp.lines;

my $subs-and-ranges = $subs.map({ [ .key, .value.line ] })
                           .sort( *.tail )
                           .rotor( 2 => -1, :partial )
                           .map({
                             [
                               .head.head,
                               .head.tail.pred .. (
                                  .elems > 1
                                    ?? .tail.tail - 2
                                    !! @lines.elems
                                )
                             ]
                           });

my $out = '';
for $subs-and-ranges.sort( *.head )[] {
  next unless .tail.max >  .tail.min;
  next if     .tail.min == .tail.max;

  my $s = @lines[ |.tail ];

  my $subdef = $s.join("\n");
  if $subdef ~~ /'sub ' $<n>=<[\w_]>+? 'export (' / -> $m {
    my $r := $subdef.substr-rw( $m.from, $m.to - $m.from);
    $r = $r.substr(0, $r.chars - 8) ~ ' (';
    $subdef ~~ s/"is      export\n"/is      export\n  is      symbol('{ $m<n> }_export')\n/;
  }

  $out ~= "$subdef\n";
}

$out.say;
