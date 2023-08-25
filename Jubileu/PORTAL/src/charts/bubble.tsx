import React from 'react';
import ReactApexChart from 'react-apexcharts';

interface ChartProps {
  options: any;
  series: any;
  width?: any;
}

const ChartBubble: React.FC<ChartProps> = ({ options, series, width = '100%' }) => {
  return <ReactApexChart options={options} series={series} type="bubble" width={width} />;
};

export default ChartBubble;
