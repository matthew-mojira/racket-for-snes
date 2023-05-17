#lang racket

;; PRINTING LIBRARY

(define (print-value val)
  (cond
    [(integer? val) (print-int val)]
    [(boolean? val) (print-bool val)]
    [(char? val)
     (begin
       (print-string "#\\")
       (print-char val))]
    [(eof-object? val) (print-string "#<eof>")]
    [(eq? val (void)) (print-string "#<void>")]
    [(procedure? val) (print-string "#<procedure>")]
    [(string? val)
     (begin
       (print-char #\")
       (begin
         (print-string val)
         (print-char #\")))]
    [else
     (begin
       (print-char #\')
       (print-value-interior val))]))

(define (print-value-interior val)
  (cond
    [(empty? val) (print-string "()")]
    [(box? val)
     (begin
       (print-string "#&")
       (print-value-interior (unbox val)))]
    [(cons? val)
     (begin
       (print-char #\()
       (begin
         (print-cons val)
         (print-char #\))))]
    [(vector? val) (print-vector val)]
    [else (print-value val)]))

(define (print-string str)
  (print-str-ind str 0))

(define (print-str-ind str ind)
  (if (= ind (string-length str))
      (void)
      (begin
        (print-char (string-ref str ind))
        (print-str-ind str (add1 ind)))))

(define (print-vector vec)
  (if (zero? (vector-length vec))
      (print-string "#()")
      (begin
        (print-string "#(")
        (print-vec-ind vec 0))))

(define (print-vec-ind vec ind)
  (begin
    (print-value-interior (vector-ref vec ind))
    (if (= ind (sub1 (vector-length vec)))
        (print-char #\))
        (begin
          (print-char #\space)
          (print-vec-ind vec (add1 ind))))))

(define (print-cons pair)
  (begin
    (print-value-interior (car pair))
    (let ([sec (cdr pair)])
      (cond
        [(empty? sec) (void)]
        [(cons? sec)
         (begin
           (print-char #\space)
           (print-cons sec))]
        [else
         (begin
           (print-string " . ")
           (print-value-interior sec))]))))

;; ACTUAL CODE

(define (fib n)
    (if (< n 2) 1 (+ (fib (- n 1)) (fib (- n 2)))))

(let ([n 10])
  (begin
    (print-string "The ")
    (begin
      (print-int n)
      (begin
        (print-string "th fibonacci number is ")
        (print-value (fib n))))))