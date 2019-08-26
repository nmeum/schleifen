(require-extension comparse srfi-1)
(load "parser.scm")

(define (die msg)
  (let ((port (current-error-port)))
    (display msg port)
    (newline port)
    (exit 1)))

(define (add-assoc assoc item)
  (append (list item) assoc))

(define (ntimes n fn arg)
  (if (> n 0)
      (ntimes (- n 1) fn (fn arg))
      arg))

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

(define (eval-loop env cond body)
  (let ((amount (eval-rvalue env cond)))
    (ntimes amount (lambda (env)
                     (eval-commands env body)) env)))

(define (eval-command comp env)
  (let ((kind (car comp)) (args (cdr comp)))
    (cond ((eq? kind 'loop)
           (eval-loop env (first args) (second args)))
          ((eq? kind 'assign)
           (eval-assign env (first args) (second args)))
          (else (error "invalid command")))))

(define (eval-commands env cmds)
  (fold eval-command env cmds))

(define (eval-program)
  (let ((prog (parse parse-program (current-input-port))))
    (if prog
        (eval-commands '() prog)
        (die "input program is invalid"))))

(define (dump-variable var seen)
  (if (member (car var) seen)
      seen
      (begin
        (display (car var)) (display ": ")
        (display (cdr var)) (newline)
        (append (list (car var)) seen))))

(define (main)
  (let ((vars (eval-program)))
    (fold dump-variable '() vars)))

(cond-expand
  ((or chicken-script compiling) (main))
  (else #t))
