import { CurrencyFormat } from "./utils/currencyFormat";

//Dash Modelo
export const optionArea = (themeContext: any) => {
  return {
    chart: {
      foreColor: themeContext.text,
      toolbar: {
        show: false,
      },
      sparkline: {
        enabled: true,
      },
    },
    dataLabels: {
      enabled: false,
    },
    stroke: {
      curve: "smooth",
    },
    xaxis: {
      type: "numeric",
      categories: [1, 2, 3, 4, 5, 6, 7, 8],
    },
  };
};

export const seriesArea = [
  {
    name: "series",
    data: [13, 26, 20, 33, 21, 40, 35, 45],
  },
];

export const optionColumn = (themeContext: any) => {
  return {
    chart: {
      type: "bar",
      foreColor: themeContext.text,
    },
    plotOptions: {
      bar: {
        horizontal: false,
        columnWidth: "55%",
        endingShape: "rounded",
      },
    },
    dataLabels: {
      enabled: false,
    },
    stroke: {
      show: true,
      width: 2,
      colors: ["transparent"],
    },
    xaxis: {
      categories: [
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
      ],
    },
    yaxis: {
      title: {
        text: "$ (thousands)",
      },
    },
    fill: {
      opacity: 1,
    },
  };
};

export const seriesColumn = [
  {
    name: "Net Profit",
    data: [44, 55, 57, 56, 61, 58, 63, 60, 66],
  },
  {
    name: "Revenue",
    data: [76, 85, 101, 98, 87, 105, 91, 114, 94],
  },
  {
    name: "Free Cash Flow",
    data: [35, 41, 36, 26, 45, 48, 52, 53, 41],
  },
];

export const optionPie = (themeContext: any, labels: any) => {
  return {
    chart: {
      type: "donut",
      foreColor: themeContext.text,
    },
    stroke: {
      show: false,
    },
    //labels: ["Tng", "Ultra", "Cambridge", "HB", "MX", "Acuvue", "Feel", "Multico", "Varilux", "Speedo", "OptisWiss"],
    //colors: ['#0d6efd', '#6f42c1', '#d63384', '#dc3545', '#fd7e14', '#ffc107', '#198754', '#20c997', '#6610f2', '#0dcaf0', '#6c757d'],
    labels: labels,
    colors: ["#0d6efd", "#6f42c1", "#d63384", "#dc3545", "#fd7e14", "#ffc107"],
    responsive: [
      {
        breakpoint: 480,
        options: {
          chart: {
            width: 200,
          },
          legend: {
            position: "bottom",
          },
        },
      },
    ],
  };
};

export const seriesPie = [
  8.1, 21.02, 4.25, 3.24, 2.39, 2.32, 2.2, 1.99, 1.9, 1.62, 31.47,
];

export const optionBubble1 = (themeContext: any) => {
  return {
    chart: {
      height: 350,
      type: "bubble",
      foreColor: themeContext.text,
    },
    dataLabels: {
      enabled: false,
    },
    fill: {
      opacity: 0.8,
    },

    xaxis: {
      tickAmount: 12,
      type: "category",
    },
    yaxis: {
      max: 2000,
    },
  };
};

export const seriesBubble1 = [
  {
    name: "Captador",
    data: [{ x: 30, y: 400, z: 20 }],
  },
  {
    name: "Carro de Som",
    data: [{ x: 20, y: 500, z: 20 }],
  },
];

export const optionBar1 = (themeContext: any, labelcat: any) => {
  return {
    chart: {
      type: "bar",
      height: 350,
      foreColor: themeContext.text,
    },
    plotOptions: {
      bar: {
        borderRadius: 4,
        horizontal: true,
      },
    },
    dataLabels: {
      enabled: true,
      offsetX: 10,
      style: {
        fontSize: "12px",
        colors: [themeContext.text],
      },
      formatter: (val: any) => {
        return val + " K";
      },
    },
    xaxis: {
      categories: labelcat,
    },
  };
};

