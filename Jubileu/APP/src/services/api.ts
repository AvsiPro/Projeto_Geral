import axios from 'axios';

const api = axios.create({
    baseURL: 'http://jubileudistribuidora119027.protheus.cloudtotvs.com.br:4050/rest'
});

export default api;