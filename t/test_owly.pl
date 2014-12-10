/* -*- Mode: Prolog -*- */

:- begin_tests(owly).

:- use_module(library(semweb/rdf_db)).
:- use_module(library(semweb/rdf_turtle)).
:- use_module(library(semweb/rdfs)).


:- ensure_loaded('prolog/owly').
:- ensure_loaded('prolog/owly/owlrender').


test(convert) :-
        debug(test),
        rdf_load('t/data/ceph.ttl'),
        wall,
        T=gland(C,P,Y),
        findall(T,T,Ts),
        maplist(owl_writeln,Ts),
        length(Ts,NumGlands),
        NumGlands =:= 4.


gland(C,P,Y) :-
        label_node(gland,Gland),
        freeze(Genus,rdfs_subclass_of(Genus,Gland)),
        equivalentTo_intersectionOf(C,Genus,[Diff]),
        someValuesFrom(Diff,P,Y).

wall :-
        freeze(D,\+ rdf_is_bnode(G)),
        equivalentTo_intersectionOf(C,G,[Diff]),
        someValuesFrom(Diff,R,Y),
        %writeln(x(C,G,R,Y)),
        owl_writeln(x(C,G,R,Y)),
        fail.
wall.

:- end_tests(owly).

