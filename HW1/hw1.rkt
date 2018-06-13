#lang racket
;; CSE 413 16au
;; Homework 1
;; Jiashuo Zhang


;; helper method: length of lst
(define (len lst)
  (if (null? lst)
      0
      (+ 1 (len (cdr lst)))))

;; Problem 1
(define (comb n k)
  (if (< n 2)
      1
      (/ (fact n) (* (fact k) (fact (- n k))))))
;; factorial of n
(define (fact n)
  (if (< n 2)
      1
      (* n (fact (- n 1)))))

;; Problem 2
(define (zip lst1 lst2)
  (cond ((zero? (len lst1)) lst2)
        ((zero? (len lst2)) lst1)
        (else (append (list (car lst1) (car lst2)) (zip (cdr lst1) (cdr lst2))))))

;; Problem 3
(define (unzip lst)
  (append (list (unzipA lst)) (list (unzipB lst))))
;; two helper methods unzipA and unzipB
(define (unzipA lst)
  (cond ((null? lst) '())
        ((equal? 1 (len lst)) lst)
        (else (append (list (car lst)) (unzipA (cddr lst))))))
(define (unzipB lst)
  (cond ((null? lst) '())
        ((equal? 1 (len lst)) '())
        (else (append (list (cadr lst)) (unzipB (cddr lst))))))
  
;; Problem 4
(define (expand lst)
  (cond ((null? lst) lst)
        ((list? (car lst)) (append (mkCopy (car lst)) (expand (cdr lst))))
        (else (append (list (car lst)) (expand (cdr lst))))))
;; helper
(define (mkCopy lst)
  (cond ((< (car lst) 2) (cdr lst))
        (else (append (mkCopy (append (list (- (car lst) 1)) (cdr lst)))
                      (cdr lst)))))

;; Problem 5
(define (treeNode value left right) (list value left right))
;; a. node
(define (value treeNode)
  (car treeNode))

(define (left treeNode)
  (cadr treeNode))

(define (right treeNode)
  (caddr treeNode))

;; b. size
(define (size tree)
  (cond ((null? tree) 0)
        (else (+ 1 (+ (size (left tree)) (size (right tree)))))))

;; c. contains
(define (contains item tree)
  (cond ((null? tree) #f)
        ((equal? item (value tree)) #t)
        (else (or (contains item (left tree)) (contains item (right tree))))))

;; d. leaves
(define (leaves tree)
  (cond ((null? tree) '())
        ((and (null? (left tree)) (null? (right tree))) (list (value tree)))
        (else (append (leaves (left tree)) (leaves (right tree))))))

;; e. isBST
(define (isBST tree)
  (cond ((null? tree) #t)
        ((and (null? (left tree)) (null? (right tree))) #t)
        ((and (> (value tree) (max (left tree))) (< (value tree) (min (right tree))))
                   (and #t (and (isBST (left tree)) (isBST (right tree)))))
        (else #f)))
;; maximum value in a tree
(define (max tree)
  (cond ((null? tree) -inf.f)
        ((and (null? (left tree)) (null? (right tree))) (value tree))
        ((and (> (max (left tree)) (value tree))(> (max (left tree)) (max (right tree)))) (max (left tree)))
        ((and (> (max (right tree)) (value tree)) (> (max (right tree)) (max (left tree)))) (max (right tree)))
        (else (value tree))))
;; minimum value in a tree
(define (min tree)
  (cond ((null? tree) +inf.f)
        ((and (null? (left tree)) (null? (right tree))) (value tree))
        ((and (< (min (left tree)) (value tree)) (< (min (left tree)) (min (right tree)))) (min (left tree)))
        ((and (< (min (right tree)) (value tree)) (< (min (right tree)) (min (left tree)))) (min (right tree)))
        (else (value tree))))

;; test tree
(define x '(10 (5 (1 () ()) (50 () ())) (20 () (21 (19 () ()) ()))))