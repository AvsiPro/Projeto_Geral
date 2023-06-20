import React from 'react';
import { Modal } from 'react-bootstrap';

interface ModalComponent {
  show: boolean;
  onHide: () => void
  title: string;
  Body: any;
  Tools: any;
}

const ModalComponent: React.FC <ModalComponent> = (props) => {
  
  return (
    <Modal
      {...props}
      size="xl"
      aria-labelledby="contained-modal-title-vcenter"
      backdrop="static"
    >
      <Modal.Header closeButton>
        <Modal.Title id="contained-modal-title-vcenter">
          {props.title}
        </Modal.Title>
      </Modal.Header>

      <Modal.Body>
        {props.Body}
      </Modal.Body>

      <Modal.Footer>
        {props.Tools}
      </Modal.Footer>

    </Modal>
  );
}

export default ModalComponent;
