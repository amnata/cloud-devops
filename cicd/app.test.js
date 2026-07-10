const request = require('supertest');
const app = require('./app'); 

describe('API Endpoints', () => {
  // Default GET endpoint tests
  describe('GET /api', () => {
    it('responds with json', async () => {
      const response = await request(app)
        .get('/api')
        .set('Accept', 'application/json');

      expect(response.status).toBe(200);
      expect(response.body).toEqual({ message: 'Hello, World!' });
    });
  });

  // New POST endpoint tests
  describe('POST /api/greet', () => {
    it('responds with a greeting message for a valid username', async () => {
      const response = await request(app)
        .post('/api/greet')
        .send({ username: 'Alice' }) 
        .set('Accept', 'application/json');

      expect(response.status).toBe(200);
      expect(response.body).toEqual({ message: 'Hey Alice' });
    });

    it('responds with a 400 status if no username is provided', async () => {
      const response = await request(app)
        .post('/api/greet')
        .send({}) 
        .set('Accept', 'application/json');

      expect(response.status).toBe(400);
      expect(response.body).toEqual({ error: 'Username is required' });
    });
  });
});
