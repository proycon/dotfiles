# Adapted from https://github.com/kurokirasama/nushell_scripts/blob/main/ollama.nu by kurokirasama , License: MIT 

export def nuplot [
  --title:string  #title
] {
  let n_cols = ($in | transpose | length)
  let name_cols = ($in | transpose | columns | first 2)

  let ylabel = if $n_cols == 1 {$name_cols | get 0} else {$name_cols | get 1}
  let xlabel = if $n_cols == 1 {""} else {$name_cols | get 0}

  let title = if ($title | is-empty) {
    if $n_cols == 1 {
      $ylabel | str upcase
    } else {
      $"($ylabel) vs ($xlabel)"
    }
  } else {
    $title
  }

  $in | to tsv | save -f tmpdata0.txt
  sed 1d tmpdata0.txt | save -f tmpdata.txt -f
  
  gnuplot -e $"set terminal png size 1024,768; unset key;set title '($title)';plot 'tmpdata.txt' w l lt 0;" | img2sixel

  rm -f tmpdata*.txt
}
