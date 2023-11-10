#!/bin/bash

declare -a myArray=(
	'<Find name='
	'<File filename='
	'<GUIConfig name=\"AppPosition\"'
	'<GUIConfig name=\"FindWindowPosition\"'
	'<GUIConfig name=\"noUpdate\"'
	'<Replace name='
	'<FileBrowser latestSelectedItem'
	'<root foldername'
	'<\/FileBrowser'
	'<ProjectPanel'
	'<\/ProjectPanel'
	'<FindHistory'
	'<Filter name'
	'<\/FindHistory'
	'<text content'
)

sedcmd="sed"

for element in "${myArray[@]}"
do
	sedcmd+=" -e \"/$element/d\""
done

eval $sedcmd
