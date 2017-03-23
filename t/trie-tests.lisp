(defpackage #:cl-trie/tests
  (:use :cl :fiveam)
  (:export run-tests))

(in-package #:cl-trie/tests)

(defun run-tests ()
  (run! 'cl-trie-suite))

(def-suite cl-trie-suite
    :description "Tests for cl-trie package.")

(in-suite cl-trie-suite)

(test trie-creation-sanity
  ;; No key should signal a warning.
  (signals cl-trie:empty-key-warning (make-instance 'cl-trie:trie))
  ;; Various keyword arguments configuration
  (finishes (make-instance 'cl-trie:trie :value 5 :activep t))
  (finishes (make-instance 'cl-trie:trie :value 5))
  (finishes (make-instance 'cl-trie:trie :activep nil))
  (finishes (make-instance 'cl-trie:trie :key "a"))
  (finishes (make-instance 'cl-trie:trie :children nil))
  (finishes (make-instance 'cl-trie:trie :key "a" :value 5))
  (finishes (make-instance 'cl-trie:trie :key "a" :activep t))
  (finishes (make-instance 'cl-trie:trie :key "a" :value 5 :activep t))
  (finishes (make-instance 'cl-trie:trie :key "a" :value 5 :activep t :children nil)))

(test trie-setf
  (let ((trie (make-instance 'cl-trie:trie :key "")))
    (is (not (cl-trie:activep trie)))
    (is (string= (cl-trie:key trie) ""))
    (is (every #'null (multiple-value-list (cl-trie:lookup trie "word"))))
    (is (not (null (setf (cl-trie:lookup trie "word") 3))))
    ;; Check if all return values are non-nil under successful key search.
    (is (every #'identity (multiple-value-list (cl-trie:lookup trie "word"))))
    (is (= (cl-trie:lookup trie "word") 3))
    (setf (cl-trie:lookup trie "word") 4)
    (is (every #'identity (multiple-value-list (cl-trie:lookup trie "word"))))
    (is (= (cl-trie:lookup trie "word") 4))
    (is (every #'null (multiple-value-list (cl-trie:lookup trie "wor"))))
    (setf (cl-trie:lookup trie "wor") 15)
    (is (every #'identity (multiple-value-list (cl-trie:lookup trie "wor"))))
    (is (= (cl-trie:lookup trie "wor") 15))))

;; The same test as trie-setf.
(test trie-insert
  (let ((trie (make-instance 'cl-trie:trie :key "")))
    (is (not (cl-trie:activep trie)))
    (is (string= (cl-trie:key trie) ""))
    (is (every #'null (multiple-value-list (cl-trie:lookup trie "word"))))
    (cl-trie:insert 3 trie "word")
    ;; Check if all return values are non-nil under successful key search.
    (is (every #'identity (multiple-value-list (cl-trie:lookup trie "word"))))
    (is (= (cl-trie:lookup trie "word") 3))
    (cl-trie:insert 4 trie "word")
    (is (every #'identity (multiple-value-list (cl-trie:lookup trie "word"))))
    (is (= (cl-trie:lookup trie "word") 4))
    (is (every #'null (multiple-value-list (cl-trie:lookup trie "wor"))))
    (cl-trie:insert 15 trie "wor")
    (is (every #'identity (multiple-value-list (cl-trie:lookup trie "wor"))))
    (is (= (cl-trie:lookup trie "wor") 15)))  )
