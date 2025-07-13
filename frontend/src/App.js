import React, { useState, useEffect } from 'react';
import axios from 'axios';
import 'bootstrap/dist/css/bootstrap.min.css';
import './App.css';
import './CurrencyConverter.css';
import ConversionForm from './components/ConversionForm';
import ConversionHistory from './components/ConversionHistory';

// Create a configured axios instance for consistent API calls
const api = axios.create({
  baseURL: 'http://localhost:3000/api/v1',
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept'
  },
  // Disable credentials for simpler CORS
  withCredentials: false
});

// Add request interceptor for debugging
api.interceptors.request.use(function (config) {
  console.log('Request being sent:', config);
  return config;
});

function App() {
  const [conversions, setConversions] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  
  console.log('API configured with baseURL:', api.defaults.baseURL);
  
  useEffect(() => {
    // Load conversion history when component mounts
    fetchConversions();
  }, []);
  
  const fetchConversions = async () => {
    setLoading(true);
    setError(null);
    
    try {
      console.log('Fetching conversions');
      const response = await api.get('/conversions');
      
      // Handle both data formats - with or without 'conversions' wrapper
      if (Array.isArray(response.data)) {
        setConversions(response.data);
      } else if (response.data && Array.isArray(response.data.conversions)) {
        setConversions(response.data.conversions);
      } else {
        console.error('Unexpected data format:', response.data);
        setError('Unexpected data format from API');
      }
    } catch (err) {
      console.error('Error fetching conversions:', err);
      setError('Failed to load conversion history');
    } finally {
      setLoading(false);
    }
  };
  
  const handleConversion = async (formData) => {
    setLoading(true);
    setError(null);
    
    try {
      console.log('Attempting conversion with data:', formData);
      const response = await api.post('/convert', formData);
      fetchConversions();
      return response.data; // Return conversion result to display in form
    } catch (err) {
      setError('Conversion failed: ' + (err.response?.data?.error || err.message));
      console.error('Error during conversion:', err);
      throw err; // Rethrow to handle in the form component
    } finally {
      setLoading(false);
    }
  };
  
  return (
    <div className="container py-4">
      <header className="mb-5 text-center">
        <h1 className="app-title">CurrencyXchange Pro</h1>
        <p className="text-muted">Fast and reliable global currency conversion</p>
      </header>
      
      <div className="row">
        <div className="col-lg-4 mb-4 mb-lg-0">
          <div className="card currency-card">
            <div className="card-header converter-header text-center">
              <i className="fas fa-exchange-alt me-2"></i> Convert Currency
            </div>
            <div className="card-body p-4">
              <ConversionForm onSubmit={handleConversion} />
            </div>
          </div>
        </div>
        
        <div className="col-lg-8">
          <div className="card currency-card">
            <div className="card-header history-header text-center">
              <i className="fas fa-history me-2"></i> Conversion History
            </div>
            <div className="card-body p-4">
              {error && <div className="alert alert-danger">{error}</div>}
              <ConversionHistory conversions={conversions} loading={loading} error={error} />
            </div>
          </div>
        </div>
      </div>
      
      <footer className="mt-5 text-center text-muted">
        <small>Exchange rates provided by ExchangeRate API</small>
      </footer>
    </div>
  );
}

export default App;
