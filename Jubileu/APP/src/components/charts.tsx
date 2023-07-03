import React, {useContext, useRef} from 'react';
import * as Style from './styles';

import {
    View,
    Animated,
    Platform,
    useWindowDimensions,
    ScrollView
} from "react-native";

import {
    VictoryLine,
    VictoryChart,
    VictoryPie,
    VictoryTheme
} from 'victory-native'

import { graphics } from '../utils/data';
import { ThemeContext } from 'styled-components';

export default function charts(){

    const { width: windowWidth, height: windowHeight } = useWindowDimensions();
    const scrollXGraphics = useRef(new Animated.Value(0)).current;
    const { colors } = useContext(ThemeContext);

    return(
        <>
            <Style.GraphicContainer windowHeight={windowHeight-(Platform.OS === 'ios' ? 330 : 260)}>
                <Style.HeaderGraphics>
                    <Style.TitleSection margin={0}>
                        Gráficos
                    </Style.TitleSection>
                    
                    <Style.MainIndicatorGraphics>
                        {graphics.map((grafic, graficIndex) => {
                            const width = scrollXGraphics.interpolate({
                                inputRange: [
                                    windowWidth * (graficIndex - 1),
                                    windowWidth * graficIndex,
                                    windowWidth * (graficIndex + 1)
                                ],
                                outputRange: [15, 30, 15],
                                extrapolate: "clamp",
                            });

                            let colorAux = grafic.color

                            if(colorAux === 'primary'){
                                colorAux = colors.primary
                            }

                            return (
                                <Style.IndicatorGraphics
                                    style={{width}}
                                    key={graficIndex}
                                    backgroundColor={colorAux}
                                />
                            );
                        })}
                    </Style.MainIndicatorGraphics>
                </Style.HeaderGraphics>
            
                <Style.GraphicSections style={Style.styleSheet.shadow}>
                    <ScrollView
                        horizontal={true}
                        pagingEnabled
                        showsHorizontalScrollIndicator={false}
                        onScroll={Animated.event(
                            [{ nativeEvent: { contentOffset: { x: scrollXGraphics } } }],
                            { useNativeDriver: false }
                        )}
                        scrollEventThrottle={16}
                    >

                        {graphics.map((item, index) => {
                            return (
                                <View key={index}>
                                    {item.title === 'VictoryLine' && (
                                        <VictoryChart
                                            theme={VictoryTheme.material}
                                        >
                                            <VictoryLine
                                                style={{data: { stroke: colors.primary }, parent: { border: "1px solid #ccc"}}}
                                                interpolation="natural"
                                                data={item.data}
                                            />
                                        </VictoryChart>
                                    )}

                                    {item.title === 'VictoryPie' && (
                                        <VictoryPie
                                            theme={VictoryTheme.material}
                                            data={item.data}
                                            padAngle={3}
                                            innerRadius={100}
                                        />
                                    )}
                                </View>
                            );
                        })}
                    </ScrollView>
                </Style.GraphicSections>
            </Style.GraphicContainer>
        </>
    )
}