import inventario.*
import wollok.game.*
import pepito.*
import enemigos.*
import objetos.*
import obstaculos.*
import interactuables.*
import config.*
import jefeFinal.*

const objetosLvlActual = [] //Lista que utiliza pepito y la espada para verificar el contacto
const obstaculosLvlActual = [] //Lista que utiliza pepito para verificar si es obstaculo
const eventos = [] //Lista global, la utilizan enemigos y obstaculos para depositar sus eventos a eliminar

class Nivel{

  method ubicarObstaculos(posicionesObstaculo, imagen, pisable, daño){
    posicionesObstaculo.forEach { pos =>
      const obstaculo = new Obstaculo(position = game.at(pos.get(0), pos.get(1)), image = imagen, esPisable = pisable, haceDaño = daño)
      obstaculosLvlActual.add(obstaculo)
      game.addVisual(obstaculo)
    }
  }

  method iniciarElemento(elemento) {
    objetosLvlActual.add(elemento)
    game.addVisual(elemento)
    elemento.iniciar()
  }

  method ubicarSlimes(posicionesSlimes){
    posicionesSlimes.forEach { pos =>
      const slime = new Slime(position = game.at(pos.get(0), pos.get(1)))
      self.iniciarElemento(slime)
    }
  }

  method ubicarAguilas(posicionesAguilas){
    posicionesAguilas.forEach { pos =>
      const aguila = new Aguila(position = game.at(pos.get(0), pos.get(1)))
      self.iniciarElemento(aguila)
    }
  }

  method ubicarMurcielagos(posicionesMurcielagos){
    posicionesMurcielagos.forEach { pos =>
      const murcielago = new Murcielago(position = game.at(pos.get(0), pos.get(1)))
      self.iniciarElemento(murcielago)
    }
  }

  method ubicarCazadores(posicionesCazadores){
    posicionesCazadores.forEach { pos =>
      const cazador = new Cazador(position = game.at(pos.get(0), pos.get(1)))
      self.iniciarElemento(cazador)
    }
  }

  method ubicarEsqueletos(posicionesEsqueletos){
    posicionesEsqueletos.forEach { pos =>
      const esqueleto = new Esqueleto(position = game.at(pos.get(0), pos.get(1)))
      self.iniciarElemento(esqueleto)
    }
  }

  method ubicarTiburones(posicionesTiburones){
    posicionesTiburones.forEach { pos =>
      const tiburon = new Tiburon(position = game.at(pos.get(0), pos.get(1)))
      self.iniciarElemento(tiburon)
    }
  }

  method ubicarTrampas(posicionesTrampas,tipo) {
    if(tipo == "Pincho"){
      posicionesTrampas.forEach{ pos => 
      const trampaPinchos = new TrampaPinchos(position = game.at(pos.get(0), pos.get(1)),esPisable = true,haceDaño=true)
      self.iniciarElemento(trampaPinchos)
      }
    }
    else if(tipo == "Fuego"){
      posicionesTrampas.forEach{pos => 
      const trampaFuegos = new TrampaFuego(position = game.at(pos.get(0), pos.get(1)),esPisable = true,haceDaño=true)
      self.iniciarElemento(trampaFuegos)
      }
    }
    else if(tipo == "Oso"){
      posicionesTrampas.forEach{pos => 
      const trampaOso = new TrampaOso(position = game.at(pos.get(0), pos.get(1)),esPisable = true,haceDaño=true)
      self.iniciarElemento(trampaOso)
      }
    }    
    
  }

  //1_Derecha, 2_Izquierda, 3_Abajo
  method ubicarTotem(posicionPlaca,dir,posT){
    const placaPresion = new PlacaPresion(position=posicionPlaca ,esPisable = true, haceDaño=false,dir="",posTotem=posT)
    if(dir==1){placaPresion.iniciarPlacaDerecha()}
    if(dir==3){placaPresion.iniciarPlacaFrente()}
    if(dir==2){placaPresion.iniciarPlacaIzquierda()}
    game.addVisual(placaPresion)
    objetosLvlActual.add(placaPresion)
  }

  method limpiarNivel() {
    objetosLvlActual.forEach({e =>
      game.removeVisual(e)
      objetosLvlActual.remove(e)
      })
    obstaculosLvlActual.forEach({e =>
      game.removeVisual(e)
      obstaculosLvlActual.remove(e)
      })
    eventos.forEach({e => game.removeTickEvent(e)})
    game.removeVisual(pepito)
  }
}

