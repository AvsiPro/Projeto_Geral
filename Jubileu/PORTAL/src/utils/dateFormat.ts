//String to Date yyyymmdd -> dd/mm/yyyy
export const SToD = (data: any) => {
  // Verifica se a data tem o formato correto

  if(!data){
    return ''
  }

  if (!/^\d{8}$/.test(data)) {
    return ''
  }

  // Extrai o ano, mês e dia da string
  const ano = data.substring(0, 4);
  const mes = data.substring(4, 6);
  const dia = data.substring(6, 8);

  // Verifica a validade dos valores de ano, mês e dia
  if (isNaN(ano) || isNaN(mes) || isNaN(dia)) {
    return ''
  }

  // Converte ano, mês e dia em números inteiros
  const anoInt = parseInt(ano);
  const mesInt = parseInt(mes);
  const diaInt = parseInt(dia);

  // Verifica se os valores de ano, mês e dia estão dentro dos limites corretos
  if (anoInt < 1 || mesInt < 1 || mesInt > 12 || diaInt < 1 || diaInt > 31) {
    return ''
  }

  // Retorna a data formatada
  return `${dia}/${mes}/${ano}`;
}


export const titleMonth = (mes: string) => {
if(mes === '1'){
  return 'Janeiro'

}else if(mes === '2'){
  return 'Fevereiro'

}else if(mes === '3'){
  return 'Março'

}else if(mes === '4'){
  return 'Abril'

}else if(mes === '5'){
  return 'Maio'

}else if(mes === '6'){
  return 'Junho'

}else if(mes === '7'){
  return 'Julho'

}else if(mes === '8'){
  return 'Agosto'

}else if(mes === '9'){
  return 'Setembro'

}else if(mes === '10'){
  return 'Outubro'

}else if(mes === '11'){
  return 'Novembro'

}else if(mes === '12'){
  return 'Dezembro'
  
}else {
  return 'Corrente'
}
}