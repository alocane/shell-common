#!/usr/bin/env bash

include "${CALLER_PACKAGE:-"alocane/shell-common"}" lib/log.sh

getVersion() {
    local vFileBasic="version"
    local vFileMaven="pom.xml"
    local vFileGradle="build.gradle"
    local vFileAngular="package.json"
    local vFileHelm="Chart.yaml"

    local baseDir=$1
    echo "searching version file in path: $baseDir"

    local vFileBasicPath="$baseDir/$vFileBasic"
    local vFileMavenPath="$baseDir/$vFileMaven"
    local vFileGradlePath="$baseDir/$vFileGradle"
    local vFileAngularPath="$baseDir/$vFileAngular"
    local vFileHelmPath="$baseDir/$vFileHelm"

    local vFiles=""
    local version=""
    local count=0
    if [ -f "$vFileBasicPath" ]; then
        vFiles="$vFiles'$vFileBasic'"
        version=$(cat "$vFileBasicPath")
        ((count++))
    fi
    if [ -f "$vFileMavenPath" ]; then
        vFiles="$vFiles'$vFileMaven'"
        version=$(xmlstarlet sel -N x=http://maven.apache.org/POM/4.0.0 -t -m "/x:project/x:version" -v . "$vFileMavenPath")
        ((count++))
    fi
    if [ -f "$vFileGradlePath" ]; then
        vFiles="$vFiles'$vFileGradle'"
        version=3
        ((count++))
    fi
    if [ -f "$vFileAngularPath" ]; then
        vFiles="$vFiles'$vFileAngular'"
        version=4
        ((count++))
    fi
    if [ -f "$vFileHelmPath" ]; then
        vFiles="$vFiles'$vFileHelm'"
        version=5
        ((count++))
    fi
    if [[ $count = 0 ]]; then
        whine "no version file found"
    elif [[ $count -gt 1 ]]; then
        whine "too much ($count) version files found: $vFiles"
    fi
    echo "found version='$version' in file: $vFiles"
    echo $version
}

req xmlstarlet