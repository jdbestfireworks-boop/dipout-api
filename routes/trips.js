const express = require('express');
const router = express.Router();
const tripsController = require('../controllers/tripsController');
const auth = require('../middleware/auth');

// Create trip (requires login)
router.post('/', auth, tripsController.createTrip);

// Get logged-in user's trips
router.get('/', auth, tripsController.getUserTrips);

module.exports = router;
