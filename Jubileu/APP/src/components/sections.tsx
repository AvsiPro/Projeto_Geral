import React, {useContext, useRef} from 'react';
import * as Style from './styles';

import { Animated, useWindowDimensions } from "react-native";
import { useNavigation } from '@react-navigation/native';

import Pedidos from "../assets/pedidos.svg";
import Clientes from "../assets/clientes.svg";
import Produtos from "../assets/produtos.svg";

import { optSections } from '../utils/data';
import { ThemeContext } from 'styled-components';

export default function sections(){

    type SvgItensType = {
        [key in typeof optSections[number]['title']]: React.FunctionComponent<React.SVGProps<SVGSVGElement>>;
    };

    const SvgItens: SvgItensType = {
        Pedidos: Pedidos,
        Clientes: Clientes,
        Produtos: Produtos,
    };
    
    const { colors } = useContext(ThemeContext);
    const navigation: any = useNavigation() //nao remover, esta macroexecutando com eval
    const scrollXSections = useRef(new Animated.Value(0)).current;
    const { width: windowWidth } = useWindowDimensions();

    
    const handleOptionAction = (action: string) => {
        if(action === 'pedidos'){
            navigation.navigate('Orders')
            
        }else if(action === 'produtos'){
            navigation.navigate('Products')

        }else if(action === 'clientes'){
            navigation.navigate('Customers')
        }
    }

    return(
        <>
            <Style.TitleSection margin={20}>
                Seções
            </Style.TitleSection>

            <Style.MainIndicatorSections>
                {optSections.map((optSections, optSectionsIndex) => {
                    const width = scrollXSections.interpolate({
                        inputRange: [
                            windowWidth * (optSectionsIndex - 1),
                            windowWidth * optSectionsIndex,
                            windowWidth * (optSectionsIndex + 1)
                        ],
                        outputRange: [15, 30, 15],
                        extrapolate: "clamp",
                    });

                    let colorAux = optSections.color

                    if(colorAux === 'primary'){
                        colorAux = colors.primary
                    }

                    return (
                        <Style.IndicatorSections
                            style={{width}}
                            key={optSectionsIndex}
                            backgroundColor={colorAux}
                        />
                    );
                })}
            </Style.MainIndicatorSections>

            <Style.ScrollSections
                horizontal={true}
                showsHorizontalScrollIndicator={false}
                onScroll={Animated.event([{ nativeEvent: { contentOffset: { x: scrollXSections } } }],{ useNativeDriver: false })}
                scrollEventThrottle={16}
            >
                {optSections.map((optSections: any, index: number) => {
                    const BackSvg = SvgItens[optSections.title];

                    return (
                        <Style.ItemService
                            key={index}
                            backgroundColor={optSections.backgroundColor}
                            style={Style.styleSheet.shadow}
                            onPress={() => handleOptionAction(optSections.action)}
                            activeOpacity={0.4}
                        >
                            {BackSvg && (
                                <BackSvg style={{ maxHeight: 200, bottom: 10 }} width={300} />
                            )}
                            <Style.NameService>{optSections.title}</Style.NameService>
                        </Style.ItemService>
                    );
                })}
            </Style.ScrollSections>
        </>
    )
}