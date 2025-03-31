# Weather Service Documentation

## Overview

The Weather Service is a Ruby on Rails application that leverages the Open-Meteo API to fetch and calculate the average temperature for a given city over a specified number of days. The service also uses Redis to cache recent weather requests, significantly improving response time for repeated queries.

---

## Installation and Setup

### Prerequisites

- Ruby (>= 3.0)
- Rails (>= 7.0)
- Redis
- Bundler

### Setting Up the Project

1. Clone the repository:

   ```bash
   git clone https://github.com/username/weather_service.git
   cd weather_service
   ```

2. Install necessary gems:

   ```bash
   bundle install
   ```

3. Start Redis:

   ```bash
   redis-server
   ```

4. Set up environment variables: Create a `.env` file in the root directory:

   ```bash
   REDIS_URL=redis://localhost:6379/1
   ```

5. Start the Rails server:

   ```bash
   rails server
   ```

---

## Endpoints

### GET /weather/\:city/\:days

Fetches the average temperature for a given city over a specified number of days.

**Request Example:**

```
GET /weather/London/3
```

**Response Example:**

```
{
  "city": "London",
  "average_temperature": 15.2
}
```

**Error Response:**

```
{
  "error": "Unable to retrieve weather data"
}
```

### Caching

- The service caches the results in Redis with a TTL of 1 hour.
- Cache key format: `weather:city:days` (e.g., `weather:london:3`).

---

## Internal Structure

### Service: WeatherService

Responsible for interacting with the Open-Meteo API and caching the results.

- **Methods:**
  - `average_temperature`: Returns the average temperature, utilizing cached data if available.
  - `geocode_city`: Fetches latitude and longitude for a given city.
  - `fetch_average_temperature`: Retrieves temperature data from Open-Meteo.

### Controller: WeatherController

Handles HTTP requests and responses.

- **Actions:**
  - `show`: Calls `WeatherService` to fetch and return the average temperature.