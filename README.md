# Weather Service Documentation

## Overview

This documentation provides step-by-step instructions to run the Weather App, which consists of a Ruby on Rails backend and a Next.js frontend. Both apps are containerized using Docker and orchestrated with Docker Compose. Redis is used as the caching service.

---

## Docker Configuration

### Docker Compose File
The `docker-compose.yml` file is located in the root directory and configures the following services:
- **backend**: Ruby on Rails API
- **frontend**: Next.js application
- **redis**: Redis caching server

### Rails Backend Dockerfile
Located at: `backend/Dockerfile`

### Next.js Frontend Dockerfile
Located at: `frontend/Dockerfile`

---

## Building the Containers
Navigate to the root directory and build the Docker containers:

```bash
docker-compose up --build
```

### Running the Containers
Start the services with the following command:

```bash
docker-compose up
```

### Accessing the Applications
- **Next.js Frontend**: http://localhost:3000
- **Rails API (Backend)**: http://localhost:3001

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
```
{
  "error": "Number of days selected invalid"
}
```
```
{
  "error": "City not found"
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
