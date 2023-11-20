// app.test.js

const request = require('supertest');
const app = require('./app');

describe('GET /', () => {
  it('responds with status 200 and contains time information', async () => {
    const response = await request(app).get('/');
    
    expect(response.status).toBe(300);
    expect(response.text).toContain('Hora de Lima');
    expect(response.text).toContain('Hora de Austin');
  });
});