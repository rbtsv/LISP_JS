(define (Fib n)
  (if (< n 3) 1
  (+ (Fib (- n 1) ) (Fib (- n 2) )
     )))

(Fib 8)