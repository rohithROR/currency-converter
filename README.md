# CurrencyXchange Pro | Global Currency Conversion

## Application Screenshots

### Currency Conversion Interface
![Currency Conversion Interface](/images/screenshot_1.png)

### Conversion Result Display
![Conversion Result Display](/images/screenshot_2.png)

### Different Currency Pairs (AUD to USD)
![Different Currency Pairs](/images/screenshot_3.png)

### Currency Conversion (GBP to USD)
![Currency Conversion GBP to USD](/images/screenshot_4.png)

A full-stack currency conversion application built with Ruby on Rails backend and React frontend. This application enables users to convert between multiple currencies using live exchange rates from the Frankfurter API, with smart rate caching to minimize external API calls and provide a seamless user experience.

## Features

- **Live Currency Conversion**: Convert amounts between various currencies using up-to-date exchange rates
- **Smart Rate Caching**: Cache exchange rates per currency pair for 1 hour to minimize external API calls
- **Conversion History**: View your complete history of currency conversions with timestamps
- **Modern UI/UX**: Beautiful and responsive interface with intuitive controls
- **Error Handling**: Robust error handling for API failures and network issues
- **Comprehensive Test Suite**: RSpec tests for backend models, services, and API endpoints

## Tech Stack

### Backend
- **Ruby on Rails 7.0.8**: API-only application serving JSON endpoints
- **Ruby 3.0.6**: Programming language
- **SQLite3**: Database for development and testing
- **RSpec**: Test framework for unit and integration tests
- **Factory Bot**: Test data generation
- **Rack CORS**: Cross-Origin Resource Sharing for frontend communication
- **HTTParty**: HTTP client for external API calls
- **Docker**: Containerization for easy deployment and development

### Frontend
- **React 18**: JavaScript library for building the user interface
- **Bootstrap 5**: Frontend framework for responsive design
- **Axios**: Promise-based HTTP client for API calls
- **Font Awesome**: Icon library for improved UI
- **CSS3 Animations**: For smooth transitions and visual feedback
- **Docker**: Containerization for consistent development environment

## Project Structure

```
currency-converter/
├── backend/                 # Rails API application
│   ├── app/
│   │   ├── controllers/     # API controllers
│   │   │   └── api/
│   │   │       └── v1/      # API version 1 controllers
│   │   ├── models/          # Database models
│   │   └── services/        # Service objects for business logic
│   ├── config/              # Rails configuration
│   ├── db/                  # Database migrations and schema
│   └── spec/                # RSpec test files
│       ├── controllers/     # Controller tests
│       ├── models/          # Model tests
│       ├── services/        # Service tests
│       └── factories/       # Factory Bot factories
└── frontend/                # React application
    ├── public/              # Static assets
    └── src/
        ├── components/      # React components
        ├── App.js           # Main application component
        └── CurrencyConverter.css # Custom styling
```

## Detailed Setup Instructions

### Prerequisites

- Ruby 3.0.6 or later
- Rails 7.0.8 or later
- Node.js 16.0.0 or later
- npm 7.10.0 or later
- Git (for cloning the repository)

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd currency-converter/backend
   ```

2. Install Ruby dependencies:
   ```bash
   bundle install
   ```

3. Create and set up the database:
   ```bash
   bin/rails db:create db:migrate
   ```

4. Run the seed data (if available):
   ```bash
   bin/rails db:seed
   ```

5. Start the Rails server:
   ```bash
   bin/rails server -b 0.0.0.0 -p 3000
   ```
   This will start the backend API on http://localhost:3000

### Frontend Setup

1. Open a new terminal and navigate to the frontend directory:
   ```bash
   cd currency-converter/frontend
   ```

2. Install Node.js dependencies:
   ```bash
   npm install
   ```

### Docker Setup (Alternative)

You can also run the entire application using Docker:

1. Make sure Docker and Docker Compose are installed on your system

2. Navigate to the project root directory:
   ```bash
   cd currency-converter
   ```

3. Build and start the containers:
   ```bash
   docker-compose up --build
   ```

4. The application will be available at:
   - Frontend: http://localhost:3001
   - Backend API: http://localhost:3000/api/v1

5. To stop the containers:
   ```bash
   docker-compose down
   ```

3. Start the React development server:
   ```bash
   npm start
   ```
   This will start the frontend application on http://localhost:3001

4. Open your browser and visit:
   ```
   http://localhost:3001
   ```

## Docker Setup

### Using Docker Compose (Recommended)

The easiest way to run both the frontend and backend applications is using Docker Compose:

1. Make sure Docker and Docker Compose are installed on your system

2. From the root directory of the project, run:
   ```bash
   docker-compose up
   ```

3. The application services will be available at:
   - Frontend: http://localhost:3001
   - Backend API: http://localhost:3000/api/v1

4. To shut down the application:
   ```bash
   docker-compose down
   ```

### Building Individual Docker Images

If you need to build the Docker images separately:

**Backend:**
```bash
cd backend
docker build -t currency-converter-backend .
```

**Frontend:**
```bash
cd frontend
docker build -t currency-converter-frontend .
```

## Running Tests

### Backend Tests (RSpec)

1. Navigate to the backend directory:
   ```bash
   cd currency-converter/backend
   ```

2. Run the complete test suite:
   ```bash
   bundle exec rspec
   ```

3. Run specific test files:
   ```bash
   # Run model tests only
   bundle exec rspec spec/models
   
   # Run controller tests only
   bundle exec rspec spec/controllers
   
   # Run a specific test file
   bundle exec rspec spec/models/exchange_rate_spec.rb
   ```

4. Run tests with more detailed output:
   ```bash
   bundle exec rspec --format documentation
   ```

### Test Coverage

The test suite includes:

- **Unit Tests**: Testing individual models and services
- **Controller Tests**: Testing API endpoints
- **Factory Tests**: Ensuring test data factories work correctly
- **Integration Tests**: Testing the entire conversion flow

## API Endpoints

- **POST /api/v1/convert**
  - Converts an amount from one currency to another
  - Required parameters:
    - `source_currency`: Source currency code (e.g., USD)
    - `target_currency`: Target currency code (e.g., EUR)
    - `amount`: Amount to convert (numeric)

- **GET /api/v1/conversions**
  - Returns the conversion history
  - No parameters required

## Implementation Details

### Rate Caching

Exchange rates are cached in the database for one hour to minimize calls to the external API. This implementation:

- Uses the `ExchangeRate` model to store and retrieve cached currency pair rates
- Implements a `find_current_rate` method that checks for existing rates less than 1 hour old
- Only makes external API calls to the Frankfurter API when a valid cached rate doesn't exist
- Saves new rates to the database with timestamps for expiration tracking
- Gracefully handles edge cases like same currency conversion (1:1 rate) and unsupported currency pairs

The caching logic is primarily implemented in the `CurrencyConverterService#get_rate` method which first tries to fetch a cached rate before making an external API call.

### Validation

Both the `ExchangeRate` and `Conversion` models include validations to ensure data integrity.

## Future Improvements

- Add user authentication to store personalized conversion history
- Support for more currencies
- Visualize exchange rate trends with charts
- Add option to schedule recurring conversions

## License

This project is for demonstration purposes only.
