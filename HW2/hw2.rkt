#lang racket

;; CSE 413 16au
;; Homework 2
;; Jiashuo Zhang

;; Part II
;; Problem 1
  ;; a.
(define (lengtht lst)
  (lengthtaux lst 0))

(define (lengthtaux lst n)
  (if (null? lst)
      n
      (lengthtaux (cdr lst) (+ n 1))))
  ;; b.
(define (lengtht2 lst)
  (letrec ([aux (lambda (lst acc)
                  (if (null? lst)
                      acc
                      (aux (cdr lst) (+ 1 acc))))])
    (aux lst 0)))


;; Problem 2
(define (poly x coeff)
  (letrec ([aux (lambda (x coeff acc n)
                  (if (null? coeff)
                      acc
                      (aux x (cdr coeff) (+ acc (* (car coeff) (pow x n))) (+ n 1))))])
    (aux x coeff 0 0)))
;; x to the power of n
(define (pow x n)
  (if (= n 0)
      1
      (* x (pow x (- n 1)))))


;; Problem 3
(define (apply-all lst x)
  (cond ((null? lst) '())
        (else (cons ((car lst) x) (apply-all (cdr lst) x)))))


;; Problem 4
(define all-are
  (lambda (op)
    (lambda (lst)
      (if (null? lst)
          #t
          (and (op (car lst)) ((all-are op) (cdr lst)))))))



;; Part III
;; Problem 1
(define (make-expr left-op operator right-op)
  (list left-op operator right-op))
(define (operator expr) (cadr expr))
(define (left-op expr) (car expr))
(define (right-op expr) (caddr expr))

;; Problem 2
  ;; preorder
(define (preorder expr-tree)
  (if (number? expr-tree)
      (list expr-tree)
      (append (list (operator expr-tree))
              (preorder (left-op expr-tree))
              (preorder (right-op expr-tree)))))
  ;; inorder
(define (inorder expr-tree)
  (if (number? expr-tree)
      (list expr-tree)
      (append (inorder (left-op expr-tree))
              (list (operator expr-tree))
              (inorder (right-op expr-tree)))))
  ;; postorder
(define (postorder expr-tree)
  (if (number? expr-tree)
      (list expr-tree)
      (append (postorder (left-op expr-tree))
              (postorder (right-op expr-tree))
              (list (operator expr-tree)))))


;; Problem 3
(define (eval-tree expr-tree)
  (if (number? expr-tree)
      expr-tree
      ((pickOp (operator expr-tree))
       (eval-tree (left-op expr-tree))
       (eval-tree (right-op expr-tree)))))
  ;; pick operation
(define (pickOp x)
  (cond ((equal? x '+) +)
        ((equal? x '-) -)
        ((equal? x '*) *)
        ((equal? x '/) /)))


;; Problem 4
(define (map-leaves f expr-tree)
  (car (aux f expr-tree)))
  ;; aux function
(define (aux f expr-tree)
  (cond ((number? expr-tree) (list (f expr-tree)))
        (else (list (append (aux f (left-op expr-tree))
                      (list (operator expr-tree))
                      (aux f (right-op expr-tree)))))))

;; Test
(define x '(a b c d e))
(define nums '(1 2 3 4))
(define tree0 '((6 * 3) + (5 - 2)))
(define tree '((((1 + 2) + (2 + 2)) * 1) + ((2 * (2 + 3)) - (4 + 1))))
(define (double n) (* n n))