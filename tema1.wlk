class CausaJudicial {
  const juecesVinculados = []
  var montoBase


  method perjuicioEconomico() = montoBase + self.ajusteEspecifico()

  method ajusteEspecifico()

  method vincularJuez(juez) {
    juecesVinculados.add(juez)
  }

  method tieneAlJuez(juez) = juecesVinculados.contains(juez)

  method perjuicioMayorA(valor) = self.perjuicioEconomico() > valor

  method aumentarMontoBase(valor) {
    montoBase += valor
  }
}

class Soborno inherits CausaJudicial {
  const hayArrepentidos

  override method ajusteEspecifico() = if (hayArrepentidos) 1 else 2
}

object obraPublica inherits CausaJudicial (
  montoBase = 3
) {
  override method ajusteEspecifico() = if (juecesVinculados.size() > 2) 0 else 2
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

  method causasQueTeDejanPegado() = causasJudiciales.filter(
    { causa => causa.perjuicioMayorA(5) }
  )

  method salirEnLosMedios() {
    causasJudiciales.forEach({ causa => causa.aumentarMontoBase(0.1) })
  }
}

class PoderEjecutivo {
  const juezAmigo
  const palabrasClave = []

  method validarCausa(causa, funcionario) {
    if (!causa.tieneAlJuez(juezAmigo)) {
      throw new DomainException(
        message = "Necesito tener un juez amigo para estar en esta causa"
      )
    }
  }

  method aceptaPropuesta(propuesta) = palabrasClave.any(
    { palabra => propuesta.contieneEnDescripcion(palabra) }
  )
}

object ministro {
  method validarCausa(causa, funcionario) {
    if (funcionario.patrimonio() <= (causa.perjuicioEconomico() * 0.5)) {
      throw new DomainException(
        message = "El patrimonio debe ser mayor al 50% del perjuicio económico de la causa"
      )
    }
  }

  method aceptaPropuesta(propuesta) = propuesta.esCorta()
}

class Propuesta {
  const fechaPresentacion
  var fechaCumplimiento
  const descripcion

  method fechaCumplimiento() = fechaCumplimiento

  method postergar() {
    fechaCumplimiento = fechaCumplimiento.plusYears(4)
  }

  method contieneEnDescripcion(palabraClave) = descripcion.contains(
    palabraClave
  )

  method esCorta() = fechaCumplimiento < fechaPresentacion.plusYears(1)
}
