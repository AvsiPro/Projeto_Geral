import React from 'react';
import  Form  from '../hookForm/form';
import * as Style from './styles';

interface Props {
  formSchema: any
}

export default function UpdateCustomer({formSchema}: Props) {
  return (
    <Style.ContainerFormCustomer>
        <Form
          formSchema={formSchema}
        />
    </Style.ContainerFormCustomer>
  );
}