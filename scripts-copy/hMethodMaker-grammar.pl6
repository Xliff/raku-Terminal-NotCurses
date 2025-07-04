#!/usr/bin/env perl6
use v6.c;

#use Data::Dump::Tree;
use IO::Capture::Simple;

use lib <.>;

use ScriptConfig;
use GTKScripts;

my %do_output;

use Grammar::Tracer;

grammar C-Function-Def {
  regex TOP { <top-bland> }

  rule top-normal { <function-normal>+ }
  rule top-bland  { <function-bland>+ }

  rule function-normal {
      <availability> 'G_GNUC_WARN_UNUSED_RESULT'? <func_def> |
      <availability><func_def>
  }

  rule function-bland {
      \s* <pre-definitions>? <func_def>
  }

  token pre-definitions {
      'G_GNUC_WARN_UNUSED_RESULT'                            |
      'G_GNUC_INTERNAL'                                      |
      <[A..Z]>+ '_DEPRECATED' [ '_IN_' (\d+)+ % '_' ]?
      '_FOR' \s* '(' (<-[)]>+) ')'
  }

  rule parameters {
      '(void)'
    |
      '(' [ <type> <var>? '[]'? ]+ % [ \s* ',' \s* ] [','? $<va>='...' ]? ')'
  }

  # cw: Double semi-colon sometimes occurs during processing, so it is acccounted
  # for, here.
  token func_name { <[ \w+ _ ]>+ }
  rule func_def {
      <returns>
    $<sub>=[
      <func_name>
      |
      '(*' <func_name> ')'
    ]
      <parameters>
    [ <postdec>+ % \s* ]?';'';'?
  }

  regex       p { [ '*' [ \s* 'const' <!before '_'> \s* ]? ]+ }
  token       n { 'const '? <[\w _]>+ }
  token       t { <n> | '(' <p> <n>? ')' \s* <parameters> }
  token     mod { 'extern' | 'long' | 'const' | 'struct' | 'enum' }
  rule     type { 'unsigned' <p>? | [ <mod>+ %% \s ]? <n>? <p>? }
  rule      var { <t> [ '[' (.+?)? ']' ]? }
  token returns { [ <mod>+ %% \s]? <.ws> <t> \s* <p>? }
  token postdec { (<[A..Z0..9]>+)+ %% '_' \s* [ '(' .+? ')' ]? }
  token      ad { 'AVAILABLE' | 'DEPRECATED' }

  token availability {
    [
      ( <[A..Z]>+'_' )+?
      <ad> [
      '_'
      ( <[A..Z]>+ )+ %% '_'
      [
      'ALL'
      |
      <[0..9]>+ %% '_'
      ]
      ]?
      |
      <[A..Z]>+'_API'
    ]
  }

}

grammar C-Function-Internal-Def is C-Function-Def {
  token ad { 'INTERNAL' }
}

# Reuse?? Why the need to redefine this when I have it in the grammar?
#my token ad { 'AVAILABLE' | 'DEPRECATED' }
my token availability {
  [
      ( <[A..Z]>+'_' )+?
      <ad> [
        '_'
        ( <[A..Z 0..9]>+ )+ %% '_'
      ]?
      |
      <[A..Z]>+'_API'
  ]
}

