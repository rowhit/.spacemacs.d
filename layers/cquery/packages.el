;;; packages.el --- cquery layer packages file for Spacemacs
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Cormac Cannon <cormacc-public@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst cquery-packages
  '(
     cquery
     company-lsp
     projectile
     ))

;; See also https://github.com/cquery-project/cquery/wiki/Emacs
(defun cquery/init-cquery ()
  (use-package cquery
    :defer t
    :commands lsp-cquery-enable
    :init
    (add-hook 'c-mode-common-hook #'cquery//enable)
    :config
    (dolist (mode c-c++-modes)
      (spacemacs/lsp-append-jump-handlers mode)
      (spacemacs/lsp-bind-keys-for-mode mode)
      (cquery/define-keys-for-mode mode)
      (spacemacs/set-leader-keys-for-major-mode mode
        ;; format
        "=c" 'spacemacs/clang-format-region-or-buffer
        "=f" 'spacemacs/clang-format-function
        ;; goto
        "gf" 'find-file-at-point
        "gF" 'ffap-other-window
        )
      )
    ;; overlay is slow
    ;; Use https://github.com/emacs-mirror/emacs/commits/feature/noverlay
    (cquery-use-default-rainbow-sem-highlight)
    (evil-set-initial-state 'cquery-tree-mode 'emacs)

    (cquery/customise-lsp-ui-peek)
    (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-gcc)) ;; in flycheck.el

    ;;evil-record-macro keybinding clobbers q in cquery-tree-mode-map for some reason?
    (evil-make-overriding-map cquery-tree-mode-map)

    ))

(defun cquery/post-init-company-lsp ()
  (spacemacs|add-company-backends :backends company-lsp :modes c-mode-common))

(defun cquery/pre-init-projectile ()
  (spacemacs|use-package-add-hook
    :post-init
    (add-to-list 'projectile-globally-ignored-directories ".cquery_cached_index")
    )
  )
