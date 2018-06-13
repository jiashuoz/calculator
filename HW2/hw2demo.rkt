Welcome to DrRacket, version 6.6 [3m].
Language: racket, with debugging; memory limit: 128 MB.
> x
'(a b c d e)
> nums
'(1 2 3 4)
> (lengtht x)
5
> (lengtht nums)
4
> (lengtht2 x)
5
> (lengtht2 nums)
4
> (poly 2 (list 1 1 1))
7
> (poly 3 (list 1 2 3))
34
> (apply-all (list sqrt double sqrt double zero?) 4)
'(2 16 2 16 #f)
> (apply-all (list number? sqrt double) 16)
'(#t 4 256)
> x
'(a b c d e)
> nums
'(1 2 3 4)
> ((all-are positive?) nums)
#t
> ((all-are number?) x)
#f
> (make-expr 4 '+ 5)
'(4 + 5)
> (make-expr '(6 * 3) '+ '(5 - 2))
'((6 * 3) + (5 - 2))
> tree
'((((1 + 2) + (2 + 2)) * 1) + ((2 * (2 + 3)) - (4 + 1)))
> (preorder tree)
'(+ * + + 1 2 + 2 2 1 - * 2 + 2 3 + 4 1)
> (inorder tree)
'(1 + 2 + 2 + 2 * 1 + 2 * 2 + 3 - 4 + 1)
> (postorder tree)
'(1 2 + 2 2 + + 1 * 2 2 3 + * 4 1 + - +)
> tree0
'((6 * 3) + (5 - 2))
> (eval-tree tree0)
21
> (eval-tree tree)
12
> (map-leaves double tree0)
'((36 * 9) + (25 - 4))
> (map-leaves double tree)
'((((1 + 4) + (4 + 4)) * 1) + ((4 * (4 + 9)) - (16 + 1)))
> (map-leaves sqrt tree)
'((((1 + 1.4142135623730951) + (1.4142135623730951 + 1.4142135623730951)) * 1)
  +
  ((1.4142135623730951 * (1.4142135623730951 + 1.7320508075688772)) - (2 + 1)))
> 