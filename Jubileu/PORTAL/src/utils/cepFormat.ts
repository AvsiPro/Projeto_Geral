export const cepFormat = (cep: string) => {
  // Remove os caracteres especiais do CEP

  if (!cep) {
    cep = '';
  }

  const cepFormatado = cep.replace(/\D/g, '');

  // Verifica se o CEP possui o tamanho correto
  if (cepFormatado.length !== 8) {
    //console.log('CEP inválido. Certifique-se de passar um CEP com 8 dígitos.');

    return ''
  }

  // Formata o CEP com hífen
  return `${cepFormatado.slice(0, 5)}-${cepFormatado.slice(5)}`;
}
  