;;; -*- lexical-binding: t -*-
;;; Settings and keybindings for general editing

(require 'p-leader)

;;;;;;;;;;;;;;
;; Settings ;;
;;;;;;;;;;;;;;

(global-subword-mode 1)
(global-auto-revert-mode 1)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(delete-selection-mode 1)
(setq-default require-final-newline t
              indent-tabs-mode nil
              tab-width 2)
(auto-fill-mode 0)

;;;;;;;;;;;;;;;
;; Functions ;;
;;;;;;;;;;;;;;;


(defun p-untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun p-indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun p-cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (p-indent-buffer)
  (p-untabify-buffer)
  (delete-trailing-whitespace))

(defun p-lorem ()
  "Insert a lorem ipsum."
  (interactive)
  (insert "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do "
          "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim"
          "ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut "
          "aliquip ex ea commodo consequat. Duis aute irure dolor in "
          "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla "
          "pariatur. Excepteur sint occaecat cupidatat non proident, sunt in "
          "culpa qui officia deserunt mollit anim id est laborum."))

(defun p-insert-date ()
  "Insert a time-stamp according to locale's date and time format."
  (interactive)
  (insert (format-time-string "%c" (current-time))))

(defun p-backward-kill-word (arg)
  "If the region is active, kills region.  Otherwise, backwards kills word."
  (interactive "p")
  (if transient-mark-mode
      (if (use-region-p)
          (kill-region (region-beginning) (region-end))
        (if subword-mode
            (subword-backward-kill arg)
          (backward-kill-word arg)))
    (kill-region (region-beginning) (region-end))))

(defun p-move-line-down (arg)
  "Move current line down while staying on current line"
  (interactive "p")
  (beginning-of-line)
  (newline arg)
  (indent-for-tab-command)
  (forward-line (- arg))
  (indent-for-tab-command))

(defun p-eol-and-ret (arg)
  "Move to the next line without altering current line"
  (interactive "p")
  (end-of-line)
  (newline arg)
  (indent-for-tab-command))

(defun p-join-next-line () ; thanks to whattheemacsd
  (interactive)
  (join-line -1))

(defun p-delete-current-line ()
  (interactive)
  (beginning-of-line)
  (kill-line 1)
  (beginning-of-line-text))

(defun p-package-name ()
  (p-keep-until-regexp
   (car (last (split-string (buffer-file-name) "/")))
   "\.el$"))

;; more whattheemacsd goodness
(defun p-fast-next-line ()
  (interactive)
  (ignore-errors (forward-line 5)))

(defun p-fast-previous-line ()
  (interactive)
  (ignore-errors (forward-line -5)))

(defun p-fast-forward-char ()
  (interactive)
  (ignore-errors (forward-char 5)))

(defun p-fast-backward-char ()
  (interactive)
  (ignore-errors (backward-char 5)))

(defun p-duplicate-line (&optional n)
  (interactive "p")
  (cl-dotimes (_ n)
    (save-excursion
      (copy-region-as-kill (line-beginning-position) (line-end-position))
      (end-of-line)
      (newline)
      (beginning-of-line)
      (yank))
    (forward-line)))

;;;;;;;;;;;;;;;;;
;; Keybindings ;;
;;;;;;;;;;;;;;;;;

(global-set-key (kbd "<S-return>") 'p-eol-and-ret)
(global-set-key (kbd "<C-return>") 'p-move-line-down)
(global-set-key (kbd "C-w") 'p-backward-kill-word)
(global-set-key (kbd "C-c d") 'p-duplicate-line)
(global-set-key (kbd "C-x \\") 'align-regexp)
(global-set-key (kbd "C-S-k") 'p-delete-current-line)
(global-set-key " " 'just-one-space)
(p-set-leader-key "n" 'p-cleanup-buffer)

(provide 'p-editing)

;;; p-editing.el ends here
