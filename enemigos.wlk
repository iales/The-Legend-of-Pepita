import pepito.*
import wollok.game.*
import niveles.*
import sonidos.*
import config.*

class Enemigo {
  var property position
  var property image
  const property esPisable = true
  const property haceDaño = true
  var property vida
  var inmortal = false
  var property velocidadDeMovimiento 
  const evento

  //  Método que define comportamiento básico de enemigos
  method estaVivo() = vida > 0
  method puedeRecibirDaño() = not inmortal && self.estaVivo()

  method colisionarCon(elemento) {
    if (elemento.esArma()) {
      self.perderVida()
    } else {
      elemento.perderVida()
    }
  }

  method contacto(pos, elemento) {
    if(pos.x()+2 >= position.x() && pos.x()+2 <= position.x() + 4 &&
       pos.y()+2 >= position.y() && pos.y()+2 <= position.y() + 4) {self.colisionarCon(elemento)}
  }

  method perderVida() {
    if (not inmortal) {
      vida -= 1
      inmortal = true
      const hitSound = new SoundEffect(soundName = "pepitoAttack.mp3")
      hitSound.activar()
      game.schedule(200, {inmortal = false})
    }
    if (vida == 0) {self.morir()}
  }

  method morir() {
    game.removeVisual(self)
    position = game.at(50,50)
    pepito.aumentarMuertes()
    eventos.add(evento)
  }

  method movimientoAleatorio(imageBack,imageFront,imageRight,imageLeft) {
    const numeroAleatorio = 1.randomUpTo(5).truncate(0)
    if (numeroAleatorio == 1 && position.y() < game.height() - 10) {
      self.moverA(self.position().up(1))
      image = imageBack
    }
    else if (numeroAleatorio == 2 && position.y() > 1) {
      self.moverA(self.position().down(1))
      image = imageFront 
    }
    else if (numeroAleatorio == 3 && position.x() < game.width() - 4) {
      self.moverA(self.position().right(1))
      image = imageRight
    }
    else if (numeroAleatorio == 4 && position.x() > 1) {
      self.moverA(self.position().left(1))
      image = imageLeft
    }
  }

  method moverA(nuevaPosicion) {
    const puedeMover = game.getObjectsIn(nuevaPosicion).all({elemento => elemento.esPisable()})
    if (puedeMover) {position = nuevaPosicion}
  }

  method perseguirPersonaje(imageFront,imageBack,imageLeft,imageRight) {
    if(self.position() != pepito.position() && vida > 0){
      self.perseguirEnDireccionX(imageLeft,imageRight)
      self.perseguirEnDireccionY(imageFront,imageBack)
    }
  }

  method perseguirEnDireccionY(imageFront,imageBack){
    if(pepito.position().y() > self.position().y()){
      image = imageFront
      self.moverA(position.up(1))
    } else if(pepito.position().y() < self.position().y()){
      image = imageBack
      self.moverA(position.down(1))
    } else{
      return position
    }
    
  }

  method perseguirEnDireccionX(imageLeft,imageRight){
    
    if(pepito.position().x() > self.position().x()){
      image = imageRight
      self.moverA(position.right(1))
    } else if(pepito.position().x() < self.position().x()){
      image = imageLeft
      self.moverA(position.left(1))
    } else {
      return position
    }
  }
}


class Slime inherits Enemigo(image = "juanFront.png", vida = 2,velocidadDeMovimiento = 500, evento = "Movimiento aleatorio slime") {
  const imageFront = "juanFront.png"
  const imageBack = "juanBack.png"
  const imageRight = "juanRight1.png"
  const imageLeft = "juanLeft1.png"

  method iniciar() {
    game.onTick(velocidadDeMovimiento, evento, {
    self.movimientoAleatorio(imageBack,imageFront,imageRight,imageLeft) 
    })
  }
}

