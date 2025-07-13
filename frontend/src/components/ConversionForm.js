import React, { useState } from 'react';

const ConversionForm = ({ onSubmit }) => {
  const [formData, setFormData] = useState({
    source_currency: 'USD',
    target_currency: 'EUR',
    amount: 1
  });
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // Currencies supported by ExchangeRate API
  const currencies = [
    'USD', 'AUD', 'BGN', 'BRL', 'CAD', 'CHF', 'CNY', 'CZK', 'DKK', 
    'EUR', 'GBP', 'HKD', 'HUF', 'IDR', 'ILS', 'INR', 'JPY', 'KRW', 
    'MXN', 'MYR', 'NOK', 'NZD', 'PHP', 'PLN', 'RON', 'RUB', 'SEK', 
    'SGD', 'THB', 'TRY', 'ZAR'
  ];

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!formData.amount || formData.amount <= 0) {
      setError('Please enter a valid amount greater than zero');
      return;
    }
    
    setLoading(true);
    setError(null);
    
    try {
      const result = await onSubmit(formData);
      setResult(result);
    } catch (err) {
      setError(err.message || 'An error occurred during conversion');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <div className="mb-3">
          <label htmlFor="amount" className="form-label fw-bold">Amount</label>
          <div className="input-group">
            <span className="input-group-text bg-white">
              <i className="fas fa-coins text-warning"></i>
            </span>
            <input
              type="number"
              className="form-control"
              id="amount"
              name="amount"
              value={formData.amount}
              onChange={handleChange}
              step="0.01"
              min="0.01"
              placeholder="Enter amount"
              required
            />
          </div>
        </div>

        <div className="mb-3">
          <label htmlFor="source_currency" className="form-label fw-bold">From Currency</label>
          <div className="input-group">
            <span className="input-group-text bg-white">
              <i className="fas fa-hand-holding-usd text-primary"></i>
            </span>
            <select
              className="form-select"
              id="source_currency"
              name="source_currency"
              value={formData.source_currency}
              onChange={handleChange}
              required
            >
              {currencies.map(currency => (
                <option key={`from-${currency}`} value={currency}>
                  {currency}
                </option>
              ))}
            </select>
          </div>
        </div>
          
        <div className="text-center my-2">
          <div className="swap-icon-container">
            <i className="fas fa-exchange-alt text-primary"></i>
          </div>
        </div>

        <div className="mb-3">
          <label htmlFor="target_currency" className="form-label fw-bold">To Currency</label>
          <div className="input-group">
            <span className="input-group-text bg-white">
              <i className="fas fa-globe-americas text-success"></i>
            </span>
            <select
              className="form-select"
              id="target_currency"
              name="target_currency"
              value={formData.target_currency}
              onChange={handleChange}
              required
            >
              {currencies.map(currency => (
                <option key={`to-${currency}`} value={currency}>
                  {currency}
                </option>
              ))}
            </select>
          </div>
        </div>

        <button type="submit" className="btn btn-convert w-100 py-2 mt-2" disabled={loading}>
          {loading ? (
            <>
              <span className="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
              Converting...
            </>
          ) : (
            <>
              <i className="fas fa-sync-alt me-2"></i> Convert Currency
            </>
          )}
        </button>
      </form>

      {error && (
        <div className="alert alert-danger mt-3">
          {error}
        </div>
      )}

      {result && !error && (
        <div className="mt-3">
          <div className="card bg-light">
            <div className="card-body p-2">
              <h3 className="card-title h6">Conversion Result</h3>
              <p className="card-text mb-1">
                {result.source_amount} {result.source_currency} = <strong>{Number(result.target_amount).toFixed(2)} {result.target_currency}</strong>
              </p>
              <p className="text-muted small mb-0">
                <span>Rate: {Number(result.rate).toFixed(4)}</span>
              </p>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ConversionForm;
