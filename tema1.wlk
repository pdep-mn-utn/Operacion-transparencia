class CausaJudicial {
  const juecesVinculados = []
  var montoBase
  
  method perjuicioEconomico() = montoBase + self.ajusteEspecifico()
  
  method ajusteEspecifico()
  
  method tieneAlJuez(juezAmigo) = juecesVinculados.contains(juezAmigo)
  
  method perjuicioMayorA(valor) = self.perjuicioEconomico() > valor
  
  method aumentarMontoBase(valor) {
    montoBase += valor
  }
}

class Soborno inherits CausaJudicial {
  const hayArrepentidos
  
  override method ajusteEspecifico() = if (hayArrepentidos) 1 else 2
}

object obrasPublicas inherits CausaJudicial (montoBase = 3) {
  override method ajusteEspecifico() = if (juecesVinculados.size() > 2) 0 else 2
}

class CausaCompleja inherits CausaJudicial {
  const causas = []
  
  override method ajusteEspecifico() = causas.sum(
    { causa => causa.ajusteEspecifico() }
  )
}

class Funcionario {
  const causasJudiciales = []
  const promesas = []
  var property patrimonio
  var property cargo
  
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
  
  method estaMetidoEnElSistema() = causasJudiciales.any(
    { causa => causa.tieneAlJuez("Dr. Armando U. Nacausa") }
  )
  
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
        message = "Necesito tener un juez amigo para estar ne esta causa"
      )
    }
  }
  
  method aceptoPedido(pedido) = palabrasClave.any(
    { palabra => pedido.contieneEnDescripcion(palabra) }
  )
}

class Ministro {
  method validarCausa(causa, funcionario) {
    if ((causa.perjuicioEconomico() * 0.5) > funcionario.patrimonio()) {
      throw new DomainException(
        message = "La causa debe tenr un perjuicio económico bajo para poder estar involucrado"
      )
    }
  }
  
  method aceptoPedido(pedido) = pedido.esCorto()
}

class Pedido {
  const fechaPedida
  var fechaPactada
  const descripcion
  
  method postergar() {
    fechaPactada = fechaPactada.plusYears(4)
  }
  
  method contieneEnDescripcion(palabraclave) = descripcion.contains(
    palabraclave
  )
  
  method esCorto() = (fechaPactada - fechaPedida) < 360
}