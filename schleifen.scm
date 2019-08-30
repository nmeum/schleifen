(import (chicken irregex)
        (chicken process-context)
        srfi-1)

(include "parser.scm")
(include "interpreter.scm")

(define (die msg)
  (let ((port (current-error-port)))
    (display msg port)
    (newline port)
    (exit 1)))

(define (dump-variable var)
  (display (car var)) (display ": ")
  (display (cdr var)) (newline))

(define (string->variable str)
  (let ((kv (irregex-split (irregex "=") str)))
    (if (= (length kv) 2)
        (cons (first kv) (string->number (second kv)))
        (die (string-append "invalid assignment: " str)))))

(define (initial-variables)
  (let ((args (argv)))
    (if (> (length args) 1)
        (map string->variable (cdr args))
        '())))

(define (main)
  (let ((prog (parse-loop-prog (current-input-port))))
    (if prog
        (let ((vars (eval-loop-prog (initial-variables) prog)))
          (for-each dump-variable vars))
        (die "input program is invalid"))))

(cond-expand
  ((or chicken-script compiling) (main))
  (else #t))
