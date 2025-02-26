import React from 'react';
import ReactApexChart from 'react-apexcharts';

interface ChartProps {
  options: any;
  series: any;
  height?: any
}

const ChartColumn: React.FC<ChartProps> = ({ options, series, height = '100%' }) => {
  return <ReactApexChart options={options} series={series} type="bar" height={height}  />;
};

export default ChartColumn;
