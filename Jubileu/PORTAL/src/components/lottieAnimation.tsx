import React, { useEffect, useRef } from "react";
import * as Style from './styles';

import Lottie, { AnimationItem } from 'lottie-web';

interface Props {
    animationData: any;
    data: any;
    loop: boolean;
    autoplay: boolean;
    width: number;
    height: number;
}

const LottieAnimation: React.FC <Props> = ({
    animationData,
    data,
    loop,
    autoplay,
    width,
    height,
}) => {

    const animationContainer = useRef<HTMLDivElement>(null);

    useEffect(() => {
        const anim: AnimationItem = Lottie.loadAnimation({
          container: animationContainer.current!,
          renderer: 'svg',
          loop: loop,
          autoplay: autoplay,
          animationData: animationData,
        });
      
        return () => {
          anim.destroy();
        };
    }, [data]);

    return (
        <Style.LottieContainer>
            <Style.LottieItem ref={animationContainer} width={width} height={height}/>
        </Style.LottieContainer>

    );
};

export default LottieAnimation;
