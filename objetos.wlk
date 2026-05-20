import inventario.*
import wollok.game.*
import pepito.*
import interactuables.*
import sonidos.*

object espada {
  var property position = game.at(5, 25)
  var property image = "swordUp.png"
  const property esPisable = true
  const property haceDaño = false
  const property esArma = true
  var property equipada = false
  var objetosLvl = []

  method actualizarEspada(objLvl) {
    objetosLvl = objLvl
    if (equipada) {
      game.removeVisual(self)
      game.addVisual(self)
    }
  }

  method reiniciar() {
    game.removeVisual(self)
    position = game.at(5, 25)
    equipada = false
    image = "swordUp.png"
  }

  
  method colisionarCon(elemento) {
    if (not elemento.haceDaño() && not equipada) { //verificamos que colisionamos con pepito
      const itemSound = new SoundEffect(soundName = "zeldaItem.mp3")
      itemSound.activar()
      position = game.at(50, 50)
      elemento.equiparEspada()
      equipada = true
      game.onCollideDo(self, {elemento => elemento.colisionarCon(self)})
    }
  }

  method atacar(){
    if (equipada) {
      image = "sword" + pepito.mirandoA() + ".png"
      if (pepito.mirandoA() == "Up") {self.moverA(pepito.position().up(2))}
      if (pepito.mirandoA() == "Down") {self.moverA(pepito.position().down(2))}
      if (pepito.mirandoA() == "Right") {self.moverA(pepito.position().right(2))}
      if (pepito.mirandoA() == "Left") {self.moverA(pepito.position().left(2))}
      game.schedule(260, {position = game.at(50, 50)})
    }

  }

  method moverA(nuevaPosicion){
    position = nuevaPosicion
    objetosLvl.forEach({o => o.contacto(nuevaPosicion,self)})
  }
}


class Objeto {
  var property position
  var property image
  const property esPisable = true
  const property haceDaño = false
  const property esArma = false

  method colisionarCon(elemento){}

  method contacto(pos, elemento) {
    if(pos.x()+2 >= position.x() && pos.x()+2 <= position.x() + 4 &&
       pos.y()+2 >= position.y() && pos.y()+2 <= position.y() + 4) {self.colisionarCon(elemento)}
  }
}

class Corazon inherits Objeto (image = "vida31.png") {

  const itemSound = game.sound("rupeeSound1.mp3")

  override method colisionarCon(elemento) {
    if (not elemento.haceDaño()) {
      elemento.curarVida()
      itemSound.play()
      position = game.at(50,50)
      game.removeVisual(self)
    }
  }
}

class Llave inherits Objeto (image = "llave.png"){

  const itemSound = game.sound("secretSound.mp3")

  override method colisionarCon(elemento) {
    if (not elemento.haceDaño()) {
      itemSound.play()
      castillo.abrir()
      position = game.at(50,50)
      game.removeVisual(self)
    }
  }
}
