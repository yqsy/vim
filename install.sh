#!/bin/sh

DIR="$( cd "$( dirname "$0"  )" && pwd  )"
cd $DIR

mkdir -p ~/.vim
ln -s $DIR/asc ~/.vim/asc
ln -s $DIR/asc.vim ~/.vim/asc.vim
ln -s $DIR/skywind.vim ~/.vim/skywind.vim

ln -s $DIR/plugin ~/.vim/plugin
ln -s $DIR/autoload ~/.vim/autoload
ln -s $DIR/doc ~/.vim/doc
ln -s $DIR/colors ~/.vim/colors
ln -s $DIR/syntax ~/.vim/syntax


