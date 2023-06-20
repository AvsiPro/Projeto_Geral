import React, { useEffect, useState } from 'react';
import { MaterialCommunityIcons } from '@expo/vector-icons';

import * as Style from './styles'
import { View } from 'react-native';

interface Props {
  imageUrl: string;
  width?: number;
  height?: number;
}

const ImageComponent: React.FC<Props> = ({ imageUrl, width = 120, height = 120 }) => {
  const [isValidImage, setIsValidImage] = useState(false);

  useEffect(() => {
    validateImage();
  }, []);

  const validateImage = async () => {
    try {
      const response = await fetch(imageUrl);
      setIsValidImage(response.ok);
    } catch (error) {
      setIsValidImage(false);
    }
  };

  return (
    <Style.ImageContainer>
      {isValidImage ? (
        <Style.ImageArea
          resizeMode="contain"
          source={{ uri: imageUrl }}
          width={width}
          height={height}
        />
      ) 
      : (
        <View style={{ width:width-20, alignItems:'center'}}>
        <MaterialCommunityIcons name="image-remove" size={width/3} color="black" />
        </View>
      )}
    </Style.ImageContainer>
  );
};

export default ImageComponent;