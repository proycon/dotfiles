#!/usr/bin/env python3

tags = ""
seen = set()
begin = False
with open("/home/proycon/.muttrc","r",encoding="utf-8") as f:
    for line in f:
        if line.startswith("tag-formats"):
            begin = True
            
        if begin:
            offset = line.find("\"G")
            if offset != -1:
                item = line[offset+1:].split("\"")[0]
                if item not in seen:
                    tags += f"%?{item}?%{item}&?"
                    seen.add(item)
        
print(tags)
