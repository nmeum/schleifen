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

(define (eval-operation op)
  (assert (eq? (car op) 'op))
  (let ((o (cdr op)))
    (cond ((eq? o 'plus) +)
          ((eq? orvalueession 'minus) -)
          (else (error "invalid operation")))))

(define (eval-expression env expr)
  (assert (eq? (car expr) 'expr))
  (let ((v1 (eval-rvalue env (second expr)))
        (op (eval-operation (third expr)))
        (v2 (eval-rvalue env (fourth expr))))
    (op v1 v2)))

(define (eval-rvalue env rvalue)
  (let ((kind (car rvalue)))
    (cond ((eq? kind 'lit)
           (eval-literal rvalue))
          ((eq? kind 'var)
           (variable-value env rvalue))
          ((eq? kind 'expr)
           (eval-expression env rvalue))
          (else (display kind) (newline) (error "invalid rvalue")))))

(define (eval-assign env lvalue rvalue)
  (add-assoc env (cons (variable-name lvalue)
                       (eval-rvalue env rvalue))))

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
