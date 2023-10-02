

addString()
{
	local strings=$1
	local outpath=$2
	local comparisonPattern='s/[^\w\r\n]//g'

	touch -a "${outpath}"
	local fileText=$(cat "${outpath}" | perl -pe "${comparisonPattern}")

	strings=$(echo "${strings}" | tr -d '"' | sed -e 's/\w*/\u&/g')

	echo "${strings}" | while read line ; do

		local comparisonLineText=$(echo "${line}" | perl -pe "${comparisonPattern}")

		# echo "line: ${line}"
		# echo "comparisonLineText: ${comparisonLineText}"

		# if ! grep -qix "${line}" "${outpath}" ; then
		if ! echo "${fileText}" |  grep -qix "${comparisonLineText}" ; then
			echo "adding ${line}"
			echo "${line}" >> "${outpath}"
		fi
	done
}

addString "$(curl --location --silent 'https://pokeapi.co/api/v2/pokemon-species?limit=1000000' | jq '.results[] | (.name)')" ~/.vim/spell/pokemon.add
addString "$(curl --location --silent 'https://pokeapi.co/api/v2/region?limit=1000000' | jq '.results[] | (.name)')" ~/.vim/spell/pokemonregions.add
