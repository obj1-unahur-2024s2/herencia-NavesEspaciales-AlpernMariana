class Nave {
  var velocidad
  var direccion
  var combustible

  method acelerar(cuanto){
    velocidad = 100000.min(velocidad + cuanto)
  }
  method desacelerar(cuanto){
    velocidad = 0.max(velocidad - cuanto)
  }
  method irHaciaSol() {direccion =10}
  method escaparDelSol() {direccion = -10}
  method ponerseParaleloAlSol(){direccion = 0}
  method acercarseUnPocoAlSol(){direccion =10.min(direccion+1)}
  method alejarseUnPocoDelSol(){direccion =10.max(direccion-1)}
  method prepararViaje(){
    self.cargarCombustible(30000)
    self.acelerar(5000)
    self.condicionAdicional()
  }
  method condicionAdicional() 
  method cargarCombustible(cuanto){
    combustible = 0.max(combustible - cuanto)
  }
  method estaTranquila(){
    return combustible>=4000 && velocidad <=12000
  }
  method recibirAmenaza(){
    self.escapar()
    self.avisar()
  }
  method escapar()
  method avisar()
  method estaDeRelajo(){
    self.estaTranquila() && self.tienePocaActividad()
  }
  method tienePocaActividad() = true

}

class NaveBaliza inherits Nave{
  var baliza 
  var cambioDeColor 
  const coloresValidos = #{"verde","rojo", "azul"}

  method initialize(){
    cambioDeColor=false
    baliza = "verde"}
   //esto asegura que se
  //inicialice en falso y en verde y no pueda definirlo como verdadero
  method cambiarColorBaliza(colorNuevo){
    if (!coloresValidos.contains(colorNuevo))
    self.error("el color nuevo no es válido")

    baliza = colorNuevo
    cambioDeColor = true
  }

  
  override method condicionAdicional() {
    self.cambiarColorBaliza("verde")
    self.ponerseParaleloAlSol()
  }

  override method estaTranquila(){
    return super() && baliza != "rojo"
  }

  override method escapar(){self.irHaciaSol()}
  override method avisar(){self.cambiarColorBaliza("rojo")}
  override method tienePocaActividad() = !cambioDeColor
}
class NavePasajeros inherits Nave{
  const pasajeros
  var comida
  var bebida
  var racionesServidas = 0

  method cargarComida(cuanto){comida += cuanto}
  method descargarComida(cuanto){
    comida= 0.max(comida-cuanto)
    racionesServidas += cuanto //revisar esto por maximos, minimos
  }
  method cargarBebida(cuanto){bebida += cuanto}
  method descargarBebida(cuanto){bebida=  0.max(comida - cuanto)}
  
  override method condicionAdicional(){
    self.cargarComida(4*pasajeros)
    self.cargarBebida(6*pasajeros)
    self.acercarseUnPocoAlSol()
  }

  override method escapar(){velocidad = velocidad*2} // o self.acelerar(velocidad)
  override method avisar(){
      self.descargarComida(pasajeros)
      self.descargarBebida(2*pasajeros)
  }
  override method tienePocaActividad(){
    return racionesServidas < 50
  }
}
class NaveHospital inherits NavePasajeros{
  var quirofanosPreparados = false
  method quirofanosPreparados() = quirofanosPreparados
  method alternarPrepararQuirofanos() {quirofanosPreparados=!quirofanosPreparados}
  override method estaTranquila(){
    return super() && !quirofanosPreparados
  }
  override method recibirAmenaza(){
    super()
    quirofanosPreparados = true    
  }
}

class NaveCombate inherits Nave{
  var estaInvisible = false
  var misilesDesplegados = false
  const property mensajesEmitidos =[]
  method ponerseInvisible () {estaInvisible =false} 
  method ponerseVisible () {estaInvisible = true} 
  method replegarMisiles(){misilesDesplegados = false}
  method desplegarMisiles(){misilesDesplegados= true}

  method emitirMensaje (mensaje) {mensajesEmitidos.add (mensaje)}
  method primerMensajeEmitido(){
    if (mensajesEmitidos.isEmpty()) self.error("no se puede emitir")
    return mensajesEmitidos.first()
  }
  method ultimoMensajeEmitido(){
    if (mensajesEmitidos.isEmpty()) self.error("no se puede emitir")
    return mensajesEmitidos.last()
  }
  method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)

  method esEscueta() = mensajesEmitidos.all(
    {m => m.length()<=30}
  )

  override method condicionAdicional(){
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en mision")

  }
  override method estaTranquila(){
    return super() && !misilesDesplegados
  }
  override method escapar(){
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }
  override method avisar(){
    self.emitioMensaje("Amenaza recibida")
  }
}

class NaveDeCombateSigilosa inherits NaveCombate{
  override method estaTranquila(){
    return super() && !estaInvisible
  }
  override method escapar(){
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}
