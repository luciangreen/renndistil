# renndistil

recover a net's code, then compile the code back into the smallest net that does the same: one neuron if the function is linearly separable, otherwise the two-layer form (for xor and xnor on two inputs). The distilled net is checked to compute the same function.

## Use

```prolog
?- use_module(prolog/renndistil).
?- distil([[n([1,1],0), n([-1,-1],2), n([2,2],-3)], [n([1,1,0],-1)]], 2, S).   % xor in, a 3-neuron xor out
?- distil([[n([1,0],0), n([0,1],5)], [n([1,1],-1)]], 2, S).                      % S = one neuron for "a"
```

## Proofs

`proofs/theorems.pl` proves 4 theorems by exhaustion: each one is checked for every case in a finite domain that covers every branch of the definitions. every two-input function, written as a big two-layer net (one hidden neuron per true input).

1. The big net computes its function (so the domain is right).
2. Distilling keeps the function.
3. The 14 separable functions become one neuron; xor and xnor become three.
4. A distilled net is never bigger than the net it came from.

```sh
swipl -g main -t halt proofs/theorems.pl
```

## 200 inputs and outputs

`io/ios.txt` lists 200 inputs and outputs from real runs, and `io/ios.pl` has the same as Prolog facts. The inputs come from a fixed seed (`io/cases.pl`). `swipl -g check -t halt io/run.pl` runs them again. It fails if any output changes, or if a predicate doesn't confirm its own recorded output, which checks steadfastness. GitHub Actions runs the proofs and the examples on every push, and records the examples on the first push.

Licence: BSD-3-Clause.
