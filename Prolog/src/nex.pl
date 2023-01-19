:- consult('menu.pl').
:- consult('play.pl').
:- consult('input.pl').
:- consult('display.pl').
:- consult('aux.pl').
:- consult('test.pl').

:- use_module(library(lists)).
:- use_module(library(system)).
:- use_module(library(random)).
:- use_module(library(clpfd)).
:- use_module(library(aggregate)).
:- use_module(library(sets)).
:- use_module(library(plunit)).



% Start predicate
nex :- play.


