#!/bin/bash

infile="$1"
[ -f "$infile" ] || { >&2 echo "file does not exist: $infile"; exit 1; }

capitalize_words() {
	for word in $1; do
		local str="$str ${word^}"
	done
	xargs <<< "$str"
}

while read -r line; do
	if grep -qE '^[[:space:]]*[[:alnum:]_]+[[:space:]]*\[[^]]*\]' <<< "$line" && ! grep -q 'label=' <<< "$line"; then
		# get the node name as the basis for the label text
		label_text="$(grep -Eo '[[:alnum:]_]+' <<< "$line" | head -n 1 | xargs)"
		>&2 echo "label text: '$label_text'"
		# replace underscores with spaces
		label_text="$(sed -e 's/_/ /g' <<< "$label_text")"
		# capitalize words
		label_text="$(capitalize_words "$label_text")"
		# find end of attributes, and add label
		line="$(sed -e "s/\]$/ label=\"$label_text\"]/g" <<< "$line")"
	fi
	echo "$line"
	>&2 echo "$line"
done < "$infile" > "$infile.temp"
mv "$infile.temp" "$infile"
