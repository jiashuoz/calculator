#lang racket

;; CSE 413 HW4
;; Jiashuo Zhang

(provide red-blue)
(provide take)
(provide combm)

;; Problem 1
(define red-blue (lambda () (cons '"red" blue)))
(define blue (lambda () (cons '"blue" red-blue)))

;; Problem 2
(define (take st n)
  (cond ((null? st) '())
        ((negative? n) '())
        ((= n 0) '())
        (else (cons (car (st)) (take (cdr (st)) (- n 1))))))

;; Problem 3
(define combm
  (letrec ([memo null]
           [fact (lambda (n)
                   (if (< n 2)
                       1
                       (* n (fact (- n 1)))))]
           [comb (lambda (n k)
                   (let ([ans (assoc (list n k) memo)])
                     (if ans
                         (cdr ans)
                         (let ([new-ans (if (< n 2)
                                            1
                                            (/ (fact n)
                                               (* (fact k) (fact (- n k)))))])
                           (begin
                             (set! memo (cons (cons (list n k) new-ans) memo))
                             new-ans)))))])
    comb))

