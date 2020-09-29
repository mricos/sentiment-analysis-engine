import axios from "axios";

const {IP, PORT} = process.env

const baseUrlHandler = axios.create({baseURL: `${IP}:${PORT}/api/nlp`});

export default baseUrlHandler; 
