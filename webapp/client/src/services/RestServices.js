import axios from 'axios';
let dev = true;

let serverUrl = dev ? 'http://localhost:3001' : 'http://<SERVER_ALB_URL>'; //this value is replaced by AWS CodeBuild

export default {
  async getAllProducts() {
    return await axios.get(serverUrl + '/api/getAllProducts');
  },
};
