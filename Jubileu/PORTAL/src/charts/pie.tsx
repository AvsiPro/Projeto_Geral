import React from 'react';
import ReactApexChart from 'react-apexcharts';

interface ChartProps {
  options: any;
  series: any;
}

const ChartPie: React.FC<ChartProps> = ({ options, series }) => {
  return <ReactApexChart options={options} series={series} type="donut" />;
};

export default ChartPie;
