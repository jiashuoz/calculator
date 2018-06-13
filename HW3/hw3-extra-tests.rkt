#lang racket
;; CSE 413
;; Extra Test file for hw3.rck
;; Jiashuo Zhang
(require rackunit)
(require "hw3-extra.rkt")


;; chain rule
;; (x^2 + x^3 + yx + y)^3 ==>
;;                (2x + 3x^2 + y) * 3(x^2 + x^3 + yx + y)^2
(check-equal? (diff 'x '(expt (+ (* x x) (expt x 3) (* y x) y) 3))
              '(* (+ (+ (* x 1) (* x 1))
                     (* 1 (* 3 (expt x 2)))
                     (+ (* y 1) (* x 0))
                     0)
                  (* 3 (expt (+ (* x x) (expt x 3) (* y x) y) 2)))
              "(x^2 + x^3 + yx + y)^3 chain rule")

;; e's exponential
 ;; e^x ==> e^x
(check-equal? (diff 'x '(expt e x)) '(* 1 (expt e x)))
 ;; e^(2x) ==> 2e^(2x)
(check-equal? (diff 'x '(expt e (* 2 x)))
              '(* (+ (* 2 1) (* x 0)) (expt e (* 2 x))))
 ;; e^y w.r.t y ==> 0
(check-equal? (diff 'x '(expt e y)) '(* 0 (expt e y)))
 ;; e^(yx) ==> ye^(yx)
(check-equal? (diff 'x '(expt e (* y x)))
              '(* (+ (* y 1) (* x 0)) (expt e (* y x))))
 ;; e^(x^2 + 2x) ==> (2x + 2) * e^(x^2 + 2x)
(check-equal? (diff 'x '(expt e (+ (expt x 2) (* 2 x) y)))
              '(* (+ (* 1 (* 2 (expt x 1))) (+ (* 2 1) (* x 0)) 0)
                  (expt e (+ (expt x 2) (* 2 x) y))))