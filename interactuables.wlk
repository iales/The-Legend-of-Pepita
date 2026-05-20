import pepito.*
import wollok.game.*
import sonidos.*
import objetos.*
import inventario.*
import config.*


object pato {
  var property position = game.at(30,6)
  var property image = "pato.png"
  const property esPisable = true
  const property haceDaño = false

  method colisionarCon(elemento) {
    game.say(self, "Para entrar al castillo necesitas la llave que se encuentra pasando el muelle del terror...")
  }

  method contacto(pos, elemento) {
    if(pos.x()+2 >= position.x() && pos.x()+2 <= position.x() + 4 &&
       pos.y()+2 >= position.y() && pos.y()+2 <= position.y() + 4) {self.colisionarCon(elemento)}
  }
}

object castillo {
  var property position = game.at(10,20)
  var property image = "castilloCerrado7.png"
  const property esPisable = true
  const property haceDaño = false
  var property abierto = false
  method abrir(){
    image = "castilloAbierto2.png"
    abierto = true
  }

  method cerrar(){
    image = "castilloCerrado7.png"
    abierto = false
  }

  method contacto(pos, elemento) {}
}

object pepita{
  var property position = game.at(18,25)
  var property image = "pepita1.png"
  const property esPisable = true
  const property haceDaño = false
  var gano = false

  method colisionarCon(elemento) {
    if (not gano){
      config.victory()
      gano = true
      }
  }

  method contacto(pos, elemento) {
    if(pos.x()+2 >= position.x() && pos.x()+2 <= position.x() + 3 &&
       pos.y()+2 >= position.y() && pos.y()+2 <= position.y() + 3) {self.colisionarCon(elemento)}
  }
}