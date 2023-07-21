export const CurrencyFormat = (valor: any) => {
  // Verifica se o valor é numérico e não é NaN
  if (typeof valor !== 'number' || isNaN(valor)) {
    console.log('O valor fornecido não é um número válido.');
    return 'R$ 0,00'
  }

  // Converte o valor para string com duas casas decimais
  const valorString = valor.toFixed(2);

  // Separa a parte inteira e a parte decimal
  const [parteInteira, parteDecimal] = valorString.split('.');

  // Formata a parte inteira com separador de milhar
  const parteInteiraFormatada = parteInteira.replace(/\B(?=(\d{3})+(?!\d))/g, '.');

  // Retorna a string formatada
  return `R$ ${parteInteiraFormatada},${parteDecimal}`;
}