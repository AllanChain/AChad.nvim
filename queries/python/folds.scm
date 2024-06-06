; doc-strings
(class_definition
  body:
    (block
      .
      (expression_statement
        (string) @fold)))

(function_definition
  body:
    (block
      .
      (expression_statement
        (string) @fold)))

; comments at the start of the file
(module
  .
  (comment)+ @fold
)
