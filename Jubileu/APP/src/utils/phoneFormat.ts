/**
 * Formata um número de telefone de 10 dígitos no formato (99) 99999-9999.
 * @param {string} numeroTelefone - O número de telefone a ser formatado.
 * @returns {string} O número de telefone formatado.
 * @throws {Error} Se o número de telefone não tiver exatamente 10 dígitos.
 */

export const phoneFormat = (numeroTelefone: string): string => {
  // Remove qualquer caractere que não seja número do número de telefone.

  if(!numeroTelefone){
    return ''
  }

  const apenasDigitos = numeroTelefone.replace(/\D/g, '');

  // Verifica se o número de telefone tem exatamente 11 dígitos.
  const numeroValido = apenasDigitos.length === 10 || apenasDigitos.length === 11;
  if (!numeroValido) {
    return ''
  }

  // Separa o número em grupos de 2 e 5 dígitos e adiciona os parênteses e o traço.

  let codigoDeArea = ''
  let primeiraParte = ''
  let segundaParte = ''

  if(apenasDigitos.length === 11){
    codigoDeArea = apenasDigitos.substring(0, 2);
    primeiraParte = apenasDigitos.substring(2, 7);
    segundaParte = apenasDigitos.substring(7);

  }else{
    codigoDeArea = apenasDigitos.substring(0, 2);
    primeiraParte = apenasDigitos.substring(2, 6);
    segundaParte = apenasDigitos.substring(6);
  }
 
  const numeroFormatado = `(${codigoDeArea}) ${primeiraParte}-${segundaParte}`;

  // Retorna o número de telefone formatado.

  return numeroFormatado;
}