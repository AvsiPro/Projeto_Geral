import React from 'react';
import ReactApexChart from 'react-apexcharts';

interface ChartProps {
  options: any;
  series: any;
  width?: any;
  height?: any;
}

const ChartPie: React.FC<ChartProps> = ({ options, series, width = '100%', height = '100%' }) => {
  return <ReactApexChart options={options} series={series} type="donut" width={width} height={height} />;
};

export default ChartPie;
