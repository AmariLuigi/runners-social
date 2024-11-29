const express = require('express');
const router = express.Router();
const axios = require('axios');

router.get('/directions', async (req, res) => {
  try {
    const { origin, destination, mode } = req.query;
    
    if (!origin || !destination) {
      return res.status(400).json({ error: 'Origin and destination are required' });
    }

    const url = `https://maps.googleapis.com/maps/api/directions/json`;
    const response = await axios.get(url, {
      params: {
        origin,
        destination,
        mode: mode || 'walking',
        key: process.env.GOOGLE_MAPS_API_KEY,
        alternatives: false,
      }
    });

    // Log the response for debugging
    console.log('Google Maps API Response:', JSON.stringify(response.data, null, 2));

    if (response.data.status === 'OK') {
      res.json(response.data);
    } else {
      console.error('Google Maps API Error:', response.data);
      res.status(400).json({ error: 'Failed to get directions', details: response.data });
    }
  } catch (error) {
    console.error('Error in directions endpoint:', error);
    res.status(500).json({ error: 'Failed to get directions', details: error.message });
  }
});

module.exports = router;
