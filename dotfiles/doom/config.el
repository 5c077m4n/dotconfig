;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Roee Shapira")
(setq user-mail-address "ro33sha@duck.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.



(setq-default delete-by-moving-to-trash t)         ; Delete files to trash
(setq-default window-combination-resize t)         ; take new window space from all other windows (not just current)
(setq-default x-stretch-cursor t)                  ; Stretch cursor to the glyph width

(setq undo-limit 80000000)                         ; Raise undo-limit to 80Mb
(setq evil-want-fine-undo t)                       ; By default while in insert all changes are one big blob. Be more granular
(setq auto-save-default t)                         ; Nobody likes to loose work, I certainly don't
(setq truncate-string-ellipsis "…")                ; Unicode ellispis are nicer than "...", and also save /precious/ space
(setq scroll-preserve-screen-position 'always)     ; Don't have `point' jump around
(setq scroll-margin 2)                             ; It's nice to maintain a little margin
(setq display-time-default-load-average nil)       ; I don't think I've ever found this useful

(unless (string-match-p "^Power N/A" (battery))    ; On laptops...
  (display-battery-mode 1))                        ; it's nice to know how much power you have
(global-subword-mode 1)                            ; Iterate through CamelCase words

;; LSP config
(after! rustic (setq rustic-rustfmt-args "+nightly"))

;; Keymaps
;;; Misc
(map! :desc "Redo last action" :n "U" #'evil-redo)
(map! :desc "Remove highlight from last search" :n "RET" #'evil-ex-nohighlight)
;;; Window jumping
(map! :desc "Jump to window on left" :n "C-h" #'evil-window-left)
(map! :desc "Jump to window on bottom" :n "C-j" #'evil-window-down)
(map! :desc "Jump to window on top" :n "C-k" #'evil-window-up)
(map! :desc "Jump to window on right" :n "C-l" #'evil-window-right)
;;; Project Files
(map! :desc "Open file tree" :n "SPC t t" #'treemacs)
(map! :desc "Open old files" :n "SPC f o" #'recentf-open-files)
;;; Formatting
(map! :desc "Foramt entire buffer" :n "SPC l" #'format-all-buffer)
;;; LSP Actions
(map! :desc "Rename symbol in entire project" :n "SPC r n" #'lsp-rename)
(map! :desc "Goto next diagnostic error" :n "g ]" #'flycheck-next-error)
(map! :desc "Goto prev diagnostic error" :n "g [" #'flycheck-previous-error)
(map! :desc "Find all references" :n "g r" #'lsp-find-references)
;;; Search
(map! :desc "Search entire project" :n "SPC f s" #'+vertico/project-search)
(map! :desc "Search beffers" :n "SPC f b" #'ibuffer)
