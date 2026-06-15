require('dotenv').config();
const db = require('./config/db');

async function init() {
  try {
    console.log('Creating tables...');

    await db.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      );
    `);

    await db.query(`
      CREATE TABLE IF NOT EXISTS trips (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id),
        pickup_location TEXT NOT NULL,
        dropoff_location TEXT NOT NULL,
        scheduled_time TIMESTAMP NOT NULL,
        status TEXT DEFAULT 'scheduled'
      );
    `);

    await db.query(`
      CREATE TABLE IF NOT EXISTS drivers (
        id SERIAL PRIMARY KEY,
        name TEXT NOT NULL,
        vehicle TEXT NOT NULL,
        license_plate TEXT NOT NULL
      );
    `);

    console.log('Tables created successfully.');
  } catch (err) {
    console.error('Error creating tables:', err);
  } finally {
    process.exit();
  }
}

init();
