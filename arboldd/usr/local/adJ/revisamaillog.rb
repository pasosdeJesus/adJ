#!/usr/bin/env ruby
# Cuenta frecuencia de ataque en bitácoras de correo

require 'debug'
require 'sorted_set'

if ARGV.length == 0 then
  puts "Faltan bitácoras de correo como parámetros"
  exit 1
end

sesip = {} # sesion -> ip
ipusuario = {} # ip -> [lista de usuarios]
usuarios = SortedSet.new()
ARGV.each do |bit|
  puts "Bitácora #{bit}"
  arc = File.open(bit)
  until arc.eof()
    linea = arc.readline()
    begin
      if linea =~ /.* ([0-9a-f]*) smtp connected address=([.0-9]*) .*/
        sesip[$~[1]] = $~[2]
      end
      if linea =~ /.* ([0-9a-f]*) smtp authentication user=([^ ]*) result=permfail/
        if sesip[$~[1]] then
          if !ipusuario[sesip[$~[1]]]
            ipusuario[sesip[$~[1]]] = [$~[2]]
          else
            ipusuario[sesip[$~[1]]] << $~[2]
          end
          usuarios << $~[2]
        else
          usuarios << $~[2]
        end
      end
    rescue Exception => e
    end

  end 
end

ol = ipusuario.map{|l,v| [l, v.length]}.sort {|x,y| y[1] <=> x[1]}

puts "IPs y usuarios inexistentes o con clave errada"
ol.each do |sig|
  i = sig[0]
  lu = ipusuario[i]
  puts "#{i} (#{lu.length})"
  linea = "  "
  lo = lu.sort
  lo.each do |u|
    plinea = linea + " " + u
    if plinea.length>80
      puts linea
      linea = "  #{u}"
    else
      linea = plinea
    end
  end
  puts linea
end
