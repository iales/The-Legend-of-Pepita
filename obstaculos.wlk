import wollok.game.*
import pepito.*
import niveles.*


class Obstaculo {
  var property position
  var property image
  const property esPisable
  var property haceDaño

  method colisionarCon(elemento){}

  method iniciar() {}

  method iniciarTrampaPeriodica(inactivo,semiActivo,activo){
    game.onTick(1100, "Activar y Desactivar", {
      if (image == inactivo){
        image = semiActivo
      }else if(image == semiActivo){
        image = activo
        haceDaño = true
      } else {
        image = inactivo
        haceDaño = false
      }
    })
    eventos.add("Activar y Desactivar")
  }

  method obstaculizar(pos) {
    if (esPisable) return false
    return pos.x()+2 >= position.x() && pos.x()+2 <= position.x() + 4 &&
           pos.y()+1 >= position.y() && pos.y()+1 <= position.y() + 4
  }

  method contacto(pos, elemento) {
    if(pos.x()+2 >= position.x() && pos.x()+2 <= position.x() + 4 &&
       pos.y()+2 >= position.y() && pos.y()+2 <= position.y() + 4) {self.colisionarCon(elemento)}
  }
}

class TrampaPinchos inherits Obstaculo(image = "trampaPinchosInactiva4.png"){
  const pinchosInactivos = "trampaPinchosInactiva4.png"
  const pinchosSemiActivos = "trampaPinchosSemiActiva4.png"
  const pinchosActivos = "trampaPinchosActivos4.png"
  
  override method iniciar() {
    self.iniciarTrampaPeriodica(pinchosInactivos, pinchosSemiActivos, pinchosActivos)
  }

  override method colisionarCon(elemento) {
    if (not elemento.esArma() && haceDaño) {
      elemento.perderVida()
    }
  }
}

class TrampaFuego inherits Obstaculo(image = "trampaFuegoInactivo.png"){
  const fuegoInactivo = "trampaFuegoInactivo.png"
  const fuegoSemiActivo = "trampaFuegoSemiactivo.png"
  const fuegoActivo = "trampaFuegoActivo.png"

  override method iniciar(){
    self.iniciarTrampaPeriodica(fuegoInactivo, fuegoSemiActivo, fuegoActivo)
  }
  
  override method colisionarCon(elemento) {
    if (not elemento.esArma() && haceDaño) {
      elemento.perderVida()
    }
  }
}
class Totem inherits Obstaculo{}

class Flecha inherits Obstaculo{
  const velocidad = 140

  method irHacia(dir,flechaN){
    const onTickName = "IrHacia" + flechaN
    var alcance = 0
    if(dir == "totemIzquierda.png"){
      game.onTick(velocidad,  onTickName , {
        position = position.left(1)
        alcance += 1
        if(alcance == 30){
          game.removeTickEvent(onTickName)
          game.removeVisual(self)
        }
      })
    }
    if(dir == "totemDerecha.png"){
      game.onTick(velocidad, onTickName, {
        position = position.right(1)
        alcance += 1
        if(alcance == 30){
          game.removeTickEvent(onTickName)
          game.removeVisual(self)
        }
      })
    }
    if(dir == "totemFrente.png"){
      game.onTick(velocidad, onTickName, {
        position = position.down(1)
        alcance += 1
        if(alcance == 30){
          game.removeTickEvent(onTickName)
          game.removeVisual(self)
        }
      })
    }
  }

  override method colisionarCon(elemento) {
    if(not elemento.esArma() && haceDaño){
      elemento.perderVida()
      game.removeTickEvent("IrHacia")
      game.removeVisual(self)
    }
  }
}

class PlacaPresion inherits Obstaculo(image = "placaPresion.png"){
  var property posTotem
  var dir    
  var property activa = false
  var property flechasActivas = 0

  method iniciarPlacaIzquierda(){
    dir = "totemDerecha.png"
    const totem = new Totem(position = posTotem,image = dir,esPisable = false,haceDaño=false)
    game.addVisual(totem)
    objetosLvlActual.add(totem)
  }
  method iniciarPlacaDerecha(){
    dir = "totemIzquierda.png"
    const totem = new Totem(position = posTotem,image = dir ,esPisable = false,haceDaño=false)
    game.addVisual(totem)
    objetosLvlActual.add(totem)
  }
  method iniciarPlacaFrente(){
    dir = "totemFrente.png"
    const totem = new Totem(position = posTotem,image = dir,esPisable = false,haceDaño=false)
    game.addVisual(totem)
    objetosLvlActual.add(totem)
  }
  
  override method colisionarCon(elemento){
    if(!activa){
      if(not elemento.esArma()){
        activa = true
        game.onTick(800, "Generar Flecha", {
          if(dir == "totemIzquierda.png"){self.generarFlecha("flechaIzquierda.png", flechasActivas)}
          if(dir == "totemDerecha.png"){self.generarFlecha("flechaDerecha.png",flechasActivas)}
          if(dir == "totemFrente.png"){self.generarFlecha("flechaAbajo.png",flechasActivas)}
          flechasActivas += 1 
        })
        eventos.add("Generar Flecha")
      }
    }
  }


  method generarFlecha(dirFlecha,nombreFlecha){
    const flecha = new Flecha(position = posTotem,image = dirFlecha ,esPisable = true,haceDaño=true)
    game.addVisual(flecha)
    flecha.irHacia(dir,nombreFlecha)
  }

}

class TrampaOso inherits Obstaculo(image = "trampaOsoInactiva.png"){
  var property activa = true

  method activar(){
      image = "trampaOsoActiva.png"
      pepito.quieto()
      activa = false
  }

  method reiniciarTrampa(){activa = true}

  override method colisionarCon(elemento) {
    if(activa && not elemento.esArma() && not elemento.haceDaño()){
      elemento.perderVida()
      self.activar()

      game.schedule(3000, {
      pepito.permitirMovimiento()
      image = "trampaOsoInactiva.png"
      game.schedule(3000,{self.reiniciarTrampa()})
      })
    }
  }

  override method contacto(pos, elemento) {
    if(pos.x()+2 >= position.x()+1 && pos.x()+2 <= position.x() + 3 &&
       pos.y()+1 >= position.y() && pos.y()+1 <= position.y() + 2) {self.colisionarCon(elemento)}
  }
}

class Lava inherits Obstaculo(image = "lavaSaliendo.png", esPisable = false , haceDaño = false){
  override method iniciar(){
    game.schedule(2000, {
      image = "lava.png"
    })
  }

  override method obstaculizar(pos) {
    if (esPisable) return false
    return pos.x()+2 >= position.x() && pos.x()+2 <= position.x() + 4 &&
           pos.y()+3 >= position.y() && pos.y()+3 <= position.y() + 4
  }
}


