(in-package :cl-user)
(defpackage clipper-test.format
  (:use :cl
        :prove
        :integral
        :clipper-test.init
        :clipper
        :clipper.database
        :clipper.format
        :clipper.config))
(in-package :clipper-test.format)

(plan 0)

(connect-to-testdb)

(defclass picture ()
  ((id :col-type (:integer 11)
       :primary-key t
       :auto-increment t
       :not-null t
       :initarg :id)
   (image-file-name :col-type (:varchar 255)
                    :initarg :image-file-name)
   (image-content-type :col-type (:varchar 255)
                       :initarg :image-content-type)
   (image-file-size :col-type (:integer 11)
                    :initarg :image-file-size)
   (url :type string
        :initarg :url))
  (:metaclass <dao-table-class>)
  (:table-name "pictures"))

(execute-sql "DROP TABLE IF EXISTS pictures")
(execute-sql (table-definition 'picture))

(let ((pic (create-dao 'picture :image-file-name "lisp-alien.png"
                                :image-content-type "image/png"
                                :image-file-size 100
                                :url "http://lisp-alien.org/lisp-alien.png")))
  (declare (ignore pic)))

(finalize)
