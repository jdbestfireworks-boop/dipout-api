const db = require('../config/db');

// CREATE TRIP
exports.createTrip = async (req, res) => {
  const { pickup_location, dropoff_location, scheduled_time } = req.body;
  const userId = req.user.id;

  try {
    const result = await db.query(
      `INSERT INTO trips (user_id, pickup_location, dropoff_location, scheduled_time)
       VALUES ($1, $2, $3, $4)
       RETURNING id, user_id, pickup_location, dropoff_location, scheduled_time, status`,
      [userId, pickup_location, dropoff_location, scheduled_time]
    );

    res.json({
      message: 'Trip created',
      trip: result.rows[0]
    });
  } catch (err) {
    console.error('Create trip error:', err);
    res.status(500).json({ message: 'Server error' });
  }
};

// GET USER TRIPS
exports.getUserTrips = async (req, res) => {
  const userId = req.user.id;

  try {
    const result = await db.query(
      `SELECT id, pickup_location, dropoff_location, scheduled_time, status
       FROM trips
       WHERE user_id = $1
       ORDER BY scheduled_time DESC`,
      [userId]
    );

    res.json({ trips: result.rows });
  } catch (err) {
    console.error('Get trips error:', err);
    res.status(500).json({ message: 'Server error' });
  }
};
