import React, {useContext, useEffect, useState} from 'react';
import * as Style from './styles';

import {
    View,
    Platform,
    useWindowDimensions,
    ScrollView,
} from "react-native";

import {
    VictoryLine,
    VictoryChart,
    VictoryPie,
    VictoryTheme,
    VictoryLabel,
    VictoryBar
} from 'victory-native'

import { ThemeContext } from 'styled-components';

import Carousel from 'react-native-snap-carousel';
import { CurrencyFormat } from '../utils/currencyFormat';
import DropDownPicker from 'react-native-dropdown-picker';
import api from '../services/api';
import { AppContext } from '../contexts/globalContext';

export default function charts(){

    const { authDetail } = useContext(AppContext);

    const { width: windowWidth, height: windowHeight } = useWindowDimensions();
    const { colors } = useContext(ThemeContext);

    const [graphic1, setGraphic1] = useState([])    
    const [maxYGraphic1, setMaxYGraphic1] = useState(0)
    const [headerGraphic1, setHeaderGraphic1] = useState([])

    const [graphic2, setGraphic2] = useState([])
    const [graphic3, setGraphic3] = useState([])
    const [categoryGraphic3, setCategoryGraphic3] = useState([])

    const wp = (percentage: number) => {
        const value = (percentage * windowWidth) / 100;
        return Math.round(value);
    }
    
    const slideWidth = wp(80);
    const itemHorizontalMargin = wp(2);
    
    const sliderWidth = windowWidth ;
    const itemWidth = slideWidth + itemHorizontalMargin * 2;


    const [graphicOpen, setGraphicOpen] = useState(false);
    const [graphicValue, setGraphicValue] = useState('graphic1');
    const [graphic, setGraphic] = useState([
      { label: "Valor vendas por dia", value: "graphic1" },
      { label: "Top Grifes por % de Vendas", value: "graphic2" },
      { label: "Top Grifes por Valor de Vendas", value: "graphic3" },
    ]);


    const getDataGraphics = async() => {

        try{

            const currentDate = new Date();
            const year = currentDate.getFullYear().toString();
            const month = (currentDate.getMonth() + 1).toString()

            const response = await api.get(`/WSAPP18?ano=${year}&mes=${month}&token=${authDetail.token}`);
            const receive = response.data;

            if (receive.status.code === '#200') {

                const convertedData1 = receive.result[0].series1[0].data.map((value: any, index: number) => ({
                    x: index + 1,
                    y: value,
                }));
                
                const max = Math.max(...convertedData1.map((dataPoint: any) => dataPoint.y));
                const roundedAndSummedMax = Math.ceil(max) + 5;


                const convertedData2 = receive.result[0].series2[0].labels.map((label: any, index: number) => ({
                    x: label,
                    y: receive.result[0].series2[0].data[index]
                }));


                const resultado = receive.result[0].series3[0].labelcat.map((x: any, index: number) => ({
                    x: x,
                    y: receive.result[0].series3[0].data[index]
                }));

                
                
                setGraphic1(convertedData1);
                setMaxYGraphic1(roundedAndSummedMax);
                setHeaderGraphic1(receive.result[0].header);
                
                setGraphic2(convertedData2);
                setGraphic3(resultado);
                setCategoryGraphic3(receive.result[0].series3[0].labelcat)
            }
        
        } catch(error){
            console.log(error)
        }

    }

    
    useEffect(() => {
        getDataGraphics();
    },[])

    return(
        <>
            <Style.GraphicContainer windowHeight={windowHeight-(Platform.OS === 'ios' ? 330 : 260)}>
                
                <Style.HeaderGraphics>
                    <Style.TitleSection margin={0}>
                        DashBoard
                    </Style.TitleSection>
                   
                </Style.HeaderGraphics>

                <View style={[{marginTop:20},Style.styleSheet.shadow]}>
                    { headerGraphic1.length > 0 &&
                        <Carousel
                            data={headerGraphic1}
                            renderItem={ ({ item }: { item: any }) =>
                                <Style.CardGraphic >
                                    <Style.TextGraphic size={18} weight='normal'>
                                        {item.title}
                                    </Style.TextGraphic>

                                    <Style.TextGraphic size={28} weight='bold'>
                                        {   item.type === 'number'
                                                ? CurrencyFormat(item.value)
                                                : (item.value)
                                        }
                                    </Style.TextGraphic>
                                </Style.CardGraphic>
                            }
                            sliderWidth={sliderWidth} // Largura do carousel
                            itemWidth={itemWidth}   // Largura de cada card
                        />
                    }
                </View>

                <Style.DropContainer width={itemWidth}>
                    <DropDownPicker
                        dropDownContainerStyle={{backgroundColor:'#fff'}}
                        open={graphicOpen}
                        value={graphicValue}
                        items={graphic}
                        setOpen={setGraphicOpen}
                        setValue={setGraphicValue}
                        setItems={setGraphic}
                        placeholder="Selecione um gráfico"
                        zIndex={3000}
                        zIndexInverse={1000}
                    />
                </Style.DropContainer>

                { graphicValue === 'graphic1' && graphic1.length > 0 &&
                    <ScrollView
                        horizontal={true}
                        showsHorizontalScrollIndicator={false}
                    >
                        <VictoryChart
                            theme={VictoryTheme.material}
                            width={1000}
                            domain={{y: [0, maxYGraphic1], x: [0, 32]}}

                        >
                            <VictoryLine
                                style={{data: { stroke: colors.primary }, parent: { border: "1px solid #ccc"}}}
                                interpolation="natural"
                                data={graphic1}
                                labels={({ datum }) => `${datum.y}K`}
                                x={(datum) => `${datum.x}`}
                                labelComponent={
                                    <VictoryLabel renderInPortal dx={10}/>
                                }
                                
                            />
                        </VictoryChart>
                    </ScrollView>
                }

                { graphicValue === 'graphic2' && graphic2.length > 0 &&
                    <View style={{alignItems: 'center'}}>
                        <VictoryPie
                            theme={VictoryTheme.material}
                            data={graphic2}
                            padAngle={4}
                            labelRadius={({ innerRadius }: any) => innerRadius + 50 }
                            labels={({ datum }) => `${datum.x}: ${datum.y}%`}
                            labelPlacement="parallel"
                            width={itemWidth}
                            style={{        
                                labels: {
                                    fontWeight: 'bold',
                                    fontSize: 8,
                                    fill: "#000000"
                                }
                            }}
                            
                        />
                    </View>
                }
                
                { graphicValue === 'graphic3' && graphic3.length > 0 &&
                    <ScrollView
                        horizontal={true}
                        showsHorizontalScrollIndicator={false}
                    >
                        <View style={{alignItems: 'center'}}>
                            <VictoryChart
                                theme={VictoryTheme.material}
                                width={1000}
                                domainPadding={{ x: 30 }}
                            >
                            <VictoryBar
                                style={{  data: { fill: colors.primary } }}
                                labels={({ datum }) => `${datum.y}K`}
                                data={graphic3}
                                categories={{ x: categoryGraphic3 }}
                                

                            />
                            </VictoryChart>
                        </View>
                    </ScrollView>

                }
                
                
            </Style.GraphicContainer>
        </>
    )
}