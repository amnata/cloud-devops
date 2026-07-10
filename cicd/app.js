const express = require('express');
const app = express();

// Middleware to parse JSON request bodies
app.use(express.json());

// Existing GET endpoint
app.get('/api', (req, res) => {
  res.json({ message: 'Hello, World!' });
});

// New POST endpoint to greet the user
app.post('/api/greet', (req, res) => {
  const { username } = req.body;
  if (!username) {
    return res.status(400).json({ error: 'Username is required' });
  }
  res.json({ message: `Hey ${username}` });
});

// Export the app for testing
module.exports = app;

// Start the server if the file is run directly
if (require.main === module) {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
  });
}