object nivel1 inherits Nivel(){
  
  const posicionesArboles = [
  [0,0], [0,5], [0,10], [0,15], [0,25], [5,0],[10,0], 
  [15,0], [20,0], [25,0], [30,0], [35,0], [0,25], [0,30], [5,30],
  [10,25], [10,30], [20,30], [25,30], [30,30], [35,30]]
  
  const posicionesSlimes = [
	[25, 10], [30, 10], [35, 10]]
  

  const posicionesAgua = [
	[0, 20], [10, 20], [15, 20],
	[15, 25], [15, 30]]

  method iniciarNivel(){
    self.limpiarNivel()
    self.ubicarObstaculos(posicionesArboles, "arbol.png", false, false)
    self.ubicarObstaculos(posicionesAgua, "agua.png", false, false)
    self.ubicarSlimes(posicionesSlimes)
    const puenteInicial = new Obstaculo(position = game.at(5,20), image = "puente.png", esPisable = true, haceDaño = false)
    objetosLvlActual.add(puenteInicial)
    game.addVisual(puenteInicial)
    pepito.iniciarPepito(obstaculosLvlActual, objetosLvlActual)
    if (not espada.equipada()) {
      game.addVisual(espada)
    }
  }

  method verificarPasoNivel(){
    if (pepito.position().x() > game.width()) {
      nivel2.iniciarNivel()
      pepito.moverA(game.at(0, pepito.position().y()))
      pepito.nivelActual(nivel2)
    }
  }
}

object nivel2 inherits Nivel(){
  const posicionesArboles = [
  [0,0],[5,0],[10,0], [15,0], [25,0], [30,0], [35,0],
  [0,30], [5,30], [10,30], [15,30], [25,30], [30,30], [35,30]]
  
  const posicionesSlimes = [[32, 5], [32, 20],[32, 10]]
  
  const posicionesAgua = 
  [[20,25],[20,15],[20,10],[20,0]]

  const posicionHuesos = [[20,30]]

  const posicionesPuente = [[20,20],[20,5]]

  const posicionesPiedras = [[5,23],[8,6]]

  const posicionTiburon = [[20,25]]

  method iniciarNivel(){  
    self.limpiarNivel()
    if (not espada.equipada()) {game.removeVisual(espada)}
    self.ubicarObstaculos(posicionesArboles, "arbol.png", false, false)
    self.ubicarObstaculos(posicionesAgua, "agua.png", false, false)
    self.ubicarObstaculos(posicionHuesos, "huesosFosiles.png", false, false)
    self.ubicarSlimes(posicionesSlimes)
    self.ubicarObstaculos(posicionesPuente, "puenteDerecha.png", true, false)
    self.ubicarObstaculos(posicionesPiedras, "roca1.png", false, false)
    self.ubicarTiburones(posicionTiburon)
    const corazon = new Corazon(position = game.at(34, 26))
    objetosLvlActual.add(corazon)
    game.addVisual(corazon)
    pepito.iniciarPepito(obstaculosLvlActual, objetosLvlActual)
  }

  method verificarPasoNivel(){
    if(pepito.position().x() < 0) {
      nivel1.iniciarNivel()
      pepito.moverA(game.at(game.width(), pepito.position().y()))
      pepito.nivelActual(nivel1)
    }
    else if(pepito.position().x() > game.width()) {
      nivel3.iniciarNivel()
      pepito.moverA(game.at(0, pepito.position().y()))
      pepito.nivelActual(nivel3)
    }
  }
}

object nivel3 inherits Nivel(){
  const posicionesArboles = [
  [0,0],[5,0], [35,25], [35, 20], [35,15],[35,10],[35,5],[35,0],
  [0,30], [5,30], [10,30], [15,30],[20,30], [25,30], [30,30], [35,30]]

  const posicionHuesos = [[30,25], [25,25], [30,20]]

  const posicionesPiedras = [[25,15],[15,20]]

  const posicionesAguilas = [[20,15], [15,25], [25, 5]]

  method iniciarNivel(){  
    self.limpiarNivel()
    self.ubicarObstaculos(posicionesArboles, "arbol.png", false, false)
    self.ubicarObstaculos(posicionHuesos, "huesosFosiles.png", false, false)
    self.ubicarObstaculos(posicionesPiedras, "roca1.png", false, false)
    self.ubicarAguilas(posicionesAguilas)
    pepito.iniciarPepito(obstaculosLvlActual, objetosLvlActual)
  }

