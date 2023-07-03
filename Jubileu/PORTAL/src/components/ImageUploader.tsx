import React, { useCallback, useState } from 'react';
import { useDropzone } from 'react-dropzone';
import {
  DropzoneContainer,
  Message,
  ImageUploaderContainer,
  ImageButtonHoriz,
  TextLabel
} from './styles';

import { IoMdClose } from "react-icons/io";

import { Badge, Button } from 'react-bootstrap';

interface Props {
    upload: (image: any) => void;
    uploadedImages: any;
    label: string;
}

const ImageUploader: React.FC <Props> = ({upload, uploadedImages, label})  => {


    const onDrop = useCallback((acceptedFiles: any) => {
        const imageFiles = acceptedFiles.filter((file: any) => file.type.startsWith('image/'));
        const remainingSlots = 5 - uploadedImages.length;
        const filesToAdd = imageFiles.slice(0, remainingSlots);

        Promise.all(
            filesToAdd.map((file: any) => {
                return new Promise<string>((resolve) => {
                    const reader = new FileReader();

                    reader.onload = () => {
                        const base64String = reader.result as string;
                        resolve(base64String);
                    };

                    reader.readAsDataURL(file);
                });
            })
        ).then((base64Strings) => {
            const updatedImages = filesToAdd.map((file: any, index: number) => ({
                file,
                base64: base64Strings[index],
                extension: file.name.split('.').pop()!.toLowerCase()
            }));

            const auxUpload =  [...uploadedImages, ...updatedImages]

            upload(auxUpload)
        });
    }, [uploadedImages]);

    const { getRootProps, getInputProps, isDragActive } = useDropzone({ onDrop });

    return (
        <ImageUploaderContainer>
            
            
            <TextLabel style={{color:'#000', width:'100%'}}>{label}</TextLabel>

            <DropzoneContainer {...getRootProps()}>
                <input {...getInputProps()} />
                {isDragActive ? (
                    <Message>Arraste e solte a imagem aqui...</Message>
                ) : (
                    <Message>Arraste uma imagem ou clique para selecionar.</Message>
                )}
            </DropzoneContainer>

            {uploadedImages.length > 0 && (
                <ImageButtonHoriz>
                    <Button onClick={() => upload([])} style={{marginRight:5}} variant="outline-danger">
                        <IoMdClose size={20} />
                    </Button>

                    <Button variant="secondary">
                        Upload <Badge text='dark' bg="light">{uploadedImages.length}</Badge>
                    </Button>
                </ImageButtonHoriz>
            )}
        </ImageUploaderContainer>
    );
};

export default ImageUploader;
