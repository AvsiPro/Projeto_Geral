import { Component, OnInit, ViewChild } from '@angular/core';
import { environment } from 'src/environments/environment';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { PoBreadcrumb, PoDynamicViewField, PoModalComponent, PoNotificationService, PoPageAction } from '@po-ui/ng-components';

import { PoPageDynamicTableCustomTableAction, PoPageDynamicTableOptions } from '@po-ui/ng-templates';
import { DomSanitizer } from '@angular/platform-browser';


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

  private headers: HttpHeaders | undefined;

  obscliente: string = '';
  obsatendente: string | undefined;

  fields: Array<PoDynamicViewField> = [
    { property: 'chamado', label: 'Chamado', gridLgColumns: 6 },
    { property: 'nota', label: 'Nota', gridLgColumns: 4 },
    { property: 'item', label: 'Item', gridLgColumns: 4 },
    { property: 'emissao', label: 'Emissão', gridLgColumns: 4 },
    { property: 'produto', label: 'Produto', gridLgColumns: 4 },
    { property: 'descricao', label: 'Descrição', gridLgColumns: 20 },
    { property: 'quantidade', label: 'Quantidade', gridLgColumns: 4 },
    { property: 'preco', label: 'Valor', gridLgColumns: 4 },
    { property: 'defeito', label: 'Defeito', gridLgColumns: 4 },
    { property: 'tipodefeito', label: 'Tipo Defeito', gridLgColumns: 4 },
    { property: 'rastreio', label: 'Num. Rastreamento', gridLgColumns: 4 }
  ];

  tableCustomActions: Array<PoPageDynamicTableCustomTableAction> = [
    {
      label: 'Detalhes',
      action: this.onClickUserDetail.bind(this),
      icon: 'po-icon-user'
    }
  ];

  constructor(public http: HttpClient,private poNotification: PoNotificationService,private sant:DomSanitizer,) { }

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

  employee: any = ''

  ngOnInit(): void {
    this.getChamadosAbertos()
  } 

  private onClickUserDetail(event: any) {

    this.employee = { 
      chamado:event.chamado,
      nota:event.nota,
      item:event.item,
      emissao:event.emissao,
      produto:event.produto,
      descricao:event.descricao,
      quantidade:event.quantidade,
      defeito:event.defeito,
      tipodefeito:event.tipodefeito,
      preco:event.preco      
    }
    this.obsatendente = event.obsatend.trim()
    this.poModal.open();
  }


  interageCliente(){

    if(!!this.obscliente){
      let body: any;
      const url_login = environment.api + 'UpdChamdo';
  
      this.headers = new HttpHeaders({
        Authorization: 'Basic UjJhbHJFZDRoQWh1MmZSMFRPQnVCTlpxdFM0YTpsUDBUYktKUDdmQ245WGJDUktkM2pYZDFYRW9hIA' });
  
      body = {
        USUARIO : localStorage.getItem('user'), 
        TEXT : this.obscliente,
        NOTA : this.employee.nota,
        CLIENTE : localStorage.getItem('cod_cliente'),
        LOJA : localStorage.getItem('loja_cliente'),
        EMISSAO : this.employee.emissao,
        PRODUTO : this.employee.produto
      };
  
      this.http.post(url_login, body, {headers: this.headers}).subscribe((res: any) => {
        const result: any = res['statusrequest'];
  
        if (result[0].code == '#200') {
          this.poNotification.success(result[0].message);
          this.poModal.close()
          window.location.reload();
  
        } else{
          this.poNotification.error(result[0].message);
        }
      }, (error) => {
        if (error.hasOwnProperty('message')){
          this.poNotification.error('Falha na comunicaçao com servidor');
        }
      });
      
    } else{
      this.poNotification.error('Necessário preencher interação!')
    }

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


  
  base64: string = ''
  fileSelected?:Blob;
  imageUrl?: string
  imagesConv: any = []

  inputImg: String = ''

  onSelectNewFile(files: FileList):void{

    var filesStr = "";

    console.log(files)

    for (let i = 0; i < files.length; i++){
      filesStr += '<li>' + files[i].name + ' </li> '

      this.fileSelected = files[i]
      this.imageUrl = this.sant.bypassSecurityTrustUrl(window.URL.createObjectURL(this.fileSelected)) as string

      if(!!this.imageUrl){
        let reader = new FileReader();
        reader.readAsDataURL(this.fileSelected as Blob)
        reader.onloadend=()=>{
          this.base64 = reader.result as string
          this.imagesConv.push({image: this.base64, name: files[i].name})
        }
      }
    }
    this.inputImg += filesStr;
  }

  clearImg(){
    this.imagesConv = []
    this.inputImg = ''
    this.imageUrl = ''
    this.base64 = ''
  }

  fGrvImage(chamado: string){

    this.imagesConv.map((event: any, index: number) =>{
      let body: any;
    
      const url_login = environment.api + 'PRTL046';
  
      this.headers = new HttpHeaders({
        Authorization: 'Basic UjJhbHJFZDRoQWh1MmZSMFRPQnVCTlpxdFM0YTpsUDBUYktKUDdmQ245WGJDUktkM2pYZDFYRW9hIA' });
  
      body = {IMAGE : event.image, NIMAGE: event.name, CHAMADO: chamado};
  
      this.http.post(url_login, body, {headers: this.headers}).subscribe((res: any) => {
        const result: any = res['statusrequest'];
  
        if (result[0].code == '#200') {
          this.poNotification.success(result[0].message)
          this.imagesConv = []
          this.inputImg = ''
  
        } else{
          this.poNotification.error('Nao enviou a imagem #500');
        }
      }, (error) => {
        if (error.hasOwnProperty('message')){
          this.poNotification.error('Falha na comunicaçao com servidor');
        }
      });
    })

  }


}
