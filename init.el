; Basic
(add-to-list 'load-path (expand-file-name "lib/borg" user-emacs-directory))
(require 'borg)
(borg-initialize)
(require 'evil-magit)

(setq make-backup-files nil)
(tool-bar-mode 0)
(setq show-paren-delay 0)
(show-paren-mode 1)

; Solarized
(custom-set-variables
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default))))
(load-theme 'solarized-dark)

; Evil mode
(evil-mode 1)

(defun evil-keyboard-quit ()
  "Keyboard quit and force normal state."
  (interactive)
  (and evil-mode (evil-force-normal-state))
  (keyboard-quit))

(define-key evil-normal-state-map   (kbd "C-g") #'evil-keyboard-quit)
(define-key evil-motion-state-map   (kbd "C-g") #'evil-keyboard-quit)
(define-key evil-insert-state-map   (kbd "C-g") #'evil-normal-state)
(define-key evil-insert-state-map   [tab]       #'evil-normal-state)
(define-key evil-window-map         (kbd "C-g") #'evil-keyboard-quit)
(define-key evil-operator-state-map (kbd "C-g") #'evil-keyboard-quit)

(define-key evil-normal-state-map ";" 'evil-ex)

; Magit
(global-set-key (kbd "C-x g") 'magit-status)

; Linum relative
(linum-relative-global-mode)
(setq linum-relative-current-symbol "")

; Whitespace
(setq whitespace-display-mappings nil)

(custom-set-faces
  '(whitespace-tab ((t (:background "#073642"))))
  '(whitespace-trailing ((t (:background "yellow"))))
  )

(setq whitespace-style (quote (face tabs tab-mark trailing)))

(global-whitespace-mode)
