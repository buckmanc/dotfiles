# schedule me!

spellDir="$HOME/.vim/spell"
externalDir="${spellDir}/external"
customPath="${externalDir}/spellfile_custom.txt"
externalPath="${spellDir}/external.add"
gboardPath="${externalDir}/gboard_spellfile.txt"

# unzip any zips in externalDir
if 7z e "${externalDir}"/*.zip -aoa -o"${externalDir}"
then
	# burn zips on success
	rm "${externalDir}"/*.zip
fi

# find new words from any text files in externalDir
sanitizedExternalWordsPath=$(mktemp -t sanitizedExternalWords.txt.XXX)
currentWordsPath=$(mktemp -t currentWords.txt.XXX)

cat "${externalDir}"/*.txt | grep -Piv '(^checksum_v1|^# Gboard Dictionary version)' | perl -pe 's/(\ten-US$|\t)//g' > "${sanitizedExternalWordsPath}"
cat "${spellDir}"/*.add > "${currentWordsPath}"

newExternalWords=$(grep -hivx -f "${currentWordsPath}" "${sanitizedExternalWordsPath}")
oldExternalWords=$(cat "${externalPath}")

# only write externally added words file if it's changed
if [[ "${newExternalWords}" != "${oldExternalWords}" ]]
then
	echo "${newExternalWords}" > "${externalPath}"
fi

# mash all vim spell files into one text file for outside use
ls "${spellDir}"/*.add | grep -iv private | xargs cat | grep -Piv '/!$' > "${customPath}" 

# write gboard file from spellfile_custom
newGboardText="# Gboard Dictionary version:1\n$(sed -e 's/$/\ten-US/g' -e 's/^/\t/g' ${customPath})"
echo "${newGboardText}" > "${gboardPath}"

