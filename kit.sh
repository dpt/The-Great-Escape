rm -rf TheGreatEscape 
sna2skool.py -c TheGreatEscape.ctl -M TheGreatEscape.prof TheGreatEscape.z80 > TheGreatEscape.skool 
skool2html.py -H TheGreatEscape.skool