export const seriesBar1 = [
  {
    data: [0.35, 0.15, 0.03, 0.02, 0.01, 0.05],
  },
];

export const header = [
  {
    title: "Vlr. Total Vendas",
    type: "number",
    value: 560590,
  },
  {
    title: "Vlr. Ticket Medio",
    type: "number",
    value: 807.77,
  },
  {
    title: "Num. Vendas",
    type: "",
    value: 694,
  },
];

export const optionArea1 = (themeContext: any) => {
  return {
    chart: {
      height: 350,
      type: "area",
      foreColor: themeContext.text,
    },
    dataLabels: {
      enabled: true,
      formatter: (val: any) => {
        return val + " K";
      },
    },
    stroke: {
      curve: "straight",
    },
  };
};

export const seriesArea1 = [
  {
    name: "series",
    data: [20, 38, 58, 40, 30, 35, 10, 56, 42, 40, 23, 26, 60],
  },
];

export const fields1 = [
  {
    field: "codigo_cliente",
    headerText: "Codigo",
    textAlign: "Center",
    width: "50px",
  },
  { field: "loja", headerText: "Loja", textAlign: "Center", width: "50px" },
  {
    field: "razao",
    headerText: "Razão Social",
    textAlign: "Center",
    width: "180px",
  },
  {
    field: "valorVendas",
    headerText: "Valor Vendas",
    textAlign: "Center",
    width: "120px",
  },
  {
    field: "vlrTicket",
    headerText: "Vlr. Ticket Medio",
    textAlign: "Center",
    width: "150px",
  },
];

export const dataTable1 = [
  {
    codigo_cliente: "Caieiras",
    loja: 115591,
    razao: 20.6,
    valorVendas: 131,
    vlrTicket: 882.38,
  },
];

export const fields2 = [
  { field: "ranking", headerText: "Pos.", textAlign: "Center", width: "50px" },
  {
    field: "product",
    headerText: "Produto",
    textAlign: "Center",
    width: "150px",
  },
  {
    field: "description",
    headerText: "Descricao",
    textAlign: "Left",
    width: "250px",
  },
  {
    field: "numVendas",
    headerText: "Num. Vendas",
    textAlign: "Center",
    width: "80px",
  },
  { field: "quant", headerText: "Quant.", textAlign: "Center", width: "80px" },
  {
    field: "vlrVendas",
    headerText: "Vlr. Vendas",
    textAlign: "Center",
    width: "100px",
  },
];

export const dataTable2 = [
  {
    ranking: 1,
    product: "3000002",
    description: "LIMPA LENTES D+ CLEAN 28ML",
    numVendas: 216,
    quant: 231,
    vlrVendas: 5327,
  },
];


/*
export const optionColumn2 = (themeContext: any, nomes: any) => {
  return {
    chart: {
      type: "bar",
      height: 350,
      stacked: true,
      foreColor: themeContext.text,
    },

    dataLabels: {
      formatter: (val: any) => {
        return CurrencyFormat(val)
      },
      offsetX: 30,
      enabled: true,
      style: {
        colors: [
          themeContext.text,
        ]
      }
    },
    plotOptions: {
      bar: {
        horizontal: true,
        dataLabels: {
          position: 'top',
        },
      },
    },
    xaxis: {
      categories: nomes,
    },
    fill: {
      opacity: 1,
    },
    colors: ["#00E396", "#008FFB"],
    yaxis: {
      labels: {
        
        formatter: (val: any) => {
          return CurrencyFormat(val)
        },
      },
    },
    tooltip: {
      shared: true,
      intersect: false
    },
    legend: {
      position: "top",
      horizontalAlign: "left",
      
    },
  };
};
*/

