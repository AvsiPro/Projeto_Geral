import React, { useEffect, useRef, useState } from 'react';
import { ScrollView, Dimensions, Animated, useWindowDimensions } from 'react-native';
import ImageComponent from './ImageComponent';

import * as Style from './styles';


const SliderComponent: React.FC <{code: string}> = ({code}) => {
    
    
    const scrollXSections = useRef(new Animated.Value(0)).current;
    const scrollViewRef = useRef<ScrollView>(null);
    const [isValidImage, setIsValidImage] = useState(false);
    const { width: windowWidth } = useWindowDimensions();

    const images = [
        `https://jubileudistribuidora.com.br/photos/${code}.jpg`,
        `https://jubileudistribuidora.com.br/photos/${code}_2.jpg`,
        `https://jubileudistribuidora.com.br/photos/${code}_3.jpg`
    ]

    useEffect(() => {
        const validateImage = async () => {
            try {
                const response = await fetch(images[0]);
                setIsValidImage(response.ok);
            } catch (error) {
                setIsValidImage(false);
            }
        };

        validateImage();
    }, []);
  

    return (
        <>
            
            <ScrollView
                ref={scrollViewRef}
                horizontal
                pagingEnabled
                showsHorizontalScrollIndicator={false}
                onScroll={Animated.event([{ nativeEvent: { contentOffset: { x: scrollXSections } } }],{ useNativeDriver: false })}
                scrollEventThrottle={16}
            >   
                {images.map((item, index) => {
                    if(isValidImage){
                        return(
                            <ImageComponent
                                key={index}
                                imageUrl={item}
                                width={windowWidth}
                                height={300}
                            />
                        )
                    }
                })}
                    
                { !isValidImage &&
                    <ImageComponent
                        imageUrl={``}
                        width={windowWidth}
                        height={300}
                    />
                }
            </ScrollView>

            <Style.MainIndicatorSections>
                {images.map((_, imagesIndex) => {
                    const width = scrollXSections.interpolate({
                        inputRange: [
                            windowWidth * (imagesIndex - 1),
                            windowWidth * imagesIndex,
                            windowWidth * (imagesIndex + 1)
                        ],
                        outputRange: [15, 30, 15],
                        extrapolate: "clamp",
                    });

                    if(isValidImage){
                        return (
                            <Style.IndicatorSections
                                style={{width}}
                                key={imagesIndex}
                                backgroundColor={'#426AD0'}
                            />
                        );
                    }
                })}
            </Style.MainIndicatorSections>
        </>
    );
};

export default SliderComponent;
