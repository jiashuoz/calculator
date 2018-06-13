#lang racket

;; Oct 20, 2016
;; Jiashuo Zhang 1365330
;; CSE 413 Homework 3

(provide diff)
;; extract elements from the formula list
(define (get-optr E) (car E))
(define (fst-op E) (cadr E))
(define (scd-op E) (caddr E))
(define (allop E) (cdr E))
(define (fst-oprd lst) (car lst))

;; extract elements from the table
(define (matchOptr table) (caar table))
(define (pickOptr table) (cadar table))
(define (otherEntry table) (cdr table))

;; make formula based on operators
(define (make-sum alist) (cons '+ alist))
(define (make-mul alist) (cons '* alist))

;; derivative of constant
(define (diff-constant x E) 0)
;; derivative of the original variable itself
(define (diff-x x E) 1)

;; SUM derivative
(define (diff-sum x E)
  (cond ((null? E) '())
        (else (make-sum (sumaux x (cdr E))))))
  ;; sum helper function
(define (sumaux x lst)
  (if (null? lst)
      '()
      (append (list (diff x (car lst))) (sumaux x (cdr lst)))))

;; PRODUCT derivative
(define (diff-product x E)
  (cond ((null? E) '())
        (else (make-sum (list (append '(*) (list (fst-op E)) (list (diff x (scd-op E))))
                 (make-mul (list (scd-op E) (diff x (fst-op E)))))))))

;; EXPT derivative
;; chain rule implemented, e^x implemented
(define (diff-expt x E)
  (cond ((null? E) '())
        ((equal? (fst-op E) 'e) (make-mul (list (diff 'x (scd-op E)) E)))
        ((and (not (equal? x (fst-op E))) (not (list? (fst-op E)))) 0)
        ((not (contains x E)) 0) 
        (else (append '(*)
                      (list (diff 'x (fst-op E)))
                      (list (append '(*)
                              (list (scd-op E))
                              (list (cons 'expt (list (fst-op E) (- (scd-op E) 1))))))))))

;; DISPATCH table
(define diff-dispatch
  (list (list '+ diff-sum)
        (list '* diff-product)
        (list 'expt diff-expt)))

;; DIFF function
(define (diff x E)
  (cond ((number? E) (diff-constant x E))
        ((equal? x E) (diff-x x E))
        ((not (pair? E)) 0)
        (else ((pickOp E diff-dispatch) x E))))

;; pick operation from the dispatch table
(define (pickOp E table)
  (cond ((equal? (get-optr E) (matchOptr table)) (pickOptr table))
        (else (pickOp E (otherEntry table)))))

;; Helper function to check if a list contains a given element
(define (contains x lst)
  (cond ((null? lst) #f)
        ((number? lst) #f)
        ((equal? x lst) #t)
        ((and (not (list? lst)) (not (equal? x lst))) #f)
        (else (or (contains x (cadr lst)) (contains x (caddr lst))))))


;; Simplify function (NOT COMPLETED) ToT
(define (simplify lst x)
  (if (null? lst)
      '()
      (simp lst x)))
(define (simp lst x)
  (cond ((number? lst) lst)
        ((nand (number? lst) (list? lst)) lst)
        ((and (equal? (get-optr lst) '*) (number? (fst-op lst)) (number? (scd-op lst)) (zero? (scd-op lst)))
         0)
        ((equal? (get-optr lst) '+) (cond ((and (zero? (fst-op lst)) (zero? (scd-op lst))) 0)
                                          ((and (zero? (fst-op lst)) (not (zero? (scd-op lst))))
                                           (scd-op lst))
                                          ((and (not (zero? (fst-op lst))) (zero? (scd-op lst)))
                                           (fst-op lst))))
        (else (append (simp (fst-op lst) x) (simp (scd-op lst) x)))))
  ;; pick operation
(define (getOp x)
  (cond ((equal? x '+) +)
        ((equal? x '-) -)
        ((equal? x '*) *)
        ((equal? x '/) /)))