export const optionColumn2 = (themeContext: any, nomes: any) => {
  return(
    {
      chart: {
        type: 'bar',
        height: 430,
        foreColor: themeContext.text,
      },
      plotOptions: {
        bar: {
          horizontal: true,
          dataLabels: {
            position: 'top',
          },
        }
      },
      dataLabels: {
        enabled: true,
        formatter: (val: any) => {
          return val > 0 ?CurrencyFormat(val) : ''
        },
        
        offsetX: 60,
        style: {
          fontSize: '10px',
          colors: [themeContext.text]
        },
      },
      colors: ["#00E396", "#008FFB"],
      tooltip: {
        formatter: (val: any) => {
          return CurrencyFormat(val)
        },
      },
      xaxis: {
        categories: nomes,
        labels: {
          
          formatter: (val: any) => {
            return CurrencyFormat(val)
          },
        },
      },
    }
  )
}

export const lineSeries = [
  {
    name: "a Pagar",
    data: [28, 29, 33, 35, 32],
  },
  {
    name: "Receber",
    data: [12, 11, 14, 18, 17],
  },
];

export const lineOptions = (themeContext: any) => {
  return {
    chart: {
      height: 350,
      type: "line",
      dropShadow: {
        enabled: true,
        color: "#000",
        top: 18,
        left: 7,
        blur: 10,
        opacity: 0.2,
      },
      toolbar: {
        show: false,
      },
      foreColor: themeContext.text,
    },
    colors: ["#77B6EA", "#545454"],
    dataLabels: {
      enabled: true,
    },
    stroke: {
      curve: "smooth",
    },
    title: {
      text: "Semanal",
      align: "left",
    },
    grid: {
      borderColor: "#e7e7e7",
      row: {
        colors: ["transparent"], // takes an array which will be repeated on columns
        opacity: 0.5,
      },
    },
    markers: {
      size: 1,
    },
    xaxis: {
      categories: ["Segunda", "Terça", "Quarta", "Quinta", "Sexta"],
      title: {
        text: "Semana",
      },
    },
    yaxis: {
      title: {
        text: "",
      },
      min: 5,
      max: 35,
    },
    legend: {
      position: "top",
      horizontalAlign: "right",
      floating: true,
      offsetY: -25,
      offsetX: -5,
    },
  };
};

export const pieSeries = [10, 15, 30, 35, 10];

export const pieOptions = (themeContext: any) => {
  return {
    chart: {
      type: "donut",
      foreColor: themeContext.text,
    },
    labels: ["SP", "MG", "ES", "DF", "RJ"],
    responsive: [
      {
        breakpoint: 480,
        options: {
          chart: {
            width: 200,
          },
          legend: {
            position: "bottom",
          },
        },
      },
    ],
  };
};

export const pieSeries2 = [15, 25, 10, 50];

export const pieOptions2 = (themeContext: any) => {
  return {
    chart: {
      type: "donut",
      foreColor: themeContext.text,
    },
    labels: ["Pontual", "Atrasado", "Adiantados", "Acordos"],
    responsive: [
      {
        breakpoint: 480,
        options: {
          chart: {
            width: 200,
          },
          legend: {
            position: "bottom",
          },
        },
      },
    ],
  };
};




export const dataColumn2 = [
  {
    name: "Diário",
    group: "budget",
    data: [44000, 55000, 41000, 67000],
  },
  {
    name: "Semanal",
    group: "actual",
    data: [48000, 50000, 40000, 65000],
  },
];

export const optionColumn3 = (themeContext: any) => {
  return {
    chart: {
      type: "bar",
      height: 350,
      stacked: true,
      foreColor: themeContext.text,
    },
    stroke: {
      width: 1,
      colors: ["#fff"],
    },
    dataLabels: {
      formatter: (val: any) => {
        return val / 1000 + "K";
      },
    },
    plotOptions: {
      bar: {
        horizontal: false,
      },
    },
    xaxis: {
      categories: ["Vencidos", "Pix Vencidos", "Pontual", "Adiantado"],
    },
    fill: {
      opacity: 1,
    },
    colors: ["#80c7fd", "#008FFB"],
    yaxis: {
      labels: {
        formatter: (val: any) => {
          return val / 1000 + "K";
        },
      },
    },
    legend: {
      position: "top",
      horizontalAlign: "left",
    },
  };
};
