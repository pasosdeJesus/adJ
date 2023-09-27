

var ultres = null

document.addEventListener('mouseover', function(e) {
  if (e.target.nodeName=='SUP' && e.target.classList.contains('footnote')) {
    bid = e.target.id.slice(2)
    span = document.querySelector('#t_'+bid)
    ultres = span
    span.classList.add('texto-pie-resaltado')
  } else if (ultres != null) {
    ultres.classList.remove('texto-pie-resaltado')
    ultres = null
  }

})
