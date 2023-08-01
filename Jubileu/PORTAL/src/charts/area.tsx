import React from 'react';
import ReactApexChart from 'react-apexcharts';

interface ChartProps {
  options: any;
  series: any;
}

const ChartArea: React.FC<ChartProps> = ({ options, series }) => {
  return <ReactApexChart options={options} series={series} type="area" width={1000} height={150}/>;
};

export default ChartArea;
