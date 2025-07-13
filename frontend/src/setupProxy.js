const { createProxyMiddleware } = require('http-proxy-middleware');

module.exports = function(app) {
  // Log all proxied requests
  app.use('/api', function(req, res, next) {
    console.log('Proxying API request:', req.method, req.url);
    next();
  });

  // Try multiple targets in sequence
  const PROXY_TARGETS = [
    'http://backend:3000',    // Docker service name
    'http://localhost:3000'   // Host machine direct access
  ];
  
  // Track current target index and if we've attempted all targets
  let currentTargetIndex = 0;
  let attemptedAllTargets = false;
  
  // Add proxy middleware
  app.use(
    '/api',
    createProxyMiddleware({
      // Try backend service name first
      target: PROXY_TARGETS[currentTargetIndex],
      // Change origin to avoid CORS issues
      changeOrigin: true,
      // Log proxy activity
      logLevel: 'debug',
      // Handle proxy errors with fallback
      onError: (err, req, res) => {
        console.error(`Proxy error with target ${PROXY_TARGETS[currentTargetIndex]}:`, err);
        
        // Try next target if available
        if (currentTargetIndex < PROXY_TARGETS.length - 1 && !attemptedAllTargets) {
          currentTargetIndex++;
          console.log(`Switching to fallback target: ${PROXY_TARGETS[currentTargetIndex]}`);
          
          // If we've tried all targets, mark as attempted all
          if (currentTargetIndex === PROXY_TARGETS.length - 1) {
            attemptedAllTargets = true;
          }
          
          // Send response indicating we're trying another endpoint
          res.writeHead(503, {
            'Content-Type': 'application/json',
            'Retry-After': '1'
          });
          res.end(JSON.stringify({ 
            error: 'Temporarily unavailable', 
            message: 'Switching to fallback API endpoint' 
          }));
        } else {
          // All targets failed, send error
          res.writeHead(500, {
            'Content-Type': 'application/json'
          });
          res.end(JSON.stringify({ error: 'All API endpoints failed', message: err.message }));
        }
      },
      // Additional headers
      onProxyReq: (proxyReq, req, res) => {
        proxyReq.setHeader('X-Forwarded-For', 'frontend');
        proxyReq.setHeader('X-Proxy-By', 'frontend-proxy');
      }
    })
  );
};
