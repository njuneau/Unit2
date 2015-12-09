#!/bin/sh

export programName="unit2"
export releaseName="$1"
export releaseFolder="release"
export buildArchive="${releaseFolder}/${programName}-${releaseName}.zip"

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
                if [ $? -eq 0 ] ; then
                    echo "Library submitted to haxelib"
                else
                    echo "haxelib returned non-zero status"
                fi
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
