import React from 'react';
import { ControlledInput, ControlledInputMask } from './controlledInput';
import * as Style from './styles';

interface Props {
  formSchema: any
}

export default function Form({formSchema} : Props) {

  return (
    <Style.ContainerForm>
      <ControlledInput
        name="name"
        control={formSchema.control}
        placeholder="Razão Social"
        error={formSchema.errors.name}
        editable={false}
      />

      <ControlledInput
        name="short_name"
        control={formSchema.control}
        placeholder="Nome Fantasia"
        error={formSchema.errors.short_name}
        editable={false}
      />

      <ControlledInputMask
        name="cnpj"
        mask={'cnpj'}
        options={{}}
        control={formSchema.control}
        placeholder="CNPJ"
        error={formSchema.errors.short_name}
        editable={false}
      />
      
      <ControlledInput
        name="email"
        control={formSchema.control}
        placeholder="E-mail"
        keyboardType="email-address"
        autoCapitalize="none"
        error={formSchema.errors.email}
      />

      <ControlledInput
        name="address"
        control={formSchema.control}
        placeholder="Endereço"
        error={formSchema.errors.address}
      />

      <ControlledInput
        name="complement"
        control={formSchema.control}
        placeholder="Complemento"
        error={formSchema.errors.complement}
      />

      <ControlledInputMask
        name="cep"
        mask={'custom'}
        options={{
          mask: '99999-999',
        }}
        control={formSchema.control}
        keyboardType="numeric"
        placeholder="CEP"
        error={formSchema.errors.cep}
      />

      <ControlledInput
        name="district"
        control={formSchema.control}
        placeholder="Bairro"
        error={formSchema.errors.district}
      />

      <ControlledInput
        name="city"
        control={formSchema.control}
        placeholder="Cidade"
        error={formSchema.errors.city}
      />

      <ControlledInput
        name="uf"
        control={formSchema.control}
        placeholder="UF"
        error={formSchema.errors.uf}
      />

      <ControlledInput
        name="contact"
        control={formSchema.control}
        placeholder="Contato"
        error={formSchema.errors.contact}
      />

      <ControlledInputMask
        name="phone"
        mask='cel-phone'
        options={{
          maskType: 'BRL',
          withDDD: true,
          dddMask: '(99) ',
        }}
        control={formSchema.control}
        keyboardType="numeric"
        placeholder="Telefone"
        error={formSchema.errors.phone}
      />

    </Style.ContainerForm>
  )
}