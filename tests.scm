(import test)

(include "parser.scm")
(include "interpreter.scm")

(define (interpret str #!optional (env '()))
  (let ((prog (parse-loop-prog str)))
    (if prog
      (eval-loop-prog env prog)
      #f)))

(test-group "parser"
  (test "variable assignment with literal"
        '((assign (var . "x")
                  (lit . 5)))
        (parse-loop-prog "x := 5;"))

  (test "variable assignment with expression"
        '((assign (var . "y")
                  (expr (var . "y")
                        (op . minus)
                        (var . "y"))))
        (parse-loop-prog "y:=y-y;"))

  (test "variable assign with variable"
        '((assign (var . "a") (var . "b")))
        (parse-loop-prog "a:=b;"))

  (test "loop with variable condition"
        '((loop (var . "x")
                ((assign (var . "x") (var . "x")))))
        (parse-loop-prog "LOOP x DO x:=x; DONE;"))

  (test "loop with loop in body"
        '((loop (lit . 1)
                ((loop (lit . 2)
                       ((assign (var . "x") (lit . 5)))))))
        (parse-loop-prog "LOOP 1 DO LOOP 2 DO x:=5; DONE; DONE;"))

  (test "sequence of multiple assignments"
        '((assign (var . "x") (lit . 1))
          (assign (var . "x") (lit . 2)))
        (parse-loop-prog "x := 1; x := 2;")))

(test-group "interpreter"
  (test "variable assignment with variable"
        '(("y" . 42) ("x" . 42)) (interpret "y := x;" '(("x" . 42)))))
