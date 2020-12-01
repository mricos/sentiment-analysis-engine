import axios from "axios";
import os from "os";
const networkInterfaces = os.networkInterfaces();

const IP = networkInterfaces["eth0"][0].address
const { PORT } = process.env

const baseUrlHandler = axios.create(
    {
	    baseURL: `http://${IP}:${PORT}/api/nlp`
    }
);

export default baseUrlHandler; 
