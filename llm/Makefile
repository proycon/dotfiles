.PHONY: zh en ru es de fr pt it nl synonyms ner chat

zh en ru es de fr pt it nl:
	(ollama list | grep gemma-translator-$@) || ollama create gemma-translator-$@ -f gemma-translator-$@.modelfile
	@while true; do read -p "> " prompt && ollama run gemma-translator-$@ "$$prompt"; done

synonyms:
	ollama create gemma-synonyms -f gemma-synonyms.modelfile
	ollama run gemma-synonyms

ner:
	ollama create gemma-ner -f gemma-ner.modelfile
	ollama run gemma-ner

chat:
	ollama run deepseek-r1:14b
