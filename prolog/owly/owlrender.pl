/* -*- Mode: Prolog -*- */

:- module(owlrender,
          [
           owl_writeln/1,
           owl_writeln/2,
           owl_render/3
           ]).

:- use_module(library(semweb/rdf_db)).
:- use_module(library(semweb/rdfs)).
:- use_module(library(owly)).

owl_writeln(X) :-
        owl_writeln(X,[]).
owl_writeln(X,Opts) :-
        owl_render(X,N,Opts),
        writeln(N).


% render compound prolog terms        
owl_render(X,N,Opts) :-
        X =.. [P|Args],
        Args=[_|_],
        findall(Nx,(member(A,Args),owl_render(A,Nx,Opts)),Nxs),
        X2 =.. [P|Nxs],
        sformat(N,'~w',[X2]),
        !.

% render by label
owl_render(X,N,Opts) :-
        \+ rdf_is_bnode(X),
        option(label(true),Opts,true),
        rdfs_label(X,Label),
        sformat(N,'~w "~w"',[X,Label]),
        !.
owl_render(X,N,Opts) :-
        \+ rdf_is_bnode(X),
        option(labelonly(true),Opts),
        rdfs_label(X,N),
        !.
owl_render(X,X,_Opts) :-
        \+ rdf_is_bnode(X),
        !.
owl_render(X,X,_Opts) :-
        % TODO - render expressions
        !.
