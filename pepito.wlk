import wollok.game.*
import objetos.*
import inventario.*
import niveles.*
import sonidos.*
import config.*

object pepito {
  var property position = game.at(5, 5)
  var property image = "pepitoFront.png"
  var property mirandoA = "Down"
  var property vivo = true
  var property nivelActual = nivel1
  var property contadorMuertes = 0
  var front = "pepitoFront.png"
  var back = "pepitoBack.png"
  var right = "pepitoRight.png"
  var left = "pepitoLeft.png"
  var vida = 6
  var property inmortal = false
  var obstaculosLvl = []
  var objetosLvl = []
  var property movimiento = true
  
  // Encapsulamiento - acceso controlado a la vida
  method vida() = vida
  method tieneVida() = vida > 0
  
  method haceDaño() = false
  method esArma() = false
  method esPisable() = true

  method iniciarPepito(obsLvl, objLvl) {
    game.addVisualCharacter(self)
    contadorMuertes = 0
    obstaculosLvl = obsLvl
    objetosLvl = objLvl
    espada.actualizarEspada(objLvl)
  }

  method arriba() {
    if(movimiento){
      const nuevaPos = position.up(1)
      self.moverA(nuevaPos)
      image = back
      mirandoA = "Up"
    }

  }
  method abajo() {
    if(movimiento){
      const nuevaPos = position.down(1)
      self.moverA(nuevaPos)
      image = front
      mirandoA = "Down"
    }
  }
  method derecha() {
    if(movimiento){
      const nuevaPos = position.right(1)
      self.moverA(nuevaPos)
      image = right
      mirandoA = "Right"
    }
  }
  method izquierda() {
    if(movimiento){
      const nuevaPos = position.left(1)
      self.moverA(nuevaPos)
      image = left
      mirandoA = "Left"
    }
  }

  method perderVida() {
    if (not inmortal && vida > 0) {
      vida -= 1
      inmortal = true
      const hitSound = new SoundEffect(soundName = "minecraftHit2.mp3")
      hitSound.activar()
      game.schedule(550, {inmortal = false})
      corazones.actualizarCorazones(vida)
    }
    else if (vida <= 0 && vivo) {
      config.gameOver()
    }
  }

  method curarVida() {
    if (vida < 5) {
      vida += 2
    } else {
      vida = 6
    }
    corazones.actualizarCorazones(vida)
  }
 

  method equiparEspada() {
    arma.mostrar()
    front ="pepitoSwordFront.png"
    back = "pepitoSwordBack.png"
    right ="pepitoSwordRight.png"
    left = "pepitoSwordLeft1.png"
  }

  method moverA(nuevaPosicion) {
    if (self.puedeMover(nuevaPosicion) && vivo) {
      position = nuevaPosicion
      objetosLvl.forEach({o => o.contacto(nuevaPosicion,self)})
      nivelActual.verificarPasoNivel()
    }
  } 

  method puedeMover(pos) {
    return obstaculosLvl.all({o => not o.obstaculizar(pos)})
  }

  method reiniciar() {
    front ="pepitoFront.png"
    back  = "pepitoBack.png"
    right ="pepitoRight.png"
    left  = "pepitoLeft.png"
    vida  = 6
    position = game.at(5, 5)
    image = front
    mirandoA = "Down"
    nivelActual = nivel1
    inmortal = false
    vivo  = true
    arma.reiniciar()
    corazones.actualizarCorazones(vida)
  }

  method quieto(){
    movimiento = false
  }
  method permitirMovimiento() {
    movimiento = true
  }

  method aumentarMuertes() {contadorMuertes += 1}

  method posicionJefe() {
    self.moverA(game.at(18, 5))
    self.quieto()
  }
}