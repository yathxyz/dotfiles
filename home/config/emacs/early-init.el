;; -*- coding: utf-8; lexical-binding: t; -*-

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(setq ring-bell-function 'ignore)

;; Stop making backup files, I have my own solutions for this
(setq make-backup-files nil)

;; Stop the autosave feature. It clutters with version control
(setq auto-save-default nil)

;; Silence stupid startup message
(setq inhibit-startup-echo-area-message (user-login-name))
(setopt inhibit-splash-screen t)
