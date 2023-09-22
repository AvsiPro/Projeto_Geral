import axios from 'axios';

export const apiLink = 'http://jubileudistribuidora119026.protheus.cloudtotvs.com.br:4050/rest'
export const apiLinkTst = 'http://jubileudistribuidora119027.protheus.cloudtotvs.com.br:4050/rest'

export const apiTst = axios.create({
    baseURL: apiLinkTst
});

const api = axios.create({
    baseURL: apiLink
});

export default api;