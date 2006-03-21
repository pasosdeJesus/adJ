<!-- Extends DocBook DSSSL 1.72 to process extensions for define -->
<!-- Extensions released to the public domain. No warranties. -->
<!-- http://structio.sourceforge.net -->

<!-- To use this, create a stylesheet extending DocBook DSSSL,  define an 
     ENTITY in the internal DTD like:
	<!ENTITY docbookrep-html.dsl SYSTEM "path/docbookrep_html.dsl">
     and in the body of your stylesheet include it:
	&docbookrep-html.dsl;
-->

(define %generate-book-toc%
	#f)

(define ($generate-qandaset-toc$)
	#f)

(define %admon-graphics%
	#t)

(define %admon-graphics-path%
	"./")

;;We don't process para with resp or sig in role attribute
(element para
 (if (and (attribute-string "role") (or (equal? (substring (attribute-string "role") 0 5) "nipal")
         (equal? (substring (attribute-string "role") 0 3) "sig") ))
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
		      (make element gi: "H2"
			    (literal "Indicadores de Logro"))	
		      (process-children)))
    (("logros") (make sequence
		      (make element gi: "H2"
			    (literal "Logros"))	
		      (process-children)))
    (else ($block-container$)))
)

;; This is copied from html/dbfootn.dsl of DocBook DSSSL Stylesheet
;; version 1.72
(mode footnote-mode
  (element footnote
    (process-children))

  (element (footnote para)
    (let ((id (if (attribute-string (normalize "id") (parent (current-node)))
                  (attribute-string (normalize "id") (parent (current-node)))
                  (generate-anchor (parent (current-node))))))
      (make element gi: "P"
            (if (= (child-number) 1)
                (make sequence
                  (make element gi: "A"
                        attributes: (list
                                     (list "NAME" (string-append "FTN." id))
			             (list "HREF" (href-to (parent (current-node
)))))
                        (literal 
                         (string-append "[" 
                                        ($footnote-number$ 
                                         (parent (current-node))) 
                                        "]")))
                  (literal " "))
                (literal ""))
            (process-children))))
)

(mode table-footnote-mode
  (element footnote
    (process-children))

  (element (footnote para)
    (let* ((target (parent (current-node)))
           (fnnum (table-footnote-number target))
           (idstr (if (attribute-string (normalize "id") target)
                      (attribute-string (normalize "id") target)
                      (generate-anchor target))))
      (make sequence
        (if (= (child-number) 1)
            (make element gi: "A"
                  attributes: (list (list "NAME" (string-append "FTN." idstr)))
                  (literal fnnum
                           (gentext-label-title-sep (normalize "footnote"))))
            (empty-sosofo))
        (process-children)
        (make empty-element gi: "BR")))))


