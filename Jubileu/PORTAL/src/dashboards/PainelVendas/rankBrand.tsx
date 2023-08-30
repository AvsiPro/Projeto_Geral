import React, { useContext, useEffect, useState } from "react";
import Button from 'react-bootstrap/Button';
import ButtonGroup from 'react-bootstrap/ButtonGroup';
import { WindowDimensionsContext } from "../../contexts/WindowDimensionsContext";
import * as Style from "./styles";
import { Row, Table } from "react-bootstrap";
import { capitalize, firstAndLastName, getInitials } from "../../utils/nameFormat";
import { lightTheme, darkTheme } from "../../themes";
import { ThemeContext } from "../../contexts/ThemeContext";
import { CurrencyFormat } from "../../utils/currencyFormat";


interface Props {
    groups1: any;
    card1: any;
}

const RankBrand: React.FC <Props> = ({groups1, card1}) => {

    const { windowDimensions } = useContext(WindowDimensionsContext);
    const { theme } = useContext(ThemeContext);
    const themeContext = theme === "light" ? lightTheme : darkTheme;

    const [brand, setBrand] = useState('CAMBRIDGE')

    const transformedData: any = {};

    card1.forEach((entry: any) => {
        const name = entry.name;
        const brands = entry.brands;
      
        brands.forEach((brand: any) => {
          const brandTitle = brand.title;
          const brandValue = brand.value;
          const brandQuantity = brand.quantity;
      
          if (!transformedData[brandTitle]) {
            transformedData[brandTitle] = [];
          }
      
          transformedData[brandTitle].push({
            name: name,
            value: brandValue,
            quantity: brandQuantity
          });
        });
      });

      

    return (
        <Style.Component windowDimensions={windowDimensions}>
            <Row className="g-4">
                <Style.TextDash size={14} weight="bold">
                    Ranking por Vendedor e Marcas
                </Style.TextDash>

                <div style={{ maxHeight: 400, overflow: "auto" }}>
                    <div style={{ overflow: "auto" }}>
                        <ButtonGroup style={{marginBottom:15}}>
                            { groups1.map((item: any, index: number) =>
                                <Button
                                    key={index}
                                    onClick={() => setBrand(item)}
                                    style={{fontSize:14, color: item === brand ? '#fff' : themeContext.text}} 
                                    variant={item === brand ? "secondary" :  "outline-"+theme}>{capitalize(item)}
                                </Button>                
                            ) }
                        </ButtonGroup>

                    </div>

                    <Table hover >
                        <thead>
                        <tr style={{color: themeContext.text}}>
                            <th>Foto</th>
                            <th>Nome</th>
                            <th>Quantidade</th>
                            <th>Valor</th>
                        </tr>
                        </thead>
                        <tbody>
                        {transformedData[brand]?.map((item: any, index: number) => 
                                <tr key={`${brand}-${index}`} style={{color: themeContext.text}}>
                                <td>
                                <Style.HeaderProfileImg>
                                    <Style.HeaderProfileText>
                                        {getInitials(
                                        firstAndLastName(item.name.trim())
                                        )}
                                    </Style.HeaderProfileText>
                                    </Style.HeaderProfileImg>
                                </td>
                                <td>
                                    {capitalize(firstAndLastName(item.name.trim()))}
                                </td>
                                <td>{item.quantity}</td>
                                <td>{CurrencyFormat(item.value)}</td>
                                </tr>
                        )}
                        </tbody>
                    </Table>
                </div>
                    
            </Row>
        </Style.Component>
    );


};

export default RankBrand;