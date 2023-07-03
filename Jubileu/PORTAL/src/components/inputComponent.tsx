import React from 'react';
import * as Styles from './styles';

interface InputTextProps {
  placeholder: string;
  label: string;
  value: string;
  onChange: (value: string) => void;
  height?: number;
  disabled?: boolean;
  mt?: number;
  mb?: number;
}

const InputText: React.FC<InputTextProps> = ({
  placeholder,
  label,
  value,
  onChange,
  height = 100,
  disabled = false,
  mt = 16,
  mb = 16
}) => {
  return (
    <Styles.InputContainer mt={mt} mb={mb}>
      <Styles.TextLabel style={{color:'#000'}}>{label}</Styles.TextLabel>
      <Styles.TextInput
        placeholder={placeholder}
        onChange={(change)=> onChange(change.target.value)}
        value={value}
        height={height}
        disabled={disabled}
      />
    </Styles.InputContainer>
  );
};

export default InputText;
