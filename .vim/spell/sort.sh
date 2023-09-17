for f in ~/.vim/spell/*.add
do
	sort -o "$f" "$f"
done
