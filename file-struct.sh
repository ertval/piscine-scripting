#!/usr/bin/env bash

mkdir -p struct/3 struct/4 struct/A

touch struct/0 struct/1 struct/2 struct/5 struct/6 struct/7 struct/8 struct/9

echo "text" > struct/3/text.txt
echo "text2" > struct/4/text2.txt
echo "text3" > struct/A/text3.txt

cd struct && tar -cf ../file-struct.tar *
