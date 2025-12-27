(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(global-display-line-numbers-mode 1)
(editorconfig-mode)
(set-language-environment "UTF-8")
(setq display-line-numbers-type 'relative)

;; Use spaces instead of tabs
(defadvice align-regexp (around align-regexp-with-spaces activate)
  (let ((indent-tabs-mode nil))
    ad-do-it))

(defun backup-dir (dir)
  `(("" .
     ,(expand-file-name
       (concat user-emacs-directory dir)))))

(setq backup-directory-alist (backup-dir "backup/per-save"))

(defun force-backup-of-buffer ()
  (when (not buffer-backed-up)
    (let ((backup-directory-alist (backup-dir "backup/per-session"))
	   (kept-new-versions 3))
      (backup-buffer)))
  (let ((buffer-backed-up nil))
    (backup-buffer)))

(add-hook 'before-save-hook 'force-backup-of-buffer)

(setq auto-save-file-name-transforms
      `((".*"
	 ,(expand-file-name (concat user-emacs-directory "autosaves"))
	   t)))

(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t
      backup-by-copying t
      vc-make-backup-files t)

(setq custom-file  "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(require 'package)

(defmacro append-to-list (target suffix)
  "Append SUFFIX to TARGET in place."
  `(setq ,target (append ,target ,suffix)))

(append-to-list package-archives
		'(("melpa" . "http://melpa.org/packages/") ;; Main package archive
		  ("melpa-stable" . "https://stable.melpa.org/packages/") ;; Some packages only do stable releases.
		  ("org-elpa" . "https://orgmode.org/elpa/"))) ;; Orgmode, if ever needed

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq
 use-package-always-ensure t
 use-package-verbose t)

(unless (eq system-type 'windows-nt)
  (use-package exec-path-from-shell :config (exec-path-from-shell-initialize)))

(setq inhibit-splash-screen t)

(use-package doom-themes :init
  (load-theme 'doom-one))

(use-package evil
  :init
  (setq evil-undo-system 'undo-redo
	evil-toggle-key "C-z"
	evil-want-C-u-scroll t
	evil-want-keybinding nil)
  (modify-syntax-entry ?_ "w")
  :config
  (evil-mode 1))

(use-package evil-collection :init (evil-collection-init))

(use-package ivy
  :init
  (ivy-mode 1)
  (setq ivy-height 15
	ivy-use-virtual-buffers t
	ivy-use-selectable-prompt t))

(use-package counsel
  :after ivy
  :init
  (counsel-mode 1)
  :bind (:map ivy-minibuffer-map))

(setq auth-sources '("~/.authinfo"))

(use-package magit)
(use-package forge :after magit)

(unless (package-installed-p 'eglot-booster)
  (package-vc-install "https://github.com/jdtsmith/eglot-booster.git"))

(use-package eglot-booster
  :after eglot
  :config (eglot-booster-mode))

(use-package eldoc-box
  :config
  (add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-at-point-mode t)
  (eldoc-box-hover-at-point-mode))

(defun my-company-sort-by-length (candidates)
  "Sort completion CANDIDATES by their length, shortest first."
  (sort candidates
        (lambda (a b) (< (length a) (length b)))))

(use-package company
  :hook ((prog-mode . company-mode))
  :config
  (setq company-minimum-prefix-length 0
	company-idle-delay 0.01
	company-dabbrev-downcase 0
	company-format-margin-function 'company-dot-icons-margin
	company-frontends '(company-pseudo-tooltip-frontend company-echo-metadata-frontend))
  :bind (:map company-active-map
	      ("<TAB>" . nil)
	      ([tab] . nil)
	      ("C-y" . company-complete-selection)))


(use-package hl-todo
  :config
  (global-hl-todo-mode)
  (setq hl-todo-color-background nil
	hl-todo-highlight-punctuation "(Rrobin):"))

;; HOLD(Hello World) :
;; TODO(robin):
;; NEXT(\\w*):
;; THEM: robin
;; PROG:
;; OKAY:
;; DONT:
;; FAIL:
;; DONE:
;; NOTE:
;; MAYBE:
;; KLUDGE:
;; HACK:
;; TEMP:
;; FIXME:
;; XXX:



;; (use-package company-box
;;   :after company
;;   :config (company-box-mode))

(load "~/.emacs.d/odin-mode.el")
