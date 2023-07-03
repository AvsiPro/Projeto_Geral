import React, { useState } from 'react';
import { TextInputProps } from 'react-native';
import * as Style from './styles';

export type InputProps = TextInputProps & {
  value?: string;
}

export type InputPropsMask = TextInputProps & {
    mask: any;
    options: any;
    value?: string;
  }

export function Input({ value, ...rest }: InputProps) {
    const [isFocused, setIsFocused] = useState(false);

    function handleInputFocus() {
        setIsFocused(true);
    }

    function handleInputBlur() {
        setIsFocused(false);
    }

    return (
        <Style.ContainerInput>
            <Style.InputText
                onFocus={handleInputFocus}
                placeholderTextColor={'#ccc'}
                onBlur={handleInputBlur}
                isFocused={isFocused}
                value={value}
                {...rest}
            />
        </Style.ContainerInput>
    );
}

export function InputMask({mask, options, value, ...rest }: InputPropsMask) {
    const [isFocused, setIsFocused] = useState(false);

    function handleInputFocus() {
        setIsFocused(true);
    }

    function handleInputBlur() {
        setIsFocused(false);
    }

    return (
        <Style.ContainerInput>
            <Style.InputTextMask
                type={mask}
                options={options}
                onFocus={handleInputFocus}
                placeholderTextColor={'#ccc'}
                onBlur={handleInputBlur}
                isFocused={isFocused}
                value={value}
                {...rest}
            />
        </Style.ContainerInput>
    );
}