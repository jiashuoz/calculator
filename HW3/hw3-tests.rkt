#lang racket

;; CSE 413
;; Jiashuo Zhang
;; Test file for hw3.rck

(require rackunit)
(require "hw3.rkt")

;; Check simple cases
  ;; constant
(check-equal? (diff 'x '4) 0 "derivative of constant")
  ;; w.r.t y
(check-equal? (diff 'x 'y) 0 "w.r.t different variable")
  ;; x*y ==> y
(check-equal? (diff 'x '(* x y)) '(+ (* x 0) (* y 1)))
  ;; x ==> 1
(check-equal? (diff 'x 'x) 1 "derivative of x")
  ;; '() ==> 0
(check-equal? (diff 'x '()) 0 "derivative of empty list")
  ;; w.r.t '(), has no meaning, force it to be 0
(check-equal? (diff '() '(+ x y))
              '(+ 0 0) "w.r.t empty list")
 ;; '() w.r.t '(), has no meaning, leave it to be 1
(check-equal? (diff '() '()) 1)

;; x + x + x
(check-equal? (diff 'x '(+ x x x)) '(+ 1 1 1) "sum of x")

;; 2x
(check-equal? (diff 'x '(* 2 x)) '(+ (* 2 1) (* x 0)) "product")

;; x + y + z + 2x
(check-equal? (diff 'x '(+ x y z (* 2 x)))
              '(+ 1 0 0 (+ (* 2 1) (* x 0))) "sum of product")

;; x + x * x
(check-equal? (diff 'x '(+ x (* x x)))
              '(+ 1 (+ (* x 1) (* x 1))) "sum of product")

;; x^4
(check-equal? (diff 'x '(expt x 4))
              '(* 1 (* 4 (expt x 3))) "x polynomial")

;; x^4 w.r.t y
(check-equal? (diff 'y '(expt x 4)) 0 "w.r.t different variable")

;; x^2 + 2x + 1
(check-equal? (diff 'x '(+ (expt x 2) (* 2 x) 1))
              '(+ (* 1 (* 2 (expt x 1))) (+ (* 2 1) (* x 0)) 0)
              "sum of product and polynomial")

;; 3x^2 + yx + y
(check-equal? (diff 'x '(+ (* 3 (expt x 2)) (* x y) y))
              '(+ (+ (* 3 (* 1 (* 2 (expt x 1))))
                     (* (expt x 2) 0))
                  (+ (* x 0) (* y 1))
                  0)
              "3x^2 + yx + y ==> 3x + y + 0")
