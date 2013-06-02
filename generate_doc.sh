#!/bin/sh
find -type f -name '*.hx' | sed -e '/^\.\/src\/\(unit2\/tests\)/d;s/\.\/src\///;' | xargs haxe -cp src -xml haxedoc.xml
