# Adapted from https://github.com/kurokirasama/nushell_scripts/blob/main/ollama.nu by kurokirasama , License: MIT 

use std/log

export def llm [
  prompt?: string
  --model(-m): string
] {
  if (ps | where name == "ollama" | length) == 0 {
        log info "ollama is not running yet..starting (may take a bit)..."
        job spawn { ollama serve e> /tmp/ollama.log }
        while (ollama ps | complete).exit_code != 0 {
            sleep 2sec
        }

  }
  let runningmodel = try { (ollama ps | detect columns | first).name } catch { "" }
  let prompt = if ($prompt | is-empty) {$in} else {$prompt}
  let model =  if ($runningmodel | is-empty) { if ($model | is-empty) {ollama list | detect columns  | get NAME | input list -f (echo "Select model:")} else {$model} } else { $runningmodel }

  let data = {
    model: $model,
    prompt: $prompt,
    stream: false
  }
  
  let url = "http://localhost:11434/api/generate"
  let response = http post $url --content-type application/json $data
  
  if ($response | get error? | is-empty) {
    $response | get response
  } else {
    return-error $"Error: ($response | get error)"
  }
}