  method verificarPasoNivel(){
    if (pepito.position().x() < 0) {
      nivel2.iniciarNivel()
      pepito.moverA(game.at(game.width(), pepito.position().y()))
      pepito.nivelActual(nivel2)
    }
    else if (pepito.position().y() < 0) {
      nivel4.iniciarNivel()
      pepito.moverA(game.at(pepito.position().x(), 30))
      pepito.nivelActual(nivel4)
    }
  }
}

object nivel4 inherits Nivel(){
  const posicionesArboles = [[0,30],[5,30],[0,25],
  [35,30],[35,25],[35,20],[35,15]]

  const posicionesPiedras = [[5,25],[0,20],[0,15],[0,10],[0,5],[0,0]]
  
  const posicionesArbustos = [[35,10],[35,5],[35,0],[30,0],[30,5]]

  const posicionesOsos = [[10,20],[20,25],[15,10],[25,20],[25,10]]

  const posicionCazador = [[20,0]]

  method iniciarNivel(){  
    self.limpiarNivel()
    self.ubicarObstaculos(posicionesArboles, "arbol.png", false, false)
    self.ubicarObstaculos(posicionesPiedras, "roca1.png", false, false)
    self.ubicarObstaculos(posicionesArbustos, "arbusto1.png", false, false)
    self.ubicarTrampas(posicionesOsos, "Oso")
    self.ubicarCazadores(posicionCazador)
    const corazon = new Corazon(position = game.at(25, 5))
    game.addVisual(corazon)
    objetosLvlActual.add(corazon)
    pepito.iniciarPepito(obstaculosLvlActual, objetosLvlActual)
  }

  method verificarPasoNivel(){
    if (pepito.position().y() > game.height() - 10) {
      nivel3.iniciarNivel()
      pepito.moverA(game.at(pepito.position().x(), 0))
      pepito.nivelActual(nivel3)
    }
    if (pepito.position().y() < 0) {
      nivel5.iniciarNivel()
      pepito.moverA(game.at(pepito.position().x(), game.height() - 10))
      pepito.nivelActual(nivel5)
    }
  }
}

object nivel5 inherits Nivel(){
  const posicionesPiedras = [[0,30],[0,25],[0,20],[0,15],[0,10],[5,5],[30,15]]
  
  const posicionesArbustos = [[0,5],[0,0],[5,0],[10,0],[15,0],
  [20,0],[25,0],[30,0],[35,0],[35,30],[30,30],[35,25]]

  const posicionesAgua = 
  [[35,20],[30,25],[30,20],[35,15],[35,10]]

  const posicionesAguilas = [[5,15], [10,15]]

  const posicionesSlimes = [[15, 8], [20, 8],[25, 8]]

  method iniciarNivel(){  
    self.limpiarNivel()
    self.ubicarObstaculos(posicionesPiedras, "roca1.png", false, false)
    self.ubicarObstaculos(posicionesArbustos, "arbusto1.png", false, false)
    self.ubicarObstaculos(posicionesAgua, "agua.png", false, false)
    self.ubicarSlimes(posicionesSlimes)
    self.ubicarAguilas(posicionesAguilas)
    pepito.iniciarPepito(obstaculosLvlActual, objetosLvlActual)
  }

  method verificarPasoNivel(){
    if (pepito.position().y() > game.height() - 10) {
      nivel4.iniciarNivel()
      pepito.moverA(game.at(pepito.position().x(), 0))
      pepito.nivelActual(nivel4)
    }
    if (pepito.position().x() > game.width()) {
      nivel6.iniciarNivel()
      pepito.moverA(game.at(0, pepito.position().y()))
      pepito.nivelActual(nivel6)
    }
  }
}

object nivel6 inherits Nivel(){

  const posicionesAgua = [
    [0,10],[5,10],[10,10],[15,10],[25,10],[30,10],[35,10],
    [15,15],
    [15,20],[25,20],[30,20],[35,20],
    [20,25],
    [35,0],[35,5]]

  const posicionesArboles = 
  [[0,0],[5,0],[10,0],[15,0], [20,0], [25,0], [30,0]]

