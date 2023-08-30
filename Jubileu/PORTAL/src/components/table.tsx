import React, { useContext, useState } from "react";
import SyncLoader from "react-spinners/SyncLoader";

import * as Style from './styles'; 

import { darkTheme, lightTheme } from "../themes";

import { ThemeContext } from "../contexts/ThemeContext";
import { WindowDimensionsContext } from "../contexts/WindowDimensionsContext";

import { BsFillCaretDownFill, BsFillCaretUpFill, BsCardImage } from 'react-icons/bs'
import { BiCheckbox, BiCheckboxChecked } from 'react-icons/bi'
import { FiSettings } from 'react-icons/fi'
import { formatRow } from "../utils/rowTableFormat";

import FinancialPopover from "../popovers/financialPopover";

import {Table as TableB, Placeholder, Col, Row} from 'react-bootstrap';
import SearchInput from "./searchInput";

import LottieAnimation from "./lottieAnimation";
import animationData from '../assets/emptylist.json'
import { useMediaQuery } from 'react-responsive';
import ModalComponent from "./modal";
import FinancialBodyModal from "./financialBodyModal";
import ImageComponent from "./ImageComponent";

interface PropsTable{
  data: any;
  fields: any;
  title: string;
  load: boolean;
  ToolsTable: any;
  handleSearch: (searchText: string) => void;
  handleMark: (row: any) => void;
  modal?: boolean ;
  search?: boolean;
  handleRowClick?: (row: any) => void
  popover?: boolean;
}

