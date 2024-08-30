const express = require('express');
const axios = require('axios');

const router = express.Router();
const GOOGLE_API_KEY = 'AIzaSyDJDyUE1x5lxaS3AiYmdHzAVAh-atb9eek'; 

router.get('/autocomplete', async (req, res) => {
  try {
    const { input } = req.query;
    const response = await axios.get('https://maps.googleapis.com/maps/api/place/autocomplete/json', {
      params: {
        input,
        key: GOOGLE_API_KEY,
      },
    });
    res.json(response.data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get('/details', async (req, res) => {
  try {
    const { place_id } = req.query;
    const response = await axios.get('https://maps.googleapis.com/maps/api/place/details/json', {
      params: {
        place_id,
        key: GOOGLE_API_KEY,
      },
    });
    res.json(response.data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