  method iniciarNivel(){  
    self.limpiarNivel()
    const fondoAguaCastillo = new Obstaculo(position = game.at(0,0), image = "fondoAguaCastillo.png", esPisable = true, haceDaño = false) 
    game.addVisual(fondoAguaCastillo)
    obstaculosLvlActual.add(fondoAguaCastillo)
    self.ubicarObstaculos(posicionesAgua, null, false, false)
    self.ubicarObstaculos(posicionesArboles, "arbol.png", false, false)
    game.addVisual(castillo)
    if(not castillo.abierto()) {game.addVisual(pato)}
    objetosLvlActual.add(castillo)
    objetosLvlActual.add(pato)
    pepito.iniciarPepito(obstaculosLvlActual, objetosLvlActual)
  }

  method verificarPasoNivel(){
    if (pepito.position().x() < 0) {
      nivel5.iniciarNivel()
      pepito.moverA(game.at(game.width(), pepito.position().y()))
      pepito.nivelActual(nivel5)
    }
    if (pepito.position().y() >= 21 && castillo.abierto()) {
      config.entrarCastillo()
      nivel7.iniciarNivel()
      pepito.moverA(game.at(18, 0))
      pepito.nivelActual(nivel7)
    }
    if(pepito.position().x()> game.width()){
      nivelMision.iniciarNivel()
      pepito.moverA(game.at(0, 15))
      pepito.nivelActual(nivelMision)
    }
  }
}

object nivelMision inherits Nivel {
  
  const posicionesAgua = [
   [0,20],[5,20],[10,20],[15,20],[20,20],[25,20],[30,20],[35,20],
   [0,10],[5,10],[10,10],[15,10],[20,10],[25,10],[30,10],[35,10]
  ]

  method iniciarNivel(){
    self.limpiarNivel()
    const fondoAgua = new Obstaculo(position = game.at(0,0), image = "fondoAgua.png", esPisable = true, haceDaño = false) 
    game.addVisual(fondoAgua)
    obstaculosLvlActual.add(fondoAgua)
    self.ubicarObstaculos(posicionesAgua, null, false, false)
    pepito.iniciarPepito(obstaculosLvlActual, objetosLvlActual)
  }

  method verificarPasoNivel(){
    if (pepito.position().x() < 0) {
      nivel6.iniciarNivel()
      pepito.moverA(game.at(35, pepito.position().y()))
      pepito.nivelActual(nivel6)
    }
    if(pepito.position().x() > game.width()){
      nivelMision2.iniciarNivel()
      pepito.moverA(game.at(0, pepito.position().y()))
      pepito.nivelActual(nivelMision2)
    }
  }
}

object nivelMision2 inherits Nivel{ 
  const posicionesAgua = [
   [0,20],[5,20],[10,20],[15,20],
   [0,10],[5,10],[10,10],[15,10]
  ]

  const posicionesPalmera = [[25,0],[30,0],[35,0],[25,30],[30,30],[35,30]]

  method iniciarNivel(){
    self.limpiarNivel()
    const fondoMuelle = new Obstaculo(position = game.at(0,0), image = "fondoMuelle.png", esPisable = true, haceDaño = false) 
    game.addVisual(fondoMuelle)
    obstaculosLvlActual.add(fondoMuelle)
    self.ubicarObstaculos(posicionesAgua, null, false, false)
    self.ubicarObstaculos(posicionesPalmera, "palmera2.png", false, false)
    pepito.iniciarPepito(obstaculosLvlActual, objetosLvlActual)
  }

  method verificarPasoNivel(){
    if (pepito.position().x() < 0) {
      nivelMision.iniciarNivel()
      pepito.moverA(game.at(35, pepito.position().y()))
      pepito.nivelActual(nivelMision)
    }
    if (pepito.position().x() > game.width()) {
      nivelMisionFinal.iniciarNivel()
      pepito.moverA(game.at(0, pepito.position().y()))
      pepito.nivelActual(nivelMisionFinal)
    }    
  }
}

object nivelMisionFinal inherits Nivel{
  const posicionesPalmera = [
    [0,0],[5,0],[10,0],[15,0],[20,0],[25,0],[30,0],[35,0],
    [0,30],[5,30],[10,30],[15,30],[20,30],[25,30],[35,30],
    [35,25],[35,20],[35,15],[35,10],[35,5],[35,0],
    [5,5],[5,15],[5,25],[15,5],[15,15],[15,25],
    [25,10],[25,15],[25,20],[25,25]
  ]

  const posicionesFuego =[[5,10],[10,10],[15,10],[20,10],[10,20],[15,20],[20,20],[5,20]]

