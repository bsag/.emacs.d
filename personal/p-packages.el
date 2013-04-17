;;; -*- lexical-binding: t -*-

(require 'package)

(defvar p-melpa-packages nil
  "A list of packages that should be installed from melpa")

(setq package-archives
      (append package-archives
              '(("marmalade" . "http://marmalade-repo.org/packages/")
                ("melpa" . "http://melpa.milkbox.net/packages/"))))

(package-initialize)

;; install melpa package
(unless (package-installed-p 'melpa)
  (progn
    (switch-to-buffer
     (url-retrieve-synchronously
      "https://raw.github.com/milkypostman/melpa/master/melpa.el"))
    (package-install-from-buffer  (package-buffer-info) 'single)))

(require 'melpa)

;; Don't get stable packages from melpa
(setq package-filter-function
      (lambda (package version archive)
        (or (not (string-equal archive "melpa"))
            (memq package p-melpa-packages))))

(when (not package-archive-contents)
  (package-refresh-contents))

(defun p-require-package (package &optional repo)
  (let ((is-melpa (equal repo 'melpa)))
    (when is-melpa
      (add-to-list 'p-melpa-packages package))
    (unless (package-installed-p package)
      (when is-melpa
        (package-refresh-contents))
      (package-install package))))

(p-require-package 'starter-kit)

(provide 'p-packages)