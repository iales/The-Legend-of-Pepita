import wollok.game.*
import pepito.*
import enemigos.*
import objetos.*
import obstaculos.*
import niveles.*
import inventario.*
import sonidos.*
import interactuables.*

object config {
  const musica = game.sound("normalMusic.mp3")
  const castleMusic = game.sound("castleMusic.mp3")
  var dentroCastillo = false
  
  //  Encapsulamiento del estado del juego
  method estaDentroCastillo() = dentroCastillo
  method cambiarUbicacion(esCastillo) { dentroCastillo = esCastillo }

  method iniciarJuego(){
    game.title("The Legend Of Pepita")
    game.height(40)
    game.width(40)
    game.boardGround("fondo2.png")
    game.cellSize(10)

    self.pantallaInicio()
  }

  method pantallaInicio() {
    const startScreen = new Screen(image = "startScreen1.png")
    game.addVisual(startScreen)
    keyboard.enter().onPressDo({
      game.removeVisual(startScreen)
      self.comenzar()
      })
  }

  method comenzar() {
    self.iniciarMusica()
    self.iniciarTeclado()

    nivel1.iniciarNivel()
    game.addVisual(corazones)
    game.addVisual(arma)

    game.onCollideDo(pepito, {elemento => elemento.colisionarCon(pepito)})
  }

  method iniciarMusica(){
    musica.shouldLoop(true)
    musica.play()
    castleMusic.shouldLoop(true)
    castleMusic.play()
    castleMusic.pause()
    keyboard.m().onPressDo({musica.volume(0)})
    keyboard.n().onPressDo({musica.volume(1)})
  }

  method iniciarTeclado(){
    // Teclas WASD para movimiento
    keyboard.w().onPressDo({pepito.arriba()})
    keyboard.s().onPressDo({pepito.abajo()})
    keyboard.d().onPressDo({pepito.derecha()})
    keyboard.a().onPressDo({pepito.izquierda()})
    
    // Tecla de ataque
    keyboard.j().onPressDo({espada.atacar()})

    // Tecla truco
    keyboard.c().onPressDo({pepito.curarVida()})
  }

  method gameOver() {
    pepito.vivo(false)
    
    const gameOverScreen = new Screen(image = "gameOver.png")
    game.addVisual(gameOverScreen)

    const deathSound = new SoundEffect(soundName = "deathSound.mp3")
    deathSound.activar()

    if (dentroCastillo) {castleMusic.pause()}
    else {musica.pause()}
    
    // Configurar tecla para reiniciar
    keyboard.r().onPressDo({
      game.removeVisual(gameOverScreen)
      self.reiniciarJuego()
    })
  }
  
  method reiniciarJuego() {
    dentroCastillo = false
    pepito.reiniciar()
    espada.reiniciar()
    nivel1.iniciarNivel()
    castillo.cerrar()
    musica.resume()
  }

  method entrarCastillo(){
    musica.pause()
    castleMusic.resume()
    dentroCastillo = true
  }

  method salirCastillo(){
    musica.resume()
    castleMusic.pause()
    dentroCastillo = false
  }

  method iniciarJefe(){
    castleMusic.pause()
  }

  method victory() {
    const victoryScreen = new Screen(image = "victory.png")
    game.addVisual(victoryScreen)

    const winSound = new SoundEffect(soundName = "bossDefeated.mp3")
    winSound.activar()

    keyboard.r().onPressDo({
      game.removeVisual(victoryScreen)
      self.reiniciarJuego()
    })
  }
}

class Screen {
  var property position = game.at(0,0)
  var property image  
}