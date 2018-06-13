;; CSE413 16au, Programming Languages, Homework 5

;; Jiashuo Zhang
;; 1365330
;; CSE 413 2016au
#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct isgreater (e1 e2)    #:transparent) ;; if e1 > e2 then 1 else 0
(struct ifnz (e1 e2 e3) #:transparent) ;; if not zero e1 then e2 else e3
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body) 
(struct apair   (e1 e2) #:transparent) ;; make a new pair
(struct first   (e)     #:transparent) ;; get first part of a pair
(struct second  (e)     #:transparent) ;; get second part of a pair
(struct munit   ()      #:transparent) ;; unit value -- good for ending a list
(struct ismunit (e)     #:transparent) ;; if e1 is unit then 1 else 0
(struct nop (e)     #:transparent) ;; if e1 is unit then 1 else 0

;; a closure is not in "source" programs; it is what functions evaluate to
(struct closure (env fun) #:transparent) 

;; Problem 1
  ;; a
(define (racketlist->mupllist lst)
  (cond [(null? lst) (munit)]
        [#t (apair (car lst) (racketlist->mupllist (cdr lst)))]))
  ;; b
(define (mupllist->racketlist lst)
  (cond [(munit? lst) '()]
        [(munit? (apair-e1 lst)) (mupllist->racketlist (apair-e2 lst))]
        [#t (cons (apair-e1 lst) (mupllist->racketlist (apair-e2 lst)))]))

;; CHANGE (put your solutions here)

;; Problem 2
;; lookup a variable in an environment
;; Do NOT change this function
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; Do NOT change the two cases given to you.  
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  (cond [(var? e) 
         (envlookup env (var-string e))]
        [(add? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        [(munit? e) e]
        [(int? e) e]
        [(closure? e) e]
        [(isgreater? e)
         (let ([v1 (eval-under-env (isgreater-e1 e) env)]
               [v2 (eval-under-env (isgreater-e2 e) env)])
           (if (and (int? v1) (int? v2))
               (if (> (int-num v1) (int-num v2))
                   (int 1)
                   (int 0))
               (error "MUPL isgreater applied to non-number")))]
        [(ifnz? e)
         (let ([v (eval-under-env (ifnz-e1 e) env)])
           (if (int? v)
               (if (= (int-num v) 0)
                   (eval-under-env (ifnz-e3 e) env)
                   (eval-under-env (ifnz-e2 e) env)
                   )
               (error "argument is not an int!")))]
        [(mlet? e)
         (letrec ([v (eval-under-env (mlet-e e) env)]
                  [newenv (cons (cons (mlet-var e) v) env)])
           (eval-under-env (mlet-body e) newenv))]
        [(apair? e)
         (let ([v1 (eval-under-env (apair-e1 e) env)]
               [v2 (eval-under-env (apair-e2 e) env)])
           (apair v1 v2))]
        [(first? e)
         (let ([v (eval-under-env (first-e e) env)])
           (if (apair? v)
               (apair-e1 v)
               (error "MUPL first applied to non-pair")))]
        [(second? e)
         (let ([v (eval-under-env (second-e e) env)])
           (if (apair? v)
               (apair-e2 v)
               (error "MUPL second applied to non-pair")))]
        [(ismunit? e)
         (let ([v (eval-under-env (ismunit-e e) env)])
           (if (munit? v)
               (int 1)
               (int 0)))]
        [(fun? e) (closure env e)]
        [(call? e)
         (letrec ([clo (eval-under-env (call-funexp e) env)]
               [rst (eval-under-env (call-actual e) env)])
           (if (closure? clo)
               (eval-under-env (fun-body (closure-fun clo))
                         (if (null? (fun-nameopt (closure-fun clo)))
                             (closure-env clo)
                             (cons (cons (fun-nameopt (closure-fun clo)) clo) (cons
                                                       (cons (fun-formal (closure-fun clo)) rst)
                                                       (closure-env clo)))))
               (error "First argument is non-closure")))]
        ; CHANGE add more cases here
        [#t  (error (format "bad MUPL expression: ~v" e))]))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))
        
;; Problem 3

(define (ifmunit e1 e2 e3)
  (ifnz (ismunit e1) e2 e3))

(define (mlet* bs e2)
  (if (null? bs)
      e2
      (let ([frstPair (car bs)]
            [restPair (cdr bs)])
        (mlet (car frstPair) (cdr frstPair) (mlet* restPair e2)))))

(define (ifeq e1 e2 e3 e4)
  (mlet* (list (cons "_x" e1) (cons "_y" e2))
    (ifnz (isgreater (var "_x") (var "_y"))
                     e4
                     (ifnz (isgreater (var "_y") (var "_x"))
                           e4
                           e3))))

;; Problem 4

(define mupl-filter
  (fun "mulpf" "f"
       (fun "recurf" "lst"
            (ifmunit (var "lst")
                     (munit)
                     [ifnz (call (var "f") (first (var "lst")))
                           (apair (first (var "lst"))
                            (call (var "recurf") (second (var "lst"))))
                           (call (var "recurf") (second (var "lst")))
                           ]))))

  
(define mupl-all-gt
  (mlet "filter" mupl-filter
        (fun "mupl-gt-i" "i"
             (fun "mupl-gt-lst" "lst"
                  (call (call (var "filter") (fun "gt-i" "x" (isgreater (var "x") (var "i"))))
                        (var "lst"))))))

;; Challenge Problem (extra credit)

(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; a recursive(?) 1-argument function

;; We will test this function directly, so it must do
;; as described in the assignment
(define (compute-free-vars e) "CHANGE")

;; Do NOT share code with eval-under-env because that will make grading
;; more difficult, so copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env) "CHANGE")

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))