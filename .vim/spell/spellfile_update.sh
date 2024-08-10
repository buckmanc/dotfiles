#!/usr/bin/env bash

# schedule me!

spellDir="$HOME/.vim/spell"
externalDir="${spellDir}/external"
customPath="${externalDir}/spellfile_custom.txt"
externalPath="${spellDir}/external.add"
gboardPath="${externalDir}/gboard_spellfile.txt"

# unzip any zips in externalDir
if ls "${externalDir}"/*.zip 1> /dev/null 2>&1
then
	if 7z e "${externalDir}"/*.zip -aoa -o"${externalDir}"
	then
		# burn zips on success
		rm "${externalDir}"/*.zip
	fi
fi

# find new words from any text files in externalDir
sanitizedExternalWordsPath=$(mktemp -t sanitizedExternalWords.txt.XXX)
currentWordsPath=$(mktemp -t currentWords.txt.XXX)

cat "${externalDir}"/*.txt | grep -Piv '(^checksum_v1|^# Gboard Dictionary version|^# From OS)' | perl -pe 's/(\ten-US$|\t)//g' | pysort > "${sanitizedExternalWordsPath}"
cat "${spellDir}"/*.add > "${currentWordsPath}"

newExternalWords=$(grep -hivx -f "${currentWordsPath}" "${sanitizedExternalWordsPath}" | uniq)
oldExternalWords=$(cat "${externalPath}")

# only write externally added words file if it's changed
if [[ "${newExternalWords}" != "${oldExternalWords}" ]]
then
	echo "${newExternalWords}" > "${externalPath}"
fi

# sort first
"${spellDir}"/sort.sh

# mash all vim spell files into one text file for outside use
ls "${spellDir}"/*.add | grep -iv private | xargs cat | grep -Piv '/!$' | sed '/^[ \t]*$/d' | uniq > "${customPath}" 

# write gboard file from spellfile_custom
newGboardText="# Gboard Dictionary version:1
$(sed -e 's/$/\ten-US/g' -e 's/^/\t/g' ${customPath})"
echo "${newGboardText}" > "${gboardPath}"

# TODO: actually dedupe files?
echo "checking for dupes..."
spellFiles="$(find "$spellDir" -type f -iname '*.add')"
echo "$spellFiles" | while read -r src
do
	echo "$spellFiles" | while read -r check
	do
		# 2>/dev/null isn't working for eating errors
		# so piping to echo -n instead
		# could sort with 'sort -t ':' -k2', but would need to aggregate output first
		grep --fixed-strings --line-regexp --color --with-filename --exclude "$src" -f "$src" "$check" || echo -n
	done
done
