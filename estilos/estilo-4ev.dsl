<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [

<!ENTITY % html "IGNORE">
<![%html;[
<!ENTITY % print "INCLUDE">
<!ENTITY docbook.dsl PUBLIC "-//Norman Walsh//DOCUMENT DocBook HTML Stylesheet//EN" CDATA dsssl>
]]>
<!ENTITY % print "INCLUDE">
<![%print;[
<!ENTITY docbook.dsl PUBLIC "-//Norman Walsh//DOCUMENT DocBook Print Stylesheet//EN" CDATA dsssl>
]]>
<!ENTITY docbookrep-html.dsl SYSTEM "docbookrep_html.dsl">
<!ENTITY docbookrep-tex.dsl SYSTEM "docbookrep_tex.dsl">

]>
<!-- Detalles de estilo.  Dominio público -->

<style-sheet>
<style-specification id="print" use="docbook">
<style-specification-body> 

;; printing:

<![%print;[

&docbookrep-tex.dsl;

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

(define tex-backend #t)

(define %graphic-default-extension%
  ;; Default extension for graphic FILEREFs
  "eps")

(define %generate-article-titlepage%
  ;; Should an article title page be produced?
  #t)


(define %article-titlepage-legalnotice%
  ;; Legal notice in article
  #t)

(define %chapter-autolabel%
  ;; Default extension for graphic FILEREFs
  #f)

(define %section-autolabel%
  ;; Default extension for graphic FILEREFs
  #f)

(define %generate-book-toc%
        ;; Sin tabla de contenido
        #f)
(define $generate-chapter-toc$
        ;; Sin tabla de contenido en capitulo
        (lambda () #f))


]]>
</style-specification-body>
</style-specification>

<style-specification id="html" use="docbook">
<style-specification-body> 

;; HTML
<![%html;[

&docbookrep-html.dsl;

(define use-id-as-filename
  #t)

(define citerefentry-link
  #t)

(define %graphic-default-extension%
  ;; Default extension for graphic FILEREFs
  "png")

(define %chapter-autolabel%
  ;; Default extension for graphic FILEREFs
  #t)

(define %section-autolabel%
  ;; Default extension for graphic FILEREFs
  #t)

(define %html-ext%
  ;; when producing HTML files, use this extension
  ".html")

(define %root-filename%
  ;; when producing HTML files, use this extension
  "index")


]]>


</style-specification-body>
</style-specification>
<external-specification id="docbook" document="docbook.dsl">
</style-sheet>
