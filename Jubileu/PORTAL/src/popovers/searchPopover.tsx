import React, { useContext, useEffect, useRef, useState } from 'react';
import { OverlayTrigger, Button } from 'react-bootstrap';

import Table from '../components/table';

import { AiOutlineCloseCircle } from 'react-icons/ai'
import { BsSearch } from 'react-icons/bs'

import * as Style from './styles'
import { fetchData as fetchDataCustomers, fetchSearch as fetchSearchCustomers } from '../services/apiCustomers';
import { fetchData as fetchDataPayment, fetchSearch as fetchSearchPayment } from '../services/apiPayment';
import { fetchData as fetchDataProduct, fetchSearch as fetchSearchProduct } from '../services/apiProducts';

import { WindowDimensionsContext } from '../contexts/WindowDimensionsContext';

interface Props {
    title: string;
    field: any;
    handleConfirmSelect: (item: any) => void;
}

const SearchPopover: React.FC <Props> = ({title, field, handleConfirmSelect}) => {
    const { windowDimensions } = useContext(WindowDimensionsContext);
    const ref = useRef(null);

    const [show, setShow] = useState<boolean>(false);
    const [load, setLoad] = useState<boolean>(false)
    const [data, setData] = useState<any>([])
    const [selected, setSelected] = useState<any>([])

    useEffect(() => {
        if(!load){
            setLoad(true)
        }
        
        const apiData = async() => {
            let returnResult: any = []

            if(field.type === 'customers'){
                returnResult = await fetchDataCustomers(1)

            }else if(field.type === 'payment'){
                returnResult = await fetchDataPayment(1)
            
            }else if(field.type === 'product'){
                returnResult = await fetchDataProduct(1)
            }

            if(returnResult.length > 0){
                setData((prevData: any) => [...prevData, ...returnResult]);
            }
            
            setLoad(false)
        };

        apiData()

    },[show]);


    const handleSearch = async (searchText: string) => {
        let returnResult: any = []

        if(field.type === 'customers'){
            returnResult = await fetchSearchCustomers(searchText)
            
        }else if(field.type === 'payment'){
            returnResult = await fetchSearchPayment(searchText)

        }else if(field.type === 'product'){
            returnResult = await fetchSearchProduct(searchText)
        }

        setData(returnResult);
        
    }

    const handleClick = () => {
        setData([])
        setLoad(false)
        setShow(!show)
    };

    const fields = () =>{
        let auxFields = []

        if(field.type === 'customers'){
            auxFields.push(
                {field: 'mark', headerText: '', textAlign: 'Center'  },
                {field: 'code', headerText: 'Codigo', textAlign: 'Center' },
                {field: 'branch', headerText: 'Loja', textAlign: 'Center' },
                {field: 'name', headerText: 'Razão Social', textAlign: 'Left', width: '300px'},
                {field: 'short_name', headerText: 'Nome Fantasia', textAlign: 'Left', width: '300px' },
                {field: 'cnpj', headerText: 'CPF/CNPJ', textAlign: 'Center', width: '200px' },
            )

        }else if(field.type === 'payment'){
            auxFields.push(
                {field: 'mark', headerText: '', textAlign: 'Center'  },
                {field: 'code', headerText: 'Codigo', textAlign: 'Center' },
                {field: 'form', headerText: 'Forma', textAlign: 'Left'},
                {field: 'description', headerText: 'Descrição', textAlign: 'Left'},
            )

        }else if(field.type === 'product'){
            auxFields.push(
                {field: 'mark', headerText: '', textAlign: 'Center'  },
                {field: 'code', headerText: 'Codigo', textAlign: 'Center' },
                {field: 'description', headerText: 'Descrição', textAlign: 'Left'},
                {field: 'photo', headerText: 'Foto', textAlign: 'Center'},
            )
        }

        return auxFields
    }
    
    const handleMark = (row: any) => {
        const updatedItems = data.map((item: any) => {
            if (item.id === row.id) {
              return { ...item, mark: true };
            }
            return { ...item, mark: false };
        });
        
        row.mark = true
        setSelected(row)
        setData(updatedItems)
    }

    const handleConfirm = () => {
        setShow(false)

        const itemSelected = {
            id: field.id,
            selected: selected
        }
        handleConfirmSelect(itemSelected)
    }

    const ToolsTable = () => {
        return(
          <div>
            <Button onClick={handleConfirm} variant="outline-primary">Selecionar</Button>{' '}
          </div>
        )
    }

    const PopOverAux = (
        <Style.PopoverSearchComponent windowDimensions={windowDimensions} id={`search-${title}`}>
            <Style.PopoverSearchHeader>
                <Style.PopoverTextLabel style={{color:'#202024'}} size={18}>{title}</Style.PopoverTextLabel>

                <Style.PopOverSearchClose onClick={handleClick}>
                    <AiOutlineCloseCircle
                        style={{width:20, height:20}}
                        color={'black'}
                    />
                </Style.PopOverSearchClose>
            </Style.PopoverSearchHeader>

            <Style.PopoverSearchBody>
                <Table
                    data={data}
                    fields={fields()}
                    title={title}
                    load={load}
                    handleSearch={handleSearch}
                    handleMark={handleMark}
                    ToolsTable={ToolsTable}
                    modal={true}
                />

            </Style.PopoverSearchBody> 
        </Style.PopoverSearchComponent>
    )
    
    return(
        <div ref={ref}>
        <OverlayTrigger
            show={show}
            placement="bottom-start"
            overlay={PopOverAux}
            container={ref}
        >   
                <Style.PopoverHeaderProfile onClick={handleClick}>
                    <BsSearch style={{width:15, height:15}} color={'black'} />
                </Style.PopoverHeaderProfile>
        </OverlayTrigger>
        </div>
    );
}
export default SearchPopover;