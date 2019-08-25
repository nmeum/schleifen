(require-extension comparse)

(define parse-spaces
  (zero-or-more (in #\newline #\ )))

(define (parse-string str)
  (sequence* ((_ parse-spaces)
              (v (char-seq str))
              (_ parse-spaces))
    (result v)))

(define parse-variable
  (bind (as-string (char-seq-match "^[a-zA-Z_][a-zA-Z0-9_]*"))
        (lambda (s)
          (result (cons 'var s)))))

(define parse-operator
  (any-of
    (parse-string "+")
    (parse-string "-")))

(define parse-operation
  (bind (as-string parse-operator)
        (lambda (s)
          (result (cons 'op (cond ((equal? s "+") 'plus)
                                  ((equal? s "-") 'minus)))))))

(define parse-literal
  (bind (as-string (char-seq-match "^[0-9]*"))
        (lambda (s) (result (cons 'lit (string->number s))))))

(define parse-primitive
  (any-of parse-variable parse-literal))

(define parse-expression
  (sequence parse-primitive parse-operation parse-primitive))

(define parse-value
  (any-of parse-expression parse-primitive))

(define parse-assign
  (sequence* ((var parse-variable)
              (_   (parse-string ":="))
              (val parse-value))
    (result (list 'assign var val))))

(define parse-loop
  (sequence* ((_    (parse-string "LOOP"))
              (cond parse-value)
              (body parse-loop-body))
    (result (list 'loop cond body))))

(define (parse-command)
  (bind (sequence (any-of parse-loop parse-assign) (parse-string ";"))
        (lambda (s) (result (car s)))))

(define parse-commands
  (sequence* ((_    parse-spaces)
              (prog (zero-or-more (parse-command)))
              (_    parse-spaces)
              (_    end-of-input))
    (result prog)))

(define parse-loop-body
  (enclosed-by (parse-string "DO") parse-commands (parse-string "DONE")))
