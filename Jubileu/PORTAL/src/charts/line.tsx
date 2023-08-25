import React from 'react';
import ReactApexChart from 'react-apexcharts';

interface ChartProps {
  options: any;
  series: any;
  width?: any;
  height?: any;
}

const ChartLine: React.FC<ChartProps> = ({ options, series, width = '100%', height = '100%' }) => {
  return <ReactApexChart options={options} series={series} type="line" width={width} height={height} />;
};

export default ChartLine;
