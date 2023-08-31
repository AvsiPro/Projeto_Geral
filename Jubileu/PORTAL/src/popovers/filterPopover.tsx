import React, { useState } from "react";
import { OverlayTrigger } from "react-bootstrap";

import Button from "react-bootstrap/Button";

import * as Style from "./styles";

interface Props {
  setDateEmisStart: any;
  setDateEmisEnd: any;
  setDateVencStart: any;
  setDateVencEnd: any;
  handleClickPay: (event: any) => void;
  handleClickComing: (event: any) => void;
  handleClickRed: (event: any) => void;
}

const FilterPopover: React.FC<Props> = ({
  setDateEmisStart,
  setDateEmisEnd,
  setDateVencStart,
  setDateVencEnd,
  handleClickPay,
  handleClickComing,
  handleClickRed,
}) => {

  const [show, setShow] = useState(false);
  const [dateEmisStartAux, setDateEmisStartAux] = useState("");
  const [dateEmisEndAux, setDateEmisEndAux] = useState("");
  const [dateVencStartAux, setDateVencStartAux] = useState("");
  const [dateVencEndAux, setDateVencEndAux] = useState("");

  const [btnPayAux, setBtnPayAux] = useState(false);
  const [btnComingAux, setBtnComingAux] = useState(false);
  const [btnRedAux, setBtnRedAux] = useState(false);

  const handleClick = (event: any) => {
    event.preventDefault();
    setShow(!show);
  };

  const handleFilter = (event: any) => {
    event.preventDefault();

    setDateEmisStart(dateEmisStartAux)
    setDateEmisEnd(dateEmisEndAux)
    setDateVencStart(dateVencStartAux)
    setDateVencEnd(dateVencEndAux)

    handleClickPay(btnPayAux)
    handleClickComing(btnComingAux)
    handleClickRed(btnRedAux)
    
    setShow(!show);
    handleFilterClear()
  };

  const handleFilterClear = () => {
    setBtnPayAux(false);
    setBtnComingAux(false);
    setBtnRedAux(false);
    setDateEmisStartAux("");
    setDateEmisEndAux("");
    setDateVencStartAux("");
    setDateVencEndAux("");
  };

  const PopOverFilterAux = (
    <Style.PopoverFilterComponent id="Filter">
      <Style.PopoverFilterHeader>
        <Style.PopoverTextLabelFilter size={18}>
          Filtro
        </Style.PopoverTextLabelFilter>
      </Style.PopoverFilterHeader>
      <Style.PopoverBodyFilter>
        <Style.PopoverBodyDataFilter>
          <Style.PopoverDataFilter>
            <label htmlFor="">Emissão de:</label>
            <input
              onChange={(event) => setDateEmisStartAux(event.target.value)}
              value={dateEmisStartAux}
              type="date"
              name=""
              id=""
            />
          </Style.PopoverDataFilter>
          <Style.PopoverDataFilter>
            <label htmlFor="">Emissão até:</label>
            <input
              onChange={(event) => setDateEmisEndAux(event.target.value)}
              value={dateEmisEndAux}
              type="date"
              name=""
              id=""
            />
          </Style.PopoverDataFilter>
        </Style.PopoverBodyDataFilter>
        <Style.PopoverBodyDataFilter>
          <Style.PopoverDataFilter>
            <label htmlFor="">Vencimento de:</label>
            <input
              onChange={(event) => setDateVencStartAux(event.target.value)}
              value={dateVencStartAux}
              type="date"
              name=""
              id=""
            />
          </Style.PopoverDataFilter>
          <Style.PopoverDataFilter>
            <label htmlFor="">Vencimento até:</label>
            <input
              onChange={(event) => setDateVencEndAux(event.target.value)}
              value={dateVencEndAux}
              type="date"
              name=""
              id=""
            />
          </Style.PopoverDataFilter>
        </Style.PopoverBodyDataFilter>
        <Style.PopoverBtnsFilter>
          <Button
            onClick={() => setBtnComingAux(!btnComingAux)}
            variant={!btnComingAux ? "outline-warning" : "warning"}
          >
            Em Aberto
          </Button>
          <Button
            onClick={() => setBtnPayAux(!btnPayAux)}
            variant={!btnPayAux ? "outline-success" : "success"}
          >
            Pagos
          </Button>
          <Button
            onClick={() => setBtnRedAux(!btnRedAux)}
            variant={!btnRedAux ? "outline-danger" : "danger"}
          >
            Atrasados
          </Button>
        </Style.PopoverBtnsFilter>
      </Style.PopoverBodyFilter>
      <Style.PopoverFilterBtn>
        <Style.PopoverButtonFilterClear onClick={handleFilterClear}>
          Limpar
        </Style.PopoverButtonFilterClear>
        <Style.PopoverButtonFilter onClick={handleFilter}>
          Filtrar
        </Style.PopoverButtonFilter>
      </Style.PopoverFilterBtn>
    </Style.PopoverFilterComponent>
  );
  return (
    <>
      <OverlayTrigger
        trigger="click"
        show={show}
        placement="bottom-end"
        overlay={PopOverFilterAux}
      >
        <Style.PopoverHeaderProfile onClick={handleClick}>
          <Style.PopoverButtonFilter>Filtrar</Style.PopoverButtonFilter>
        </Style.PopoverHeaderProfile>
      </OverlayTrigger>
    </>
  );
};
export default FilterPopover;