const Table: React.FC <PropsTable> = ({
  data,
  fields,
  title,
  load,
  ToolsTable,
  handleSearch,
  handleMark,
  modal = false,
  search = true,
  handleRowClick = () => {},
  popover = false
}) => {

  const { theme } = useContext(ThemeContext);
  const { windowDimensions } = useContext(WindowDimensionsContext);
  const isMobile = useMediaQuery({ query: '(max-width: 767px)' });

  const [sortOrder, setSortOrder] = useState<"asc" | "desc">("asc");
  const [sortedField, setSortedField] = useState<string | null>(null);
  const [showModalFinancial, setShowModalFinancial] = useState<boolean>(false)
  const [financialCustomer, setFinancialCustomer] = useState<any>(null)


  const handleSort = (field: string) => {
    if (sortedField === field) {
      setSortOrder(sortOrder === "asc" ? "desc" : "asc");
    } else {
      setSortedField(field);
      setSortOrder("asc");
    }
  };

  const sortedData = sortedField
  ? data.slice().sort((a: any, b: any) => {
      const fieldA = a[sortedField];
      const fieldB = b[sortedField];

      // Verificar se os campos são numéricos
      const isNumeric = !isNaN(fieldA) && !isNaN(fieldB);

      // Verificar se os campos são objetos com a propriedade "price"
      const isObjectWithPrice = typeof fieldA === "object" && "price" in fieldA;

      // Tratar campos numéricos
      if (isNumeric) {
        return sortOrder === "asc" ? fieldA - fieldB : fieldB - fieldA;
      }

      // Tratar campos de objeto com a propriedade "price"
      if (isObjectWithPrice) {
        return sortOrder === "asc" ? fieldA.price - fieldB.price : fieldB.price - fieldA.price;
      }

      // Tratar campos de texto
      const compareResult = fieldA.localeCompare(fieldB);
      return sortOrder === "asc" ? compareResult : -compareResult;
    }).reduce((acc: any, current: any) => {
      const x = acc.find((item: { id: any }) => item.id === current.id);
      return !x ? acc.concat([current]) : acc;
    }, [])
  : data;

  const handleOpenFinancial = (item: any) => {
    setFinancialCustomer(item)
    setShowModalFinancial(true)
  }

  const handleCloseFinancial = () => {
    setShowModalFinancial(false)
    setFinancialCustomer(null)
  }

  const BodyModalFinancial = (
    <FinancialBodyModal
      financialCustomer={financialCustomer}
      type='v'
    />
  )
  

  return (
    <>
    <Style.TableComponent
      id="my-table"
      windowDimensions={windowDimensions}
      modal={modal}
      isMobile={isMobile}
      popover={popover}
    >
      { !modal &&
        <Style.TextH3 style={{color:'#000'}}>
          {title}
        </Style.TextH3>
      }


      { load ?
        <>
          <Placeholder as="p" animation="glow">
            {
              Array.from({length:3}).map((_, index) => (
                <div key={index}>
                  <Placeholder xs={3} /> <Placeholder xs={2} /> <Placeholder xs={2} /> <Placeholder xs={2} /> <Placeholder xs={2} /> {' '}
                </div>
              ))
            }
          </Placeholder>

          <SyncLoader
            color={theme === 'dark' ? darkTheme.primary : lightTheme.primary}
            loading={load}
            size={12}
            style={{display:'flex',justifyContent:'center', marginTop:30}}
          />
        </>
      :
        <>
          <Style.ToolsContainer modal={modal} isMobile={isMobile}>
            
            { search &&
              <Row xs={2} md={4} lg={6}>
                <Col>
                  <SearchInput placeholder="Pesquisar..." onSearch={handleSearch} />
                </Col>
              </Row>
            }

            <ToolsTable />
          </Style.ToolsContainer>

          <Style.TableWrapper windowDimensions={windowDimensions}>

            <TableB striped bordered hover responsive>
              <thead>
                <Style.TableRow>
                  {fields.map((item: any) => {
                    const action = item.field === 'action' || item.field === 'mark' || item.field === 'photo' 

                    return(
                      <Style.TableHeader key={item.field} textAlign={item.textAlign}>
                          <Style.TableSortColumn
                            action={action}
                            width={item.width}
                            onClick={() => {!action && handleSort(item.field)}}
                          >
                            { action
                              ? item.field === 'photo' ? <BsCardImage size={15} color={'black'}/> :<FiSettings size={15} color={'black'} /> 
                              : item.headerText
                            }
                            { !action
                              ? sortedField === item.field && sortOrder === "asc"
                                ? <BsFillCaretUpFill style={{width:15, height:15, marginLeft:15}} color={'black'} />
                                : <BsFillCaretDownFill style={{width:15, height:15, marginLeft:15}} color={'black'} /> 
                              : <></>
                            }
                          </Style.TableSortColumn>
                      </Style.TableHeader>
                    )
                  })}
                </Style.TableRow>
              </thead>
              
              <tbody>
                {sortedData.map((item: any, index: number) => (
                  <Style.TableRow key={index} onClick={() => handleRowClick(item)}>
                    {fields.map((subItem: any) =>
                      <Style.TableData key={subItem.field} textAlign={subItem.textAlign} width={subItem.width}>
                        { subItem.field === 'action'
                          ? 
                            <FinancialPopover
                              handleFinancialClick={handleOpenFinancial}
                              item={item}
                            />
                          : subItem.field === 'mark' ?

                            <Style.TableButtonAction onClick={() => handleMark(item)}>
                                {item.mark
                                  ? <BiCheckboxChecked style={{width:20, height:20}} color={'black'} />
                                  : <BiCheckbox style={{width:20, height:20}} color={'black'} />
                                  
                                }
                            </Style.TableButtonAction>
                            
                          
                          : subItem.field === 'photo' ?
                            
                              <ImageComponent src={`https://jubileudistribuidora.com.br/photos/${item['code']}.jpg`} size={80} code={item['code']}/>
                          
                          : subItem.field === 'price' || subItem.field === 'price2' || subItem.field === 'price3' ?

                              formatRow(subItem.field, item[subItem.field].price)

                          : formatRow(subItem.field, item[subItem.field])
                        }

                      </Style.TableData>
                    )}
                  </Style.TableRow>
                ))}
              </tbody>
            </TableB>
          </Style.TableWrapper>
          
          { data.length <= 0 &&
            <LottieAnimation
              animationData={animationData}
              data={data}
              loop={true}
              autoplay={true}
              width={300}
              height={300}
            />
          }
        </>
      }
      
    </Style.TableComponent>


    <ModalComponent
        show={showModalFinancial}
        onHide={handleCloseFinancial}
        title='Títulos'
        Body={BodyModalFinancial}
        Tools={<></>}
    />
  </>
  );
};

export default Table;