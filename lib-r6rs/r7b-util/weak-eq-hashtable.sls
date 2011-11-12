(library (r7b-util weak-eq-hashtable)
         (export make-weak-eq-hashtable
                 weak-hashtable-set!
                 weak-hashtable-ref)
         (import (rnrs) (r7b-util weak-vectors))

(define (weak-hashtable-gc wht)
  (define (check key value)
    (unless (q-data value)
      (hashtable-delete! wht key)))
  (let-values (((key value) (hashtable-entries wht)))
              (for-each check
                        (vector->list key)
                        (vector->list value))))

(define (weak-hashtable-set! wht key obj) 
  (define h (equal-hash key))
  (define q (make-q key obj))
  (define (try h)
    (let ((p (hashtable-ref wht h #f)))
      (if p
        (try (+ h 1))
        (hashtable-set! wht h q))))
  (weak-hashtable-gc wht)
  (try h))

(define (make-q obj data)
  (let ((wv (make-weak-vector 2)))
    (weak-vector-set! wv obj 0)
    (weak-vector-set! wv obj 1)
    wv))

(define (q-obj q) (weak-vector-ref q 0))
(define (q-data q) (weak-vector-ref q 1))

(define (weak-hashtable-ref wht obj) 
  (define (check h)
    (let ((q (hashtable-ref wht h #f)))
      (and q
           (if (eq? (q-obj q) obj)
             (q-data q)
             (check (+ h 1))))))
  (check (equal-hash obj)))

(define (make-weak-eq-hashtable) (make-eq-hashtable))

)