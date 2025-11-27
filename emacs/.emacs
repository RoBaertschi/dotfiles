(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

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

(use-package exec-path-from-shell :config (exec-path-from-shell-initialize))
(use-package doom-themes :init
  (load-theme 'doom-one))

(use-package evil
  :init
  (setq evil-undo-system 'undo-redo
	evil-toggle-key "C-z"
	evil-want-C-u-scroll t)
  (modify-syntax-entry ?_ "w")
  :config
  (evil-mode 1))

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

(load "~/.emacs.d/odin-mode.el")
