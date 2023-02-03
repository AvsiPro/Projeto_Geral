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
  detailedProduto: Array<any> = []
  notifyNumber: string = '0'

  @ViewChild('userDetailProduto') userDetailProduto: PoModalComponent | undefined;


  readonly detailFields: Array<PoDynamicViewField> = [
    { property: 'item'},
    { property: 'cod_produto'},
    { property: 'preco'},
    { property: 'nota'},
    { property: 'quantidade'},
    { property: 'emissao'},
    { property: 'bairro_empresa', divider: 'Dados da empresa'},
    { property: 'nome_empresa', gridColumns: 6},
    { property: 'cnpj'},
    { property: 'endereco_empresa', gridColumns: 8},
    { property: 'cidade_empresa'},
    { property: 'estado_empresa'},
    { property: 'inscr_estadual'},
    { property: 'base_icm', divider: 'Detalhes '},
    { property: 'chave_nfe', gridColumns: 12},
    { property: 'desc_cfop', gridColumns: 12},
    { property: 'filial_faturamento'},
    { property: 'serie'},
    { property: 'valor_icm'},
    { property: 'valor_ipi'},
];

  serviceApi =  environment.api + `EnvChamdo/?cod_cliente=${localStorage.getItem('cod_cliente')}&loja_cliente=${localStorage.getItem('loja_cliente')}`;

  public readonly actions: Array<PoPageAction> = [
    { label: 'Incluir Chamado', url: '/FORMULARIO', icon: 'po-icon po-icon-plus' }
  ];
  public readonly breadcrumb: PoBreadcrumb = {
    items: [{ label: 'Home', link: '/' }, { label: 'Garantia' }]
  };

  private headers: HttpHeaders | undefined;

  obscliente: string = '';
  obsatendente: string | undefined;
  numChamado: string = ''

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
      label: 'Detalhes Chamado',
      action: this.onClickUserDetail.bind(this),
      icon: 'po-icon-user'
    },
    {
      label: 'Espelho da Nota',
      action: this.onClickProdutoDetail.bind(this),
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
          { value: '2', color: 'color-02', label: 'Atendido' },
          { value: '1', color: 'color-08', label: 'Em Aberto' },
          { value: '3', color: 'color-07', label: 'Negado' },
          { value: '4', color: 'color-11', label: 'Finalizado' },
        ], gridLgColumns: 4, filter: true },
      ]
    };
  }

  employee: any = ''

  ngOnInit(): void {
    this.getChamadosAbertos()
  } 


  onClickUserDetail(event: any) {
    
    this.numChamado = event.chamado
    this.loadNotify(event.chamado, 'visualiza')

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


  onClicknotiFy() {
    
    let chamadoLocal = JSON.parse(localStorage.getItem('chamados') as string)

    this.numChamado = chamadoLocal[0].chamado
    this.loadNotify(chamadoLocal[0].chamado, 'visualiza')

    this.employee = { 
      chamado:chamadoLocal[0].chamado,
      nota:chamadoLocal[0].nota,
      item:chamadoLocal[0].item,
      emissao:chamadoLocal[0].emissao,
      produto:chamadoLocal[0].produto,
      descricao:chamadoLocal[0].descricao,
      quantidade:chamadoLocal[0].quantidade,
      defeito:chamadoLocal[0].defeito,
      tipodefeito:chamadoLocal[0].tipodefeito,
      preco:chamadoLocal[0].preco      
    }
    this.obsatendente = chamadoLocal[0].obsatend.trim()
    this.poModal.open();
  }


  private onClickProdutoDetail(user: any) {
    let url = environment.api + `FieldService/?nota=${user['nota']}&codigo=${user['produto']}&cod_cliente=${localStorage.getItem('cod_cliente')}&loja_cliente=${localStorage.getItem('loja_cliente')}`
    
      this.http.get(url).subscribe((res: any)=>{
      this.detailedProduto = res['items'][0]
      this.userDetailProduto!.open();
    })

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
          
          this.fGrvImage(this.numChamado)
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


  loadNotify(chamado: string, tpGet: string){  

      const url_login = environment.api + 'chamadoNotific';
  
      this.headers = new HttpHeaders({
        Authorization: 'Basic UjJhbHJFZDRoQWh1MmZSMFRPQnVCTlpxdFM0YTpsUDBUYktKUDdmQ245WGJDUktkM2pYZDFYRW9hIA' });
  
      this.http.post(url_login, {CHAMADO : chamado, TPGET : tpGet}, {headers: this.headers}).subscribe((res: any) => {
        const result: any = res['statusrequest'];
  
        if (result[0].code == '#200') {

          if(result[0].message === 'atualizou'){
            this.notifyNumber = '1'
          }else{
            this.notifyNumber = '0'
          }
          
        } else{
          console.log(result[0].message);
        }
      }, (error) => {
        if (error.hasOwnProperty('message')){
          console.log('Falha na comunicaçao com servidor');
        }
      });

  }

  getChamadosAbertos(){
    let url = environment.api + `EnvChamdo/?cod_cliente=${localStorage.getItem('cod_cliente')}&loja_cliente=${localStorage.getItem('loja_cliente')}`
    let items: any = []
    
    this.http.get(url).subscribe((response: any) =>{
      response['items'].forEach((element: any) =>{
        this.loadNotify(element.chamado, 'busca')

        items.push({
          chamado:element.chamado,
          nota:element.nota,
          item:element.item,
          emissao:element.emissao,
          produto:element.produto,
          descricao:element.descricao,
          quantidade:element.quantidade,
          defeito:element.defeito,
          tipodefeito:element.tipodefeito,
          preco:element.preco,
          obsatend:element.obsatend
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
