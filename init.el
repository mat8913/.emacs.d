; Basic
(add-to-list 'load-path (expand-file-name "lib/borg" user-emacs-directory))
(require 'borg)
(borg-initialize)
(require 'use-package)

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
(use-package evil
  :demand t
  :bind (:map evil-insert-state-map
         ([tab] . evil-normal-state)
         ("C-g" . evil-normal-state)
         :map evil-normal-state-map
         (";" . evil-ex)
         ("C-g" . evil-keyboard-quit)
         :map evil-motion-state-map
         ("C-g" . evil-keyboard-quit)
         :map evil-window-map
         ("C-g" . evil-keyboard-quit)
         :map evil-operator-state-map
         ("C-g" . evil-keyboard-quit))
  :init
  (defun evil-keyboard-quit ()
    "Keyboard quit and force normal state."
    (interactive)
    (and evil-mode (evil-force-normal-state))
    (keyboard-quit))
  :config
  (evil-mode 1)
)

; Magit
(use-package magit
  :bind ("C-x g" . magit-status))

(use-package evil-magit
  :demand t)

; Linum relative
(linum-relative-global-mode)
(setq linum-relative-current-symbol "")

(defadvice linum-update-window (around linum-dynamic activate)
  (let* ((w (length (number-to-string
                     (count-lines (point-min) (point-max)))))
         (linum-relative-format (concat " %" (number-to-string w) "s ")))
    ad-do-it))
(set-face-attribute 'linum nil :background "#073642" :weight 'normal)

; Whitespace
(setq whitespace-display-mappings nil)

(custom-set-faces
  '(whitespace-tab ((t (:background "#073642"))))
  '(whitespace-trailing ((t (:background "yellow"))))
  )

(setq whitespace-style (quote (face tabs tab-mark trailing)))

(global-whitespace-mode)

; Powerline
(custom-set-faces
 '(mode-line ((t (:overline nil :underline nil))))
 '(mode-line-inactive ((t (:overline nil :underline nil))))
 '(powerline-evil-normal-face ((t (:inherit powerline-evil-base-face :background "#AFD700" :foreground "#005F00" :weight bold))))
 '(powerline-evil-insert-face ((t (:inherit powerline-evil-base-face :background "#FFFFFF" :foreground "#005F5F" :weight bold))))
 '(powerline-evil-visual-face ((t (:inherit powerline-evil-base-face :background "#FFAF00" :foreground "#875F00" :weight bold))))
 '(powerline-evil-replace-face ((t (:inherit powerline-evil-base-face :background "#D70000" :foreground "#FFFFFF" :weight bold))))
)

(defface my-pl-segment1-active
  '((t (:foreground "#FFFFFF" :background "#585858" :weight bold)))
  "Powerline first segment active face.")
(defface my-pl-segment1-inactive
  '((t (:foreground "#808080" :background "#262626")))
  "Powerline first segment inactive face.")
(defface my-pl-segment2-active
  '((t (:foreground "#9E9E9E" :background "#303030")))
  "Powerline second segment active face.")
(defface my-pl-segment2-inactive
  '((t (:foreground "#4F4F4F" :background "#121212")))
  "Powerline second segment inactive face.")
(defface my-pl-segment3-active
  '((t (:foreground "#9E9E9E" :background "#585858")))
  "Powerline third segment active face.")
(defface my-pl-segment3-inactive
  '((t (:foreground "#626262" :background "#262626")))
  "Powerline third segment inactive face.")
(defface my-pl-segment4-active
  '((t (:foreground "#262626" :background "#D0D0D0")))
  "Powerline fourth segment active face.")
(defface my-pl-segment4-inactive
  '((t (:foreground "#121212" :background "#626262")))
  "Powerline fourth segment inactive face.")

(defun air--powerline-default-theme ()
  "Set up my custom Powerline with Evil indicators."
  (setq-default mode-line-format
                '("%e"
                  (:eval
                   (let* ((active (powerline-selected-window-active))
                          (seg1 (if active 'my-pl-segment1-active 'my-pl-segment1-inactive))
                          (seg2 (if active 'my-pl-segment2-active 'my-pl-segment2-inactive))
                          (seg3 (if active 'my-pl-segment3-active 'my-pl-segment3-inactive))
                          (seg4 (if active 'my-pl-segment4-active 'my-pl-segment4-inactive))
                          (separator-left (intern (format "powerline-%s-%s"
                                                          (powerline-current-separator)
                                                          (car powerline-default-separator-dir))))
                          (separator-right (intern (format "powerline-%s-%s"
                                                           (powerline-current-separator)
                                                           (cdr powerline-default-separator-dir))))
                          (lhs (list (let ((evil-face (powerline-evil-face)))
                                       (if (and active evil-mode)
                                           (powerline-raw (powerline-evil-tag) evil-face)
                                         ))
                                     (if (and active evil-mode)
                                         (funcall separator-left (powerline-evil-face) seg1))
                                     (powerline-buffer-id seg1 'l)
                                     (powerline-raw "[%*]" seg1 'l)
                                     (when (and (boundp 'which-func-mode) which-func-mode)
                                       (powerline-raw which-func-format seg1 'l))
                                     (powerline-raw " " seg1)
                                     (funcall separator-left seg1 seg2)
                                     (powerline-vc seg2 'r)
                                     ))
                          (rhs (list (powerline-raw global-mode-string seg2 'r)


                                     (when (boundp 'erc-modified-channels-object)
                                       (powerline-raw erc-modified-channels-object seg2 'l))
                                     (powerline-major-mode seg2 'l)
                                     (powerline-process seg2)
                                     (powerline-minor-modes seg2 'l)
                                     (powerline-narrow seg2 'l)
                                     (powerline-raw " " seg2)

                                     (funcall separator-right seg2 seg3)

                                     (unless window-system
                                       (powerline-raw (char-to-string #xe0a1) seg3 'l))
                                     (powerline-raw " " seg3)
                                     (powerline-raw "%6p" seg3 'r)
                                     (funcall separator-right seg3 seg4)
                                     (powerline-raw "%4l" seg4 'l)
                                     (powerline-raw ":" seg4 'l)
                                     (powerline-raw "%3c" seg4 'r)
                                     (when powerline-display-hud
                                       (powerline-hud seg4 seg3))
                                     )))
                     (concat (powerline-render lhs)
                             (powerline-fill seg2 (powerline-width rhs))
                             (powerline-render rhs)))))))

(setq powerline-default-separator (if (display-graphic-p) 'arrow
                                    nil))
(air--powerline-default-theme)

; C mode
(add-hook 'c-mode-hook (lambda ()
    (c-set-style "linux")
))

; Haskell mode
(use-package haskell-mode
  :bind (:map haskell-mode-map
         ("<backtab>" . nil))
  :config
  (add-hook 'haskell-mode-hook #'intero-mode)
  (add-hook 'haskell-mode-hook 'kakapo-mode)
  (add-hook 'haskell-mode-hook (lambda ()
      (setq-local indent-tabs-mode nil)
      (setq-local tab-width 4)
      (setq-local evil-shift-width 4))))

; Kakapo mode
(use-package kakapo-mode
  :commands kakapo-open
  :config
  (add-hook 'kakapo-mode-hook (lambda ()
      (define-key evil-normal-state-local-map "o" (lambda () (interactive) (kakapo-open nil)))
      (define-key evil-normal-state-local-map "O" (lambda () (interactive) (kakapo-open t)))
      (define-key evil-insert-state-local-map (kbd "RET") 'kakapo-ret-and-indent)
      (define-key evil-insert-state-local-map (kbd "DEL") 'kakapo-backspace)
      (define-key evil-insert-state-local-map (kbd "<S-backspace>") 'kakapo-upline))))

; Company mode
(use-package company
  :bind (:map company-mode-map
         ("<backtab>" . company-complete)))
