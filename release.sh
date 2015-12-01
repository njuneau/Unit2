#!/bin/sh

export releaseName="$1"
export releaseFolder="release"
export buildArchive="${releaseFolder}/${releaseName}.zip"

if [ $1 != "" ] ; then

    echo "Performing release ${releaseName}"
    if [ ! -d $releaseFolder ] ; then
        mkdir $releaseFolder
        echo "Created release folder"
    else
        echo "Release folder already exists"
    fi
    if [ -f $buildArchive ] ; then
        echo "Found old release ${buildArchive} - cleaning up"
        rm $buildArchive
    fi

    git status
    echo "Confirm? [y/n]"
    read buildConfirmed

    if [ $buildConfirmed == "y" ] ; then
        git archive -o ${buildArchive} HEAD haxelib.json README.rst COPYRIGHT src/main

        if [ $? -eq 0 ] ; then
            echo "Archive created at ${buildArchive}"
            echo "Submit to haxelib? [y/n]"

            read submitToHaxelib

            if [ $submitToHaxelib == "y" ] ; then
                haxelib submit $buildArchive
                echo "Library submitted to haxelib"
            else
                echo "Submit skipped"
            fi
        else
            echo "Error with the git archive command - see output"
        fi

    else
        echo "Build canceled"
    fi

else
    echo "Usage : ./release.sh [releaseName]"
fi
