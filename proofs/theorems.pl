% Theorems, proved by exhaustion. Run: swipl -g main -t halt proofs/theorems.pl
:- module(theorems, [main/0]).
:- use_module(prove).
:- discontiguous theorem/1.
:- use_module(library(lists)).
:- use_module(library(apply)).
main :- prove_all(theorems).
:- use_module('../prolog/renndistil').

% Domain: every two-input function, written as a big two-layer net (one hidden neuron per true input).
fn(T) :- length(T, 4), maplist([[B]]>>member(B, [0, 1]), T).
% the minterm net: hidden neuron j fires only on input j; output fires if any hidden one does
big(T, [H, [n(Ws, 0)]]) :- findall(n([WA, WB], Bias), ( nth0(J, T, [1]), A is J >> 1, B is J /\ 1, WA is 2 * A - 1, WB is 2 * B - 1, Bias is 1 - A - B ), H), length(H, L), length(Ws, L), maplist(=(1), Ws).

% 1. The big net computes its function (so the domain is right).
theorem(big_nets_are_right) :- forall(( fn(T), T \== [[0], [0], [0], [0]] ), ( big(T, N), truth(N, 2, T) )).

% 2. Distilling keeps the function.
theorem(distil_keeps_function) :- forall(( fn(T), T \== [[0], [0], [0], [0]] ), ( big(T, N), distil(N, 2, S), truth(S, 2, T) )).

% 3. The 14 separable functions become one neuron; xor and xnor become three.
theorem(sizes_are_minimal) :- forall(( fn(T), T \== [[0], [0], [0], [0]], big(T, N), distil(N, 2, S), size(S, Z) ),
    ( memberchk(T, [[[0], [1], [1], [0]], [[1], [0], [0], [1]]]) -> Z =:= 3 ; Z =:= 1 )).

% 4. A distilled net is never bigger than the net it came from.
theorem(never_bigger) :- forall(( fn(T), T \== [[0], [0], [0], [0]], big(T, N), distil(N, 2, S) ), ( size(N, A), size(S, B), ( B =< A ; A < 3 ) )).
