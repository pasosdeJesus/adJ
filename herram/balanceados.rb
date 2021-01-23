#!/usr/bin/env ruby
# Determina balance o no de `´, « », ( )


ar=ARGV[0]
if ar.nil? || ar.length==0
  puts "Falta archivo gbfxml como primer parametro"
  exit 1
end

# Parejas que abre y cierra y en general debería estar balanceadas
pacs = [['`', '´'], ['«', '»'], ['(', ')'], ['[', ']'], ['{', '}']]

abiertos = {}
lab = {}
cerrados = {}
pacs.each do |pac|
  abiertos[pac[0]] = 0
  lab[pac[0]] = []
  cerrados[pac[0]] = 0
end
nlinea = 1
File.readlines(ar).each do |linea|
  pacs.each do |pac|
    nab = linea.split(pac[0]).count
    abiertos[pac[0]] += nab>0 ? nab-1 : 0
    (1..nab).each do
      lab[pac[0]].push(nlinea)
    end
    ldiv = linea.split(pac[1])
    ncer = ldiv.count
    cerrados[pac[0]] += ncer>0 ? ncer-1 : 0
    (1..ncer).each do
      if lab[pac[0]].count > 0
        lab[pac[0]].pop()
      else
        print "* #{nlinea}: "
        (1..ldiv.count-1).each do |i|
          print "Vez #{i}: #{ldiv[i-1][-3..-1]}#{pac[1]}#{ldiv[i][0..3]}. "
        end
        print "\n"
      end
    end
  end
  nlinea += 1
end

pacs.each do |pac|
  if abiertos[pac[0]] != cerrados[pac[0]]
    puts "Para pareja (#{pac[0]}, #{pac[1]}), no coinciden "\
      "diálogos abiertos (#{abiertos[pac[0]]}) y "\
      "diálogos cerrados (#{cerrados[pac[0]]})"
    if abiertos[pac[0]] > cerrados[pac[0]]
      puts "Abiertos no cerrados: #{lab[pac[0]].count}"
      puts "Líneas donde se inician abiertos que no son cerrados:"
      puts lab[pac[0]]
    else

    end
  else
    puts "Para pareja (#{pac[0]}, #{pac[1]}), "\
      "coinciden diálogos abiertos y diálogos cerrados"
  end
end
