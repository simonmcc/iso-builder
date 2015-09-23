#!/bin/bash
#
# setup.sh - setup & activate a python virtualenv
# for ansible work
#
if [[ -d .venv ]]; then
  source .venv/bin/activate
else
  virtualenv .venv
  source .venv/bin/activate
fi

pip install ansible
