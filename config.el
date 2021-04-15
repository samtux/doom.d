;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Samuel Mesa"
      user-mail-address "samuelmesa@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-solarized-light)
(setq doom-theme 'zaiste)
(setq doom-font (font-spec :family "JetBrains Mono" :size 21))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(require 'ox-latex)
(setq org-latex-listings t)
(add-to-list 'org-latex-packages-alist '("" "listings"))
(add-to-list 'org-latex-packages-alist '("" "color"))
(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-latex-listings 'minted)

(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(cond
 ((string-equal doom-theme "zaiste")
  (progn
    (custom-set-faces
     '(org-block-begin-line
       ((t (:underline "#A7A6AA" :foreground "#000000" :background "#E7E7E7"))))
     '(org-block
       ((t (:background "#EFF0F1"))))
     '(org-block-end-line
       ((t (:overline "#A7A6AA" :foreground "#000000" :background "#E7E7E7"))))
     )
)))

;; Conda and Jupyter support

(use-package conda
  :defer t
  :init
  (setq conda-anaconda-home (expand-file-name "/opt/anaconda")
  conda-env-home-directory (expand-file-name "/opt/anaconda"))
  :config
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell))


;; Tool selection may be jedi, or anaconda-mode. This script settle it
;; down with anaconda-mode.
(use-package company
 :ensure t
 :config
 (setq company-idle-delay 0
       company-minimum-prefix-length 2
       company-show-numbers t
       company-tooltip-limit 10
       company-tooltip-align-annotations t
       ;; invert the navigation direction if the the completion popup-isearch-match
       ;; is displayed on top (happens near the bottom of windows)
       company-tooltip-flip-when-above t)
 (global-company-mode t)
 )

(use-package anaconda-mode
  :ensure t
  :config
  (add-hook 'python-mode-hook 'anaconda-mode)
  ;;(add-hook 'python-mode-hook 'anaconda-eldoc-mode)
)

(use-package company-anaconda
  :ensure t
  :init (require 'rx)
  :after (company)
  :config
  (add-to-list 'company-backends 'company-anaconda)
)

(use-package jupyter
  :commands (jupyter-run-server-repl
             jupyter-run-repl
             jupyter-server-list-kernels)
  :ensure t
  :init (eval-after-load 'jupyter-org-extensions ; conflicts with my helm config, I use <f2 #>
          '(unbind-key "C-c h" jupyter-org-interaction-mode-map))
  :bind (:map jupyter-repl-mode-map
                ("C-n" . nil)
                ("C-p" . nil))
  :hook (jupyter-repl-mode . (lambda ()
                                 (company-mode)
                                 (setq company-backends '(company-capf))))
)

(use-package ob-jupyter)

(after! org
  (add-to-list 'org-structure-template-alist
               '("jup" . "src jupyter-python :results raw drawer")))

(org-babel-do-load-languages
  'org-babel-load-languages
  '((python . t)
    (latex . t)
    (jupyter . t)))

(setq org-babel-default-header-args:sh    '((:results . "output replace"))
                  org-babel-default-header-args:bash  '((:results . "output replace"))
                  org-babel-default-header-args:shell '((:results . "output replace"))
                  org-babel-default-header-args:jupyter-python '((:async . "yes")
                                                                 (:session . "py")
                                                                 (:kernel . "base")))

(setq org-confirm-babel-evaluate nil)
(setq ob-async-no-async-languages-alist '("jupyter-python")) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Configuraciones adicionales

(define-skeleton org-skeleton
  "Header info for a emacs-org file."
  "Title: "
  "#+TITLE:" str " \n"
  "#+AUTHOR: Your Name\n"
  "#+email: your-email@server.com\n"
  "#+INFOJS_OPT: \n"
  "#+BABEL: :session *R* :cache yes :results output graphics :exports both :tangle yes \n"
  "-----"
 )
(global-set-key [C-S-f4] 'org-skeleton)