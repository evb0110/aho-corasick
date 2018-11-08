#!/usr/bin/perl6

# defines the goto function

my @words = <his she hers>;
say @words;

my Hash @g;
my @output;
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
# say join ' ', $state, $aj;
  }
  @output[$state] = $keyword; 
# say "---$state → $keyword";
}

enter($_) for @words;


# OUTPUT

for @output.kv -> $k, $v is copy {
  $v = '' unless defined $v;
#  say "$k: $v"; 
}


for 0..$newstate -> $k {
  my $v = @g[$k];
  next unless defined $v;
  for %$v.kv -> $key, $val {
    say "$k -> $val [ label = \"$key\" ]"; 
  }
}
# for all a...


