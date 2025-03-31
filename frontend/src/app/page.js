"use client";

import { useState } from 'react';
import "./globals.css";
import { getAverageTemperature } from '@/services/weatherService';

export default function WeatherApp() {
  const [city, setCity] = useState('');
  const [days, setDays] = useState('');
  const [averageTemp, setAverageTemp] = useState(null);
  const [error, setError] = useState(null);

  const fetchWeather = async () => {
    try {
      const data = await getAverageTemperature(city, days);
      setAverageTemp(data.average_temperature);
      setError(null);
    } catch (err) {
      setError('Unable to retrieve weather data');
      setAverageTemp(null);
    }
  };

  return (
    <div className="flex flex-col items-center p-8 space-y-4 bg-gray-100 min-h-screen">
      <h1 className="text-3xl font-bold text-gray-800">Weather App</h1>
      <input
        type="text"
        placeholder="Enter city"
        value={city}
        onChange={(e) => setCity(e.target.value)}
        className="p-2 border border-gray-300 rounded w-80 text-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500 placeholder-gray-500"
      />
      <input
        type="number"
        placeholder="Number of days"
        value={days}
        onChange={(e) => setDays(e.target.value)}
        className="p-2 border border-gray-300 rounded w-80 text-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500 placeholder-gray-500"
      />
      <button
        onClick={fetchWeather}
        className="p-2 bg-blue-500 text-white rounded hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-700"
      >
        Get Average Temperature
      </button>
      {averageTemp !== null && (
        <div className="mt-4 p-4 bg-green-100 text-green-800 rounded shadow">
          Average Temperature: {averageTemp}°C
        </div>
      )}
      {error && (
        <div className="mt-4 p-4 bg-red-100 text-red-600 rounded shadow">
          {error}
        </div>
      )}
    </div>
  );
}
