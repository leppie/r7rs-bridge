;;; ACK -- One of the Kernighan and Van Wyk benchmarks.

(import (scheme base)
        (scheme write)
        (scheme read))

(define (ack m n)
  (cond ((= m 0) (+ n 1))
        ((= n 0) (ack (- m 1) 1))
        (else (ack (- m 1) (ack m (- n 1))))))

(define (main)
  (let* ((count (read))
         (input1 (read))
         (input2 (read))
         (output (read))
         (s2 (number->string input2))
         (s1 (number->string input1))
         (name "ack"))
    (run-r6rs-benchmark
     (string-append name ":" s1 ":" s2)
     count
     (lambda () (ack (hide count input1) (hide count input2)))
     (lambda (result) (= result output)))))

;;; The following code is appended to all benchmarks.

;;; Given an integer and an object, returns the object
;;; without making it too easy for compilers to tell
;;; the object will be returned.

(define (hide r x)
  (call-with-values
   (lambda ()
     (values (vector values (lambda (x) x))
             (if (< r 100) 0 1)))
   (lambda (v i)
     ((vector-ref v i) x))))

;;; Given the name of a benchmark,
;;; the number of times it should be executed,
;;; a thunk that runs the benchmark once,
;;; and a unary predicate that is true of the
;;; correct results the thunk may return,
;;; runs the benchmark for the number of specified iterations.
;;;
;;; Implementation-specific versions of this procedure may
;;; provide timings for the benchmark proper (without startup
;;; and compile time).

(define (run-r6rs-benchmark name count thunk ok?)
  (display "Running ")
  (display name)
  (newline)
  (let loop ((i 0)
             (result (if #f #f)))
    (cond ((< i count)
           (loop (+ i 1) (thunk)))
          ((ok? result)
           result)
          (else
           (display "ERROR: returned incorrect result: ")
           (write result)
           (newline)
           result))))

(main)