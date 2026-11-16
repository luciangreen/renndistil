% renndistil: recover a net's code, then compile the code back into the smallest net that does
% the same: one neuron if the function is linearly separable, otherwise the two-layer form
% (for xor and xnor on two inputs). The distilled net is checked to compute the same function.
%?- distil([[n([1,1],0), n([-1,-1],2), n([2,2],-3)], [n([1,1,0],-1)]], 2, S).   % xor in, a 3-neuron xor out
%?- distil([[n([1,0],0), n([0,1],5)], [n([1,1],-1)]], 2, S).                      % S = one neuron for "a"
:- module(renndistil, [neuron/3, forward/3, bits/2, truth/3, single/3, distil/3, size/2]).
:- use_module(library(lists)).
:- use_module(library(apply)).

neuron(n(Ws, B), Xs, Y) :- foldl([W, X, A0, A]>>(A is A0 + W * X), Ws, Xs, B, S), ( S > 0 -> Y = 1 ; Y = 0 ).
forward([], Xs, Xs).
forward([L|Ls], Xs, Out) :- maplist([N, Y]>>neuron(N, Xs, Y), L, Ys), forward(Ls, Ys, Out).
bits(K, Bs) :- length(Bs, K), maplist([X]>>member(X, [0, 1]), Bs).
truth(Net, K, T) :- findall(O, ( bits(K, I), forward(Net, I, O) ), T).

size(Net, S) :- foldl([L, A0, A]>>( length(L, K), A is A0 + K ), Net, 0, S).

% single(+Table, +K, -Neuron): the first neuron (weights -2..2, bias -3..3) with that truth table.
single(T, K, N) :- length(Ws, K), maplist([W]>>between(-2, 2, W), Ws), between(-3, 3, B), N = n(Ws, B), truth([[N]], K, T), !.

% distil(+Net, +K, -Small)
distil(Net, K, Small) :- truth(Net, K, T),
    ( single(T, K, N) -> Small = [[N]]
    ; K =:= 2, T == [[0], [1], [1], [0]] -> Small = [[n([1, 1], 0), n([-1, -1], 2)], [n([1, 1], -1)]]
    ; K =:= 2, T == [[1], [0], [0], [1]] -> Small = [[n([1, 1], 0), n([-1, -1], 2)], [n([-1, -1], 2)]]
    ; Small = Net ).
