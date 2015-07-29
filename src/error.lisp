(in-package :cl-user)
(defpackage clipper.error
  (:use :cl
        :annot.doc))
(in-package :clipper.error)

(syntax:use-syntax :annot)

@doc
"Base error condition."
@export
(define-condition <clipper-error> (simple-error) ())

@doc
"Invalid stare type error."
@export
(define-condition <clipper-invalid-store-type> (<clipper-error>)
  ((type :initarg :type))
  (:report
   (lambda (condition stream)
     (format stream
             "Invalid store type: ~a."
             (slot-value condition 'type)))))

@doc
"Incomplete config error."
@export
(define-condition <clipper-incomplete-config> (<clipper-error>)
  ((slot-list :initarg :slot-list))
  (:report
   (lambda (condition stream)
     (format stream
             "Incomplete config: ~{~A ~}"
             (slot-value condition 'slot-list)))))

@doc
"Incomplete local config error."
@export
(define-condition <clipper-incomplete-local-config> (<clipper-incomplete-config>) ())

@doc
"Incomplete S3 config error."
@export
(define-condition <clipper-incomplete-s3-config> (<clipper-incomplete-config>) ())

@doc
"No source specified error."
@export
(define-condition <clipper-no-source-specified> (<clipper-error>)
  ((object :initarg :object))
  (:report
   (lambda (condition stream)
     (format stream
             "Please provide URL or vector data with ~a."
             (slot-value condition 'object)))))

@doc
"Unsupported content type error."
@export
(define-condition <clipper-unsupported-content-type> (<clipper-error>)
  ((content-type :initarg :content-type))
  (:report
   (lambda (condition stream)
     (format stream
             "Unsupported content-type : ~a."
             (slot-value condition 'content-type)))))

@export
(define-condition <clipper-incomplete-for-attach-image> (<clipper-error>)
  ((type :initarg :type)
   (args :initarg :args))
  (:report
   (lambda (condition stream)
     (format stream
             "attach-image with ~a needs~{ ~a~}"
             (slot-value condition 'type)
             (slot-value condition 'args)))))

@doc
"Image type error."
@export
(define-condition <clipper-image-type-error> (<clipper-error>)
  ((type :initarg :type))
  (:report
   (lambda (condition stream)
     (format stream
             "Type of image: ~a does not satisfy '(simple-array (unsigned-byte 8))."
             (slot-value condition 'type)))))
