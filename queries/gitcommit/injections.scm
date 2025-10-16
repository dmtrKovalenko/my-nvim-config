; Inject text language for word-level Git keyword highlighting
; Text parser should tokenize individual words
((message_line) @injection.content
 (#set! injection.language "markdown"))
