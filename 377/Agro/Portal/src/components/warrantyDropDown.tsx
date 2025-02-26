import React from "react";

import * as Style from './styles'
import { Dropdown } from "react-bootstrap";

import { option1, option2 } from "../utils/warrantyOpt";

interface Props {
    selectedOption: string;
    selectedOption1: string;
    selectedOption2: string;
    setSelectedOption: (opt: string) => void;
    setSelectedOption1: (opt: string) => void;
    setSelectedOption2: (opt: string) => void;
}

const WarrantyDropDown: React.FC <Props> = ({
    selectedOption,
    selectedOption1,
    selectedOption2,
    setSelectedOption,
    setSelectedOption1,
    setSelectedOption2
})  => {

    return(
   
        <Style.WarrantyBodyDropContainer>
            <Dropdown style={{padding:5}}>
                <Dropdown.Toggle 
                    variant={!selectedOption ? "outline-secondary" : "outline-success"}
                    id="dropdown-basic"
                >
                { !!selectedOption
                    ? option1[parseInt(selectedOption)-1].label
                    : 'Opções de Troca'

                }
                </Dropdown.Toggle>
        
                <Dropdown.Menu>
                { option1.map((item: any, index: number) =>
                    <Dropdown.Item key={index} onClick={() => setSelectedOption(item.option)}>{item.label}</Dropdown.Item>
                    )
                }
                </Dropdown.Menu>
            </Dropdown>

            <Dropdown style={{ padding: 5 }}>
                <Dropdown.Toggle
                    variant={!selectedOption1 ? "outline-secondary" : "outline-success"}
                    id="dropdown-basic"
                >
                {!!selectedOption1
                    ? option2.find((item: any) => item.option === selectedOption1)?.label
                    : 'Defeito em'}
                </Dropdown.Toggle>

                <Dropdown.Menu>
                {option2.map((item: any, index: number) => (
                    <Dropdown.Item
                    key={index}
                    onClick={() => {
                        setSelectedOption1(item.option);
                        setSelectedOption2('');
                    }}
                    >
                    {item.label}
                    </Dropdown.Item>
                ))}
                </Dropdown.Menu>
            </Dropdown>

            <Dropdown style={{ padding: 5 }}>
                <Dropdown.Toggle
                    variant={!selectedOption2 ? "outline-secondary" : "outline-success"}
                    id="dropdown-basic"
                >
                {!!selectedOption2
                    ? option2
                        .find((item: any) => item.option === selectedOption1)
                        ?.type.find((type: any) => type.option === selectedOption2)?.label
                    : 'Tipo Defeito'}
                </Dropdown.Toggle>

                <Dropdown.Menu>
                {!!selectedOption1 &&
                    option2
                    .find((item: any) => item.option === selectedOption1)
                    ?.type.map((type: any, index: number) => (
                        <Dropdown.Item
                        key={index}
                        onClick={() => setSelectedOption2(type.option)}
                        >
                        {type.label}
                        </Dropdown.Item>
                    ))}
                </Dropdown.Menu>
            </Dropdown>
        </Style.WarrantyBodyDropContainer>

    )
}

export default WarrantyDropDown;