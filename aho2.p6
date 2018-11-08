#!/usr/bin/perl6

my constant $debug-switch = 0;
my constant $graph-switch = 0;
my $x = <A humble heron is the humblest apshe>;
my @words = <humble he she hers heron apshe>;
say "Keywords: @words[]";
say "String: $x";

my Hash @g;
my SetHash @output;
my $newstate = 0;

my sub enter( $keyword ) {
  my $state = 0;
  for $keyword.comb -> $aj {
    if defined @g[$state]{$aj} {
      $state = @g[$state]{$aj};
    } else { 
      $newstate++;
      @g[$state]{$aj} = $newstate;
      $state = $newstate;
    }
  }
  @output[$state]{$keyword}++; 
}

enter($_) for @words;
for @g.keys {
  @output[$_] = SetHash.new 
     unless defined @output[$_];
}





# MAKING FAILURE FUNCTION

my Int @f;
my SetHash $queue;

for @g[0].kv -> $a, $s {
  $queue{$s}++;
  @f[$s] = 0
}
while $queue {
  my $r = $queue.pick;
  $queue{$r}--;
  for @g[$r].kv -> $a, $s {
    $queue{$s}++;

    my $state = @f[$r];
    while ! defined @g[$state]{$a} 
         and $state > 0 {
         $state = @f[$state];
    } 
    
    if $state == 0 {
      @f[$s] = 0;
      @f[$s] = @g[$state]{$a}
          if defined @g[$state]{$a};
      next;
    }
    
    @f[$s] = @g[$state]{$a};
    @output[$s] = 
       (@output[@f[$s]].keys (|) @output[$s].keys).SetHash;
  }
}
@f[0] = 0;



# MATCHING


my @a = $x.comb;
my $state = 0;
my Pair @matches;
for @a.kv -> $i, $ai {
  $state = @f[$state]
     until defined @g[$state]{$ai} or $state == 0;
  $state = @g[$state]{$ai} 
       if defined @g[$state]{$ai};
#  say "$i: @output[$state]" if @output[$state]; 
  @matches.push($i => @output[$state]) 
          if @output[$state];
}

say '';
my $format = "%5s: %-7s\n";
printf $format, "index", "match";
for @matches -> $match {
  my ($i, $v) = $match.kv;
  for $v.keys {
    my $n = $i + 1 - $_.chars;
    printf $format, $n, $_;
  }
}


# OUTPUT

exit unless $debug-switch;

for @output.kv -> $k, $v is copy {
  $v = '' unless defined $v;
  say "$k: $v"; 
}


exit unless $graph-switch;

for 0..@g.elems-1 -> $k {
  my $f = @f[$k];
  say "$k -> $f [ color=blue ]"; 
  my $v = @g[$k];
  next unless defined $v;
  for %$v.kv -> $key, $val {
    say "$k -> $val [ label = \"$key\" ]"; 
  }
}