class Cazador inherits Enemigo(image = "cazador.png", vida = 5,velocidadDeMovimiento = 500, evento = "Perseguir A Pepito"){
  const imageFront = "cazadorEspalda.png"
  const imageBack = "cazador.png"
  const imageLeft = "cazadorIzquierda.png"
  const imageRight = "cazadorDerecha.png"

  method iniciar(){
    game.onTick(velocidadDeMovimiento, evento, 
      {
        self.perseguirPersonaje(imageFront,imageBack,imageLeft,imageRight)
      }
    )
  }
}

class Aguila inherits Enemigo(image = "aguila1.png", vida = 1,velocidadDeMovimiento = 150, evento = "Movimiento aleatorio aguila"){

  const imagen1 = "aguila1.png"
  const imagen2 = "aguilaVolando1.png" 

  method iniciar() {
    game.onTick(velocidadDeMovimiento, evento, {
    self.movimientoAleatorio(image,image,image,image) 
    if(image == imagen1){
      image = imagen2
    }else{
      image = imagen1
    }
    })
  }
}

class Tiburon inherits Enemigo(image = "tiburon.png", vida = 6,velocidadDeMovimiento = 70, evento = "hundir o atacar"){

  var hundido = false
  var dir = true 
  
  method hundir(){image = "aletaDorsal.png" hundido = true}

  method atacar(){image = "tiburon.png" hundido = false}

  method movimiento(){
      if(dir){
        if(position.y() == 0){
          dir = !dir
          position = position.up(1)
        }else{
          position = position.down(1)
        } 
    }else if(!dir){
      if(position.y()==25){
        dir = !dir
        position = position.down(1)
      }else{
        position = position.up(1)
      }
    }
  }

  method iniciar() {
    game.onTick(3000, evento, {
      game.removeTickEvent("moverse")
      if(hundido){self.atacar()}
      else {
        self.hundir()
        game.onTick(velocidadDeMovimiento,"moverse",{self.movimiento()})
      }
    })
  }
}

class Murcielago inherits Enemigo(image = "murcielago.png", vida = 3,velocidadDeMovimiento = 200, evento = "Movimiento aleatorio murcielago"){

  const imagen1 = "murcielago.png"
  const imagen2 = "murcielagoVolando.png" 

  method iniciar() {
    game.onTick(velocidadDeMovimiento, evento, {
    self.movimientoAleatorio(image,image,image,image) 
    if(image == imagen1){
      image = imagen2
    }else{
      image = imagen1
    }
    })
  }
}

class Esqueleto inherits Enemigo(image = "esqueletoFrente.png", vida = 6,velocidadDeMovimiento = 440, evento = "Esqueleto perseguir A Pepito"){
  var imageFront = "esqueletoAtras1.png"
  var imageBack = "esqueletoFrente1.png"
  var imageLeft = "esqueletoIzquierda1.png"
  var imageRight = "esqueletoDerecha1.png"

  var fase = 1

  method iniciar(){
    game.onTick(velocidadDeMovimiento, evento, 
      {
        self.perseguirPersonaje(imageFront,imageBack,imageLeft,imageRight)
      }
    )
  }

  override method perderVida() {
    if (not inmortal) {
      vida -= 1
      inmortal = true
      const hitSound = new SoundEffect(soundName = "pepitoAttack.mp3")
      hitSound.activar()
      game.schedule(200, {inmortal = false})
    }
    if (vida == 0) {
      if (fase == 1) {
        self.siguienteFase()
      } else if (fase == 2) {self.morir()}
    }
  }

  method siguienteFase() {
    image = "huesos1.png"
    game.schedule(3000, {
      game.removeTickEvent("Esqueleto perseguir A Pepito")
      vida = 4
      velocidadDeMovimiento = 280
      imageFront = "esqueletoAtrasEnojado.png"
      imageBack = "esqueletoFrenteEnojado.png"
      imageLeft = "esqueletoIzquierdaEnojado.png"
      imageRight = "esqueletoDerechaEnojado.png"
      fase = 2
      self.iniciar()
      })
  }
}
