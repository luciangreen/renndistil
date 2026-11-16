:- module(cases, [title/1, case/3]).
:- use_module('../prolog/renndistil').
:- use_module(engine).
title('renndistil').
n_g(K, n(Ws, B)) :- length(Ws, K), maplist([W]>>rnd_int(-2, 2, W), Ws), rnd_int(-3, 3, B).
net_g(K, [H, [O]]) :- rnd_int(1, 4, NH), length(H, NH), maplist(n_g(K), H), n_g(NH, O).
case(distil, [N, 2], distil) :- net_g(2, N).
case(distil_sizes, [N], distil_sizes) :- net_g(2, N).
case(single, [T, 2], single) :- length(T, 4), maplist([[B]]>>rnd_int(0, 1, B), T).
distil_sizes(N, from(A)-to(B)) :- size(N, A), distil(N, 2, S), size(S, B).
