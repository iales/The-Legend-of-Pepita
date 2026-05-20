import enemigos.*
import pepito.*
import config.*
import sonidos.*
import wollok.game.*
import niveles.*
import obstaculos.*

object gato inherits Enemigo(position = game.at(15,20), image = "gatoDisfrazado1.png", vida = 26,velocidadDeMovimiento = 550, evento = "Gato persigue a pepito"){

  const imageFront = "gatoAtras.png"
  const imageBack = "gato1.png"
  const imageLeft = "gatoIzquierda.png"
  const imageRight = "gatoDerecha.png"

  var activo = false
  var primeraFase = true
  var segundaFase= true
  const musicaJefe = game.sound("bossBattle.mp3")
  var contadorGatitos = 0

  const posicionesLava = [[10,15],[15,15],[20,15],[25,15],[10,10],[25,10],[10,5],[25,5]]
  const listaLava = []

  override method colisionarCon(elemento) {
    if (activo) {
      if (elemento.esArma()) {
        self.perderVida()
      } else {
        elemento.perderVida()
      }
    } else {self.dialogoJefe()}
  }

  method dialogoJefe() {
    activo = true
    pepito.posicionJefe()
    config.iniciarJefe()
    game.say(self, "Buen trabajo encontrando la llave…")
    game.schedule(2800, {
      game.say(self, "Pero hasta acá llegaste.")
      game.schedule(2400, {
        image = "gatoDisfrazado2.png"
        game.schedule(1600, {
          image = "gatoDisfrazado3.png"
          game.schedule(1600, {
            image = "gato1.png"
            game.schedule(1000, {
              image = "gatoAccion.png"
              musicaJefe.play()
              pepito.permitirMovimiento()
              game.schedule(1600, {self.iniciarGato()})
            })
          })
        })
      })
    })
  }

  method iniciarGato() {
    game.onTick(velocidadDeMovimiento, evento,{self.perseguirPersonaje(imageFront,imageBack,imageLeft,imageRight)})
  }

  method iniciarPrimeraFase(){
    primeraFase = false
    game.removeTickEvent(evento)
    position = game.at(15,22)
    pepito.moverA(game.at(18,5))
    self.iniciarLava(posicionesLava)
    self.dispararBolaDeEnergia()
  }

  method finalizarPrimeraFase() {
    game.removeTickEvent("disparar")
    self.limpiarLava()
    self.iniciarGato()  
  }

  method iniciarSegundaFase(){
    game.removeTickEvent(evento)
    game.schedule(400,{inmortal = true})
    segundaFase = false
    position = game.at(15,22)
    pepito.moverA(game.at(18,5))
    image = "gatoAccion.png"
    game.onTick(2400, "Crear gatitos", {
      const gatito = new Gatito(position = game.at(6.randomUpTo(30).truncate(0),6.randomUpTo(25).truncate(0)))
      game.addVisual(gatito)
      objetosLvlActual.add(gatito)
      gatito.iniciar()
      if(contadorGatitos >= 4) {self.finalizarSegundaFase()}
    })
  }

  method finalizarSegundaFase() {
    game.schedule(200,{inmortal = false})
    game.removeTickEvent("Crear gatitos")
    self.limpiarLava()
    self.iniciarGato()  
  }

  method muerteGatito() {contadorGatitos += 1}

  method dispararBolaDeEnergia(){
    var nombreBola = 0
    image = "gatoAccion.png"
    game.onTick(2500,"disparar",{
      const bolaEnergia = new SkillShot(position = self.position(),image = "bolaEnergia2.png",velocidad = 100,nombre= nombreBola, rango= 20)
      game.addVisual(bolaEnergia)
      objetosLvlActual.add(bolaEnergia)
      bolaEnergia.disparoAPepito(pepito.position())
      nombreBola+=1
      if (vida <= 15) {self.finalizarPrimeraFase()}
    })
  }

  method iniciarLava(posiciones){
    posiciones.forEach {pos => 
      const lava = new Lava(position = game.at(pos.get(0), pos.get(1)))
      lava.iniciar()
      game.addVisual(lava)
      listaLava.add(lava)
      obstaculosLvlActual.add(lava)
    }
  }

  method limpiarLava(){
    listaLava.forEach{lava =>
      game.removeVisual(lava)
      listaLava.remove(lava)
      obstaculosLvlActual.remove(lava)
    }
  }

  override method moverA(nuevaPosicion) {
    const puedeMover = game.getObjectsIn(nuevaPosicion).all({elemento => elemento.esPisable()})
    if (puedeMover) {
      const stompSound = new SoundEffect(soundName = "stomp.mp3")
      stompSound.activar()
      position = nuevaPosicion
    }
  }

