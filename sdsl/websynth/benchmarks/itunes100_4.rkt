#lang s-exp rosette

(require (only-in racket/runtime-path define-runtime-path))
(require "../dom.rkt")
(require "../websynth.rkt")
(require "../websynthlib.rkt")

(define-runtime-path html (build-path "." "../html/itunes_top100_v2.html"))
(define dom (read-DOMNode html))
(define-tags (tags dom))
(define max_zpath_depth (depth dom))

; Record 0 fields
(define-symbolic r0f0zpath tag? [max_zpath_depth])
(define-symbolic r0f1zpath tag? [max_zpath_depth])

(define-symbolic r0fieldmask boolean? [max_zpath_depth])
; Record 1 fields
(define-symbolic r1f0zpath tag? [max_zpath_depth])
(define-symbolic r1f1zpath tag? [max_zpath_depth])

(define-symbolic r1fieldmask boolean? [max_zpath_depth])
; Record 2 fields
(define-symbolic r2f0zpath tag? [max_zpath_depth])
(define-symbolic r2f1zpath tag? [max_zpath_depth])

(define-symbolic r2fieldmask boolean? [max_zpath_depth])
; Record 3 fields
(define-symbolic r3f0zpath tag? [max_zpath_depth])
(define-symbolic r3f1zpath tag? [max_zpath_depth])

(define-symbolic r3fieldmask boolean? [max_zpath_depth])

; Cross-record Mask
(define-symbolic recordmask boolean? [max_zpath_depth])
(current-log-handler (log-handler #:info any/c))
(current-bitwidth 1)

; Record 0 zpath asserts
(assert (path? r0f0zpath dom "Sail"))
(assert (path? r0f1zpath dom "AWOLNATION"))

; Record 1 zpath asserts
(assert (path? r1f0zpath dom "I Won't Give Up"))
(assert (path? r1f1zpath dom "Jason Mraz"))

; Record 2 zpath asserts
(assert (path? r2f0zpath dom "Diamonds"))
(assert (path? r2f1zpath dom "Rihanna"))

; Record 3 zpath asserts
(assert (path? r3f0zpath dom "What Christmas Means to Me"))
(assert (path? r3f1zpath dom "Cee Lo Green"))

; Record 0 Field Mask Generation
(generate-mask r0f0zpath r0f1zpath r0fieldmask max_zpath_depth)

; Record 1 Field Mask Generation
(generate-mask r1f0zpath r1f1zpath r1fieldmask max_zpath_depth)

; Record 2 Field Mask Generation
(generate-mask r2f0zpath r2f1zpath r2fieldmask max_zpath_depth)

; Record 3 Field Mask Generation
(generate-mask r3f0zpath r3f1zpath r3fieldmask max_zpath_depth)


; Record Mask and Solve
(generate-mask r0f0zpath r1f0zpath recordmask max_zpath_depth)
(define sol (solve #t))

; Record 0 zpaths
; Record 1 zpaths
; Record 2 zpaths
; Record 3 zpaths

; Construct final zpaths
(define r0f0zpath_list (map label (evaluate r0f0zpath)))
(define generalizelized_r0f0zpath_list 
   (apply-mask r0f0zpath_list (evaluate recordmask)))
(define field0_zpath (synthsis_solution->zpath generalizelized_r0f0zpath_list))

(define r0f1zpath_list (map label (evaluate r0f1zpath)))
(define generalizelized_r0f1zpath_list 
   (apply-mask r0f1zpath_list (evaluate recordmask)))
(define field1_zpath (synthsis_solution->zpath generalizelized_r0f1zpath_list))

(printf "DOM stats:  size = ~a, depth = ~a, tags = ~a\n" (size dom) max_zpath_depth (enum-size tag?))
(zip 
(DOM-Flatten (DOM-XPath dom field0_zpath))
(DOM-Flatten (DOM-XPath dom field1_zpath))
)
