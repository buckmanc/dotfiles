for f in ~/.vim/spell/*.add
do
	sort -u -o "$f" "$f"
done
