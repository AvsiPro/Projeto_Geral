import { Component, OnInit, ViewChild } from '@angular/core';
import { environment } from 'src/environments/environment';
import { HttpClient } from '@angular/common/http';
import { PoBreadcrumb, PoModalComponent, PoPageAction } from '@po-ui/ng-components';

import { PoPageDynamicTableOptions } from '@po-ui/ng-templates';


@Component({
  selector: 'app-warranty',
  templateUrl: './warranty.component.html',
  styleUrls: ['./warranty.component.css']
})
export class WarrantyComponent implements OnInit {
  @ViewChild(PoModalComponent, { static: true })
  poModal!: PoModalComponent;
  quickSearchWidth: number = 3;
  detailedChamado: Array<any> = []

  serviceApi =  environment.api + `EnvChamdo/?cod_cliente=${localStorage.getItem('cod_cliente')}&loja_cliente=${localStorage.getItem('loja_cliente')}`;

  public readonly actions: Array<PoPageAction> = [
    { label: 'Incluir Chamado', url: '/FORMULARIO', icon: 'po-icon po-icon-cart' },
  ];
  public readonly breadcrumb: PoBreadcrumb = {
    items: [{ label: 'Home', link: '/' }, { label: 'Garantia' }]
  };

  constructor(public http: HttpClient) { }

  onLoad(): PoPageDynamicTableOptions {
    return {
      fields: [
        { property: 'chamado', label: 'Chamado', gridLgColumns: 6 , filter: true},
        { property: 'nota', label: 'Nota', gridLgColumns: 4 , filter: true},
        { property: 'item', label: 'Item', gridLgColumns: 4, filter: true },
        { property: 'emissao', label: 'Emissão', gridLgColumns: 4, filter: true },
        { property: 'produto', label: 'Produto', gridLgColumns: 4, filter: true },
        { property: 'descricao', label: 'Descrição', gridLgColumns: 20, filter: true },
        { property: 'quantidade', label: 'Quantidade', gridLgColumns: 4 , filter: true},
        { property: 'preco', label: 'Valor', gridLgColumns: 4, filter: true },
        { property: 'defeito', label: 'Defeito', gridLgColumns: 4, filter: true },
        { property: 'tipodefeito', label: 'Tipo Defeito', gridLgColumns: 4, filter: true },
        { property: 'status', type: 'label', labels:[
          { value: '2', color: 'color-11', label: 'Atendido' },
          { value: '1', color: 'color-08', label: 'Em Aberto' },
          { value: '3', color: 'color-07', label: 'Negado' },
        ], gridLgColumns: 4, filter: true },
      ]
    };
  }

  ngOnInit(): void {
    this.getChamadosAbertos()
  } 
  modalOpen() {
    this.poModal.open();
  }


  getChamadosAbertos(){
    let url = environment.api + `EnvChamdo/?cod_cliente=${localStorage.getItem('cod_cliente')}&loja_cliente=${localStorage.getItem('loja_cliente')}`
    let items: any = []
    
    this.http.get(url).subscribe((response: any) =>{
      response['items'].forEach((element: any) =>{
        items.push({
          chamado: element.chamado,
          nota: element.nota,
          produto: element.produto,
        })
      })

      const setChamado = items.length > 0 ? JSON.stringify(items) : JSON.stringify([])
      localStorage.setItem('chamados', setChamado)

    })
  }

}
