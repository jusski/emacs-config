; This is my super-poopy .emacs file.
; This is my super-poopy .emacs file.
; I barely know how to program LISP, and I know
; even less about ELISP.  So take everything in
; this file with a grain of salt!
;
; - Casey

; Stop Emacs from losing undo information by
; setting very high limits for undo buffers
(setq undo-limit 20000000)
(setq undo-strong-limit 40000000)

					; Determine the underlying operating system
(setq casey-aquamacs (featurep 'aquamacs))
(setq casey-linux (featurep 'x))
(setq casey-win32 (not (or casey-aquamacs casey-linux)))

(setq casey-todo-file "w:/handmade/code/todo.txt")
(setq casey-log-file "w:/handmade/code/log.txt")

(global-hl-line-mode 1)
(set-face-background 'hl-line "midnight blue")

(setq compilation-directory-locked nil)
(scroll-bar-mode -1)
(setq shift-select-mode nil)
(setq enable-local-variables nil)
(setq casey-font "outline-DejaVu Sans Mono")

(when casey-win32 
  (setq casey-makescript "build.bat")
  (setq casey-font "outline-Liberation Mono")
  )

(when casey-aquamacs 
  (cua-mode 0) 
  (osx-key-mode 0)
  (tabbar-mode 0)
  (setq mac-command-modifier 'meta)
  (setq x-select-enable-clipboard t)
  (setq aquamacs-save-options-on-quit 0)
  (setq special-display-regexps nil)
  (setq special-display-buffer-names nil)
  (define-key function-key-map [return] [13])
  (setq mac-command-key-is-meta t)
  (scroll-bar-mode nil)
  (setq mac-pass-command-to-system nil)
  (setq casey-makescript "./build.macosx")
  )

(when casey-linux
  (setq casey-makescript "./build.linux")
  (display-battery-mode 1)
  )

					; Turn off the toolbar
(tool-bar-mode 0)

(load-library "view")
(require 'cc-mode)
(require 'ido)
(require 'compile)
(ido-mode t)

					; Setup my find-files
(define-key global-map "\ef" 'counsel-find-file)
(define-key global-map "\eF" 'find-file-other-window)

(global-set-key (read-kbd-macro "\eb")  'counsel-switch-buffer)
(global-set-key (read-kbd-macro "\eB")  'counsel-switch-buffer-other-window)

(defun casey-ediff-setup-windows (buffer-A buffer-B buffer-C control-buffer)
  (ediff-setup-windows-plain buffer-A buffer-B buffer-C control-buffer)
  )
(setq ediff-window-setup-function 'casey-ediff-setup-windows)
(setq ediff-split-window-function 'split-window-horizontally)

					; Turn off the bell on Mac OS X
(defun nil-bell ())
(setq ring-bell-function 'nil-bell)

					; Setup my compilation mode
(defun casey-big-fun-compilation-hook ()
  (make-local-variable 'truncate-lines)
  (setq truncate-lines nil)
  )

(add-hook 'compilation-mode-hook 'casey-big-fun-compilation-hook)

(defun load-todo ()
  (interactive)
  (find-file casey-todo-file)
  )
(define-key global-map "\et" 'load-todo)

(defun insert-timeofday ()
  (interactive "*")
  (insert (format-time-string "---------------- %a, %d %b %y: %I:%M%p")))
(defun load-log ()
  (interactive)
  (find-file casey-log-file)
  (if (boundp 'longlines-mode) ()
    (longlines-mode 1)
    (longlines-show-hard-newlines))
  (if (equal longlines-mode t) ()
    (longlines-mode 1)
    (longlines-show-hard-newlines))
  (end-of-buffer)
  (newline-and-indent)
  (insert-timeofday)
  (newline-and-indent)
  (newline-and-indent)
  (end-of-buffer)
  )
(define-key global-map "\eT" 'load-log)

					; no screwing with my middle mouse button
(global-unset-key [mouse-2])

					; Bright-red TODO
(setq fixme-modes '(c++-mode c-mode emacs-lisp-mode))
(make-face 'font-lock-important-face)
(make-face 'font-lock-fixme-face)
(make-face 'font-lock-note-face)
(make-face 'font-lock-function-call-face)
(make-face 'font-lock-macros-face)
(mapc (lambda (mode)
	(font-lock-add-keywords
	 mode
	 '(("\\<\\(TODO\\)" 1 'font-lock-fixme-face t)
	   ("\\<\\(IMPORTANT\\)" 1 'font-lock-important-face t)
	   ("\\<\\([A-Z_]+_[A-Z0-9_]+\\)" 1 'font-lock-macros-face t)
	   ("\\<\\(internal\\)" 1 'font-lock-macros-face t)
	   ("\\<\\([[:upper:]]\\sw+\\)(" 1 'font-lock-function-call-face t)
	   ("\\<\\(PushArray\\)" 1 'font-lock-macros-face t)
	   ("\\<\\(PushStruct\\)" 1 'font-lock-macros-face t)
	   ("\\<\\(PushSize\\)" 1 'font-lock-macros-face t)
	   ("\\<\\(ArrayCount\\)" 1 'font-lock-macros-face t)
	   ("\\<\\(InvalidDefaultCase\\)" 1 'font-lock-macros-face t)
	   ("\\<\\(Maximum\\)" 1 'font-lock-macros-face t)
	   ("\\<\\(Minimum\\)" 1 'font-lock-macros-face t)
	   ("\\<\\(MegaBytes\\)" 1 'font-lock-macros-face t)
	   ("\\<\\(KilloBytes\\)" 1 'font-lock-macros-face t)
	   ("\\<\\(BITMAP_BYTES_PER_PIXEL\\)" 1 'font-lock-macros-face t)
	   ("\\<\\(Trace\\)" 1 'font-lock-macros-face t)
	   ("\\<\\(Assert\\)" 1 'font-lock-macros-face t)
	   ("\\<\\(INVALID_CODE_PATH\\)" 1 'font-lock-macros-face t)
	   ("\\<\\(NOTE\\)" 1 'font-lock-note-face t))))
      fixme-modes)

;(modify-face 'font-lock-macros-face "SteelBlue" nil nil nil nil nil nil nil)
(modify-face 'font-lock-fixme-face "Red" nil nil t nil t nil nil)
(modify-face 'font-lock-important-face "Yellow" nil nil t nil t nil nil)
(modify-face 'font-lock-note-face "Dark Green" nil nil t nil t nil nil)
;(modify-face 'font-lock-function-call-face "IndianRed" nil nil nil nil nil nil nil)

					; Accepted file extensions and their appropriate modes
(setq auto-mode-alist
      (append
       '(("\\.cpp$"    . c++-mode)
         ("\\.hin$"    . c++-mode)
         ("\\.cin$"    . c++-mode)
         ("\\.inl$"    . c++-mode)
         ("\\.rdc$"    . c++-mode)
         ("\\.h$"    . c++-mode)
	 ("\\.vs$"    . c++-mode)
	 ("\\.fs$"    . c++-mode)
         ("\\.c$"   . c++-mode)
         ("\\.cc$"   . c++-mode)
         ("\\.c8$"   . c++-mode)
         ("\\.txt$" . indented-text-mode)
         ("\\.emacs$" . emacs-lisp-mode)
         ("\\.gen$" . gen-mode)
         ("\\.ms$" . fundamental-mode)
         ("\\.m$" . objc-mode)
         ("\\.mm$" . objc-mode)
         ) auto-mode-alist))

					; C++ indentation style
(defconst casey-big-fun-c-style
  '((c-electric-pound-behavior   . nil)
    (c-tab-always-indent         . t)
    (c-comment-only-line-offset  . 0)
    (c-hanging-braces-alist      . ((class-open)
                                    (class-close)
                                    (defun-open)
                                    (defun-close)
                                    (inline-open)
                                    (inline-close)
                                    (brace-list-open)
                                    (brace-list-close)
                                    (brace-list-intro)
                                    (brace-list-entry)
                                    (block-open)
                                    (block-close)
                                    (substatement-open)
                                    (statement-case-open)
                                    (class-open)))
    (c-hanging-colons-alist      . ((inher-intro)
                                    (case-label)
                                    (label)
                                    (access-label)
                                    (access-key)
                                    (member-init-intro)))
    (c-cleanup-list              . (scope-operator
                                    list-close-comma
                                    defun-close-semi))
    (c-offsets-alist             . ((arglist-close         .  c-lineup-arglist)
                                    (label                 . -4)
				    (comment-intro         .  0)
                                    (access-label          . -4)
                                    (substatement-open     .  0)
                                    (statement-cont        .  c-lineup-assignments)
				    (class-open            .  0)
                                    (statement-case-intro  .  4)
                                    (statement-block-intro .  4)
                                    (case-label            .  4)
                                    (block-open            .  0)
                                    (inline-open           .  0)
                                    (topmost-intro-cont    .  0)
                                    (knr-argdecl-intro     . -4)
                                    (brace-list-open       .  0)
                                    (brace-list-intro      .  4)))
    (c-echo-syntactic-information-p . t))
  "Casey's Big Fun C++ Style")


					; CC++ mode handling
(defun casey-big-fun-c-hook ()
					; Set my style for the current buffer
  (c-add-style "BigFun" casey-big-fun-c-style t)
  
					; 4-space tabs
  (setq tab-width 4
        indent-tabs-mode nil)

					; Additional style stuff
  (c-set-offset 'member-init-intro '++)

					; No hungry backspace
  (c-toggle-auto-hungry-state -1)

					; Newline indents, semi-colon doesn't

  (setq c-hanging-semi&comma-criteria '((lambda () 'stop)))
  
					; Handle super-tabbify (TAB completes, shift-TAB actually tabs)
  (setq dabbrev-case-replace t)
  (setq dabbrev-case-fold-search t)
  (setq dabbrev-upcase-means-case-search t)

					; Abbrevation expansion
  (abbrev-mode 1)
  
  (defun casey-header-format ()
    "Format the given file as a header file."
    (interactive)
    (setq BaseFileName (file-name-sans-extension (file-name-nondirectory buffer-file-name)))
    (insert "#pragma once")
    
    )

  (defun casey-source-format ()
    "Format the given file as a source file."
    (interactive)
    (setq BaseFileName (file-name-sans-extension (file-name-nondirectory buffer-file-name)))
    
    )

  (cond ((file-exists-p buffer-file-name) t)
        ((string-match "[.]hin" buffer-file-name) (casey-source-format))
        ((string-match "[.]cin" buffer-file-name) (casey-source-format))
        ((string-match "[.]h" buffer-file-name) (casey-header-format))
        ((string-match "[.]cpp" buffer-file-name) (casey-source-format)))

  (defun casey-find-corresponding-file ()
    "Find the file that corresponds to this one."
    (interactive)
    (setq CorrespondingFileName nil)
    (setq BaseFileName (file-name-sans-extension buffer-file-name))
    (if (string-match "\\.c" buffer-file-name)
	(setq CorrespondingFileName (concat BaseFileName ".h")))
    (if (string-match "\\.h" buffer-file-name)
	(if (file-exists-p (concat BaseFileName ".c")) (setq CorrespondingFileName (concat BaseFileName ".c"))
	  (setq CorrespondingFileName (concat BaseFileName ".cpp"))))
    (if (string-match "\\.hin" buffer-file-name)
	(setq CorrespondingFileName (concat BaseFileName ".cin")))
    (if (string-match "\\.cin" buffer-file-name)
	(setq CorrespondingFileName (concat BaseFileName ".hin")))
    (if (string-match "\\.cpp" buffer-file-name)
	(setq CorrespondingFileName (concat BaseFileName ".h")))
    (if CorrespondingFileName (find-file CorrespondingFileName)
      (error "Unable to find a corresponding file")))
  (defun casey-find-corresponding-file-other-window ()
    "Find the file that corresponds to this one."
    (interactive)
    (find-file-other-window buffer-file-name)
    (casey-find-corresponding-file)
    (other-window -1))
  (define-key c++-mode-map [f12] 'casey-find-corresponding-file)
  (define-key c++-mode-map [M-f12] 'casey-find-corresponding-file-other-window)

					; Alternate bindings for F-keyless setups (ie MacOS X terminal)
  (define-key c++-mode-map "\ec" 'casey-find-corresponding-file)
  (define-key c++-mode-map "\eC" 'casey-find-corresponding-file-other-window)

  (define-key c++-mode-map "\es" 'casey-save-buffer)

  (define-key c++-mode-map "\t" 'dabbrev-expand)
;  (define-key c++-mode-map [S-tab] 'indent-for-tab-command)
  (define-key c++-mode-map "\C-y" 'indent-for-tab-command)
 ; (define-key c++-mode-map [C-tab] 'indent-region)
 
  (define-key c++-mode-map "\e." 'c-fill-paragraph)


  (define-key c++-mode-map "\e " 'set-mark-command)
					;clang error parsing
;  (add-to-list 'compilation-error-regexp-alist-alist
 ;            '(clang-anonymous
  ;             "^.* at \\(\\([^\n:/]+/\\)+[^\n:/]+\\):\\([0-9]+\\):\\([0-9]+\\)"
   ;            1 3 4))
  (add-to-list 'compilation-error-regexp-alist 'clang-anonymous)
  (add-to-list 'compilation-error-regexp-alist-alist
               '(clang-anonymous
		 "\\(^.*.cpp\\)\(\\([0-9]+\\),\\([0-9]+\\)\):.*"
               
               1 2 3))
  ;(add-to-list 'compilation-error-regexp-alist 'clang-anonymous)
  
  ; devenv.com error parsing
  ;(add-to-list 'compilation-error-regexp-alist 'casey-devenv)
  ;(add-to-list 'compilation-error-regexp-alist-alist '(casey-devenv
   ;"*\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) : \\(?:see declaration\\|\\(?:warnin\\(g\\)\\|[a-z ]+\\) C[0-9]+:\\)"
    ;2 3 nil (4)))
)

(defun casey-replace-string (FromString ToString)
  "Replace a string without moving point."
  (interactive "sReplace: \nsReplace: %s  With: ")
  (save-excursion
    (replace-string FromString ToString)
  ))
(define-key global-map [f8] 'casey-replace-string)

(add-hook 'c-mode-common-hook 'casey-big-fun-c-hook)

(defun casey-save-buffer ()
  "Save the buffer after untabifying it."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (untabify (point-min) (point-max))))
  (save-buffer))

; TXT mode handling
(defun casey-big-fun-text-hook ()
  ; 4-space tabs
  (setq tab-width 4
        indent-tabs-mode nil)

  ; Newline indents, semi-colon doesn't
  (define-key text-mode-map "\C-m" 'newline-and-indent)

  ; Prevent overriding of alt-s
  (define-key text-mode-map "\es" 'casey-save-buffer)
  )
(add-hook 'text-mode-hook 'casey-big-fun-text-hook)

; Window Commands
(defun w32-restore-frame ()
    "Restore a minimized frame"
     (interactive)
     (w32-send-sys-command 61728))

(defun maximize-frame ()
    "Maximize the current frame"
     (interactive)
     (when casey-aquamacs (aquamacs-toggle-full-frame))
     (when casey-win32 (w32-send-sys-command 61488)))

(define-key global-map "\ep" 'maximize-frame)
(define-key global-map "\ew" 'other-window)

; Navigation
(defun previous-blank-line ()
  "Moves to the previous line containing nothing but whitespace."
  (interactive)
  (search-backward-regexp "^[ \t]*\n")
)

(defun next-blank-line ()
  "Moves to the next line containing nothing but whitespace."
  (interactive)
  (forward-line)
  (search-forward-regexp "^[ \t]*\n")
  (forward-line -1)
)

(define-key global-map [C-right] 'forward-word)
(define-key global-map [C-left] 'backward-word)
(define-key global-map [C-up] 'previous-blank-line)
(define-key global-map [C-down] 'next-blank-line)
(define-key global-map [home] 'beginning-of-line)
(define-key global-map [end] 'end-of-line)
(define-key global-map [pgup] 'forward-page)
(define-key global-map [pgdown] 'backward-page)
(define-key global-map [C-next] 'scroll-other-window)
(define-key global-map [C-prior] 'scroll-other-window-down)

; ALT-alternatives
(defadvice set-mark-command (after no-bloody-t-m-m activate)
  "Prevent consecutive marks activating bloody `transient-mark-mode'."
  (if transient-mark-mode (setq transient-mark-mode nil)))

(defadvice mouse-set-region-1 (after no-bloody-t-m-m activate)
  "Prevent mouse commands activating bloody `transient-mark-mode'."
  (if transient-mark-mode (setq transient-mark-mode nil))) 

(defun append-as-kill ()
  "Performs copy-region-as-kill as an append."
  (interactive)
  (append-next-kill) 
  (copy-region-as-kill (mark) (point))
)
(define-key global-map "\e " 'set-mark-command)
(define-key global-map "\eq" 'copy-region-as-kill)
(define-key global-map "\ez" 'kill-region)
(define-key global-map [M-up] 'previous-blank-line)
(define-key global-map [M-down] 'next-blank-line)
(define-key global-map [M-right] 'forward-whitespace)
(define-key global-map [M-left] 'backward-to-word)

;(define-key global-map "\e:" 'View-back-to-mark)
;(define-key global-map "\e;" 'exchange-point-and-mark)

(define-key global-map [f9] 'first-error)
(define-key global-map [f10] 'previous-error)
(define-key global-map [f11] 'next-error)

(define-key global-map "\en" 'next-error)
(define-key global-map "\eN" 'previous-error)

(define-key global-map "\eg" 'goto-line)

; Editting
(define-key global-map "" 'nil)
(define-key global-map "\eu" 'undo)
(define-key global-map "\e6" 'upcase-word)
(define-key global-map "\e^" 'captilize-word)
(define-key global-map "\e." 'fill-paragraph)

(defun casey-replace-in-region (old-word new-word)
  "Perform a replace-string in the current region."
  (interactive "sReplace: \nsReplace: %s  With: ")
  (save-excursion (save-restriction
		    (narrow-to-region (mark) (point))
		    (beginning-of-buffer)
		    (replace-string old-word new-word)
		    ))
  )
(define-key global-map [f7] 'casey-replace-in-region)


; \377 is alt-backspace
(define-key global-map "\377" 'backward-kill-word)
(define-key global-map [M-delete] 'kill-word)

(define-key global-map "\e[" 'start-kbd-macro)
(define-key global-map "\e]" 'end-kbd-macro)
(define-key global-map "\e'" 'call-last-kbd-macro)

; Buffers
(define-key global-map "\er" 'revert-buffer)
;(define-key global-map "\ek" 'kill-this-buffer)
(define-key global-map "\es" 'save-buffer)

; Compilation
(setq compilation-context-lines 0)
(setq compilation-error-regexp-alist
    (cons '("^\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) : \\(?:fatal error\\|warnin\\(g\\)\\) C[0-9]+:" 2 3 nil (4))
     compilation-error-regexp-alist))

(defun find-project-directory-recursive ()
  "Recursively search for a makefile."
  (interactive)
  (if (file-exists-p casey-makescript) t
      (cd "../")
      (find-project-directory-recursive)))

(defun lock-compilation-directory ()
  "The compilation process should NOT hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked t)
  (message "Compilation directory is locked."))

(defun unlock-compilation-directory ()
  "The compilation process SHOULD hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked nil)
  (message "Compilation directory is roaming."))

(defun find-project-directory ()
  "Find the project directory."
  (interactive)
  (setq find-project-from-directory default-directory)
  (switch-to-buffer-other-window "*compilation*")
  (if compilation-directory-locked (cd last-compilation-directory)
  (cd find-project-from-directory)
  (find-project-directory-recursive)
  (setq last-compilation-directory default-directory)))

(defun make-without-asking ()
  "Make the current build."
  (interactive)
  (save-some-buffers t)
  (if (find-project-directory) (compile casey-makescript))
  (other-window 1))
(define-key global-map "\em" 'make-without-asking)

; Commands
;(set-variable 'grep-command "rg -n -H --no-heading --color always -e  ")

; Smooth scroll
(setq scroll-step 3)

; Clock
(display-time)

; Startup windowing
(setq next-line-add-newlines nil)
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil)
(split-window-horizontally)

(defun casey-never-split-a-window ()
	    "Never, ever split a window.  Why would anyone EVER want you to do that??"
	    nil)
(setq split-window-preferred-function 'casey-never-split-a-window)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(auto-save-interval 0)
 '(auto-save-list-file-prefix nil)
 '(auto-save-timeout 0)
 '(auto-show-mode t t)
 '(delete-auto-save-files nil)
 '(delete-old-versions (quote other))
 '(imenu-auto-rescan t)
 '(imenu-auto-rescan-maxout 500000)
 '(kept-new-versions 5)
 '(kept-old-versions 5)
 '(make-backup-file-name-function (quote ignore))
 '(make-backup-files nil)
 '(mouse-wheel-follow-mouse nil)
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount (quote (15)))
 '(version-control nil)
 '(rcirc-reconnect-delay 60)
 '(rcirc-omit-responses '("JOIN" "PART" "QUIT" "NICK" "NAMES" "TOPIC")))

(define-key global-map "\t" 'dabbrev-expand)
(define-key global-map "\C-y" 'indent-for-tab-command)
(define-key global-map "\C-d" 'kill-region)

(add-to-list 'default-frame-alist '(font . "consolas-10"))
(set-face-attribute 'default t :font "consolas-10")
;(set-face-attribute 'font-lock-builtin-face nil :foreground "#DAB98F")
(set-face-attribute 'font-lock-builtin-face nil :foreground nil)
(set-face-attribute 'font-lock-comment-face nil :foreground "gray50")
;(set-face-attribute 'font-lock-constant-face nil :foreground "olive drab")
(set-face-attribute 'font-lock-constant-face nil :foreground nil)
;(set-face-attribute 'font-lock-doc-face nil :foreground "gray50")
;(set-face-attribute 'font-lock-function-name-face nil :foreground "IndianRed")
(set-face-attribute 'font-lock-function-name-face nil :foreground nil)
(set-face-attribute 'font-lock-function-call-face nil :foreground nil)
;(set-face-attribute 'font-lock-keyword-face nil :foreground "DarkGoldenrod3")
;(set-face-attribute 'font-lock-keyword-face nil :foreground "SkyBlue")
(set-face-attribute 'font-lock-keyword-face nil :foreground nil)
;(set-face-attribute 'font-lock-string-face nil :foreground "olive drab")
(set-face-attribute 'font-lock-string-face nil :foreground nil)
(set-face-attribute 'font-lock-type-face nil :foreground nil)
;(set-face-attribute 'font-lock-type-face nil :foreground "SteelBlue")
;(set-face-attribute 'font-lock-variable-name-face nil :foreground "burlywood3")
(set-face-attribute 'font-lock-variable-name-face nil :foreground nil)

(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))


(global-set-key [(meta up)]  'move-line-up)
(global-set-key [(meta down)]  'move-line-down)

(global-set-key (kbd "M-o") 'previous-blank-line)
(global-set-key (kbd "M-k") 'backward-char)
(global-set-key (kbd "M-l") 'next-blank-line)
(global-set-key (kbd "M-;") 'forward-char)
(global-set-key (kbd "M-C-;") 'forward-char)
(global-set-key (kbd "M-C-k") 'backward-char)
(global-set-key (kbd "M-C-o") 'previous-line)
(global-set-key (kbd "M-C-l") 'next-line)

(global-set-key (kbd "C-k") 'backward-word)
(global-set-key (kbd "C-;") 'forward-word)
(global-set-key (kbd "C-o") 'previous-line)
(global-set-key (kbd "C-l") 'next-line)

(global-set-key (kbd "C-?") 'comment-region)
(global-set-key (kbd "\eF") 'indent-region)


(global-set-key (kbd "C-f") 'copy-region-as-kill)
;(global-set-key (kbd "\C-d") 'kill-region)
(global-set-key (kbd "\ed") 'kill-region)
(global-set-key (kbd "C-p") 'yank)
(global-set-key (kbd "C-w") 'other-window)
(global-set-key (kbd "C-a") 'back-to-indentation)

(global-set-key (kbd "\ep") 'set-mark-command)
(global-set-key (kbd "\ei") 'copy-region-as-kill)
(global-set-key [C-tab] 'c-indent-line-or-region)
(define-key c++-mode-map "\C-d" 'kill-region)
(define-key c++-mode-map "\e/" 'occur)
;(define-key c++-mode-map "\ej" 'ido-imenu-anywhere)
(define-key c++-mode-map "\ej" 'xref-find-definitions-other-window)
;(define-key c++-mode-map "\C-d" 'kill-region)

(global-set-key (kbd "C-b") 'counsel-switch-buffer)
(global-set-key (kbd "C-.") 'xref-pop-marker-stack)
(global-set-key (kbd "C-j") 'counsel-imenu)

(setq executable "win32_main.exe")
(setq runscript "run.bat")
(setq debugscript "debug.bat")

(defun find-runscript-recursive ()
  "Recursively search for a makefile."
  (interactive)
  (if (file-exists-p runscript) t
      (cd "../")
      (find-runscript-recursive)))

(defun find-debugscript-recursive ()
  "Recursively search for a makefile."
  (interactive)
  (if (file-exists-p runscript) t
      (cd "../")
      (find-runscript-recursive)))

(defun execute-main ()
  (interactive)
  (find-runscript-recursive)
  (async-shell-command "run.bat"))

(defun execute-main-background ()
  (interactive)
 ;(other-window 1)
  (find-runscript-recursive)
  (eshell-command "run.bat &"))

(defun execute-debug-background ()
  (interactive)
 ;(other-window 1)
  (find-debugscript-recursive)
  (eshell-command "debug.bat &"))

(define-key c++-mode-map [f12] 'execute-main-background)
(global-set-key [f5] 'execute-main-background)
(global-set-key [(control f5)] 'execute-main)
(global-set-key [f9] 'execute-debug-background)

(defun occur-symbol-at-point ()
  (interactive)
  (let ((sym (thing-at-point 'symbol)))
    (if sym (push (regexp-quote sym) regexp-history))
      (call-interactively 'occur)))

(global-set-key [f6] 'occur-symbol-at-point)

(defun isearch-from-buffer-start ()
  (interactive)
  (goto-char (point-min))
  (isearch-forward))



(defun my/query-replace (from-string to-string &optional delimited start end)
  "Replace some occurrences of FROM-STRING with TO-STRING.  As each match is
found, the user must type a character saying what to do with it. This is a
modified version of the standard `query-replace' function in `replace.el',
This modified version defaults to operating on the entire buffer instead of
working only from POINT to the end of the buffer. For more information, see
the documentation of `query-replace'"
  (interactive
   (let ((common
      (query-replace-read-args
       (concat "Query replace"
           (if current-prefix-arg " word" "")
           (if (and transient-mark-mode mark-active) " in region" ""))
       nil)))
     (list (nth 0 common) (nth 1 common) (nth 2 common)
       (if (and transient-mark-mode mark-active)
           (region-beginning)
         (buffer-end -1))
       (if (and transient-mark-mode mark-active)
           (region-end)
         (buffer-end 1)))))
  (perform-replace from-string to-string t nil delimited nil nil start end))
;; Replace the default key mapping
(global-set-key [f8] 'my/query-replace)

(setq imenu-generic-expression '((nil "^\\([A-Z_]+\\)=.*" 1)))

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(setq ido-auto-merge-work-directories-length -1)

(setq ido-ignore-buffers '("\\` " "^\*"))

(defun post-load-stuff ()
  (interactive)
  (menu-bar-mode 0)
  (electric-pair-mode 1)
  (maximize-frame)
  (set-foreground-color "burlywood3")
  (set-background-color "#161616")
  (set-cursor-color "#40FF40")
  (setq auto-window-vscroll nil)
  )

(defun delete-backward-word1 ()
  (interactive)
  (let ((beg (point))) (backward-word 1) (delete-region beg (point))))

(defun delete-forward-word1 ()
  (interactive)
  (let ((beg (point))) (forward-word 1) (delete-region beg (point))))


(global-set-key [(control backspace)] 'delete-backward-word1)
(global-set-key [(control delete)] 'delete-forward-word1)
(global-set-key [(control s)] 'swiper)
;; bind it to M-j
(require 'ivy)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")
(setq ivy-ignore-buffers '("\:" "\\` " "^\*"))
(define-key ivy-minibuffer-map (kbd "C-w") 'ivy-next-history-element)
(define-key ivy-minibuffer-map (kbd "C-o") 'ivy-previous-line)
(define-key ivy-minibuffer-map (kbd "C-l") 'ivy-next-line)
(define-key ivy-mode-map [remap ivy-call-and-recenter] 'ivy-next-line)


(require 'swiper)
(define-key swiper-map (kbd "C-l") 'ivy-next-line)

(require 'counsel)
(define-key counsel-grep-map (kbd "C-l") 'ivy-next-line)
(define-key counsel-ag-map (kbd "C-l") 'ivy-next-line)

(require 'dired)
(define-key dired-mode-map (kbd "C-l") 'dired-next-line)
(define-key dired-mode-map (kbd "C-o") 'dired-previous-line)


(ctags-global-auto-update-mode)
(setq ctags-update-prompt-create-tags nil)
(setq tags-revert-without-query 1)

(global-set-key [f1] 'eshell)
(global-set-key [f2] 'quick-calc)
(global-set-key [(control v)] 'recenter)
(global-set-key [(control q)] 'browse-url-at-point)

(require 'rcirc)
(setq rcirc-default-nick "jusski")
(add-to-list 'rcirc-server-alist
             '("irc.libera.chat"
               :channels ("#emacs" "#c" "#git")))
(setq rcirc-authinfo
                '(("libera" nickserv "jusski" "asdf6gh")))

(add-hook 'rcirc-mode-hook
               (lambda ()
                 (rcirc-track-minor-mode 1)))
(add-hook 'window-setup-hook 'post-load-stuff t)

(defun bury-compile-buffer-if-successful (buffer string)
 "Bury a compilation buffer if succeeded without warnings "
 (when (and
         (buffer-live-p buffer)
         (string-match "compilation" (buffer-name buffer))
         (string-match "finished" string)
         (not
          (with-current-buffer buffer
            (goto-char (point-min))
            (search-forward "error" nil t)))
	  (not
           (with-current-buffer buffer
             (goto-char (point-min))
             (search-forward "warning" nil t))))
    (run-with-timer 0 nil
                    (lambda (buf)
                      (bury-buffer buf)
                      (switch-to-prev-buffer (get-buffer-window buf) 'kill))
                    buffer)))
;(add-hook 'compilation-finish-functions 'bury-compile-buffer-if-successful)

(defvar my-mode-map (make-sparse-keymap)
  "Keymap for `my-mode'.")

;;;###autoload
(define-minor-mode my-mode
  "A minor mode so that my key settings override annoying major modes."
  ;; If init-value is not set to t, this mode does not get enabled in
  ;; `fundamental-mode' buffers even after doing \"(global-my-mode 1)\".
  ;; More info: http://emacs.stackexchange.com/q/16693/115
  :init-value t
  :lighter " my-mode"
  :keymap my-mode-map)

;;;###autoload
(define-globalized-minor-mode global-my-mode my-mode my-mode)

;; https://github.com/jwiegley/use-package/blob/master/bind-key.el
;; The keymaps in `emulation-mode-map-alists' take precedence over
;; `minor-mode-map-alist'
(add-to-list 'emulation-mode-map-alists `((my-mode . ,my-mode-map)))

;; Turn off the minor mode in the minibuffer
(defun turn-off-my-mode ()
  "Turn off my-mode."
  (my-mode -1))
(add-hook 'minibuffer-setup-hook #'turn-off-my-mode)

(provide 'my-mode)


(defun my-grep ()
  (interactive)
  (setq symbol-at-point (thing-at-point 'symbol))
  (if (not (null symbol-at-point))
      (setq what-to-find (read-shell-command (format "list lines matching regexp (default %s): " symbol-at-point)))
    (setq what-to-find (read-shell-command (format "list lines matching regexp: " symbol-at-point))))
  (if (string-blank-p what-to-find)
      (grep (format "grep --color=always -nH --null -e  %s *.cpp *.h" symbol-at-point))
    (grep (format "grep --color=always -nH --null -e  %s *.cpp *.h" what-to-find)))
  )

(defun find-file-rec ()
  "Find a file in the current working directory recursively."
  (interactive)
  (find-file
   (completing-read
    "Find file: " (process-lines "rg" "--color=never" "--files"))))
 

(define-key my-mode-map (kbd "C-o") #'previous-line)
(define-key my-mode-map (kbd "C-/") #'occur-symbol-at-point)
(define-key my-mode-map (kbd "M-/") #'my-grep)
(define-key my-mode-map (kbd "M-w") #'other-window)
(define-key my-mode-map (kbd "C-w") #'other-window)

(setq dired-dwim-target t)

(custom-set-faces
 '(ediff-odd-diff-A ((t ( :background "dark slate gray")))))
(custom-set-faces
 '(ediff-odd-diff-B ((t ( :background "dark slate gray")))))
(custom-set-faces
 '(ediff-odd-diff-C ((t ( :background "dark slate gray")))))


(custom-set-faces
 '(ediff-even-diff-A ((t ( :background "dark slate gray")))))
(custom-set-faces
 '(ediff-even-diff-B ((t ( :background "dark slate gray")))))
(custom-set-faces
 '(ediff-even-diff-C ((t ( :background "dark slate gray")))))

