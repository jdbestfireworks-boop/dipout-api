const db = require('../config/db');

// REGISTER DRIVER
exports.registerDriver = async (req, res) => {
  const { name, vehicle, license_plate } = req.body;

  try {
    const result = await db.query(
      `INSERT INTO drivers (name, vehicle, license_plate)
       VALUES ($1, $2, $3)
       RETURNING id, name, vehicle, license_plate`,
      [name, vehicle, license_plate]
    );

    res.json({
      message: 'Driver registered',
      driver: result.rows[0]
    });
  } catch (err) {
    console.error('Register driver error:', err);
    res.status(500).json({ message: 'Server error' });
  }
};

// LIST DRIVERS
exports.getDrivers = async (req, res) => {
  try {
    const result = await db.query(
      `SELECT id, name, vehicle, license_plate
       FROM drivers
       ORDER BY id DESC`
    );

    res.json({ drivers: result.rows });
  } catch (err) {
    console.error('Get drivers error:', err);
    res.status(500).json({ message: 'Server error' });
  }
};