  method iniciarNivel(){
    self.limpiarNivel()
    const fondoArena = new Obstaculo(position = game.at(0,0), image = "arenaFondo.png", esPisable = true, haceDaño = false) 
    game.addVisual(fondoArena)
    obstaculosLvlActual.add(fondoArena)
    self.ubicarTotem(game.at(30,25),3,game.at(30,30))
    const llave = new Llave(position = game.at(30,25))
    objetosLvlActual.add(llave)
    game.addVisual(llave)
    self.ubicarTrampas(posicionesFuego, "Fuego")
    self.ubicarObstaculos(posicionesPalmera, "palmera2.png", false, false)
    pepito.iniciarPepito(obstaculosLvlActual, objetosLvlActual)
  }

  method verificarPasoNivel(){
    if (pepito.position().x() < 0) {
      nivelMision2.iniciarNivel()
      pepito.moverA(game.at(35, pepito.position().y()))
      pepito.nivelActual(nivelMision2)
    } 
  }
}

object nivel7 inherits Nivel(){
  var corazonPickeado = false
  var abierto = false
  const puerta = new Obstaculo(position = game.at(15,30), image = "puertaCerrada.png", esPisable = false, haceDaño = false)

  const posicionesPared = [
    [5,0],[10,0],[25,0],[30,0],
    [5,30],[10,30],[15,32],[20,32],[25,30],[30,30],
    [0,5],[0,10],[0,15],[0,20],[0,25],
    [35,5],[35,10],[35,15],[35,20],[35,25]
  ]

  const posicionesMurcielago = [
    [15,20],[20,20],[25,20]
  ]

  const posicionesTrampas = [
    [10,15],[15,15],[20,15],[25,15]
  ]

  method iniciarNivel(){  
    self.limpiarNivel()
    const fondoCastillo = new Obstaculo(position = game.at(0,0), image = "fondoCastillo1.png", esPisable = true, haceDaño = false) 
    game.addVisual(fondoCastillo)
    obstaculosLvlActual.add(fondoCastillo)
    self.ubicarObstaculos(posicionesPared, null, false, false)
    game.addVisual(puerta)
    objetosLvlActual.add(puerta)
    self.ubicarTrampas(posicionesTrampas,"Pincho")
    self.ubicarMurcielagos(posicionesMurcielago)
    pepito.iniciarPepito(obstaculosLvlActual, objetosLvlActual)
  }

  method verificarPasoNivel(){
    if (pepito.contadorMuertes() == 3) {
      abierto = true
      game.removeVisual(puerta)
      objetosLvlActual.remove(puerta)
      if(!corazonPickeado){
        const corazon = new Corazon(position = game.at(30, 25))
        objetosLvlActual.add(corazon)
        game.addVisual(corazon)
      }
      corazonPickeado = true
    }
    if (pepito.position().y() < 0) {
      if (not abierto) {game.removeVisual(puerta)}
      config.salirCastillo()
      nivel6.iniciarNivel()
      pepito.moverA(game.at(20, 20))
      pepito.nivelActual(nivel6)
    }
    if (pepito.position().y() >= 30 && abierto) {
      nivel8.iniciarNivel()
      pepito.moverA(game.at(18, 0))
      pepito.nivelActual(nivel8)
    }
  }
}

object nivel8 inherits Nivel(){
  var corazonPickeado = false
  var abierto = false
  const puerta = new Obstaculo(position = game.at(15,30), image = "puertaCerrada.png", esPisable = false, haceDaño = false)

  const posicionesPared = [
    [5,0],[10,0],[25,0],[30,0],
    [5,30],[10,30],[15,32],[20,32],[25,30],[30,30],
    [0,5],[0,10],[0,15],[0,20],[0,25],
    [35,5],[35,10],[35,15],[35,20],[35,25]
  ]

  const posicionesFuego =[
    [10,10],[25,10],
    [10,20],[25,20]
  ]  

  const posicionEsqueleto = [[20,25]]

  method iniciarNivel(){  
    self.limpiarNivel()
    const fondoCastillo = new Obstaculo(position = game.at(0,0), image = "fondoCastillo1.png", esPisable = true, haceDaño = false) 
    game.addVisual(fondoCastillo)
    obstaculosLvlActual.add(fondoCastillo)
    self.ubicarObstaculos(posicionesPared, null, false, false)
    self.ubicarTrampas(posicionesFuego, "Fuego")
    game.addVisual(puerta)
    objetosLvlActual.add(puerta)
    self.ubicarEsqueletos(posicionEsqueleto)
    pepito.iniciarPepito(obstaculosLvlActual, objetosLvlActual)
  }

