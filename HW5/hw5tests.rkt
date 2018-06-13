;; CSE413 16au, Programming Languages, Homework 5

;; Jiashuo Zhang
;; CSE 413 2016au
;; hw5
#lang racket

(require "hw5.rkt")

; This file uses Racket's unit-testing framework.

; Note we have provided [only] 3 tests, but you can't run them until do some of the assignment.
; You will want to add more tests.

(require rackunit)
(define x (list (int 1) (int 3) (int 5) (int 7) (int 9)))
(define muplx (apair (int 1) (apair (int 2) (apair (int 3) (apair (int 4) (munit))))))
(define tests
  (test-suite
   "Homework 5 Tests"
   
   ;; racket to mupl list check
   (check-equal? (racketlist->mupllist x)
                 (apair (int 1) (apair (int 3) (apair (int 5) (apair (int 7) (apair (int 9) (munit)))))) "racklist to mupllist")

   ;; mupl to racket list check
   (check-equal? (mupllist->racketlist muplx)
                 (list (int 1) (int 2) (int 3) (int 4)))

   ;; first test
   (check-equal? (eval-exp (first (apair (int 3) (apair (int 3) (munit))))) (int 3))
   
   ;; ifnz and isgreater test
   (check-equal? (eval-exp (ifnz (eval-exp (isgreater (int 9) (int 10))) (int 1) (int 0)))
                 (int 0) "test ifnz and isgreater")
   ;; ifnz and isgreater test
   (check-equal? (eval-exp (ifnz (eval-exp (isgreater (int 10) (int 9))) (int 1) (int 0)))
                 (int 1) "test ifnz and isgreater")

   ;; isgreater bad argument test
   (check-exn (lambda (x) (string=? (exn-message x) "MUPL isgreater applied to non-number"))
              (lambda () (eval-exp (isgreater (int 2) (munit))))
              "isgreater bad argument")

   ;; mlet eval-exp test
   (check-equal? (eval-exp (mlet "x" (int 10) (add (int 1) (var "x"))))
                 (int 11) "mlet test")

   ;; add simple test
   (check-equal? (eval-exp (add (int 2) (int 2))) (int 4) "add simple test")

   ;; add bad argument test
   (check-exn (lambda (x) (string=? (exn-message x) "MUPL addition applied to non-number"))
              (lambda () (eval-exp (add (int 2) (munit))))
              "add bad argument")

   ;; call eval-exp test
   (check-equal? (eval-exp (call (closure '() (fun "f" "x" (add (var "x") (int 1)))) (int 10)))
                 (int 11) "call test")

   ;; call not closure test
   (check-exn (lambda (x) (string=? (exn-message x) "First argument is non-closure"))
              (lambda () (eval-exp (call (int 1) (int 10))))
              "call bad argument")
   ;; ifmunit test
   (check-equal? (eval-exp (ifmunit (munit) (int 1) (int 2))) (int 1) "ifmunit check")

   ;; mlet* test
   (check-equal? (eval-exp (mlet* (list (cons "x" (int 1))) (add (int 2) (var "x"))))
                 (int 3) "mlet* test")

   ;; ifeq test
   (check-equal? (eval-exp (ifeq (int 0) (int 1) (int 10) (int 11))) (int 11) "ifeq test")
   (check-equal? (eval-exp (ifeq (int 1) (int 1) (int 10) (int 11))) (int 10) "ifeq test")
   
   ;; final test
   ;; mupl-all-gt and mupl-filter test
   (check-equal? (mupllist->racketlist
                  (eval-exp (call (call mupl-all-gt (int 9))
                                  (racketlist->mupllist 
                                   (list (int 10) (int 9) (int 15))))))
                 (list (int 10) (int 15))
                 "provided combined test using problems 1, 2, and 4")
   ))

(require rackunit/text-ui)
;; runs the test
(run-tests tests)
