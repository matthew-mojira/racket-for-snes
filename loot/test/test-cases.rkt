#lang racket

(require "make-test.rkt")

;; REGULAR TESTS

;; Abscond examples
(make-test '(7) 7)
(make-test '(-8) -8)
(make-test '(0) 0)
(make-test '(16383) 16383)
(make-test '(-16384) -16384)

;; Blackmail examples
(make-test '((add1 0)) 1)
(make-test '((add1 -1)) 0)
(make-test '((sub1 1)) 0)
(make-test '((add1 (add1 7))) 9)
(make-test '((add1 (sub1 7))) 7)
(make-test '((add1 (add1 0))) 2)
(make-test '((add1 (add1 -1))) 1)
(make-test '((add1 (sub1 9999))) 9999)
(make-test '((add1 (add1 (add1 (add1 -4730))))) -4726)

;; Con examples
(make-test '((if (zero? 0) 1 2)) 1)
(make-test '((if (zero? 1) 1 2)) 2)
(make-test '((if (zero? -7) 1 2)) 2)
(make-test '((if (zero? (add1 -7)) 1 (add1 2))) 3)
(make-test '((if (zero? (add1 -1)) 1 (add1 2))) 1)
(make-test '((if (zero? 0) (if (zero? 1) 1 2) 7)) 2)
(make-test '((if (zero? (if (zero? 0) 1 0)) (if (zero? 1) 1 2) 7)) 7)

;; Dupe examples
(make-test '(#t) #t)
(make-test '(#f) #f)
(make-test '((if #t 1 2)) 1)
(make-test '((if #f 1 2)) 2)
(make-test '((if 0 1 2)) 1)
(make-test '((if #t 3 4)) 3)
(make-test '((if #f 3 4)) 4)
(make-test '((if 0 3 4)) 3)
(make-test '((if 0 #f #t)) #f)
(make-test '((if #f 4 (if 3 1 2))) 1)
(make-test '((zero? 4)) #f)
(make-test '((zero? 0)) #t)
(make-test '((zero? (sub1 1))) #t)
(make-test '((zero? (sub1 (sub1 1)))) #f)

;; Dodger examples
(make-test '(#\a) #\a)
(make-test '(#\b) #\b)
(make-test '((char? #\a)) #t)
(make-test '((char? (char->integer #\a))) #f)
(make-test '((char? (integer->char (char->integer #\a)))) #t)
(make-test '((char? #t)) #f)
(make-test '((char? 8)) #f)
(make-test '((char->integer #\a)) (char->integer #\a))
(make-test '((if (char? #\f) #\t #\f)) #\t)

;; Extort examples
(make-test '((add1 #f)) 'err)
(make-test '((sub1 #f)) 'err)
(make-test '((zero? #f)) 'err)
(make-test '((add1 #\f)) 'err)
(make-test '((sub1 #\f)) 'err)
(make-test '((zero? #\f)) 'err)
(make-test '((if (zero? #f) 1 2)) 'err)
(make-test '((char->integer #f)) 'err)
(make-test '((integer->char #f)) 'err)
(make-test '((integer->char -1)) 'err)
; testing for valid print arguments are done implicitly by the fact that
; _every_ single test calls print-value (which will defer to the primitives
; eventually)
(make-test '((print-int (add1 #f))) 'err)
(make-test '((print-int #f)) 'err)
(make-test '((print-int #\f)) 'err)
(make-test '((print-char -1)) 'err)
(make-test '((print-char 256)) 'err)
(make-test '((print-bool -1)) 'err)
(make-test '((print-bool 256)) 'err)

;; Fraud examples
(make-test '((let ([x 7]) x)) 7)
(make-test '((let ([x 7]) 2)) 2)
(make-test '((let ([x 7]) (add1 x))) 8)
(make-test '((let ([x (add1 7)]) x)) 8)
(make-test '((let ([x 7]) (let ([y 2]) x))) 7)
(make-test '((let ([x 7]) (let ([y 2]) x))) 7)
(make-test '((let ([x 7]) (let ([y 2]) (+ x y)))) 9)
(make-test '((let ([x 7]) (let ([x 2]) x))) 2)
(make-test '((let ([x 7]) (let ([x (add1 x)]) x))) 8)
(make-test '((let ([x 0]) (if (zero? x) 7 8))) 7)
(make-test '((let ([x 1]) (add1 (if (zero? x) 7 8)))) 9)
(make-test '((let ([x 7]) (let ([y (+ x 20)]) y))) 27)
(make-test '((let ([x 7]) (let ([y (+ x 20)]) (- y 20)))) 7)
(make-test '((let ([x 7])
               (begin
                 (let ([x 2]) x)
                 x)))
           7)
(make-test '((+ 3 4)) 7)
(make-test '((+ 3 #f)) 'err)
(make-test '((+ #f 3)) 'err)
(make-test '((- 3 4)) -1)
(make-test '((- (zero? 0) 4)) 'err)
(make-test '((- 3 #\c)) 'err)
(make-test '((+ (+ 2 1) 4)) 7)
(make-test '((+ (+ 2 1) (+ 2 2))) 7)
(make-test '((let ([x (+ 1 2)]) (let ([z (- 4 x)]) (+ (+ x x) z)))) 7)
(make-test '((let ([x (+ 1 2)]) (let ([z 3]) (= x z)))) #t)
(make-test '((= 5 5)) #t)
(make-test '((= 4 5)) #f)
(make-test '((= (add1 4) 5)) #t)
(make-test '((= #\a #\b)) 'err)
(make-test '((= 4 #\c)) 'err)
(make-test '((= (add1 #f) 5)) 'err)
(make-test '((< 5 5)) #f)
(make-test '((< 5 (sub1 5))) #f)
(make-test '((< 4 5)) #t)
(make-test '((< (sub1 5) 5)) #t)
(make-test '((< (add1 4) 5)) #f)
(make-test '((if (< 10 20) 100 101)) 100)
(make-test '((if (< -10 20) 200 201)) 200)
(make-test '((if (< -10 -20) 300 301)) 301)
(make-test '((if (< 10 -20) 400 401)) 401)
(make-test '((if (< 20 10) 500 501)) 501)
(make-test '((if (< -20 10) 600 601)) 600)
(make-test '((if (< -20 -10) 700 701)) 700)
(make-test '((if (< 20 -10) 800 801)) 801)
(make-test '((let ([x #\c])
               (+ (char->integer x)
                  (let ([y (< (+ 6 -6) (add1 (add1 (- 43 (sub1 46)))))])
                    (if y (add1 67) 12)))))
           111)
(make-test
 '((+ 1
      (+ 2
         (+ 3
            (+ 4
               (+ 5
                  (+ 6
                     (+ 7
                        (+ 8
                           (+ 9
                              (+ 10
                                 (+ 11
                                    (+ 12
                                       (+ 13
                                          (+ 14
                                             (+ 15
                                                (+ 16
                                                   (+ 17
                                                      (+ 18
                                                         19)))))))))))))))))))
 190)
(make-test
 '((+ (+ (+ (+ (+ (+ (+ (+ (+ (+ (+ (+ (+ (+ (+ (+ (+ (+ 1 19) 2) 3) 4) 5) 6) 7)
                                    8)
                                 9)
                              10)
                           11)
                        12)
                     13)
                  14)
               15)
            16)
         17)
      18))
 190)

;; Hustle examples
(make-test '('()) '())
(make-test '((box 1)) (box 1))
(make-test '((box -1)) (box -1))
(make-test '((unbox (box (box -1)))) (box -1))
(make-test '((unbox (box 8))) 8)
(make-test '((box? (box 42))) #t)
(make-test '((box? (box (box 42)))) #t)
(make-test '((box? (unbox (box 42)))) #f)
(make-test '((box? 42)) #f)
(make-test '((box? (cons 1 2))) #f)

(make-test '((cons 1 2)) (cons 1 2))
(make-test '((car (cons 1 2))) 1)
(make-test '((cdr (cons 1 2))) 2)
(make-test '((cons 3 (cons 4 5))) (cons 3 (cons 4 5)))
(make-test '((cons 1 '())) (list 1))
(make-test '((let ([x (cons 1 2)])
               (begin
                 (cdr x)
                 (car x))))
           1)
(make-test '((let ([x (cons 1 2)]) (let ([y (box 3)]) (unbox y)))) 3)
(make-test '((cons? (cons 1 2))) #t)
(make-test '((cons? (cons 1 '()))) #t)
(make-test '((cons? (cons 1 (cons 5 '())))) #t)
(make-test '((cons? (car (cdr (cons 1 (cons 5 '())))))) #f)
(make-test '((cons? (cdr (cons 1 (cons 5 '()))))) #t)
(make-test '((eq? 1 1)) #t)
(make-test '((eq? 1 2)) #f)
(make-test '((eq? (cons 1 2) (cons 1 2))) #f)
(make-test '((let ([x (cons 1 2)]) (eq? x x))) #t)

(make-test '((box (cons 1 2))) (box (cons 1 2)))
(make-test '((cdr (box (cons 1 2)))) 'err)
(make-test '((unbox (box (cons 1 2)))) (cons 1 2))
(make-test '((car (unbox (box (cons 1 2))))) 1)

;; Hoax examples
(make-test '((make-vector 0 0)) #())
(make-test '((make-vector 1 0)) #(0))
(make-test '((make-vector 3 0)) #(0 0 0))
(make-test '((make-vector 3 5)) #(5 5 5))
(make-test '((vector? (make-vector 0 0))) #t)
(make-test '((vector? (cons 0 0))) #f)
(make-test '((vector-ref (make-vector 0 #f) 0)) 'err)
(make-test '((vector-ref (make-vector 3 5) -1)) 'err)
(make-test '((vector-ref (make-vector 3 5) 0)) 5)
(make-test '((vector-ref (make-vector 3 5) 1)) 5)
(make-test '((vector-ref (make-vector 3 5) 2)) 5)
(make-test '((vector-ref (make-vector 3 5) 3)) 'err)
(make-test '((let ([x (make-vector 3 5)])
               (begin
                 (vector-set! x 0 4)
                 x)))
           #(4 5 5))
(make-test '((let ([x (make-vector 9 #t)])
               (begin
                 (vector-set! x 5 #f)
                 x)))
           #(#t #t #t #t #t #f #t #t #t))
(make-test '((let ([x (make-vector 3 5)])
               (begin
                 (vector-set! x 1 4)
                 x)))
           #(5 4 5))
(make-test '((let ([x (make-vector 3 5)])
               (begin
                 (vector-set! x 2 4)
                 x)))
           #(5 5 4))
(make-test '((let ([x (make-vector 3 5)])
               (begin
                 (vector-set! x 3 4)
                 x)))
           'err)
(make-test '((let ([x (make-vector 3 5)])
               (begin
                 (vector-set! x -1 4)
                 x)))
           'err)
(make-test '((let ([x (make-vector 7 #\c)])
               (begin
                 (vector-set! x 11 4)
                 x)))
           'err)
(make-test '((vector-length (make-vector 3 #f))) 3)
(make-test '((vector-length (make-vector 3000 (box 20)))) 3000)
(make-test '((vector-length (make-vector 0 #f))) 0)

(make-test '("") "")
(make-test '("fred") "fred")
(make-test '("wilma") "wilma")
(make-test '((string-length "")) 0)
(make-test '((string-length "c")) 1)
(make-test '((string-length "fred")) 4)
(make-test '((string-length "wonderfulwonderfulwonderfulwonderful")) 36)
(make-test '((string-ref "fred" 0)) #\f)
(make-test '((string-ref "fred" 1)) #\r)
(make-test '((string-ref "fred" 2)) #\e)
(make-test '((string-ref "fred" 4)) 'err)
(make-test '((string? "fred")) #t)
(make-test '((begin
               (make-string 3 #\f)
               (make-string 3 #\f)))
           "fff")

(make-test '((make-string 0 #\f)) "")
(make-test '((make-string 3 #\f)) "fff")
(make-test '((make-string 3 #\g)) "ggg")
(make-test '((make-string 7 #\h)) "hhhhhhh")
(make-test '((make-string 40 #\i)) "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii")
(make-test
 '((make-string 72 #\+))
 "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
(make-test '((string-length (make-string 0 #\f))) 0)
(make-test '((string-length (make-string 4 #\t))) 4)

(make-test '((string-ref (make-string 0 #\a) -1)) 'err)
(make-test '((string-ref (make-string 0 #\a) 0)) 'err)
(make-test '((string-ref (make-string 0 #\a) 1)) 'err)
(make-test '((string-ref (make-string 7 #\a) -3)) 'err)
(make-test '((string-ref (make-string 7 #\a) -2)) 'err)
(make-test '((string-ref (make-string 7 #\a) -1)) 'err)
(make-test '((string-ref (make-string 7 #\a) 0)) #\a)
(make-test '((string-ref (make-string 7 #\a) 1)) #\a)
(make-test '((string-ref (make-string 7 #\a) 2)) #\a)
(make-test '((string-ref (make-string 7 #\a) 3)) #\a)
(make-test '((string-ref (make-string 7 #\a) 4)) #\a)
(make-test '((string-ref (make-string 7 #\a) 5)) #\a)
(make-test '((string-ref (make-string 7 #\a) 6)) #\a)
(make-test '((string-ref (make-string 7 #\a) 7)) 'err)
(make-test '((string-ref (make-string 7 #\a) 8)) 'err)
(make-test '((string-ref (make-string 7 #\a) 9)) 'err)

(make-test '((string? (cons (make-string 3 #\c) (make-string 5 #\f)))) #f)
(make-test '((string? (cons 1 2))) #f)
(make-test '((string? (make-string 0 #\a))) #t)
(make-test '((string? (make-string 400 #\b))) #t)
(make-test '((string? (make-string 12 #\c))) #t)
(make-test '((string? (string-ref (make-string 12 #\c) 11))) #f)
(make-test '((string? (box 1))) #f)
(make-test '((string? (box (make-string 20 #\d)))) #f)

(make-test '((make-vector 3 "one")) #("one" "one" "one"))
(make-test '((vector-set! (make-vector 3 "one") 1 "two")) (void))
(make-test '((let ([x (make-vector 3 "one")])
               (begin
                 (vector-set! x 1 "two")
                 x)))
           #("one" "two" "one"))

(make-test '((let ([x "string1"])
               (let ([y "helfon603"])
                 (let ([z "wejr!!!9"])
                   (let ([ans (make-vector 6 -1)])
                     (begin
                       (vector-set! ans 0 (string-ref x 2))
                       (begin
                         (vector-set! ans 1 (string-ref y 8))
                         (begin
                           (vector-set! ans 2 (string-ref z 3))
                           (begin
                             (vector-set! ans 3 (string-length x))
                             (begin
                               (vector-set! ans 4 (string-length y))
                               (begin
                                 (vector-set! ans 5 (string-length z))
                                 ans)))))))))))
           #(#\r #\3 #\r 7 9 8))

;; Iniquity examples
(make-test '((define (fib n)
               (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))
             (fib 0))
           0)
(make-test '((define (fib n)
               (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))
             (fib 1))
           1)
(make-test '((define (fib n)
               (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))
             (fib 2))
           1)
(make-test '((define (fib n)
               (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))
             (fib 3))
           2)
(make-test '((define (fib n)
               (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))
             (fib 4))
           3)
(make-test '((define (fib n)
               (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))
             (fib 5))
           5)
(make-test '((define (fib n)
               (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))
             (fib 10))
           55)

(make-test '((define (f x)
               x)
             (f 5))
           5)
(make-test '((define (tri x)
               (if (zero? x) 0 (+ x (tri (sub1 x)))))
             (tri 0))
           0)
(make-test '((define (tri x)
               (if (zero? x) 0 (+ x (tri (sub1 x)))))
             (tri 2))
           3)
(make-test '((define (tri x)
               (if (zero? x) 0 (+ x (tri (sub1 x)))))
             (tri 9))
           45)
(make-test '((define (tri x)
               (if (zero? x) 0 (+ x (tri (sub1 x)))))
             (tri 50))
           1275)
(make-test '((define (even? x)
               (if (zero? x) #t (odd? (sub1 x))))
             (define (odd? x)
               (if (zero? x) #f (even? (sub1 x))))
             (even? 101))
           #f)
(make-test '((define (even? x)
               (if (zero? x) #t (odd? (sub1 x))))
             (define (odd? x)
               (if (zero? x) #f (even? (sub1 x))))
             (even? 0))
           #t)
(make-test '((define (even? x)
               (if (zero? x) #t (odd? (sub1 x))))
             (define (odd? x)
               (if (zero? x) #f (even? (sub1 x))))
             (even? 1234))
           #t)
(make-test '((define (map-add1 xs)
               (if (empty? xs) '() (cons (add1 (car xs)) (map-add1 (cdr xs)))))
             (map-add1 '()))
           '())
(make-test '((define (map-add1 xs)
               (if (empty? xs) '() (cons (add1 (car xs)) (map-add1 (cdr xs)))))
             (map-add1 (cons 1 (cons -2 (cons 3 (cons 5 (cons 10 '())))))))
           '(2 -1 4 6 11))
(make-test '((define (f x y)
               y)
             (f 1 (add1 #f)))
           'err)
(make-test
 '((define (mult a b)
     (if (zero? a) 0 (if (zero? b) 0 (if (= b 1) a (+ a (mult a (sub1 b)))))))
   (mult 5 3))
 15)
(make-test
 '((define (mult a b)
     (if (zero? a) 0 (if (zero? b) 0 (if (= b 1) a (+ a (mult a (sub1 b)))))))
   (mult 0 0))
 0)
(make-test
 '((define (mult a b)
     (if (zero? a) 0 (if (zero? b) 0 (if (= b 1) a (+ a (mult a (sub1 b)))))))
   (mult 0 3))
 0)
(make-test
 '((define (mult a b)
     (if (zero? a) 0 (if (zero? b) 0 (if (= b 1) a (+ a (mult a (sub1 b)))))))
   (mult 5 0))
 0)
(make-test
 '((define (mult a b)
     (if (zero? a) 0 (if (zero? b) 0 (if (= b 1) a (+ a (mult a (sub1 b)))))))
   (mult 5 1))
 5)
(make-test
 '((define (mult a b)
     (if (zero? a) 0 (if (zero? b) 0 (if (= b 1) a (+ a (mult a (sub1 b)))))))
   (mult 1755 1))
 1755)
(make-test
 '((define (mult a b)
     (if (zero? a) 0 (if (zero? b) 0 (if (= b 1) a (+ a (mult a (sub1 b)))))))
   (mult 383 10))
 3830)
(make-test
 '((define (mult a b)
     (if (zero? a) 0 (if (zero? b) 0 (if (= b 1) a (+ a (mult a (sub1 b)))))))
   (mult 10 383))
 3830)
(make-test
 '((define (sum15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)
     (+ x1
        (+ x2
           (+ x3
              (+ x4
                 (+ x5
                    (+ x6
                       (+ x7
                          (+ x8
                             (+ x9
                                (+ x10
                                   (+ x11
                                      (+ x12 (+ x13 (+ x14 x15)))))))))))))))
   (sum15 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))
 15)
(make-test
 '((define (sum15 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15)
     (+ x1
        (+ x2
           (+ x3
              (+ x4
                 (+ x5
                    (+ x6
                       (+ x7
                          (+ x8
                             (+ x9
                                (+ x10
                                   (+ x11
                                      (+ x12 (+ x13 (+ x14 x15)))))))))))))))
   (sum15 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15))
 120)
; Jig examples
(make-test '((define (s n)
               (if (zero? n) 0 (s (add1 n))))
             (s 0))
           0)
(make-test '((define (s n)
               (if (zero? n) 0 (s (add1 n))))
             (s 1))
           0)
(make-test '((define (s n)
               (if (zero? n) 0 (s (add1 n))))
             (s 1000))
           0)
(make-test '((define (s n)
               (if (zero? n) 0 (s (add1 n))))
             (s 10000))
           0)

;stolen from somewhere, please note later
(make-test '((define (fib n)
               (fib-iter 1 0 n))
             (define (fib-iter a b count)
               (if (= count 0) b (fib-iter (+ a b) a (- count 1))))
             (fib 0))
           0)
(make-test '((define (fib n)
               (fib-iter 1 0 n))
             (define (fib-iter a b count)
               (if (= count 0) b (fib-iter (+ a b) a (- count 1))))
             (fib 1))
           1)
(make-test '((define (fib n)
               (fib-iter 1 0 n))
             (define (fib-iter a b count)
               (if (= count 0) b (fib-iter (+ a b) a (- count 1))))
             (fib 2))
           1)
(make-test '((define (fib n)
               (fib-iter 1 0 n))
             (define (fib-iter a b count)
               (if (= count 0) b (fib-iter (+ a b) a (- count 1))))
             (fib 3))
           2)
(make-test '((define (fib n)
               (fib-iter 1 0 n))
             (define (fib-iter a b count)
               (if (= count 0) b (fib-iter (+ a b) a (- count 1))))
             (fib 4))
           3)
(make-test '((define (fib n)
               (fib-iter 1 0 n))
             (define (fib-iter a b count)
               (if (= count 0) b (fib-iter (+ a b) a (- count 1))))
             (fib 5))
           5)
(make-test '((define (fib n)
               (fib-iter 1 0 n))
             (define (fib-iter a b count)
               (if (= count 0) b (fib-iter (+ a b) a (- count 1))))
             (fib 10))
           55)
(make-test '((define (fib n)
               (fib-iter 1 0 n))
             (define (fib-iter a b count)
               (if (= count 0) b (fib-iter (+ a b) a (- count 1))))
             (fib 20))
           6765)

(make-test '((define (f x y)
               (g (+ y 10)))
             (define (g x)
               (+ x 100))
             (f 1 2))
           112)
(make-test '((define (f x y)
               (g (+ x 10)))
             (define (g x)
               (+ x 100))
             (f 1 2))
           111)
(make-test '((define (f x y)
               (- x y))
             (define (g x)
               (f (+ 10 x) (+ 100 x)))
             (g 1))
           -90)
(make-test '((define (f x y)
               (- x y))
             (define (g x)
               (f (+ 100 x) (+ 10 x)))
             (g 1))
           90)

;; Loot tests
(make-test '(((lambda (x y z) (+ x (+ y z))) 1 2 3)) 6)
(make-test '(((lambda (x y z) (+ x (+ y z))) 3 2 1)) 6)
(make-test '(((lambda (x y z) (+ x (+ y z))) 10 10 10)) 30)

(make-test '((((lambda (x) (lambda (y) (+ x y))) 10) 20)) 30)

(make-test '((define (f x)
               (+ x 40))
             (define (g x)
               (- x 40))
             (let ([x 0]) (if (zero? ((lambda (x) x) 90)) (f x) (g x))))
           -40)

(make-test '(((λ (x) x) 5)) 5)

(make-test '((let ([f (λ (x) x)]) (f 5))) 5)
(make-test '((let ([f (λ (x y) x)]) (f 5 7))) 5)
(make-test '((let ([f (λ (x y) y)]) (f 5 7))) 7)
(make-test
 '(((let ([x 1]) (let ([y 2]) (lambda (z) (cons x (cons y (cons z '())))))) 3))
 '(1 2 3))
(make-test '((define (adder n)
               (λ (x) (+ x n)))
             ((adder 5) 10))
           15)
(make-test
 '((((λ (t) ((λ (f) (t (λ (z) ((f f) z)))) (λ (f) (t (λ (z) ((f f) z))))))
     (λ (tri) (λ (n) (if (zero? n) 0 (+ n (tri (sub1 n)))))))
    36))
 666)
(make-test '((define (tri n)
               (if (zero? n) 0 (+ n (tri (sub1 n)))))
             (tri 36))
           666)
