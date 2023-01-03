import { FaturamentoService } from './faturamento.service';
import { environment } from 'src/environments/environment';
import { Component, OnInit, ViewChild } from '@angular/core';
import {  PoPageDynamicTableCustomTableAction, PoPageDynamicTableOptions } from '@po-ui/ng-templates';
import { PoBreadcrumb, PoModalComponent } from '@po-ui/ng-components';


@Component({
  selector: 'app-faturamento',
  templateUrl: './faturamento.component.html',
  styleUrls: ['./faturamento.component.scss']
})
export class FaturamentoComponent implements OnInit {
  @ViewChild('userDetailModal')
  userDetailModal!: PoModalComponent;

  serviceApi = environment.api + `Faturamento/?VENDEDOR=${localStorage.getItem('cod_vendedor')}?CODIGO=${localStorage.getItem('cod_cliente')}`;
  quickSearchWidth: number = 3;
  rastro: String | any;


  readonly breadcrumb: PoBreadcrumb = {
    items: [{ label: 'Home', link: '/' }, { label: 'Faturamento'}]
  };

  tableCustomActions: Array<PoPageDynamicTableCustomTableAction> = [];

  constructor( public faturamentoServices: FaturamentoService) {}

  ngOnInit(): void {

    this.tableCustomActions.push(
      {
        label: 'Danfe',
        icon: 'po-icon po-icon-sale',
        action: this.onClickUploadDanfe.bind(this),
      },
      {
        label: 'Xml',
        icon: 'po-icon po-icon-xml',
        action: this.onClickUploadXml.bind(this),
      },
      {
        label: 'Rastrear',
        action: this.onClickUserDetail.bind(this),
        icon: 'po-icon po-icon po-icon-truck'
      }
    )
  
  }

onLoad(): PoPageDynamicTableOptions {
  return {
    fields: [
      { property: 'filial', label: 'Filial', gridLgColumns: 4 , filter: true},
      { property: 'documento', label: 'Documento', gridLgColumns: 4, filter: true },
      { property: 'serie', label: 'Serie', gridLgColumns: 4, filter: true },
      { property: 'emissao', label: 'Emissão', gridLgColumns: 4, filter: true },
      { property: 'cliente', label: 'Cliente', gridLgColumns: 12 , filter: true},
      { property: 'valor', label: 'Valor', gridLgColumns: 4, filter: true },
      { property: 'etiqueta', allowColumnsManager: true, label: 'Etiqueta', gridLgColumns: 4, filter: true },
    ]
  };
}

  printPage() {
    window.print();
  }

  isUserInactive(person: { status: string; }) {
    return person.status === 'inactive';
  }

  private onClickUploadDanfe(user: { [x: string]: any; }){
    const exportFileDefaultName = user.danfe;
    const linkElement = document.createElement('a');
    linkElement.setAttribute('href', user.danfe);
    linkElement.setAttribute('download', exportFileDefaultName);
    linkElement.setAttribute('target', '_blank');
    linkElement.click();
  }
  private onClickUploadXml(user: { [x: string]: any; }){
    const exportFileDefaultName = user.xml;
    const linkElement = document.createElement('a');
    linkElement.setAttribute('href', user.xml);
    linkElement.setAttribute('download', exportFileDefaultName);
    linkElement.setAttribute('target', '_blank');
    linkElement.click();
  }
  private onClickUserDetail(user: { [x: string]: any; }) {
    this.rastro = user.rastro
    this.userDetailModal.open()
  }

}
