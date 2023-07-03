import React, { useEffect } from 'react';
import { Alert, Button } from 'react-bootstrap';

import * as Style from './styles';

interface Props {
    header: string;
    body: string;
    textButton: string;
    type: string;
    showAlert: boolean;
    handleShowAlert: () => void;
}

export const AlertComponent: React.FC <Props> = ({header, body, textButton, type, showAlert, handleShowAlert}) => {

  useEffect(() => {
    let timeout: NodeJS.Timeout;
    if (showAlert) {
      timeout = setTimeout(handleShowAlert, 5000);
    }
    return () => clearTimeout(timeout);
  }, [showAlert]);

  return (
    <Style.AlertContainer transition show={showAlert} variant={type}>
      <Alert.Heading>{header}</Alert.Heading>
      <hr />
      <p>{body}</p>
      <div className="d-flex justify-content-end">
        <Button onClick={handleShowAlert} variant={`outline-${type}`}>
          {textButton}
        </Button>
      </div>
    </Style.AlertContainer>
  );
}