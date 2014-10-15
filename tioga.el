;;; tioga.el --- minor mode for working with Tioga

;; Copyright (C) 2014 Josiah Schwab

;; Author: Josiah Schwab <jschwab@gmail.com>
;; Keywords: plotting, files

;; This software is under the MIT License
;; http://opensource.org/licenses/MIT

;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use, copy,
;; modify, merge, publish, distribute, sublicense, and/or sell copies
;; of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
;; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
;; ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
;; CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Commentary:

;; See README.org

;;; Code:

(require 'dash)

(defgroup tioga nil
  "tioga customizations."
  :prefix "tioga-"
  :group 'tioga)


(defconst tioga~alignment-options
  '("ALIGNED_AT_BASELINE" "ALIGNED_AT_BOTTOM" "ALIGNED_AT_MIDHEIGHT" "ALIGNED_AT_TOP"))

(defconst tioga~justification-options
  '("LEFT_JUSTIFIED" "CENTERED" "RIGHT_JUSTIFIED"))

(defconst tioga~line-options
  '("LINE_TYPE_SOLID" "LINE_TYPE_DOT" "LINE_TYPE_DASH" "LINE_TYPE_DOT_DASH" "LINE_TYPE_DOT_SHORT_DASH" "LINE_TYPE_DOT_LONG_DASH" "LINE_TYPE_SHORT_DASH" "LINE_TYPE_LONG_DASH" "LINE_TYPE_SHORT_DASH_LONG_DASH"))

(defconst tioga~options
  (list
   tioga~alignment-options
   tioga~justification-options
   tioga~line-options))

(defun tioga~next-element (element list)
  "Return the next element (cyclically) in list after element"
  (let ((index (-elem-index element list)))
    (if index (nth (mod (1+ index) (length list)) list))))

(defun tioga~next-option (option)
  "Return the next value of option or nil if current is not in options"
  (-first-item (-non-nil (--map (tioga~next-element option it) tioga~options))))

(defun tioga-cycle-option-at-point()
  "Cycle through Tioga options"
  (interactive)
  (let ((option (tioga~next-option (thing-at-point 'symbol))))
    (if option 
        (let ((bounds (bounds-of-thing-at-point 'symbol)))
          (save-excursion
            (goto-char (car bounds))
            (delete-region (car bounds) (cdr bounds))
            (insert option))))))

(define-minor-mode tioga-mode
  "Toggle Tioga minor mode in the usual way."
  :init-value nil
  ;; The indicator for the mode line.
  :lighter " Tioga"
  ;; The minor mode bindings.
  :keymap
  '(
    ("\C-c\C-t" . tioga-cycle-option-at-point)
    )
  ;; the body
  (if tioga-mode

      ;; turn tioga-mode on
      (progn
        (yas-activate-extra-mode 'tioga-mode))
    
    ;; turn tioga-mode off
    (progn
      (yas-deactivate-extra-mode 'tioga-mode)))

  ;; the group
  :group 'tioga)

(provide 'tioga)
;;; tioga.el ends here

