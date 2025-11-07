class CausaJudicial {
  const juecesVinculados = []
  var montoBase
  const property caratula
  
  method perjuicioEconomico() = montoBase + self.ajusteEspecifico()
  
  method ajusteEspecifico()
  
  method tieneAlJuez(juezAmigo) = juecesVinculados.contains(juezAmigo)
  
  method montoRaro() = montoBase.even()
  
  method aumentarMontoBase(valor) {
    montoBase += valor
  }

  method tieneMasDeUnJuez() = juecesVinculados.size() > 1
}

class DesvioDeFondos inherits CausaJudicial {
  const fechaCausa
  
  override method ajusteEspecifico() = (new Date().year() - fechaCausa.year()) * 1
}

object criptoDelito inherits CausaJudicial (montoBase = 5, caratula="estafa") {
  override method ajusteEspecifico() = montoBase * 0.3
}

class CausaCompleja inherits CausaJudicial {
  const causas = []
  
  override method ajusteEspecifico() = causas.sum(
    { causa => causa.ajusteEspecifico() }
  )
}

class Funcionario {
  const causasJudiciales = []
  var property patrimonio
  var property cargo
  const promesas = []

   method escucharPedido(pedido) {
    if (!cargo.aceptoPedido(pedido)) pedido.postergar()
    promesas.add(pedido)
  }

  method tieneMuchasCausas() = causasJudiciales.size() > 3
  
  method validarPatrimonio() {
    if (patrimonio == 0) {
      throw new DomainException(
        message = "Está incriminando a un chicho que no tiene plata"
      )
    }
  }
  
  method comerseUnaCausa(causa) {
    self.validarPatrimonio()
    cargo.validarCausa(causa)
    causasJudiciales.add(causa)
  }
  
  method estaTecleando() = causasJudiciales.all{causa => causa.tieneMasDeUnJuez()}

  method causasRaris() = causasJudiciales.filter{causa => causa.montoRaro()}

  method caratulasRaris() = self.causasRaris().map{causa => causa.caratula()}

  method salirEnLosMedios() {
    causasJudiciales.forEach({ causa => causa.aumentarMontoBase(0.1) })
  }
}

class Legislador {
  method validarCausa(causa, funcionario) {
    if (funcionario.tieneMuchasCausas()) {
      throw new DomainException(
        message = "No le entra más una bala a este Congresista."
      )
    }
  }

  method aceptoPedido(pedido) = pedido.esDelAnioVigente()
}

class JefeDeGobierno {
  method validarCausa(causa, funcionario) {
    if (causa.montoRaro()) {
      throw new DomainException(message = "La causa tiene un monto raris")
    }
  }
  method aceptoPedido(pedido) = pedido.esTranqui()
}

class Pedido {
  const fechaPedida
  var fechaPactada
  const descripcion
  
  method postergar() {
    fechaPactada = fechaPactada.plusYears(4)
  }

  method esDelAnioVigente() = new Date().year() == fechaPedida.year()

  method esTranqui() = descripcion.size() < 15
  
}