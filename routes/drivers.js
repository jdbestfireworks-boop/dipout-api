const express = require('express');
const router = express.Router();
const driversController = require('../controllers/driversController');

// Register driver
router.post('/', driversController.registerDriver);

// List drivers
router.get('/', driversController.getDrivers);

module.exports = router;
