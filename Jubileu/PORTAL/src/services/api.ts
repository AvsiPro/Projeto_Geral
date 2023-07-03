import axios from 'axios';

export const apiLink = 'http://jubileudistribuidora119027.protheus.cloudtotvs.com.br:4050/rest'

const api = axios.create({
    baseURL: apiLink
});

export default api;