import React from 'react';
import ReactApexChart from 'react-apexcharts';

interface ChartProps {
  options: any;
  series: any;
}

const ChartBar: React.FC<ChartProps> = ({ options, series }) => {
  return <ReactApexChart options={options} series={series} type="bar" />;
};

export default ChartBar;
