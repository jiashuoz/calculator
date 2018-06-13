Welcome to DrRacket, version 6.6 [3m].
Language: racket, with debugging; memory limit: 128 MB.
> (fact 2)
2
> (fact 4)
24
> (len '(1 2 3))
3
> (len '())
0
> (comb 3 2)
3
> (comb 5 1)
5
> (comb 10 2)
45
> (zip '(a b c) '(x y z))
'(a x b y c z)
> (zip '(1 2) '(w x y z))
'(1 w 2 x y z)
> (zip '() '(a b c))
'(a b c)
> (unzip '(a b c d e f))
'((a c e) (b d f))
> (unzip '(a b c d e f))
'((a c e) (b d f))
> (unzip '(a b c d e f g))
'((a c e g) (b d f))
> (expand '(a (3 b) (3 a) b (2 c) (3 a)))
'(a b b b a a a b c c a a a)
> (expand '())
'()
> x
'(10 (5 (1 () ()) (50 () ())) (20 () (21 (19 () ()) ())))
> (value x)
10
> (right x)
'(20 () (21 (19 () ()) ()))
> (left x)
'(5 (1 () ()) (50 () ()))
> (value (left x))
5
> (value (left (left x)))
1
> (size x)
7
> (size (right x))
3
> (contains 50 x)
#t
> (contains 21 (left x))
#f
> (contains 1 (right x))
#f
> (contains 19 (right x))
#t
> (leaves x)
'(1 50 19)
> (leaves '(1 (2 () ()) (3 (4 () ()) ())))
'(2 4)
> (isBST x)
#f
> (isBST '(10 (5 (1 () ()) (50 () ())) (20 () (21 () ()))))
#f
> (isBST '(10 (5 (1 () ()) ()) (20 () (21 () ()))))
#t
> (isBST '(3 (1 () ()) (5 () ())))
#t
> 