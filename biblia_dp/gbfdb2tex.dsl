<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [

<!-- Extension to DSSSL Stylesheet for GBF DocBook -->
<!-- Customizes and define how to process extensions of GBF DocBook -->

<!ENTITY % html "IGNORE">
<![%html;[
<!ENTITY % print "IGNORE">
<!ENTITY docbook.dsl SYSTEM "docbook.dsl" CDATA dsssl>
]]>
<!ENTITY % print "INCLUDE">
<![%print;[
<!ENTITY docbook.dsl SYSTEM "docbook.dsl" CDATA dsssl>
]]>
]>
<style-sheet>
<style-specification use="docbook">
<style-specification-body> 

;; HTML:

<![%html;[

(define %footnotes-at-end%
  ;; Should footnotes appear at the end of HTML pages?
  #t)

(define %html-ext% 
  ;; Default extension for HTML output files
  ".html")

(define %root-filename%
  ;; Name for the root HTML document
  "index")

<!-- Words of Jesus -->
(element fr 
	(make element gi: "B"
		(process-children)))

]]>

;; printing:

<![%print;[

(define (article-titlepage-recto-elements)
  (list (normalize "title") 
        (normalize "subtitle") 
        (normalize "corpauthor") 
        (normalize "authorgroup") 
        (normalize "author") 
        (normalize "edition") 
        (normalize "pubdate") 
        (normalize "legalnotice") 
        (normalize "revhistory") 
        (normalize "abstract")))


(define bop-footnotes
  ;; Make "bottom-of-page" footnotes?
  #t)

<!-- Using -V tex-backend when calling openjade 
(define tex-backend 
  #t) -->

(define %graphic-default-extension%
  ;; Default extension for graphic FILEREFs
  "ps")

(element anchor
  (empty-sosofo))

(define %generate-article-titlepage%
  ;; Should an article title page be produced?
  #t)


(define %article-titlepage-legalnotice%
  ;; Legal notice in article
  #t)

(define %ss-size-factor%
	0.5)

(define %ss-shift-factor%
	0.5) 

<!-- (define %page-n-columns% 2) -->

<!-- Words of Jesus -->
(element fr ($bold-seq$))
]]>

;; both:

(define %chapter-autolabel%
   ;; Are chapters enumerated?
   #f)
(define %generate-book-toc%
	;; Sin tabla de contenido
	#f)
(define $generate-chapter-toc$
	;; Sin tabla de contenido en capitulo
	(lambda () #f))



</style-specification-body>
</style-specification>
<external-specification id="docbook" document="docbook.dsl">
</style-sheet>
