(require-extension srfi-1)

(define (set-variable env variable)
  (let ((pair (assoc (car variable) env)))
    (if pair
        (begin
          (set-cdr! pair (cdr variable))
          env)
        (cons variable env))))

(define (ntimes n fn arg)
  (if (> n 0)
      (ntimes (- n 1) fn (fn arg))
      arg))

(define (variable-name lvalue)
  (assert (eq? (car lvalue) 'var))
  (cdr lvalue))

(define (variable-value env variable)
  (assert (eq? (car variable) 'var))
  (let ((value (assoc (cdr variable) env)))
    (if value (cdr value) 0)))

(define (eval-literal literal)
  (assert (eq? (car literal) 'lit))
  (cdr literal))

(define (eval-operation op)
  (assert (eq? (car op) 'op))
  (let ((o (cdr op)))
    (cond ((eq? o 'plus) +)
          ((eq? o 'minus) -)
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
  (set-variable env (cons (variable-name lvalue)
                          (eval-rvalue env rvalue))))

(define (eval-loop env cond body)
  (let ((amount (eval-rvalue env cond)))
    (ntimes amount (lambda (env)
                     (eval-loop-prog env body)) env)))

(define (eval-command comp env)
  (let ((kind (car comp)) (args (cdr comp)))
    (cond ((eq? kind 'loop)
           (eval-loop env (first args) (second args)))
          ((eq? kind 'assign)
           (eval-assign env (first args) (second args)))
          (else (error "invalid command")))))

(define (eval-loop-prog env prog)
  (fold eval-command env prog))
