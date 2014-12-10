/* -*- Mode: Prolog -*- */

:- module(owly,
          [
           label_node/2,
           
           someValuesFrom/3,
           subClassOf_someValuesFrom/3,

           intersectionOf/2,
           intersectionOf/3,
           intersectionOf/4,

           equivalentTo/2,
           equivalentTo_intersectionOf/2,
           equivalentTo_intersectionOf/3
           ]).

:- use_module(library(semweb/rdf_db)).
:- use_module(library(semweb/rdfs)).

label_node(N,X) :-
        var(X),
        nonvar(N),
        rdf(X,rdfs:label,literal(type(_,N))).
label_node(N,X) :-
        rdfs_label(X,N).


:- rdf_meta someValuesFrom(r,r,r).
someValuesFrom(R,P,D) :-
        rdf(R,owl:someValuesFrom,D),
        rdf(R,owl:onProperty,P).
        

:- rdf_meta subClassOf_someValuesFrom(r,r,r).
subClassOf_someValuesFrom(C,P,D) :-
        rdfs_subclass_of(C,X),someValuesFrom(X,P,D).

:- rdf_meta intersectionOf(r,r).
intersectionOf(R,L) :-
        rdf(R,owl:intersectionOf,RL),
        rdfs_list_to_prolog_list(RL,L).

:- rdf_meta intersectionOf(r,r,r).
intersectionOf(R,D1,Tail) :-
        rdf(R,owl:intersectionOf,RL),
        rdfs_list_to_prolog_list(RL,L),
        xlist(D1,Tail,L).

:- rdf_meta intersectionOf(r,r,r,r).
intersectionOf(R,D1,D2,Tail) :-
        rdf(R,owl:intersectionOf,RL),
        rdfs_list_to_prolog_list(RL,L),
        xlist(D1,Tail,L).

:- rdf_meta equivalentTo(r,r).
equivalentTo(C,D) :-
        rdf(C,owl:equivalentClass,D).

:- rdf_meta equivalentTo_intersectionOf(r,r).
equivalentTo_intersectionOf(C,L) :-
        equivalentTo(C,X),
        intersectionOf(X,L).

:- rdf_meta equivalentTo_intersectionOf(r,r,r).
equivalentTo_intersectionOf(C,D1,Tail) :-
        equivalentTo(C,X),
        intersectionOf(X,D1,Tail).


%% UTILS

xlist(D1,Tail,L) :-
        select(D1,L,Tail).
xlist(D1,D2,Tail,L) :-
        select(D1,L,L2),
        select(D2,L2,Tail).
xlist(D1,D2,D3,Tail,L) :-
        select(D1,L,L2),
        select(D2,L2,L3),
        select(D3,L3,Tail).








