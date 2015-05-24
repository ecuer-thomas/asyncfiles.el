;; Background save-buffer
;;
;; 28/05/15


;; background-save-buffer
;; save current-buffer in a new process
;;
;; Although it's couuld solves UI Freezing while saving
;; under ssh, by example, it's reveal more problems like
;; "- What append if an user "spam" (background-save-buffer)" -> fork bomb ?
;; Also, it's hard to communicate with the user in a separate process,
;; so this fonction overwrite buffer's file, no matter if it's has changed or not.
;; therefore, it's could be dangerous with versionning systems.

(defun background-save-buffer (&optional arg)
  (setq this-buffer (buffer-substring-no-properties (point-min) (point-max)))
  (setq this-buffer-name (buffer-name))

  (interactive "p")

  (async-start
   `(lambda ()
      ,(async-inject-variables "this-buffer" )
      ,(async-inject-variables "this-buffer-name" )



      (defun ask-user-about-lock (&option args)
	nil)

      (with-temp-buffer
	;; write to temporary bufer
	(insert this-buffer)
	;; write to disk
	(write-file this-buffer-name))
      this-buffer-name)

     (lambda (&optional filename)
       (message "[background] file saved : %s" filename))))


;; background-load-file
;; Open a file in a different process,
;; then create a buffer and fill it with loaded content.


(defun background-load-file (&optional args)
  (interactive "p")
  (setq filename (read-file-name "file : "))

  (async-start
   `(lambda ()
      ,(async-inject-variables "filename" )

      ;; open file
      (find-file filename)
      (setq local-buffer-content (buffer-substring-no-properties (point-min) (point-max)))
      (kill-buffer (buffer-name))
      local-buffer-content)



   (lambda (content)
     (get-buffer-create filename)

     ;; write content
     (with-current-buffer filename
       (insert content))
     (switch-to-buffer filename)

     ;; "link" buffer to file's path
     (set-visited-file-name filename)
     (message "[foreground] File loaded %s." filename))))



(global-set-key (kbd "M-s M-f")'background-load-file)
(global-set-key (kbd "M-s M-s")'background-save-buffer)

;; Overwrite C-x-s standard shortcut

;(substitute-key-definition
; 'save-buffer 'background-save-buffer (current-global-map))

