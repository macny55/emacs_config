; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; japanese environment
(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)

;;elispディレクトリをロードパスに設定
(add-to-list 'load-path "~/.emacs.d/elisp")

;;カレントディレクトリの設定
;;(cd "/Users/macny55/sencha")

;;load-pathを追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))
;;引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")

;; ------------------------------------------------------------------------
;; @ buffer

   ;; バッファ画面外文字の切り詰め表示
   (setq truncate-lines nil)

   ;; ウィンドウ縦分割時のバッファ画面外文字の切り詰め表示
   (setq truncate-partial-width-windows t)

   ;; 同一バッファ名にディレクトリ付与
   (require 'uniquify)
   (setq uniquify-buffer-name-style 'forward)
   (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
   (setq uniquify-ignore-buffers-re "*[^*]+*")

;; ------------------------------------------------------------------------
;; @ fringe

   ;; バッファ中の行番号表示
   (global-linum-mode t)

   ;; 行番号のフォーマット
   ;; (set-face-attribute 'linum nil :foreground "red" :height 0.8)
   (set-face-attribute 'linum nil :height 0.8)
   (setq linum-format "%4d")

;; ------------------------------------------------------------------------
;; @ modeline

   ;; 行番号の表示
   (line-number-mode t)

   ;; 列番号の表示
   (column-number-mode t)

   ;; 時刻の表示
   (require 'time)
   (setq display-time-24hr-format t)
   (setq display-time-string-forms '(24-hours ":" minutes))
   (display-time-mode t)

   ;; cp932エンコード時の表示を「P」とする
   (coding-system-put 'cp932 :mnemonic ?P)
   (coding-system-put 'cp932-dos :mnemonic ?P)
   (coding-system-put 'cp932-unix :mnemonic ?P)
   (coding-system-put 'cp932-mac :mnemonic ?P)

;; ------------------------------------------------------------------------
;; @ cursor

   ;; カーソル点滅表示
   (blink-cursor-mode 0)

   ;; スクロール時のカーソル位置の維持
   (setq scroll-preserve-screen-position t)

   ;; スクロール行数（一行ごとのスクロール）
   (setq vertical-centering-font-regexp ".*")
   (setq scroll-conservatively 35)
   (setq scroll-margin 0)
   (setq scroll-step 1)

   ;; 画面スクロール時の重複行数
   (setq next-screen-context-lines 1)

;; ------------------------------------------------------------------------
;; @ default setting

   ;; 起動メッセージの非表示
   (setq inhibit-startup-message t)

   ;; スタートアップ時のエコー領域メッセージの非表示
   (setq inhibit-startup-echo-area-message -1)

;; ------------------------------------------------------------------------
;; @ image-library
   ;; (setq image-library-alist
   ;;       '((xpm "libxpm.dll")
   ;;         (png "libpng14.dll")
   ;;         (jpeg "libjpeg.dll")
   ;;         (tiff "libtiff3.dll")
   ;;         (gif "libungif4.dll")
   ;;         (svg "librsvg-2-2.dll")
   ;;         (gdk-pixbuf "libgdk_pixbuf-2.0-0.dll")
   ;;         (glib "libglib-2.0-0.dll")
   ;;         (gobject "libgobject-2.0-0.dll"))
   ;;       )

;; ------------------------------------------------------------------------
;; @ backup

   ;; 変更ファイルのバックアップ
   (setq make-backup-files nil)

   ;; 変更ファイルの番号つきバックアップ
   (setq version-control nil)

   ;; 編集中ファイルのバックアップ
   (setq auto-save-list-file-name nil)
   (setq auto-save-list-file-prefix nil)

   ;; 編集中ファイルのバックアップ先
   (setq auto-save-file-name-transforms
         `((".*" ,temporary-file-directory t)))

   ;; 編集中ファイルのバックアップ間隔（秒）
   (setq auto-save-timeout 30)

   ;; 編集中ファイルのバックアップ間隔（打鍵）
   (setq auto-save-interval 500)

   ;; バックアップ世代数
   (setq kept-old-versions 1)
   (setq kept-new-versions 2)

   ;; 上書き時の警告表示
   ;; (setq trim-versions-without-asking nil)

   ;; 古いバックアップファイルの削除
   (setq delete-old-versions t)

;; ------------------------------------------------------------------------
;; @ key bind

   ;; 標準キーバインド変更
   (global-set-key "\C-z"          'scroll-down)

;; ------------------------------------------------------------------------
;; @ scroll

   ;; バッファの先頭までスクロールアップ
   (defadvice scroll-up (around scroll-up-around)
     (interactive)
     (let* ( (start_num (+ 1 (count-lines (point-min) (point))) ) )
       (goto-char (point-max))
       (let* ( (end_num (+ 1 (count-lines (point-min) (point))) ) )
         (goto-line start_num )
         (let* ( (limit_num (- (- end_num start_num) (window-height)) ))
           (if (< (- (- end_num start_num) (window-height)) 0)
               (goto-char (point-max))
             ad-do-it)) )) )
   (ad-activate 'scroll-up)

   ;; バッファの最後までスクロールダウン
   (defadvice scroll-down (around scroll-down-around)
     (interactive)
     (let* ( (start_num (+ 1 (count-lines (point-min) (point)))) )
       (if (< start_num (window-height))
           (goto-char (point-min))
         ad-do-it) ))
   (ad-activate 'scroll-down)

;; ------------------------------------------------------------------------
;; @ print

   (setq ps-print-color-p t
         ps-lpr-command "gswin32c.exe"
         ps-multibyte-buffer 'non-latin-printer
         ps-lpr-switches '("-sDEVICE=mswinpr2" "-dNOPAUSE" "-dBATCH" "-dWINKANJI")
         printer-name nil
         ps-printer-name nil
         ps-printer-name-option nil
         ps-print-header nil          ; ヘッダの非表示
         )

;; ------------------------------------------------------------------------
;; @ hiwin-mode
   (require 'hiwin)

   ;; hiwin-modeを有効化
   ;; (hiwin-activate)

   ;; 非アクティブウィンドウの背景色を設定
   ;; (set-face-background 'hiwin-face "gray80")

;; グループ化せずに*scratch*以外のタブを表示
(require 'cl)
 (when (require 'tabbar nil t)
    (setq tabbar-buffer-groups-function
	    (lambda (b) (list "All Buffers")))
    (setq tabbar-buffer-list-function
          (lambda ()
            (remove-if
             (lambda(buffer)
	       (unless (string= (buffer-name buffer) "*shell*")
		 (find (aref (buffer-name buffer) 0) " *")))
             (buffer-list))))
    (tabbar-mode))

;; 左に表示されるボタンを無効化
(setq tabbar-home-button-enabled "")
(setq tabbar-scroll-left-button-enabled "")
(setq tabbar-scroll-right-button-enabled "")
(setq tabbar-scroll-left-button-disabled "")
(setq tabbar-scroll-right-button-disabled "")

;; 色設定
 (set-face-attribute
   'tabbar-default-face nil
   :background "gray90") ;バー自体の色
  (set-face-attribute ;非アクティブなタブ
   'tabbar-unselected-face nil
   :background "gray90"
   :foreground "black"
   :box nil)
  (set-face-attribute ;アクティブなタブ
   'tabbar-selected-face nil
   :background "black"
   :foreground "white"
   :box nil)

;; 幅設定
  (set-face-attribute
   'tabbar-separator-face nil
   :height 0.7)

;; Firefoxライクなキーバインドに
(global-set-key [(control tab)]       'tabbar-forward)
(global-set-key [(control shift iso-lefttab)] 'tabbar-backward)
;; -nw では効かないので別のキーバインドを割り当てる
(global-set-key (kbd "C-x n") 'tabbar-forward)
(global-set-key (kbd "C-x p") 'tabbar-backward)

;;F4ボタンで切り替え
(global-set-key [f4] 'tabbar-mode)
;; ------------------------------------------------------------------------
;; @ color-theme
   (require 'color-theme)
   (color-theme-initialize)

;; ------------------------------------------------------------------------
;;web-mode
(require 'web-mode)

;;; emacs 23以下の互換
(when (< emacs-major-version 24)
  (defalias 'prog-mode 'fundamental-mode))

;;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))

;;; インデント数
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-html-offset   2)
  (setq web-mode-css-offset    2)
  (setq web-mode-script-offset 2)
  (setq web-mode-php-offset    2)
  (setq web-mode-java-offset   2)
  (setq web-mode-asp-offset    2))
(add-hook 'web-mode-hook 'web-mode-hook)

;;; メニューバーを消す
(menu-bar-mode -1)
;;; ツールバーを消す
(tool-bar-mode -1)
;;; 対応する括弧を光らせる。
(show-paren-mode 1)
;;; ウィンドウ内に収まらないときだけ括弧内も光らせる。
(setq show-paren-style 'mixed)
;;; ウィンドウ最大化
(require 'maximize)
(global-set-key [f9] 'maximize-toggle-frame-vmax)
(global-set-key [f11] 'maximize-toggle-frame-hmax)
;; 長い行は折り返す
(setq truncate-lines t)
;;Color
(if window-system (progn
   (set-background-color "Black")
   (set-foreground-color "LightGray")
   (set-cursor-color "Gray")
   (set-frame-parameter nil 'alpha 80)
   ))
;;絶対パスを表示
(set-default 'mode-line-buffer-identification
           '(buffer-file-name ("%f") ("%b")))

;;emacsでgitを扱うmagitの設定
(add-to-list 'exec-path "D:/Git/Git/bin")
(require 'magit)
(if (eq system-type 'windows-nt)
    (setq magit-git-executable "D:/Git/Git/bin/git.exe"))

;; デフォルトの文字コードと改行コード
(set-default-coding-systems 'utf-8-dos)

;; パスとファイル名はShift_JIS
(setq default-file-name-coding-system 'japanese-cp932-dos)

;;packageの設定
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)
;;flymakeの自動実行
(require 'flymake)

;;jslの設定
(defun flymake-jsl-init ()
  (list "jsl" (list "-process" (flymake-init-create-temp-buffer-copy
				'flymake-create-temp-inplace))))
(add-to-list 'flymake-allowed-file-name-masks
	     '("\\.js\\'" flymake-jsl-init))
(add-to-list 'flymake-err-line-patterns
	     '("^\\(.+\\)(\\([0-9]+\\)): \\(.*warning\\|SyntaxError\\): \\(.*\\)" 1 2 nil 4))

;;tree-undoの設定
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

(defun my-next-line-n () (interactive) (next-line 10))
(defun my-prev-line-n () (interactive) (previous-line 10))
(global-set-key (kbd "C->") 'my-next-line-n)
(global-set-key (kbd "C-<") 'my-prev-line-n)

;; js2-mode
(add-to-list 'load-path "~/.emacs.d/elisp/js2-mode")
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; 変更のあったファイルの自動再読み込み
(global-auto-revert-mode 1)

(when (require 'auto-install nil t)
  ;; インストールディレクトリを設定する
  ;; 初期値は ~/.emacs.d/auto-install/
  (setq auto-install-directory "~/.emacs.d/elisp")

  ;; EmacsWiki に登録されている elisp の名前を取得する
  ;;(auto-install-update-emacswiki-package-name t)

  ;; 必要であればプロキシの設定を行う
  ;; (setq url-proxy-services '(("http" . "10.70.30.50:8080")))

  ;; install-elisp の関数を利用可能にする
  ;;(auto-install-compatibility-setup)
)
(when (require 'anything-startup nil t)
  (global-set-key (kbd "\C-x b") 'anything)
)

(add-to-list 'load-path "~/.emacs.d/elisp/yasnippet")
(when (require 'yasnippet nil t)
  ;;(yas/initialize)
  (yas/load-directory "~/.emacs.d/elisp/yasnippet/snippets")
  (yas/load-directory "~/.emacs.d/elisp/yasnippet/extras/imported")
  (yas/global-mode 1)
)
;;Auto Complete Mode1
(add-to-list 'load-path "~/.emacs.d/elisp/auto-complete")
(when (require 'auto-complete-config nil t)
  (ac-config-default)
  (setq ac-auto-start 1)
  (setq ac-dwim t)
  (setq ac-use-menu-map t) ;; C-n/C-pで候補選択可能
  (add-to-list 'ac-sources 'ac-source-yasnippet) ;; 常にYASnippetを補完候補に
  (setq ac-dictionary-directories "~/.emacs.d/elisp/auto-complete/ac-dict") ;; 辞書ファイルのディレクトリ
  (setq ac-comphist-file "~/.emacs.d/elisp/auto-complete/ac-comphist.dat") ;; 補完履歴のキャッシュ先
)
;; JavaScript
(setq ac-modes
      (append ac-modes '(js2-mode)))
