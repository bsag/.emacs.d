;;; -*- lexical-binding: t -*-

(require 'p-bindings)

(add-to-list 'explicit-bash-args "--login")

(global-set-key (kbd "C-z C-s") 'shell)
(global-set-key (kbd "C-z C-t") 'ansi-term)

(provide 'p-shell)