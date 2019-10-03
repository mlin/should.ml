#!/bin/sh

set -eux

# install ocaml and opam from apt
sudo apt update -qq
sudo apt install -qq ocaml opam

opam init -y
eval "$(opam env)"

# install packages from opam
opam install -q -y dune ounit

# compile & run tests
dune build @all
dune runtest
