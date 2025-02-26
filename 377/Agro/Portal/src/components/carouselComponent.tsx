import React from 'react';

import Carousel from 'react-bootstrap/Carousel';
import ImageComponent from './ImageComponent';

interface Props {
    code: string;
}

const CarouselComponent: React.FC <Props> = ({code}) => {
    
  return (
    <Carousel slide variant="dark">
      <Carousel.Item>
        <ImageComponent src={`https://jubileudistribuidora.com.br/photos/${code}.jpg`} size={1000} />
      </Carousel.Item>

      <Carousel.Item>
        <ImageComponent src={`https://jubileudistribuidora.com.br/photos/${code}_2.jpg`} size={1000} />
      </Carousel.Item>
      
      <Carousel.Item>
        <ImageComponent src={`https://jubileudistribuidora.com.br/photos/${code}_3.jpg`} size={1000} />
      </Carousel.Item>

      <Carousel.Item>
        <ImageComponent src={`https://jubileudistribuidora.com.br/photos/${code}_4.jpg`} size={1000} />
      </Carousel.Item>

    </Carousel>
  );
}

export default CarouselComponent;