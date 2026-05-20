class SoundEffect {
  const soundName
  const soundEffect = game.sound(soundName)

  method activar() {soundEffect.play()}
}