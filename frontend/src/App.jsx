import React from 'react';
import Dashboard from './pages/Dashboard/index.jsx';

const App = () => (
  <div className="app-shell">
    <header className="app-header">
      <h1>Orbit Analytics</h1>
    </header>
    <main className="app-content">
      <Dashboard />
    </main>
  </div>
);

export default App;
