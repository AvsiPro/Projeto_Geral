export const getInitials = (name: string) => {
  const names = name.split(' ');
  const firstInitial = names[0].charAt(0);

  if (names.length === 1) {
    return firstInitial.toUpperCase();
  }

  const lastInitial = names[names.length - 1].charAt(0);
  return `${firstInitial}${lastInitial}`.toUpperCase();
};


export const capitalize = (fullName: string) => {

  if (!fullName) {
    fullName = '';
  }

  const words = fullName.split(" ");
  const capitalizedWords = words.map(word => {
    return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
  });
  return capitalizedWords.join(" ").substring(0,22);
}

export const capitalizeNoWarap = (fullName: string) => {
  const words = fullName.split(" ");
  const capitalizedWords = words.map(word => {
    return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
  });
  return capitalizedWords.join(" ")
}

export const firstAndLastName = (nomeCompleto: string) => {
  if (!nomeCompleto) {
    nomeCompleto = '';
  }

  const partesDoNome = nomeCompleto.split(' ');
  const primeiroNome = partesDoNome[0];

  if (partesDoNome.length === 1) {
    return primeiroNome;
  }

  const ultimoNome = partesDoNome[partesDoNome.length - 1];

  return `${primeiroNome} ${ultimoNome}`;
};
