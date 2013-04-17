;;; -*- lexical-binding: t -*-
;;; Miscellaneous options and settings

(require 'p-path)

;;;;;;;;;;;;;;
;; Settings ;;
;;;;;;;;;;;;;;

(setq disabled-command-function nil)
(setq dired-use-ls-dired nil)

;;;;;;;;;;;;
;; Backup ;;
;;;;;;;;;;;;

(setq make-backup-files nil)
(setq auto-save-default nil)

;;;;;;;;;;
;; File ;;
;;;;;;;;;;

(setq recentf-max-saved-items 200)
(setq delete-by-moving-to-trash t)
(setq trash-directory (expand-file-name "~/.Trash"))

(setq comint-scroll-to-bottom-on-output t)
(setq-default major-mode 'text-mode)

(setq tetris-score-file (concat user-emacs-directory "tetris-scores"))

;;;;;;;;;;;;;;;
;; Functions ;;
;;;;;;;;;;;;;;;

(defvar p-passwords-loaded nil)

(defun p-load-password-file ()
  (let ((password-file (expand-file-name "~/.passwords.gpg")))
    (when (file-exists-p password-file)
      (load password-file)
      (setq p-passwords-loaded t))))

(defun p-password (sym)
  (unless p-passwords-loaded
    (p-load-password-file))
  (if (boundp sym)
      (symbol-value sym)
    nil))

;; recompile modules directory
(defun p-delete-current-buffer-file ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (ido-kill-buffer)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename t)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))

(defun p-rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(defun p-kill-emacs-hook ()
  (byte-recompile-directory p-dir 0)
  (byte-recompile-file (concat user-emacs-directory "init.el") nil 0))

(add-hook 'kill-emacs-hook 'p-kill-emacs-hook)

;;;;;;;;;;;;;;;;;
;; Keybindings ;;
;;;;;;;;;;;;;;;;;

(global-set-key (kbd "C-x C-r") 'p-rename-current-buffer-file)
(global-set-key (kbd "C-x C-k") 'p-delete-current-buffer-file)

(provide 'p-options)

;;; p-options.el ends here
