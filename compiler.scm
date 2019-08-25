(require-extension comparse)
(load "parser.scm")

(define (die msg)
  (let ((port (current-error-port)))
    (display msg port)
    (newline port)
    (exit 1)))

(define (compile-component c)
  (when c
    (display (car c))
    (newline)))

(define (compile-program)
  (let ((prog (parse parse-commands (current-input-port))))
    (if prog
        (for-each compile-component prog)
        (die "input program is invalid"))))

(cond-expand
  ((or chicken-script compiling) (compile-program))
  (else #t))
