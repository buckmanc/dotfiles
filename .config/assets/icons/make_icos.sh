#!/usr/bin/env bash

pngDir="$HOME/.config/assets/icons/png"
icoDir="$HOME/.config/assets/icons/ico"

if [[ -d "$icoDir" ]]
then
	rm -r "$icoDir"
fi

mkdir -p "$icoDir"

for inPath in "$pngDir"/*.png
do
	filename="$(basename "$inPath")"
	filename="${filename%.*}"
	outPath="${icoDir}/${filename}.ico"

	# echo "inPath: $inPath"
	# echo "outPath: $outPath"

	convert -resize "256x256>" "$inPath" "$outPath"
done

echo "$(ls "$pngDir/"*.png | wc -l) pngs"
echo "$(ls "$icoDir/"*.ico | wc -l) icos"