sub MAIN (
        $filename,                     #= Filename to process
       :$files,                        #= Send output to files
  Str  :$remove,                       #= Prefix to remove from method names
  Str  :$var,                          #= Class variable name [defaults to '$!w']. If not specified class methods will be generated.
  Str  :$output-only,                  #= Only output methods and attributes matching the given pattern. Pattern should be placed in quotes.
  Bool :$no-headers,                   #= Do not display section headers.
  Int  :$trim-start,                   #= Trim lines from the beginning of the post-processed file
  Int  :$trim-end,                     #= Trim lines from the end of the post-processed file
  Str  :$remove-from-start  is copy,   #= Remove colon separated prefix strings from all lines
  Str  :$remove-from-end    is copy,   #= Remove colon separate suffix strings from all lines
  Str  :$lib                is copy,   #= Library name to use
       :$delete             =  '',      #= Comma separated list of lines to delete
  Str  :$output             =  'all',  #= Type of output: 'methods', 'attributes', 'subs' or 'all'
  Bool :$extreme            =  False,  #= Use extreme cleanup methods
  Bool :$internal           =  False,  #= Add checking for INTERNAL methods
  Bool :$bland              =  True,   #= Do NOT attempt to process preprocessor prefixes to subroutines
  Bool :$get-set            =  False,  #= Convert simple get/set routine to "attribute" code.
  Bool :$raw-methods        =  False,  #= Use method format for raw invocations (NFYI)
  Bool :x11(:$X11)          =  False   #= Use GUI mode (must have a valid DISPLAY)
) {

  parse-file($CONFIG-NAME);

  # Get specific option values from configuration file, if it exists,
  # and those keys are defined.
  if %config<hfile-prefix> -> $pre is copy {
    $remove-from-start ~= ':' if $remove-from-start;
    $remove-from-start ~= $pre;
    #$*ERR.say: "<hfile-perfix> = { $pre }";
  }

  if %config<hfile-suffix> -> $suf {
    $remove-from-end ~= ':' if $remove-from-end;
    $remove-from-end ~= $suf;
  }
  $remove-from-end ~= $remove-from-end ?? ':' !! '' ~ 'G_GNUC_CONST';

  my $fn = $filename;

  $fn = "{ %config<include-directory> // '/usr/include/gtk-3.0/gtk' }/$fn"
    unless $fn.starts-with('/');
  die "Cannot find '$fn'\n" unless $fn.IO.e;

  if $internal.not {
    if $output ne 'all' {
      for $output.split(',') -> $o {
        die qq:to/DIE/ unless $o eq <all attributes methods subs>.any;
        Output can only be one of 'attributes', 'methods', 'subs' or 'all'"
        DIE

        %do_output{$o} = 1;
      }
    } else {
      %do_output<all> = 1;
    }
  } else {
    %do_output<subs> = 1;
  }

  my $attr;
  with $var {
    ($attr = $var) ~~ s:g/$ <!before '!'>//;
    $attr = '$!' ~ $attr unless $attr ~~ /^ '$!' /;
  }

  my @detected;
  my $contents = $fn.IO.open.slurp-rest;

  my ($out-file, $out-raw-file, $item);
  $lib //= %config<library> // %config<lib>;
  if $files {
    $item     = $filename.split('.').head.split('-').tail.tc;
    $lib      = $item.split('/').head.lc.subst(/ ^ 'lib'/, '') unless $lib;
    $out-file = $item.subst('/', '-', :g)  ~ '.pm6';

    use File::Find;

    my $head      = find( dir => 'lib', type => 'dir', name => 'Raw' ).head;
    $out-raw-file = $head.add($out-file).open(:w);
    $out-file     = $head.parent.add($out-file).open(:w);
  }
  $lib = 'gtk' unless $lib;

  # cw: Remove all struct definitions;
  $contents ~~ m:g/<struct>/;
  if $/ {
    for $/[].reverse {
      given .<struct> {
        #say "Removing { .from } to { .to }...";
        $contents.substr-rw( .from, .to - .from ) = ''
      }
    }
  }

  my token nested-parens {
    '(' ~ ')' [
      || <- [()] >+
      || <.before '('> <~~>
    ]*
  }

  my token mname { <[A..Za..z0..9_]>+ }
  my token decl  { (<[A..Z]>+)+ %% '_' <nested-parens>? }
  my token args  { '(' <-[)]>+ ')' }

  # Remove extraneous, non-necessary bits!
  # Comments

  $contents ~~ s:g/ '\\' $$ \s+ .+? $$ //;

  $contents ~~
    s:g/
      ^^ '#define'    <.ws>
      <decl> <args>?  <.ws>
      <mname>?        <.ws>
      <nested-parens>
    //;

  $contents ~~ s:g/
    '__attribute''__'?\s*'((' [
      'nonnull'\s*'('<-[)]>+')' |
      'warn_unused_result'      |
      'format'\s*'('<-[)]>+')'
    ]
    '))'
  //;
  $contents ~~ s:g/ ^^ <.ws>? '//' .+? $$                                    //;
  $contents ~~ s:g/ ^^ '#define' <.ws> <decl> <.ws>  .+? $$                  //;
  $contents ~~ s:g/ ^^ '#' .+? $$                                            //;
  $contents ~~ s:g/ <[A..Z]>+ [ '_BEGIN_DECLS' || '_END_DECLS' ]             //;
  $contents ~~ s:g/ '/*' ~ '*/' (.+?)                                        //;
  $contents ~~ s:g/ 'G_STMT_START'  .+? 'G_STMT_END'                         //;
  # Multi line defines;

  $contents ~~ s:g/ 'const ' //;
  $contents ~~ s:g/ [ 'struct' | 'union' ] <.ws> <[\w _]>+ <.ws> '{' .+? '};'//;
  $contents ~~ s:g/'typedef' .+? ';'                                         //;
  $contents ~~ s:g/ ^ .+? '\\' $                                             //;
  $contents ~~ s:g/ ^^ <.ws> '}' <.ws>? $$                                   //;
  $contents ~~ s:g/<!after ';'>\n/ /;
  $contents ~~ s:g/ ^^ 'GIMPVAR' .+? $$                                      //;

  # cw: Too permissive, but will work for most things. Needs an anchor to $$!
  $contents ~~ s:g/ 'G_GNUC_' (<[A..Z]>+)+ %% '_' //;

  $contents ~~ s:g/ 'gst_byte_reader_' [
                       'dup' | 'peek' | 'skip' | 'get'
                     ]'_string_utf8(reader' ',str'? ')'//;
  $contents ~~ s:g/ ^^ \s* 'static' \s* 'inline'? .+? $$ //;
  # GObject creation boilerplate
  $contents ~~ s:g/ '((obj), ' .+? ',' .+? '))'//;
  $contents ~~ s:g/ '((cls), ' .+? ',' .+? '))'//;
  $contents ~~ s:g/ '((obj), ' .+? '))'//;
  $contents ~~ s:g/ '((cls), ' .+? '))'//;
  $contents ~~ s:g/ '((obj), ' .+? ',' .+? '))'//;

  $contents ~~ s:g/ 'G_DECLARE_' [ <[A..Z]>+ ]+ % '_' ' (' <-[)]>+ ')' //;
  $contents ~~ s:g/ 'G_DECLARE_FINAL_TYPE('<-[)]>+')'//;

  $contents ~~ s:g/ 'extern "C" {' //;
  $contents ~~ s:g/ 'G_DEFINE_AUTOPTR_CLEANUP_FUNC' \s* '(' .+? ',' .+? ')' //;

  $contents ~~ s:g/ 'GType' /\nGType/;

  # Should be put behind an --extreme flag
  if $extreme {
    $contents ~~ s:g/ '#'\w+         //;
    $contents ~~ s:g/ ')' \s+        / );\n /;
  }

  # $contents ~~ s:g/<availability>// if $bland;
  $contents ~~ s:g/<enum>//;

  $contents ~~ s:g/'RESTRICT'//;

  if $remove-from-start {
    # Remove unnecessary whitespace
    $remove-from-start .= trim;
    # cw: Treat each section separated by spaces as a different item, otherwise
    # it might not work.
    $remove-from-start ~~ s:g/\s\s+/:/;
    for ( $remove-from-start // () ).split(':') -> $r {
      #$*ERR.say: "Removing { $r } from start of line...";
      say "Removing { $r } from start of line...";
      $contents ~~ s:g/ ^^ \s* <{ $r }> <[\s\r\n]>* //;
    }
  }

  if $remove-from-end {
    # Remove unnecessary whitespace
    $remove-from-end .= trim;
    # cw: Treat each section separated by spaces as a different item, otherwise
    # it might not work.
    $remove-from-end ~~ s:g/\s\s+/:/;
    for ( $remove-from-end // () ).split(':') -> $r {
      $contents ~~ s:g/ \s* $r \s* ';' $$ /;/;
    }
    $contents ~~ s:g/ <!before ';'> <?{ $/.Str.chars }> $$/;/;
  }

  $contents.say;

  $contents = $contents.lines.skip($trim-start).join("\n")
    if $trim-start;
  $contents = $contents.lines.reverse.skip($trim-end).reverse.join("\n")
    if $trim-end;

  my regex range { (\d+) '-' (\d+) }

  if $contents.lines.elems -> $e {
    my $s-fmt = '%0' ~ $e.log(10).Int + 1 ~ 'd';
    $contents = (gather for $contents.lines.kv -> $k, $v {
      # Last chance removal by line prefix.
      next if $v.starts-with('extern');

      # Last chance to clean up artifacts left by processing:
      my $val = $v;
      $val .= subst( /\s*';'/ , ';' );

      take "{ ($k + 1).fmt($s-fmt) }: { $val }"
    }).join("\n");
  }

  # Check for multiple semi-colons on a line and split that line.
  # This is a pain in the ass, as we have to re-perform operations that
  # have been already done to preserve correctness!
  if $contents.lines.map({ +.comb(';') }).grep( * > 1) {
    $contents = (do {
      (my $sc = $contents) ~~ s:g/^^ (\d+) ':' \s*//;
      my $count = 1;
      gather for $sc.lines {
        for .chop.split(';') {
          my $s = $_;
          if $remove-from-start {
            for ( $remove-from-start // () ).split(':') -> $r {
              $s ~~ s:g/ ^^ \s* $r \s* //;
            }
          }
          if $remove-from-end {
            for ( $remove-from-end // () ).split(':') -> $r {
              $s ~~ s:g/ \s* $r \s* ';'? $$ /;/;
            }
          }
          take "{ $count++ }: { $s };";
        }
      }
    }).join("\n");
    # $contents may change in this block, so $stripped-contents needs to be
    # updated
    # (my $stripped-contents = $contents) ~~ s:g/^^ (\d+) ':' \s*//;
  }

  if $delete {
    my @d = $delete.split(',').map({
      my &meth;
      die 'All elements in $delete must be an integer or an integer range!'
        unless $_ ~~ &range || ( &meth = .^lookup('Int') );
      my $r;
      $r = &meth($_) if &meth;
      $r = $_ unless $r;
      $r;
    });

    my @d-ranges;
    for @d {
      if $_ ~~ &range {
        @d-ranges.append: $/[0].Int ... $/[1].Int;
      } else {
        @d-ranges.push: .Int;
      }
    }

    my @c = $contents.lines;
    #say "C:------\n{ @c.join("\n") }------";
    @c.splice($_ - 1, 1) for @d-ranges.reverse;
    $contents = @c.join("\n");
  }
  (my $stripped-contents = $contents) ~~ s:g/^^ (\d+) ':' \s*//;

  my \grammar := $internal ??
    C-Function-Internal-Def
    !!
    C-Function-Def;
  my $top-rule  = $bland ?? 'top-bland'      !! 'top-normal';
  my $func-rule = $bland ?? 'function-bland' !! 'function-normal';
  my $matched = grammar.parse($stripped-contents, rule => $top-rule);

  unless $matched {
    say '============';
    say $stripped-contents;
    say '------------';
    say 'Could not find any functions!';
    say '-----------------------------';
    $contents.say;
    exit 1;
  }

  my %first-params;
  for $matched{$func-rule}[] -> $m {
    my $av = $bland ??
      { pre-definitions => ($m<pre-definitions> // '').Str } !!
      $m<availability>;

    my $avail = $bland ??
      !$av<pre-definitions>.contains('DEPRECATED')
        !!
      ($av<ad> // '') ne '_DEPRECATED';

    say "----------- PREDEF\n{ $m<pre-definitions>.gist }";

    my $dep-for = do if $m<pre-definitions>[1] -> $df {
      $df.Str;
    } else {
      '';
    }

    my @p;
    my $orig = $m<func_def><sub>.Str.trim;
    my @tv = ($m<func_def><parameters><type> [Z] $m<func_def><parameters><var>);

    @p.push: [ .[0], .[1] ] for @tv;

    sub resolve-type($match is copy) {
      say "M: { $match.gist }";


      my $t         = $match ~~ Match ?? ($match<n> // 'int') !! $match;
      my $orig-type = $t;

      # cw: FINALLY got around to doing something that should have been
      #     done from the start.
      $t ~~ s/^g?u?[ 'char' | 'Str' ]/Str/;
      $t ~~ s/^int/gint/;
      $t ~~ s/^float/gfloat/;
      $t ~~ s/^double/gdouble/;
      $t ~~ s/void/Pointer/;
      $t ~~ s/GError/Pointer[GError]/;

      # By testing time, $np should only contain the count of '*' in the Match
      my $np = do given $match {
        when Match { ( $match<p>.Str // '').Str.comb('*').elems }

        default    { 0 }
      }
      $t = "{ 'CArray[' x ($np - 1) }{ $t }{ ']' x ($np - 1) }" if $np > 1;
      $t;
    }

    my @v = @p.map({
      my $t = resolve-type( .[0] );
      '$' ~ .[1]<t>.Str.trim ~ do if (my $np = (.[0]<p> // '').Str.chars) {
        if $np == 1 &&
           ($t eq <gfloat gdouble>.any || $t.starts-with(<gint guint>.any).so)
        {
          ' is rw';
        }
      }
    });
    my @t     = @p.map({ resolve-type(.[0] ) });

    %first-params{ @t.head }++ if @t.head.chars;

    my $tmax  = @t.map( *.chars ).max;
    my @t-sd  = @t.map( *.fmt("  %-{ $tmax }s") );

    my $o_call = (@t-sd [Z] @v).join(",\n");

    my $sub = $m<func_def><sub>.Str.trim;
    $o_call ~= ', ...' if $m<func_def><va>;

    if $attr && $sub.starts-with("{$remove // ''}new_").not {
      @v.shift if +@v;
      @t.shift if +@t;
    }

    my $sig = (@t [Z] @v).join(', ');
    my $call = @v.map( *.trim ).join(', ');
    $sig ~= ', ...' if $m<func_def><va>;

    if $attr {
      if $call.chars {
        $call = "{$attr}, {$call}";
      } else {
        if $sub ~~ (/'_new'$/ , /'_get_type' $/).any {
          $call = '';
        } else {
          $call = $attr;
        }
      }
    }

    if $remove {
      unless $sub ~~ s/ $remove // {
        unless $sub ~~ s/ { $remove.split('_')[0] ~ '_' } // {
          $sub ~~ s/ 'g_' //;
        }
      }
    }

    my $h = {
           avail => $avail,
         dep-for => $dep-for,
        original => $orig.trim,
         returns => $m<func_def><returns>,
           'sub' => $sub,
          params => @p,
          o_call => $o_call,
            call => $call.subst(' is rw', '', :g),
             sig => $sig,
       call_vars => @v,
      call_types => @t,
         var_arg => $m<func_def><va>:exists
    };

    #my $p = 1;

    # This will eventually go into a separate CompUnit
    my $p6r = do given $h<returns><t>.Str.trim {
      when 'gpointer' {
        'Pointer';
      }
      when 'float' {
        'gfloat'
      }
      when 'int' {
        'gint';
      }
      when 'va_list' {
      }
      when 'gboolean' {
        'uint32';
      }
      when 'gchar' | 'guchar' | 'char' {
        # This logic may no longer be n.join('')ecessary.
        #$p++;
        'Str';
      }
      default {
        $_;
      }
    }

    if $h<returns><p> {
      # Again, by loop time, $np should be the number of '*' characters found.
      my $np = ($h<returns><p> // '').Str;
      $np = ( ($np ~~ m:g/'*'/).Array.elems );
      $np-- if $p6r eq 'Str'; # Already counts for a '*'
      if $np > 1 {
        $p6r = "CArray[{ $p6r }]" for ^$np - 1;
      }
    }
    $h<p6_return> = $p6r;

    @detected.push: $h;
  }

  my %collider;
  my %methods;
  my %getset;
  for @detected -> $d {
    # Convert signatures to perl6.
    #
    #$d<sub> = substr($d<sub>, $prechop);
    if $d<sub> ~~ /^^ ( [ 'get' || 'set' ] ) '_' ( .+ ) / {
      %getset{$/[1]}{$/[0]} = $d;
    } else {
      %methods{$d<sub>} = $d;
      %collider{$d<sub>}++;
    }
  }

  for %getset.keys.sort -> $gs {
    if !(
      $get-set                              &&
      %getset{$gs}<get>                     &&
      %getset{$gs}<get><params>.elems == 1  &&
      %getset{$gs}<set>                     &&
      %getset{$gs}<set><params>.elems == 2
    ) {
      say "Removing non-conforming get:set {$gs}...";
      if %getset{$gs}<get>.defined {
        %methods{%getset{$gs}<get><sub>} = %getset{$gs}<get>;
        %collider{ %getset{$gs}<get><sub> }++;
      }
      if %getset{$gs}<set>.defined {
        %methods{%getset{$gs}<set><sub>} = %getset{$gs}<set>;
        %collider{ %getset{$gs}<set><sub> }++;
      }
      %getset{$gs}:delete;
    } else {
      %getset{$gs}<get><sub> ~~ s/['get' | 'set']_//;
      %collider{ %getset{$gs}<get><sub> }++;
    }
  }

  if %do_output<all> || %do_output<attributes> {
    say "\nGETSET\n------" unless $no-headers;
    for %getset.keys.sort -> $gs {
      if $output-only.defined {
        next unless $gs ~~ /<{ $output-only }>/;
      }

      my $sp = %getset{$gs}<set><call>.split(', ')[*-1];

      say qq:to/METHOD/;
        method { %getset{$gs}<get><sub> } is rw \{
          Proxy.new(
            FETCH => sub (\$) \{
              { %getset{$gs}<get><original> ~ '(' ~ %getset{$gs}<get><call> ~ ')' };
            \},
            STORE => sub (\$, { $sp } is copy) \{
              { %getset{$gs}<set><original> ~ '(' ~ %getset{$gs}<set><call> ~ ')'};
            \}
          );
        \}
      METHOD

    }
  }

  sub O ($str, :$file = $out-file) {
    use nqp;

    say $str;
    $file.say: nqp::hllize($str) if $file;
  }
  sub O-Raw ($str, :$raw-file = $out-raw-file) {
    O($str, file => $raw-file);
  }

  sub outputSub ($m, $method = False) {
    my $o_call = $m<o_call>
      ?? ( $m<o_call>.lines == 1
        ?? "({ $m<o_call>.substr(2) })"
        !! "(\n{ $m<o_call> }\n)"
      )
      !! '';

    my $subcall = qq:to/CALL/.chomp;
      sub { $m<original> } { $o_call }
      CALL

    # if $method {
    #   # This should be done, above.
    #   my @p = $m<params>;
    #   @p.shift if @p[0][1] eq $var;
    #
    # }

    my $r = '';
    $r ~= "\n  returns { $m<p6_return> }"           if $m<p6_return> &&
                                                       $m<p6_return> ne 'void';
    $r ~= "\n  is      DEPRECATED({ $m<dep-for> })" if $m<dep-for>;
    $r ~= "\n  is      symbol('{ $m<original> }')"  if $method;

    O-Raw( qq:to/SUB/ );
      $subcall {
      $r }
        is      native({ $lib })
        is      export
      \{ * \}
      SUB
  }

  sub outputMethods {
    my $invocant = $var ?? %first-params.pairs.sort( *.value ).head.key
                        !! '';

    say "\nMETHODS\n-------" unless $no-headers;
    if %do_output<all> || %do_output<methods> {
      for %methods.keys.sort -> $m {
        if $output-only.defined {
          next unless $m ~~ /<{ $output-only }>/;
        }

        my @sig_list = %methods{$m}<sig>.split(/\, /);

        my rule replacer { «[ 'Gtk'<[A..Z]>\w+ | 'GtkWindow' ]» };
        my $sig = %methods{$m}<sig>;
        my $call = %methods{$m}<call>;
        my $mult = '';

        # $mult = %methods{$m}<call_types>.grep(/<replacer>/) ?? 'multi ' !! ''
        #   if
        #     %methods{$m}<call_types> &&
        #     %methods{$m}<call_types>[0] eq <
        #       GtkEntryIconPosition
        #       GtkTreeIter
        #     >.none;

        my $dep = %methods{$m}<avail>
          ?? ''
          !! "IS DEPRECATED{ %methods{$m}<dep-for> ?? "({
              %methods{$m}<dep-for>.subst($remove, '') }) " !! ' '}";

        my @lines = %methods{$m}<o_call>.lines;

        if +@lines {
          #say "Pre-Lines: { @lines.gist }";

          @lines .= skip(1) if @lines.head.trim.split(/ \s+ /).head eq
                               $invocant;

          #say "Post Invocant ({ $invocant }): { @lines.gist }";
        }
        my $params = %methods{$m}<call_types>.elems
          ?? ( +@lines == 1
            ?? " ({ @lines.head.substr(2) })"
            !! " (\n{ @lines.map( "  " ~  * ).join("\n") }\n  )"
          )
          !! '';
        O( qq:to/METHOD/.chomp );
          { $mult }method { %methods{$m}<sub> }{ $params } { $dep }\{
            { %methods{$m}<original> }({ $call });
          \}
        METHOD

        if $mult {
          my $o_call = %methods{$m}<call_vars>.clone;
          my $o_types = %methods{$m}<call_types>.clone;
          for (^$o_types) -> $oidx {
            given $oidx {
              when s/GtkWindow/GTK::Window/ {
                $o_call[$oidx] ~~ s/\$(\w+)/\$$0.window/;
              }
              when s/'Gtk' <!before 'Window'> (<[A..Z]> \w+)/GTK::$0/ {
                $o_call[$oidx] ~~ s/\$(\w+)/\$$0.widget/;
              }
            }
          }
          my $oc = $o_call.join(', ');
          my @pa = $o_types.Array [Z] %methods{$m}<call_vars>.Array;
          my $os = @pa.join(', ');
          my $params = @pa.grep( * ).elems ?? " ({ $os })" !! '';

          # { @pa.elems }
          O( qq:to/METHOD/.chomp )
            { $mult }method { %methods{$m}<sub> }{ $params }  \{
              samewith({ $oc });
            \}
          METHOD

        }
        O( '' );
      }
    }
  }

  my ($redir-output, $use-X11, %class);
  if $X11 {
    for <
      GTK::Application
      SourceViewGTK::View
    > {
      my $cu = $_;
      say "Loading { $cu } ...";
      %class{$cu} = try require ::($cu);
      my $mod-failed = ::($cu) ~~ Failure;
      say "Failed to load $cu" if $mod-failed;

      unless (
        $use-X11 = $use-X11.defined ?? $use-X11 && $mod-failed.not
                                    !! $mod-failed.not;
      ) {
        warn "Cannot switch to GUI mode: $_ load failure";
        last
      }
    }

    capture_stdout_on($redir-output);
  }

  outputMethods;
  if %do_output<all> || %do_output<subs> {
    say "\nSUBS\n----\n" unless $no-headers;
    O-Raw( "\n\n### { $fn }\n" );
    outputSub( %methods{$_}    , $raw-methods) for %methods.keys.sort;
    outputSub( %getset{$_}<get>, $raw-methods) for  %getset.keys.sort;
    outputSub( %getset{$_}<set>, $raw-methods) for  %getset.keys.sort;
  }

  for %collider.pairs.grep( *.value > 1 ) -> $d {
    $*ERR.say: "DUPLICATES\n----------" if !$++ ;
    $*ERR.say: ~$d;
  }

  if $use-X11 {
    my \app  = %class<GTK::Application>;
    my \view = %class<SourceViewGTK::View>;

    my $a = app.new( title => 'org.genex.hMethodMaker' );
    $a.activate.tap({
      my $v = view.new;

      $v.buffer.text = $redir-output;
      $a.window.add($v);
      $a.window.show_all;
    });

    $a.run;
  }

  LAST {
    if $out-raw-file {
      $out-raw-file.close;
      say "Sub definitions written to { $out-raw-file }";
    }

    if $out-file {
      $out-file.close;
      say "Methods written to { $out-file }.";
    }
  }
}
