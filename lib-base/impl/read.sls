(library (impl read)
         (export read)
         (import (implbase lib readerwriter)
                 (scheme base))
         (begin
(define read read/ss)
))