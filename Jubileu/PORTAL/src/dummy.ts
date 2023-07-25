//Dash Modelo
export const optionArea = (themeContext: any) => {
    return (
      {
        chart: {
          foreColor: themeContext.text,
          toolbar: {
            show: false
          },
          sparkline: {
            enabled: true,
          }
        },
        dataLabels: {
          enabled: false,
        },
        stroke: {
          curve: "smooth",
        },
        xaxis: {
          type: "numeric",
          categories: [1,2,3,4,5,6,7,8,],
        }
    }
  )
};

export const seriesArea = [
  {
    name: "series",
    data: [13, 26, 20, 33, 21, 40, 35, 45],
  },
]


export const optionColumn = (themeContext: any) => {
  return( 
    {
      chart: {
        type: 'bar',
        foreColor: themeContext.text,
      },
      plotOptions: {
        bar: {
          horizontal: false,
          columnWidth: '55%',
          endingShape: 'rounded'
        },
      },
      dataLabels: {
        enabled: false
      },
      stroke: {
        show: true,
        width: 2,
        colors: ['transparent']
      },
      xaxis: {
        categories: ['Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'],
      },
      yaxis: {
        title: {
          text: '$ (thousands)'
        }
      },
      fill: {
        opacity: 1
      }
    }
  )
}

export const seriesColumn = [{
  name: 'Net Profit',
  data: [44, 55, 57, 56, 61, 58, 63, 60, 66]
}, {
  name: 'Revenue',
  data: [76, 85, 101, 98, 87, 105, 91, 114, 94]
}, {
  name: 'Free Cash Flow',
  data: [35, 41, 36, 26, 45, 48, 52, 53, 41]
}]

export const optionPie = (themeContext: any) => {
  return (
    {
      chart: {
        type: 'donut',
        foreColor: themeContext.text,
      },
      stroke:{
        show:false,
      },
      labels: ["Tng", "Ultra", "Cambridge", "HB", "MX", "Acuvue", "Feel", "Multico", "Varilux", "Speedo", "OptisWiss"],
      colors: ['#0d6efd', '#6f42c1', '#d63384', '#dc3545', '#fd7e14', '#ffc107', '#198754', '#20c997', '#6610f2', '#0dcaf0', '#6c757d'],
      responsive: [{
        breakpoint: 480,
        options: {
          chart: {
            width: 200
          },
          legend: {
            position: 'bottom'
          }
        }
      }]
    }
  )
}

export const seriesPie = [ 8.10, 21.02, 4.25, 3.24, 2.39, 2.32, 2.20, 1.99, 1.90, 1.62, 31.47 ]


export const optionBubble1 = (themeContext: any) => {
  return (
    {
      chart: {
          height: 350,
          type: 'bubble',
          foreColor: themeContext.text,
      },
      dataLabels: {
          enabled: false
      },
      fill: {
          opacity: 0.8
      },

      xaxis: {
          tickAmount: 12,
          type: 'category',
      },
      yaxis: {
          max: 2000
      }
    }
  )
}

export const seriesBubble1 = [
  {
    name: 'Captador',
    data: [{ x: 30, y: 400, z: 20}]
  },
  {
    name: 'Carro de Som',
    data: [{ x: 20, y: 500, z: 20}]
  },
];


export const optionBar1 = (themeContext: any) => {
  return(
    {
      chart: {
        type: 'bar',
        height: 350,
        foreColor: themeContext.text,
      },
      plotOptions: {
        bar: {
          borderRadius: 4,
          horizontal: true,
        }
      },
      dataLabels: {
        enabled: true,
        offsetX: 10,
        style: {
          fontSize: '12px',
          colors: [themeContext.text]
        },
        formatter: (val: any) => {
          return (val + ' M')
        },
      },
      xaxis: {
        categories: ['Lente Oftalmica', 'Oculos Rx', 'Oculos Sol', 'Lente Contato', 'Acessorios'],
      }
    }
  )
}

export const seriesBar1 = [{
  data: [0.35, 0.15, 0.03, 0.02, 0.01]
}]


export const header = [
  {
    "title": "Vlr. Total Vendas",
    "type": "number",
    "value": 560590
  },
  {
    "title": "Vlr. Ticket Medio",
    "type": "number",
    "value": 807.77
  },
  {
    "title": "Num. Vendas",
    "type": "",
    "value": 694
  }
]


export const optionArea1 = (themeContext: any) => {
  return (
    {
      chart: {
        height: 350,
        type: 'area',
        foreColor: themeContext.text,
      },
      dataLabels: {
        enabled: true,
        formatter: (val: any) => {
          return (val + ' K')
        }
      },
      stroke: {
        curve: 'straight'
      },
    }
)
};

export const seriesArea1 = [
{
  name: "series",
  data: [20, 38, 58, 40, 30, 35, 10, 56, 42, 40, 23, 26, 60],
},
]

export const fields1 = [
  {field: 'filial', headerText: 'Filial', textAlign: 'Center', width: '100px'   },
  {field: 'vlrVendas', headerText: 'Vlr. Vendas', textAlign: 'Center', width: '100px'},
  {field: 'percTotal', headerText: '% Total', textAlign: 'Center', width: '100px'  },
  {field: 'numVendas', headerText: 'Num. Vendas', textAlign: 'Center', width: '100px'  },
  {field: 'vlrTicket', headerText: 'Vlr. Ticket Medio', textAlign: 'Center', width: '100px' },
]

export const dataTable1 = [
  {
    filial: 'Caieiras',
    vlrVendas: 115591,
    percTotal: 20.6,
    numVendas: 131,
    vlrTicket: 882.38
  },
]

export const fields2 = [
  {field: 'pos', headerText: 'Pos.', textAlign: 'Center'   },
  {field: 'product', headerText: 'Produto', textAlign: 'Center', width: '100px'},
  {field: 'upc', headerText: 'UPC', textAlign: 'Center', width: '80px'  },
  {field: 'description', headerText: 'Descricao', textAlign: 'Left', width: '250px'  },
  {field: 'numVendas', headerText: 'Num. Vendas', textAlign: 'Center', width: '80px' },
  {field: 'quant', headerText: 'Quant.', textAlign: 'Center', width: '80px' },
  {field: 'vlrVendas', headerText: 'Vlr. Vendas', textAlign: 'Center', width: '100px' },
]

export const dataTable2 = [
  {
    pos: 1,
    product: '3000002',
    upc: '',
    description: 'LIMPA LENTES D+ CLEAN 28ML',
    numVendas: 216,
    quant: 231,
    vlrVendas: 5327
  },
]