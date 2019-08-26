(require-extension comparse srfi-1)
(load "parser.scm")

(define (die msg)
  (let ((port (current-error-port)))
    (display msg port)
    (newline port)
    (exit 1)))

(define (add-assoc assoc item)
  (append (list item) assoc))

(define (eval-loop env cond body)
  (error "not implemented")
  env)

(define (variable-name lvalue)
  (assert (eq? (car lvalue) 'var))
  (cdr lvalue))

(define (variable-value env variable)
  (assert (eq? (car variable) 'var))
  (cdr (assoc (cdr variable) env)))

(define (eval-literal literal)
  (assert (eq? (car literal) 'lit))
  (cdr literal))

(define (eval-expr env expr)
  (let ((kind (car expr)))
    (cond ((eq? kind 'lit)
           (eval-literal expr))
          ((eq? kind 'var)
           (variable-value env expr))
          ((eq? kind 'op)
           (error "not implemented"))
          (else (error "invalid expression")))))

(define (eval-assign env lvalue expr)
  (add-assoc env (cons (variable-name lvalue)
                       (eval-expr env expr))))

(define (eval-command env comp)
  (let ((kind (car comp)) (args (cdr comp)))
    (cond ((eq? kind 'loop)
           (eval-loop env (first args) (second args)))
          ((eq? kind 'assign)
           (eval-assign env (first args) (second args)))
          (else (error "invalid command")))))

(define (compile-program)
  (let ((prog (parse parse-program (current-input-port))))
    (if prog
        (fold eval-command '() prog)
        (die "input program is invalid"))))

(cond-expand
  ((or chicken-script compiling) (compile-program))
  (else #t))
