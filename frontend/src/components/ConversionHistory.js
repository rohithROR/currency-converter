import React from 'react';

const ConversionHistory = ({ conversions, loading, error }) => {
  if (loading) {
    return (
      <div className="text-center p-4">
        <div className="spinner-border text-primary" role="status">
          <span className="visually-hidden">Loading...</span>
        </div>
        <p className="mt-2">Loading conversion history...</p>
      </div>
    );
  }
  
  if (error) {
    return (
      <div className="alert alert-danger">
        <i className="fas fa-exclamation-circle me-2"></i>
        Error loading conversion history.
      </div>
    );
  }
  
  if (!conversions || conversions.length === 0) {
    return (
      <div className="text-center p-4">
        <i className="fas fa-history fs-1 text-muted mb-3"></i>
        <p>No conversion history available yet.</p>
        <p className="text-muted small">Your currency conversions will appear here.</p>
      </div>
    );
  }

  return (
    <div className="history-container fade-in">
      <div className="table-responsive no-scrollbar">
        <table className="table table-hover history-table align-middle w-100">
          <thead>
            <tr>
              <th width="20%" className="text-center"><i className="far fa-calendar-alt me-2"></i>Date</th>
              <th width="40%" className="text-center"><i className="fas fa-exchange-alt me-2"></i>Conversion</th>
              <th width="10%" className="text-center"><i className="fas fa-chart-line me-2"></i>Rate</th>
              <th width="30%" className="text-center result-column-header"><i className="fas fa-check-circle me-2"></i>Result</th>
            </tr>
          </thead>
          <tbody>
            {conversions.map(conversion => (
              <tr key={conversion.id}>
                <td className="text-nowrap text-center">{new Date(conversion.created_at).toLocaleString()}</td>
                <td className="conversion-cell text-center">
                  <div className="conversion-display">
                    <div className="source-container">
                      <div className="amount-currency">
                        <span className="amount-value">{parseFloat(conversion.source_amount).toFixed(1)}</span>
                        <span className="badge bg-primary ms-1">{conversion.source_currency}</span>
                      </div>
                    </div>
                    <div className="arrow-container">
                      <i className="fas fa-arrow-right text-muted"></i>
                    </div>
                    <div className="target-container">
                      <div className="amount-currency">
                        <span className="amount-value">{parseFloat(conversion.target_amount).toFixed(1)}</span>
                        <span className="badge bg-success ms-1">{conversion.target_currency}</span>
                      </div>
                    </div>
                  </div>
                </td>
                <td className="text-center">{Number(conversion.rate).toFixed(4)}</td>
                <td className="result-cell text-center">
                  <div className="result-display">
                    <span className="result-amount">{Number(conversion.target_amount).toFixed(2)}</span>
                    <span className="result-currency">{conversion.target_currency}</span>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default ConversionHistory;
