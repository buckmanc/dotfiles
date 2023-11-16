for f in ~/.vim/spell/*.add
do
	cat "$f" | ~/bin/pysort | sponge "$f"
done
