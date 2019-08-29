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
  (test "variable assignment with literal"
        '(("a" . 1)) (interpret "a := 1;"))

  (test "variable assignment with variable"
        '(("y" . 42) ("x" . 42)) (interpret "y := x;" '(("x" . 42))))

  (test "variable assignment with expression"
        '(("x" . 2)) (interpret "x := 1 + 1;"))

  (test "variable default values"
        '(("x" . 1)) (interpret "x := y + 1;"))

  (test "loop with literal condition"
        '(("x" . 3)) (interpret "LOOP 3 DO x := x + 1; DONE;"))

  (test "loop with condition modification"
        '(("z". 2)) (interpret "LOOP z DO z := z + 1; DONE;" '(("z" . 1))))

  (test "loop with false condition"
        '() (interpret "LOOP 0 DO x := 42; DONE;")))
