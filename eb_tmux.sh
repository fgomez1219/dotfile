#!/bin/sh

## Nombre para la sesion:
#sn=main

cd $HOME/eventbrite
tmux split-window -h
tmux select-pane -t 0
tmux split-window -v
cd $HOME/eventbrite
tmux new-window 'vim'
cd $HOME
tmux new-window 
#tmux -CC -2 attach-session -d
tmux select-window -t "0"



##!/bin/bash

## Nombre para la sesion:
#sn=main

## Arrancar la sesion en $HOME, con la primera ventana:
#cd $HOME
#tmux new-session -s "$sn" -d

## Crear 1 terminal mas para mi usuario y una para "root"
#tmux new-window -t "$sn"
#tmux new-window -n "root" 'sudo su - root'

## Seleccionar la primera ventana y hacer un attach a la sesion:
#tmux select-window -t "$sn:1"
#tmux -2 attach-session -t "$sn"
