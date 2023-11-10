for f in ~/.vim/spell/*.add
do
	cat "$f" | pysort | sponge "$f"
done
