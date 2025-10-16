; Custom highlights for git commit editor to work with markdwon like syntax

(title) @function

(branch) @string

(change) @keyword

(filepath) @string

(arrow) @punctuation.delimiter

(subject
  (subject_prefix) @function @nospell)

(prefix
  (type) @keyword @nospell)

(prefix
  (scope) @variable.parameter @nospell)

(prefix
  [
   "("
   ")"
   ":"
   ] @punctuation.delimiter)

(prefix
  "!" @punctuation.special)

(message) @spell

(trailer
  (token) @label)

; (trailer (value) @none)
(breaking_change
  (token) @comment.error)

(breaking_change
  (value) @none @spell)

(scissor) @comment

; Capture all nodes that start with semicolon as comments
((_) @comment
 (#match? @comment "^;.*"))

; Makes markdown like headers starting with # highlighted
((_) @function
 (#match? @function "^#.*"))

