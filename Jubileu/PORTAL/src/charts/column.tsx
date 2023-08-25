import React from 'react';
import ReactApexChart from 'react-apexcharts';

interface ChartProps {
  options: any;
  series: any;
}

const ChartColumn: React.FC<ChartProps> = ({ options, series }) => {
  return <ReactApexChart options={options} series={series} type="bar" height={'100%'}  />;
};

export default ChartColumn;
