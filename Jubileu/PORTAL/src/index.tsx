import { createRoot } from 'react-dom/client';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';

const rootElement: any = document.getElementById('root');
createRoot(rootElement).render(<App />);
reportWebVitals();
