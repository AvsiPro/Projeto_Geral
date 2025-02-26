import React, { useState } from 'react';

import ModalComponent from './modal';
import CarouselComponent from './carouselComponent';

import * as Style from './styles'

interface Props {
    src: string;
    size: number;
    code?: string;
}

const ImageComponent: React.FC<Props> = ({ src, size, code = '' }) => {
  const [showModal, setShowModal] = useState(false);

  return (
    <>
        <Style.HeaderButtonCart onClick={() => !!code && setShowModal(true)}>
            <img src={src} width={size} />
        </Style.HeaderButtonCart>
        
        <ModalComponent
            show={showModal}
            onHide={() => setShowModal(false)}
            title={''}
            Body={<CarouselComponent code={code}/>}
            Tools={() => {}}
        />
    </>
  );
};

export default ImageComponent;
