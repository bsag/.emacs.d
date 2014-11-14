;;; -*- lexical-binding: t -*-

(p-require-package 'erc-image 'melpa)

(require 'p-options)
(require 'p-jabber)

(defvar p-erc-channels '("#emacs"
                         "#clojure"
                         "#haskell"
                         "#ruby"
                         "#vim"
                         "##security"))

;; Join the a couple of interesting channels whenever connecting to Freenode.
(p-configure-feature erc
  (require 'erc-image)
  (add-to-list 'erc-modules 'image)
  (add-to-list 'erc-modules 'smiley)
  (setq erc-autojoin-channels-alist
        (list
         (cons "freenode.net"
               p-erc-channels)))

  (setq erc-track-enable-keybindings nil
        erc-nick "shosti"
        erc-password (p-password "Personal/erc"))

  ;; auto identify
  (erc-services-mode 1)
  (setq erc-prompt-for-nickserv-password nil)
  (setq erc-nickserv-passwords
        `((freenode ((,erc-nick . ,erc-password))))))

(defun p-erc-connect ()
  (interactive)
  (erc :server "irc.freenode.net"))

;; This seems like as good a place as any to put this
(defun p-switch-to-room ()
  (interactive)
  (let* ((chatrooms (append (p-hipchat-rooms)
                            (--map (cons it it) p-erc-channels)))
         (room-names (-map 'car chatrooms))
         (room
          (completing-read "Room: " room-names nil nil nil nil
                           (car room-names))))
    (switch-to-buffer (cdr (assoc room chatrooms)))))

(p-set-leader-key "j" 'p-switch-to-room)

(provide 'p-erc)
