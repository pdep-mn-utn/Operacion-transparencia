class CausaJudicial {
  const juecesVinculados = []
  var montoBase
  const property caratula

  method perjuicioEconomico() = montoBase + self.ajusteEspecifico()

  method ajusteEspecifico()

  method vincularJuez(juez) {
    juecesVinculados.add(juez)
  }

  method montoRaro() = montoBase.even()

  method aumentarMontoBase(valor) {
    montoBase += valor
  }

  method tieneMasDeUnJuez() = juecesVinculados.size() > 1
}

class DesvioDeFondos inherits CausaJudicial {
  const fechaCausa

  method aniosPendiente() = new Date().year() - fechaCausa.year()

  override method ajusteEspecifico() = self.aniosPendiente() * 1.5
}

object criptoDelito inherits CausaJudicial (montoBase = 5, caratula = "estafa") {
  override method ajusteEspecifico() = montoBase * 0.3
}

class CausaCompleja inherits CausaJudicial {
  const causas = []

  override method ajusteEspecifico() = causas.sum(
    { causa => causa.ajusteEspecifico() }
  )
}

class Funcionario {
  const property causasJudiciales = []
  const property promesas = []
  var property patrimonio
  var property cargo

  method escucharPropuesta(propuesta) {
    if (!cargo.aceptaPropuesta(propuesta)) propuesta.postergar()
    promesas.add(propuesta)
  }

  method llegoAlTopeDeCausas() = causasJudiciales.size() >= 3

  method validarPatrimonio() {
    if (patrimonio <= 0) {
      throw new DomainException(
        message = "Está incriminando a un chicho que no tiene plata"
      )
    }
  }

  method comerseUnaCausa(causa) {
    self.validarPatrimonio()
    cargo.validarCausa(causa, self)
    causasJudiciales.add(causa)
  }

  method estaTecleando() = causasJudiciales.all(
    { causa => causa.tieneMasDeUnJuez() }
  )

  method causasRaris() = causasJudiciales.filter({ causa => causa.montoRaro() })

  method caratulasRaris() = self.causasRaris().map({ causa => causa.caratula() })

  method salirEnLosMedios() {
    causasJudiciales.forEach({ causa => causa.aumentarMontoBase(0.1) })
  }
}

object legislador {
  method validarCausa(causa, funcionario) {
    if (funcionario.llegoAlTopeDeCausas()) {
      throw new DomainException(
        message = "No le entra más una bala a este Congresista."
      )
    }
  }

  method aceptaPropuesta(propuesta) = propuesta.esDelAnioVigente()
}

object jefeDeGobierno {
  method validarCausa(causa, funcionario) {
    if (causa.montoRaro()) {
      throw new DomainException(message = "La causa tiene un monto raris")
    }
  }

  method aceptaPropuesta(propuesta) = propuesta.esTranqui()
}

class Propuesta {
  const fechaPresentacion
  var fechaCumplimiento
  const descripcion

  method fechaCumplimiento() = fechaCumplimiento

  method postergar() {
    fechaCumplimiento = fechaCumplimiento.plusYears(4)
  }

  method esDelAnioVigente() = new Date().year() == fechaPresentacion.year()

  method esTranqui() = descripcion.size() < 15
}
