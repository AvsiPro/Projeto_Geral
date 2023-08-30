import * as Style from '../components/styles'

import { BsGenderMale, BsGenderFemale } from 'react-icons/bs'
import { CurrencyFormat } from './currencyFormat'
import { CgcFormat } from './cgcFormat'
import { phoneFormat } from './phoneFormat'
import { capitalize } from './nameFormat'
import { cepFormat } from './cepFormat'
import { SToD } from './dateFormat'

export const formatRow = (field: string, data: any) => {
  if(field === 'gender'){
    if(data === 'F'){
      return (
        <Style.TableGenderRow>
          <Style.TextLabel style={{color: '#000'}}>Feminino</Style.TextLabel>
          
          <BsGenderFemale
            style={{width:20, height:20, marginLeft:5}}
            color={'#D99BFF'}
          /> 
        </Style.TableGenderRow>
      )
    }else {
      return (
        <Style.TableGenderRow>
        <Style.TextLabel style={{color: '#000'}}>Masculino</Style.TextLabel>

        <BsGenderMale
          style={{width:20, height:20, marginLeft:5}}
          color={'#426AD0'}
        /> 
      </Style.TableGenderRow> 
      )
    }

  }else if(field === 'price' ||
    field === 'price2' ||
    field === 'price3' ||
    field === 'number' ||
    field === 'valueTotal' ||
    field === 'valueVcto' ||
    field === 'valueLiqd' ||
    field === 'valueReceive' ||
    field === 'valueCards' ||
    field === 'valueRTotal' ||
    field === 'valueFluxo' ||
    field === 'valueOpen' ||
    field === 'valueCardsN' ||
    field === 'valueReceiveO' ||
    field === 'valueReceiveC' ||
    field === 'vlrVendas' ||
    field === 'valorVendas' ||
    field === 'vlrDesc' ||
    field === 'vlrTicket' ||
    field === 'vlrVBrut'

    ){
    return CurrencyFormat(data)

  }else if(field === 'cnpj' || field === 'customer_cnpj'){
    return CgcFormat(data)

  }else if(field === 'phone'){
    return phoneFormat(data)

  }else if(field === 'issue_date' ||
    field === 'emission' ||
    field === 'date'
  ){
    return SToD(data)

  }else if(field === 'cep'){
    return cepFormat(data)

  }else if(field === 'percent' || field === 'openPercent' || field === 'percTotal' ){
    return `${data}%`

  }else if(field === 'k'){
    return `${data} K`
    
  }else if(
    field === 'name' ||
    field === 'short_name' ||
    field === 'address' ||
    field === 'district' ||
    field === 'city' ||
    field === 'state' ||
    field === 'contact'
  ){
    return capitalize(data)

  }else{
    return data
  }

}