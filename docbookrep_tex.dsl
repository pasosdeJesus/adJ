<!-- Extends DocBook DSSSL 1.72 to process extensions for repasa -->
<!-- Extensions released to the public domain. No warranties. -->
<!-- http://structio.sourceforge.net/repasa -->

<!-- To use this, create a stylesheet extending DocBook DSSSL,  define an 
     ENTITY in the internal DTD like:
	<!ENTITY docbookrep-tex.dsl SYSTEM "path/docbookrep_tex.dsl">
     and in the body of your stylesheet include it:
	&docbookrep-tex.dsl;
-->

;;We don't process para with resp or sig in role attribute
(element para 
	(if (attribute-string "role")
		(empty-sosofo)
 		($paragraph$)
	)
)

(element answer
 (empty-sosofo)
)


(element highlights
  (case (attribute-string "role")
    (("indicadores") (make sequence
                      (literal "Indicadores de Logro")
                      (process-children)))
    (("logros") (make sequence
                      (literal "Logros")
                      (process-children)))
    (else ($block-container$)))
)


<!-- The next one is copied from print/dbblock.dsl in original
	DocBook DSSSL 1.72 -->
(element (footnote para)
  ;; Note: this can only get called if the backend is 'tex
  ;; If the backend is anything else, footnote never calls process
  ;; children except in endnote-mode, so this doesn't get called.
  (let ((fnnum  (footnote-number (parent (current-node)))))
    (if (= (child-number) 1)
        (make paragraph
          font-size: (* %footnote-size-factor% %bf-size%)
          font-posture: 'upright
          quadding: %default-quadding%
          line-spacing: (* (* %footnote-size-factor% %bf-size%)
                           %line-spacing-factor%)
          space-before: %para-sep%
          space-after: %para-sep%
          start-indent: %footnote-field-width%
          first-line-start-indent: (- %footnote-field-width%)
          (make line-field
            field-width: %footnote-field-width%
            (literal fnnum
                     (gentext-label-title-sep (normalize "footnote"))))
          (process-children-trim))
        (make paragraph
          font-size: (* %footnote-size-factor% %bf-size%)
          font-posture: 'upright
          quadding: %default-quadding%
          line-spacing: (* (* %footnote-size-factor% %bf-size%)
                           %line-spacing-factor%)
          space-before: %para-sep%
          space-after: %para-sep%
          start-indent: %footnote-field-width%
          (process-children-trim)))))



