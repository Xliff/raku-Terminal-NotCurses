use GTKScripts;

my $p = "preamble".IO.slurp;
my $c = "notcurses-orig.h".IO.slurp;
$c ~~ s:g/"__attribute__ ((" <-[)]>+ \)* "))"//;
$c ~~ m:g/<static-inline-func>/;

my (@c, @h);

sub prepLine ($_) {
  .subst("static ", "")
  .subst("inline", "")
  .subst("ALLOC", "");
  .subst("(", 'export (');
}

do for $/[] {
  @c.push: prepLine( .Str.trim );

  @h.push: [~](
    prepLine(
      .<static-inline-func><func_block><func_def_common>.subst(
        "\n",
        ' ',
        :g
      )
    ),
    ";\n"
  );
}

"notcurses-extern.c".IO.spurt: "{ $p }\n" ~ @c.join("\n") ~ "\n", :close;
"notcurses-extern.h".IO.spurt: "{ $p }\n" ~ @h.join("\n") ~ "\n", :close;
