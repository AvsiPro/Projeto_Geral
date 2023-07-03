import { TextInput } from 'react-native';
import { TextInputMask } from 'react-native-masked-text';
import styled, { css } from 'styled-components/native';

interface Props {
    isFocused: boolean;
}

export const Error = styled.Text`
    color: #DC1637;
    margin: 3px 0 16px;
`

export const ContainerInput = styled.View`
    flex-direction: row;
    margin-bottom: 8px;
`;

export const InputText = styled(TextInput) <Props>`
    flex: 1;
    border-radius:10px;
    background-color: #fff;
    color: #7A7A80;
    padding: 15px 23px;
    ${({ isFocused }) => isFocused && css`
        border-bottom-width: 2px;
        border-bottom-color: ${(props) => props.theme.colors.primary};
    `};
`;

export const InputTextMask = styled(TextInputMask) <Props>`
    flex: 1;
    border-radius:10px;
    background-color: #fff;
    color: #7A7A80;
    padding: 15px 23px;
    ${({ isFocused }) => isFocused && css`
        border-bottom-width: 2px;
        border-bottom-color: ${(props) => props.theme.colors.primary};
    `};
`;

export const ContainerForm = styled.View`
    width: 100%;
`;