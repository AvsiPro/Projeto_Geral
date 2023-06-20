export const CgcFormat = (documento: any) => {

  if (!documento) {
    documento = '';
  }

  // Remover todos os caracteres não numéricos
  documento = documento.replace(/\D+/g, '');

  // Verificar o tamanho do documento
  if (documento.length === 11) {
    // CPF
    documento = documento.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4');
  } else if (documento.length === 14) {
    // CNPJ
    documento = documento.replace(/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/, '$1.$2.$3/$4-$5');
  } else {
    // Documento inválido
    return 'Documento inválido';
  }

  return documento;
}