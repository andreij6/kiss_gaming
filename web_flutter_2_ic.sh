#!/bin/bash

#remove folder
rm -r -f static-ic-website/content

#remake folder
mkdir static-ic-website/content

#copy files to ic
cp -R raffle_ui/build/web/ static-ic-website/content