// app.test.js

const request = require('supertest');
const app = require('./app');

describe('GET /', () => {
  it('responds with status 200 and contains time information', async () => {
    const response = await request(app).get('/');
    
    expect(response.status).toBe(200);
    expect(response.text).toContain('limaTime');
    expect(response.text).toContain('austinTime');
  });
});