  method verificarPasoNivel(){
    if (pepito.contadorMuertes() == 1) {
      abierto = true
      game.removeVisual(puerta)
      objetosLvlActual.remove(puerta)
      if(!corazonPickeado){
        const corazon = new Corazon(position = game.at(30, 25))
        objetosLvlActual.add(corazon)
        game.addVisual(corazon)
      }
      corazonPickeado = true
    }
    if (pepito.position().y() < 0) {
      if (not abierto) {game.removeVisual(puerta)}
      nivel7.iniciarNivel()
      pepito.moverA(game.at(18, 30))
      pepito.nivelActual(nivel7)
    }
    if (pepito.position().y() >= 30 && abierto) {
      nivel9.iniciarNivel()
      pepito.moverA(game.at(18, 5))
      pepito.nivelActual(nivel9)
    }
  }
}

object nivel9 inherits Nivel(){

  var abierto = false
  const puerta1 = new Obstaculo(position = game.at(15,30), image = "puertaCerrada.png", esPisable = false, haceDaño = false)
  const puerta2 = new Obstaculo(position = game.at(15,0), image = "puertaCerrada.png", esPisable = false, haceDaño = false)

  const posicionesPared = [
    [5,0],[10,0],[15,-2],[20,-2],[25,0],[30,0],
    [5,30],[10,30],[15,32],[20,32],[25,30],[30,30],
    [0,5],[0,10],[0,15],[0,20],[0,25],
    [35,5],[35,10],[35,15],[35,20],[35,25]
  ]

  const posicionesHuesos = [
    [5,25],[30,25]
  ]

  method iniciarNivel(){  
    self.limpiarNivel()
    const fondoCastillo = new Obstaculo(position = game.at(0,0), image = "fondoCastillo1.png", esPisable = true, haceDaño = false) 
    game.addVisual(fondoCastillo)
    obstaculosLvlActual.add(fondoCastillo)
    self.ubicarObstaculos(posicionesPared, null, false, false)
    self.ubicarObstaculos(posicionesHuesos, "huesos.png", true, false)
    game.addVisual(puerta1)
    game.addVisual(puerta2)
    objetosLvlActual.add(puerta1)
    objetosLvlActual.add(puerta2)
    objetosLvlActual.add(gato)
    pepito.iniciarPepito(obstaculosLvlActual, objetosLvlActual)
    game.addVisual(gato)
  }

  method verificarPasoNivel(){
    if (pepito.contadorMuertes() == 1) {
      abierto = true
      game.removeVisual(puerta1)
      objetosLvlActual.remove(puerta1)
    }
    if (pepito.position().y() >= 30 && abierto) {
      game.removeVisual(puerta2)
      objetosLvlActual.remove(puerta2)
      nivel10.iniciarNivel()
      pepito.moverA(game.at(18, 5))
      pepito.nivelActual(nivel10)
    }
  }
}

object nivel10 inherits Nivel(){

  const puerta1 = new Obstaculo(position = game.at(15,30), image = "puertaCerrada.png", esPisable = false, haceDaño = false)
  const puerta2 = new Obstaculo(position = game.at(15,0), image = "puertaCerrada.png", esPisable = false, haceDaño = false)

  const posicionesPared = [
    [5,0],[10,0],[15,-2],[20,-2],[25,0],[30,0],
    [5,30],[10,30],[15,32],[20,32],[25,30],[30,30],
    [0,5],[0,10],[0,15],[0,20],[0,25],
    [35,5],[35,10],[35,15],[35,20],[35,25]
  ]

  method iniciarNivel(){  
    self.limpiarNivel()
    const fondoCastillo = new Obstaculo(position = game.at(0,0), image = "fondoCastillo1.png", esPisable = true, haceDaño = false) 
    game.addVisual(fondoCastillo)
    obstaculosLvlActual.add(fondoCastillo)
    self.ubicarObstaculos(posicionesPared, null, false, false)
    game.addVisual(puerta1)
    game.addVisual(puerta2)
    objetosLvlActual.add(puerta1)
    objetosLvlActual.add(puerta2)
    game.addVisual(pepita)
    objetosLvlActual.add(pepita)
    pepito.iniciarPepito(obstaculosLvlActual, objetosLvlActual)
  }
  method verificarPasoNivel(){}
}