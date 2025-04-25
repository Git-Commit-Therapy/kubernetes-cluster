#!/bin/bash

# This scripts needs, of course, minikube, helmfile and tmux installed

minikube start
helmfile sync

tmux new -s SA-kubernetes -n dashboard -d

# Dashboard
tmux send-keys -t SA-kubernetes:0 "minikube dashboard" C-m

# Tunnel
tmux new-window -t SA-kubernetes -n tunnel
tmux send-keys -t SA-kubernetes:1 "minikube tunnel" C-m

tmux a -t SA-kubernetes
