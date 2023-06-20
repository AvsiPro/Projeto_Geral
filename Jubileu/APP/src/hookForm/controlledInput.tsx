import React from 'react';
import { Control, Controller, FieldError } from 'react-hook-form';
import { Input, InputProps, InputMask, InputPropsMask } from './input';

type Props = InputProps & {
  control: Control<any>;
  name: string;
  error?: FieldError;
}

type PropsMask = InputPropsMask & {
  mask: any;
  control: Control<any>;
  name: string;
  error?: FieldError;
}

import * as Style from './styles';

export function ControlledInput({ control, name, error, ...rest }: Props) {
  return (
    <>
      <Controller
        name={name}
        control={control}
        render={({ field: { onChange, value } }) => (
          <Input
            onChangeText={onChange}
            value={value}
            {...rest}
          />
        )}
      />

      {
        error && <Style.Error>{error.message}</Style.Error>
      }

    </>
  )
}

export function ControlledInputMask({ mask, control, name, error, ...rest }: PropsMask) {
  return (
    <>
      <Controller
        name={name}
        control={control}
        render={({ field: { onChange, value } }) => (
          <InputMask
            mask={mask}
            onChangeText={onChange}
            value={value}
            {...rest}
          />
        )}
      />

      {
        error && <Style.Error>{error.message}</Style.Error>
      }

    </>
  )
}