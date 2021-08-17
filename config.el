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
;;(setq doom-theme 'zaiste)
;;(setq doom-theme 'leuven)
(setq doom-theme 'material-light)
(setq doom-font (font-spec :family "Hack Nerd Font" :size 21)
      doom-variable-pitch-font (font-spec :family "Libre Baskerville")
      doom-serif-font (font-spec :family "Libre Baskerville"))


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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Conda and Jupyter support

(use-package conda
  :defer t
  :init
  (setq conda-anaconda-home (expand-file-name "/opt/anaconda")
  conda-env-home-directory (expand-file-name "/opt/anaconda"))
  :config
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell))


;;;;;;;;;;;;;;;;;; Principio primera configuracion 

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

(use-package jupyter
    :config (set-face-attribute
             'jupyter-repl-traceback nil :background "wheat1")
    :ensure t
    :bind (:map jupyter-repl-mode-map
                ("C-n" . nil)
                ("C-p" . nil))
    :hook (jupyter-repl-mode . (lambda ()
                                 (company-mode)
                                 (setq company-backends '(company-capf)))))

(setq org-babel-default-header-args:sh    '((:results . "output replace"))
                  org-babel-default-header-args:bash  '((:results . "output replace"))
                  org-babel-default-header-args:shell '((:results . "output replace"))
                  org-babel-default-header-args:jupyter-python '((:async . "yes")
                                                                 (:session . "py")
                                                                 (:kernel . "geoenv")
))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (blockdiag . t)
   (jupyter . t))) 

(use-package ob-jupyter)
(setq org-confirm-babel-evaluate nil)
(setq ob-async-no-async-languages-alist '("jupyter-python")) 



(setq ob-mermaid-cli-path "/usr/bin/mmdc")

;;;;;;;;;;;;;;;;;; final primera configuracion 

;;;;;;;;;;;;;;;;;; Principio segunda configuracion 


; ;; Tool selection may be jedi, or anaconda-mode. This script settle it
; ;; down with anaconda-mode.
; (use-package company
;  :ensure t
;  :config
;  (setq company-idle-delay 0
;        company-minimum-prefix-length 2
;        company-show-numbers t
;        company-tooltip-limit 10
;        company-tooltip-align-annotations t
;        ;; invert the navigation direction if the the completion popup-isearch-match
;        ;; is displayed on top (happens near the bottom of windows)
;        company-tooltip-flip-when-above t)
;  (global-company-mode t)
;  )

; (use-package anaconda-mode
;   :ensure t
;   :config
;   (add-hook 'python-mode-hook 'anaconda-mode)
;   ;;(add-hook 'python-mode-hook 'anaconda-eldoc-mode)
; )

; (use-package company-anaconda
;   :ensure t
;   :init (require 'rx)
;   :after (company)
;   :config
;   (add-to-list 'company-backends 'company-anaconda)
; )

; (use-package jupyter
;   :commands (jupyter-run-server-repl
;              jupyter-run-repl
;              jupyter-server-list-kernels)
;   :ensure t
;   :init (eval-after-load 'jupyter-org-extensions ; conflicts with my helm config, I use <f2 #>
;           '(unbind-key "C-c h" jupyter-org-interaction-mode-map))
;   :bind (:map jupyter-repl-mode-map
;                 ("C-n" . nil)
;                 ("C-p" . nil))
;   :hook (jupyter-repl-mode . (lambda ()
;                                  (company-mode)
;                                  (setq company-backends '(company-capf))))
; )

; (use-package ob-jupyter)

; (after! org
;   (add-to-list 'org-structure-template-alist
;                '("jup" . "src jupyter-python :results raw drawer")))

; (org-babel-do-load-languages
;   'org-babel-load-languages
;   '((python . t)
;     (latex . t)
;     (jupyter . t)))

; (setq org-babel-default-header-args:sh    '((:results . "output replace"))
;                   org-babel-default-header-args:bash  '((:results . "output replace"))
;                   org-babel-default-header-args:shell '((:results . "output replace"))
;                   org-babel-default-header-args:jupyter-python '((:async . "yes")
;                                                                  (:session . "py")
;                                                                  (:kernel . "geonviroment")))

; (setq org-confirm-babel-evaluate nil)
; (setq ob-async-no-async-languages-alist '("jupyter-python")) 

;;;;;;;;;;;;;;;;;; Fin segunda configuracion 

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

(use-package! org-download
  :config
  ;; take an image that is already on the clipboard
  (customize-set-variable 'org-download-screenshot-method "xclip -selection clipboard -t image/png -o > %s"))

(use-package! org-cliplink)

(use-package org-special-block-extras
  :ensure nil
  :hook (org-mode . org-special-block-extras-mode)
  :custom
    (org-special-block-extras--docs-libraries
     '("~/org-special-block-extras/documentation.org")
     "The places where I keep my ‘#+documentation’")
    ;; (org-special-block-extras-fancy-links
    ;; nil "Disable this feature.")
  :config
  ;; Use short names like ‘defblock’ instead of the fully qualified name
  ;; ‘org-special-block-extras--defblock’
    (org-special-block-extras-short-names))

;;; Configuracion de autorecargar buffer 
(global-auto-revert-mode t)


(defun org-export-as-pdf ()
  (interactive)
  (save-buffer)
  (org-latex-export-to-pdf))

(add-hook 
 'org-mode-hook
 (lambda()
   (define-key org-mode-map 
       (kbd "<f5>") 'org-export-as-pdf)))

(add-hook 
 'org-mode-hook
 (lambda()
   (define-key org-mode-map 
       (kbd "<f6>") 'org-re-reveal-export-to-html)))


; (use-package pdf-tools
;    :pin manual
;    :config
;    (pdf-tools-install)
;    (setq-default pdf-view-display-size 'fit-width)
;    (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
;    :custom
;    (pdf-annot-activate-created-annotations t "automatically annotate highlights"))


(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
      TeX-source-correlate-start-server t)

(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)


(add-hook 'pdf-view-mode-hook (lambda() (linum-mode -1)))

;;;;;;;; org-ref

(setq bibtex-completion-bibliography "~/org/bibliography/references.bib"
      bibtex-completion-library-path "~/org/bibliography/bibtex-pdfs"
      bibtex-completion-notes-path "~/org/bibliography/bibtex-notes")

;; open pdf with system pdf viewer (works on mac)
(setq bibtex-completion-pdf-open-function
  (lambda (fpath)
    (start-process "open" "*open*" "open" fpath)))

(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))
(require 'org-ref)


(require 'org-re-reveal)
;;(require 'org-reveal)
; (require 'oer-reveal-publish)
; (oer-reveal-setup-submodules t)
; (oer-reveal-generate-include-files t)
; (oer-reveal-publish-setq-defaults)


(after! (org-re-reveal magit)
  (setq org-re-reveal-root (concat doom-local-dir "reveal.js")
        org-re-reveal-revealjs-version "4")
  (unless (file-directory-p org-re-reveal-root)
    (magit-run-git-async "clone" "https://github.com/hakimel/reveal.js.git" org-re-reveal-root)))


(add-to-list 'org-re-reveal-plugin-config '(chalkboard "RevealChalkboard" "https://cdn.jsdelivr.net/npm/reveal.js-plugins@4.1.2/chalkboard/plugin.js"))
(add-to-list 'org-re-reveal-plugin-config '(fullscreen "RevealFullscreen" "https://cdn.jsdelivr.net/npm/reveal.js-plugins@4.1.2/fullscreen/plugin.js"))

;;;;;;;;;;;;;;;;;;;;;; Recomendacion LSP y DAP

; (use-package lsp-mode
;   :init (setq lsp-keymap-prefix "C-;")
;   :hook ((js2-mode . lsp)
;          (yaml-mode . lsp)
;          (go-mode . lsp)
;          (typescript-mode . lsp)
;          (lsp-mode . lsp-enable-which-key-integration))
;   :config (progn
;             (define-key lsp-mode-map "M-." 'lsp-goto-implementation)
;             (let ((eslint-language-server-file "/home/samuelmesa/tmp/github.com/microsoft/vscode-eslint/server/out/eslintServer.js"))
;               (if (file-exists-p eslint-language-server-file)
;                   (setq lsp-eslint-server-command '("node" eslint-language-server-file "--stdio"))
;                 (message "You're missing the vscode eslint plugin. Currently, you have to manually install it."))))
;   :commands lsp lsp-deferred
;   ((typescript-language-server . "npm install -g typescript-language-server")
;    (javascript-typescript-langserver . "npm install -g javascript-typescript-langserver")
;    (yaml-language-server . "npm install -g yaml-language-server")
;    (tsc . "npm install -g typescript")
;    (gopls . "GO111MODULE=on go get golang.org/x/tools/gopls@latest")))

; (use-package lsp-python-ms
;   :init (setq lsp-python-ms-auto-install-server t)
;   :hook (python-mode . (lambda ()
;                          (require 'lsp-python-ms)
;                          (lsp))))

; (use-package lsp-ui
;   ;; flycheck integration & higher level UI modules
;   :commands lsp-ui-mode)

; (use-package company-lsp
;   ;; company-mode completion
;   :commands company-lsp
;   :config (push 'company-lsp company-backends))

; (use-package lsp-treemacs
;   ;; project wide overview
;   :commands lsp-treemacs-errors-list)

; (use-package dap-mode
;   :commands (dap-debug dap-debug-edit-template))

(use-package org2blog
  :ensure t)

(setq org2blog/wp-blog-alist
      '(("geotux"
         :url "https://geotux.tuxfamily.org/xmlrpc.php"
         :username "samtux")))
