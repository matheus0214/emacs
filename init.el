;;; init.el --- Configuração Básica para Emacs 31 no Terminal -*- lexical-binding: t; -*-

;; -----------------------------------------------------------------
;; 1. LIMPEZA DA INTERFACE (Essencial para Terminal)
;; -----------------------------------------------------------------
(setq inhibit-startup-screen t)         ; Remove a tela inicial padrão
(setq initial-scratch-message "")       ; Deixa o buffer *scratch* limpo
(menu-bar-mode -1)                      ; Desativa a barra de menu de texto

;; -----------------------------------------------------------------
;; 2. COMPORTAMENTO E SUPORTE AO MOUSE
;; -----------------------------------------------------------------
(xterm-mouse-mode t)                    ; ATIVA O MOUSE NO TERMINAL
(mouse-wheel-mode t)                    ; Ativa o motor nativo de rolagem

;; Mapeia os eventos de scroll de texto que o seu terminal envia
(global-set-key (kbd "<wheel-up>")   (lambda () (interactive) (scroll-down 1)))
(global-set-key (kbd "<wheel-down>") (lambda () (interactive) (scroll-up 1)))

;; Garante compatibilidade caso seu terminal envie como botões numéricos
(unless (display-graphic-p)
  (global-set-key [mouse-4] (lambda () (interactive) (scroll-down 1)))
  (global-set-key [mouse-5] (lambda () (interactive) (scroll-up 1))))

(setq-default indent-tabs-mode nil)     ; Usa espaços em vez de Tabs para indentar
(setq-default tab-width 2)              ; Define tamanho do tab como 4 espaços
(global-display-line-numbers-mode t)    ; Ativa números de linha em todos os buffers
(column-number-mode t)                  ; Mostra o número da coluna no rodapé
(electric-pair-mode t)                  ; Auto-completa parênteses, aspas e colchetes
(setq make-backup-files nil)            ; Desativa arquivos de backup temporários

;; -----------------------------------------------------------------
;; 3. RECURSOS NOVOS DO EMACS 31 (Melhorias no Minibuffer)
;; -----------------------------------------------------------------
(setq completion-eager-update t)
(setq completion-eager-display 'auto)
(setq minibuffer-visible-completions 'up-down)

(cua-mode t)

;; -----------------------------------------------------------------
;; 4. TEMA VISUAL
;; -----------------------------------------------------------------
(load-theme 'tango-dark t)

;; -----------------------------------------------------------------
;; 5. GERENCIADOR DE PACOTES
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq package-install-upgrade-built-in t)

;; Força o Emacs a baixar a lista da MELPA se ela estiver vazia
(unless package-archive-contents
  (package-refresh-contents))

;; Garante que o 'use-package' esteja instalado no sistema
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; -----------------------------------------------------------------
;; 6. CONFIGURAÇÃO JS E TS SEM ERROS (Nativo Emacs 31)
;; -----------------------------------------------------------------
(setq treesit-font-lock-level 4)              ; Nível máximo de colorização

;; Define explicitamente a pasta onde as gramáticas serão compiladas
(setq treesit-extra-load-path (list (expand-file-name "tree-sitter" user-emacs-directory)))

;; Força as URLs limpas sem aninhamento excessivo para evitar erros de clonagem
(setq treesit-language-source-alist
      '((javascript "https://github.com/tree-sitter/tree-sitter-javascript")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")))

;; Associa os arquivos aos modos Tree-sitter modernos
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))

;; -----------------------------------------------------------------
;; 7. VERTICO + CONSULT (Busca e Menus Avançados)
;; -----------------------------------------------------------------
;; VERTICO: Transforma o minibuffer em uma lista vertical elegante
(use-package vertico
  :ensure t
  :init
  (vertico-mode 1)
  :custom
  (vertico-scroll-margin 2)  ; Mantém uma margem visual ao rolar a lista
  (vertico-count 10)         ; Quantidade de linhas exibidas no rodapé
  (vertico-resize nil))      ; Mantém o tamanho do painel fixo

;; MARGINALIA: Adiciona descrições e detalhes úteis ao lado dos comandos
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode 1))

;; ORDERLESS: Permite buscar termos fora de ordem (ex: digitar "js config" acha "config-js")
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; CONSULT: Fornece comandos de busca extremamente rápidos
(use-package consult
  :ensure t
  :bind (;; Substitui a busca tradicional (C-s) pela busca visual do Consult
         ("C-s" . consult-line)
         ;; Substitui a alternância de buffers (C-x b) por uma com preview em tempo real
         ("C-x b" . consult-buffer)
         ;; Atalho útil para pular para qualquer função/classe no arquivo de código
         ("M-g i" . consult-imenu)
         ("C-x f" . consult-find)
         ("C-M-s" . consult-ripgrep)
         ))

;; TEMA
(use-package pixel-themes
  :vc (:url "https://github.com/lucasobx/pixel-themes"
       :rev :newest)
  :config
  (pixel-themes-mode 1)
  (pixel-themes-load-theme 'pixel-themes-fallen-leaves))

(use-package compat :ensure t)
(use-package transient :ensure t)
;; -----------------------------------------------------------------
;; 8. MAGIT (A Melhor Interface Git do Mundo)
;; -----------------------------------------------------------------
(use-package magit
  :ensure t
  :bind (;; Define o atalho universal "Control + x" seguido de "g" para abrir o Git
         ("C-x g" . magit-status)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil)
 '(package-vc-selected-packages
   '((pixel-themes :url "https://github.com/lucasobx/pixel-themes"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

