(in-package :cl-user)
(defpackage clipper-test.s3
  (:use :cl
        :prove
        :integral
        :clipper-test.init
        :clipper
        :clipper.config
        :clipper.format
        :clipper.database))
(in-package :clipper-test.s3)

(plan 2)

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

(setup-clipper :store-type :s3
               :aws-access-key "sample-access-key"
               :aws-secret-key "sample-secret-key"
               :s3-endpoint "s3-ap-northeast-1.amazonaws.com"
               :s3-bucket-name "clipper-test"
               :clipper-class (find-class 'picture)
               :format ":ID/:FILE-NAME.:EXTENSION")

(let ((object (create-dao 'picture :image-file-name "lisp-alien.png"
                                   :image-content-type "image/png"
                                   :image-file-size 100
                                   :url "http://lisp-alien.org/lisp-alien.png")))
  (is (store-format object)
      (format nil "~a/~a.~a"
              (clip-id object)
              (clip-image-file-name-without-extension object)
              (clip-extension object)))
  (is (image-url object)
      (format nil "https://~a/~a/~a/~a.~a"
              (clipper-config-s3-endpoint *clipper-config*)
              (clipper-config-s3-bucket-name *clipper-config*)
              (clip-id object)
              (clip-image-file-name-without-extension object)
              (clip-extension object))))

(finalize)
