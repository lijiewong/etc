(add-to-list 'load-path "~/etc/emacs.d")

(setq-default fill-column 80)
(if window-system (tool-bar-mode -1))
(menu-bar-mode -1)
(column-number-mode 1)
(winner-mode 1)
(setq tramp-mode nil)

(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-use-filename-at-point 'guess)
(setq ido-use-url-at-point nil)
(setq ido-enable-tramp-completion nil)
(setq ido-auto-merge-work-directories-length -1)
(ido-mode 1)

(setq dabbrev-case-fold-search nil)
(setq-default indent-tabs-mode nil)
(setq-default require-final-newline 'ask)
(global-unset-key (kbd "C-x C-c"))
(global-set-key (kbd "M-/") 'dabbrev-completion)
(global-set-key (kbd "C-M-/") 'dabbrev-expand)
(global-set-key (kbd "C-M-_") 'dabbrev-expand)
(global-set-key (kbd "ESC M-w") 'clipboard-kill-ring-save)
(global-set-key (kbd "M-r") 'isearch-backward-regexp)
(global-set-key (kbd "M-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-c q q") 'query-replace)
(global-set-key (kbd "C-c q w") 'query-replace-regexp)
(global-set-key (kbd "C-x C-b") 'buffer-menu)
(global-set-key (kbd "M-<left>") 'windmove-left)
(global-set-key (kbd "ESC <left>") 'windmove-left)
(global-set-key (kbd "M-<right>") 'windmove-right)
(global-set-key (kbd "ESC <right>") 'windmove-right)
(global-set-key (kbd "M-<up>") 'windmove-up)
(global-set-key (kbd "ESC <up>") 'windmove-up)
(global-set-key (kbd "M-<down>") 'windmove-down)
(global-set-key (kbd "ESC <down>") 'windmove-down)
(global-set-key (kbd "<f5>") 'recompile)

;(setq font-lock-maximum-decoration 2)
(setq jit-lock-chunk-size 100)
(setq jit-lock-context-time 10)
(setq jit-lock-defer-time 2)
(setq jit-lock-stealth-load 90)
(setq jit-lock-stealth-nice 0.05)
(setq jit-lock-stealth-time 1)

(setq compilation-scroll-output 'first-error)

(setq
 backup-by-copying t
 backup-directory-alist '(("." . "~/.emacs_saves"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)

(require 'ffap)
(defun ffap-near-mouse-other-window (e)
  (interactive "e")
  (mouse-set-point e)
  (ffap-other-window))
(global-unset-key [C-down-mouse-1])
(global-set-key [C-mouse-1] 'ffap-near-mouse-other-window)

(require 'server)

(require 'whole-line-or-region)
(defadvice whole-line-or-region-kill-region (before read-only-ok activate)
  (interactive "p")
  (unless kill-read-only-ok (barf-if-buffer-read-only)))
(whole-line-or-region-mode 1)

(global-font-lock-mode 1)
(setq-default transient-mark-mode t)
(setq require-final-newline t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(setq find-file-visit-truename t)

(set-variable 'confirm-kill-emacs nil)

(defun toggle-window-dedicated ()
  "Toggle whether the current active window is dedicated or not."
  (interactive)
  (let* ((window (selected-window))
	 (dedicated (not (window-dedicated-p window))))
    (set-window-dedicated-p window dedicated)
    (message "Window '%s' is %s"
	     (current-buffer)
	     (if dedicated "dedicated" "normal"))))
(global-set-key "\C-\M-z" 'toggle-window-dedicated)

(require 'multi-term)
(setq multi-term-program "/bin/zsh")

(defun term-send-next-raw ()
  "Send the next character to the terminal."
  (interactive)
  (term-send-raw-string (char-to-string (read-quoted-char))))

(defun term-set-mark-command (arg)
  "Starts a mark from char mode"
  (interactive "P")
  (term-line-mode)
  (set-mark-command arg))

(setq term-bind-key-alist
      '(("C-q" . term-send-next-raw)
        ("C-c C-c" . term-send-raw)
        ("C-c C-j" . term-line-mode)
        ("C-c C-k" . term-char-mode)
        ("C-y" . term-paste)
        ("C-v" . scroll-up-command)
        ("C-<right>" . term-send-forward-word)
        ("C-<left>" . term-send-backward-word)
;	("M-," . term-send-input)
        ("M-d" . term-send-raw-meta)
        ("M-DEL" . term-send-raw-meta)
        ("C-@" . term-set-mark-command)))

(define-key term-mode-map (kbd "C-c C-c") 'term-char-mode)

(defun setup-mode-width (width)
  "Sets up width parameters for the mode"
  (font-lock-set-up-width-warning width)
  (set-fill-column width))

(add-hook 'c-mode-common-hook '(lambda () (setup-mode-width 80)))
(add-hook 'python-mode-hook '(lambda () (setup-mode-width 80)))
(add-hook 'java-mode-hook '(lambda () (setup-mode-width 100)))

(defun set-subword-mode ()
  "Sets subword mode"
  (if (fboundp 'subword-mode)
      (subword-mode 1)
      (c-subword-mode 1)))

(add-hook 'c-mode-common-hook 'set-subword-mode)
(add-hook 'python-mode-hook 'set-subword-mode)

(add-hook 'go-mode '(lambda () (setq tab-width 2)))

(defun get-buffer-create-temp (name)
  "Creates/gets a temporary buffer named name"
  (let ((buffer (get-buffer-create name)))
    (save-current-buffer
      (set-buffer buffer)
      (toggle-read-only t)
      (help-mode))
    buffer))

; braindead stuff that trigger regexps of death easily.
(compilation-minor-mode 0)
(delete 'watcom compilation-error-regexp-alist)

(require 'workgroups)
(setq wg-prefix-key (kbd "C-c w"))
(setq wg-switch-on-load nil)
(setq wg-morph-on nil)
(setq wg-mode-line-on nil)
(workgroups-mode 1)

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(add-to-list 'custom-theme-load-path "~/etc/emacs.d/emacs-color-theme-solarized")
(setq frame-background-mode 'dark)
(set-terminal-parameter nil 'background-mode 'dark)
(load-theme 'solarized t)

; VC is super slow. just disable it in general.
(add-hook 'emacs-startup-hook
          (lambda ()
            (global-auto-revert-mode 0)
            (setq vc-handled-backends 'nil)))

(add-hook 'window-configuration-change-hook
          (lambda ()
            (dolist (b (buffer-list 'nil))
              (with-current-buffer b
                (auto-revert-mode
                 (if (and (get-buffer-window 'nil 'visible)
                          buffer-file-name)
                     1 0))))))