  override method contacto(pos, elemento) {
    if(pos.x()+2 >= position.x()+2 && pos.x()+2 <= position.x() + 8 &&
       pos.y()+2 >= position.y() && pos.y()+2 <= position.y() + 6) {self.colisionarCon(elemento)}
  }

  override method perderVida() {
    if (not inmortal) {
      vida -= 1
      inmortal = true
      const hitSound = new SoundEffect(soundName = "thwompSound.mp3")
      hitSound.activar()
      game.schedule(200, {inmortal = false})
    }
    if (vida <= 20 && primeraFase) {self.iniciarPrimeraFase()}
    else if (vida <= 10 && segundaFase) {self.iniciarSegundaFase()}
    if (vida == 0) {self.morir()}
  }

  override method morir() {
    game.removeVisual(self)
    position = game.at(50,50)
    const gritoMuerte = new SoundEffect(soundName = "bossDeathSound.mp3")
    gritoMuerte.activar()
    pepito.aumentarMuertes()
    eventos.add(evento)
    pepito.inmortal(true)
    musicaJefe.pause()
  }
}

class SkillShot{
  var property position 
  var property image
  var property velocidad 
  const initialPosition = gato.position() 
  const property esPisable = true
  var property haceDaño = true 
  const nombre
  const nombreBola = "Disparo" + nombre
  const rango


  method colisionarCon(elemento) {
    if(not elemento.esArma() && haceDaño){
      elemento.perderVida()
      game.removeTickEvent(nombre)
      game.removeVisual(self)
    }

    if(elemento.esArma()){
      self.parry()
    }
  }

  method contacto(pos, elemento) {
    if(pos.x()+2 >= position.x() && pos.x()+2 <= position.x() + 4 &&
       pos.y()+2 >= position.y() && pos.y()+2 <= position.y() + 4) {self.colisionarCon(elemento)}
  }

  method parry(){
    game.removeTickEvent(nombreBola)
    game.onTick(velocidad - 100, nombreBola, {
      if(initialPosition.x() > self.position().x()){self.moverseA(4)}
      if(initialPosition.x() < self.position().x()){self.moverseA(5)}
      if(initialPosition.x() == self.position().x()){self.moverseA(6)}
      
      if(initialPosition == position){
        game.removeVisual(self)
        game.removeTickEvent(nombreBola)
        gato.perderVida()
      }   
    })
  }
  

  method moverseA(tipo){
    if(tipo==1){position = self.position().down(1) position = self.position().right(1)}
    if(tipo==2){position = self.position().down(1) position = self.position().left(1)}
    if(tipo==3){position = self.position().down(1)}
    if(tipo==4){position = self.position().up(1) position = self.position().right(1)}
    if(tipo==5){position = self.position().up(1) position = self.position().left(1)}
    if(tipo==6){position = self.position().up(1)}
  } 

  method disparoAPepito(posPepito){
    var alcance = 0
    game.onTick(velocidad, nombreBola,{
      if(posPepito.x() > self.position().x()){
        self.moverseA(1)
        alcance +=1
      }else if(posPepito.x() < self.position().x()){
        self.moverseA(2)
        alcance +=1
      }else{
        self.moverseA(3)
        alcance +=1
      }
      if(alcance == rango){
        game.removeVisual(self)
        game.removeTickEvent(nombreBola)
        
      }   
    })
  }
}

class Gatito inherits Enemigo(image = "gatito1.png", vida = 1,velocidadDeMovimiento = 300, evento = "Movimiento gracioso"){

  const imagen1 = "gatito1.png"
  const imagen2 = "gatito2.png"

	var property direccionX = 1
	var property direccionY = 1

  method iniciar(){
    game.onTick(velocidadDeMovimiento, evento, {self.movimientoDiagonal()})
  }

	method movimientoDiagonal() {
		
		const nuevaPosicionX = position.x() + direccionX
		const nuevaPosicionY = position.y() + direccionY
		
		var huboReboteX = false

		if (nuevaPosicionX >= game.width() - 5 || nuevaPosicionX <= 5) {
			direccionX = direccionX * -1
			huboReboteX = true
		}

		if (huboReboteX) {
			if (direccionX == 1) { 
				image = imagen1
			} else {image = imagen2}
		}

		if (nuevaPosicionY >= game.height() - 10 || nuevaPosicionY <= 5) {
			direccionY = direccionY * -1
		}

		const posicionFinal = game.at(position.x() + direccionX, position.y() + direccionY)
		self.moverA(posicionFinal)
	}

  override method morir() {
    game.removeVisual(self)
    position = game.at(50,50)
    gato.muerteGatito()
    eventos.add(evento)
  }

}