(p-require-package 'helm 'melpa)
(p-require-package 'helm-ls-git 'melpa)

(require 'helm-ls-git)
(require 'p-leader)

(setq helm-for-files-preferred-list
      '(helm-source-buffers-list
        helm-source-ls-git
        helm-source-recentf
        helm-source-bookmarks
        helm-source-file-cache
        helm-source-files-in-current-dir
        helm-source-locate))

(p-set-leader-key "b" 'helm-for-files)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)

(eval-after-load 'helm
  '(define-key helm-map (kbd "C-w") nil))

(provide 'p-helm)

;;; p-helm.el ends here
