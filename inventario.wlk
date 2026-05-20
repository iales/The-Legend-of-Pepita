object corazones {
  var property position = game.at(22, 35)
  var property image = "vidas6.png"

  method actualizarCorazones(vida) {
    image = "vidas" + vida + ".png"
  }
}

object arma {
  var property position = game.at(50, 50)
  var property image = "swordUp.png"

  method mostrar(){
    position = game.at(0, 35)
  }

  method reiniciar() {
    position = game.at(50, 50)
  }
}