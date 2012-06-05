#!/bin/sh

cd BackboneJS.docset/Contents/Resources
ruby tokens.rb
cd -
/Developer/usr/bin/docsetutil index BackboneJS.docset/
tar -czf BackboneJS.tgz BackboneJS.docset
