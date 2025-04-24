export def iso639-1 [] {
    let $data = http get https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes | query web --as-table ['Set 1', 'ISO Language Names','Endonym(s)']
    return $data
}

export def opengraph [url: string] {
    http get $url | query web --query 'meta[property^="og:"]' --attribute [ property content ]
}

# Web query to extract metadata from a URL
export def scrapemeta [url: string] {
    http get $url | query web --query 'meta' --attribute [ name property content ]
}

# Show a preview image for the website
export def ogimage [url: string] {
    curl --silent --output - (http get $url | query web --query 'meta[property^="og:image"]' --attribute [ content ]).0.content | img2sixel
}

# Web query for Mojeek
export def mojeek [query: string] {
    http get $"https://www.mojeek.com/search?q=($query | url encode)" | query web --as-html --query 'div.results li' | each { 
        {
            title: ($in | query web --query h2 | flatten | str join),
            url: ($in | query web --query 'a.title[href]' --attribute href | str join),
            shortdesc: ($in | query web --query p.s | flatten | str join)
        }
    }
}

# Web query for Alpine Linux packages (edge)
export def lspkg-alpine [query: string] {
    http get https://pkgs.alpinelinux.org/packages?name=($query | url encode) | query web --as-table ["Package","Version","Maintainer"]
}

