#lang racket

;; CSE 413 HW4 test
;; Jiashuo Zhang 1365330
;; Test file for hw4.rkt

(require rackunit)
(require "hw4.rkt")

;; Problem 1
;; First element of red-blue stream
(check-equal? (car (red-blue)) "red" "first element")
(check-equal? (procedure? (cdr (red-blue))) #true)
(check-equal? (car ((cdr (red-blue)))) "blue")
(check-equal? (car ((cdr ((cdr (red-blue)))))) "red")

;; Problem 2
;; Check take function extracts the correct values
; stream of powers of 2
(define powers-of-two
  (letrec ([f (lambda (x) (cons x (lambda () (f (* x 2)))))])
    (lambda () (f 2))))

(check-equal? (take red-blue 10)
              '("red" "blue" "red" "blue" "red" "blue" "red" "blue" "red" "blue"))
(check-equal? (take '() 3) '())
(check-equal? (take red-blue -10) '())
(check-equal? (take powers-of-two 4) '(2 4 8 16))

;; Problem 3
(check-equal? (combm 2 10) 1/1814400)
(check-equal? (combm 5 10) 1/30240)

 ;; I used two ways to test if combm is working properly
 ;; 1: substitute memo with mem that's defined in global env and print out mem
 ;; 2: when an answer is found in memo, print out some string other than the result
 ;; Below is the test-version of combm
(define mem null)
(define combtest
  (letrec ([memo null]
           [fact (lambda (n)
                   (if (< n 2)
                       1
                       (* n (fact (- n 1)))))]
           [comb (lambda (n k)
                   (let ([ans (assoc (list n k) mem)])
                     (if ans
                         "yeah found it"
                         (let ([new-ans (if (< n 2)
                                            1
                                            (/ (fact n)
                                               (* (fact k) (fact (- n k)))))])
                           (begin
                             (set! mem (cons (cons (list n k) new-ans) mem))
                             new-ans)))))])
    comb))

(combtest 2 10)
mem
(combtest 3 10)
mem
(combtest 2 10)
