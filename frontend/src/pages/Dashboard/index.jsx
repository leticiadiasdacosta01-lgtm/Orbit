import React, { useEffect, useMemo, useState } from 'react';
import {
  Area,
  AreaChart,
  CartesianGrid,
  Legend,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis
} from 'recharts';

const currencyFormatter = new Intl.NumberFormat('pt-BR', {
  style: 'currency',
  currency: 'BRL'
});

const Dashboard = () => {
  const [dreSummary, setDreSummary] = useState([]);
  const [indicators, setIndicators] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const loadData = async () => {
      try {
        const [dreRes, indRes] = await Promise.all([
          fetch('/api/dre/resumo'),
          fetch('/api/indicadores')
        ]);

        if (!dreRes.ok) {
          throw new Error('Falha ao carregar resumo de DRE');
        }
        if (!indRes.ok) {
          throw new Error('Falha ao carregar indicadores');
        }

        const dreData = await dreRes.json();
        const indicatorData = await indRes.json();
        setDreSummary(dreData);
        setIndicators(indicatorData);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    loadData();
  }, []);

  const totals = useMemo(() => {
    const base = { receita: 0, despesa: 0, resultado: 0 };
    dreSummary.forEach((item) => {
      if (item.account_type?.toLowerCase().includes('receita')) {
        base.receita += item.total_amount;
      } else if (item.account_type?.toLowerCase().includes('despesa')) {
        base.despesa += item.total_amount;
      } else {
        base.resultado += item.total_amount;
      }
    });
    base.resultado += base.receita + base.despesa;
    return base;
  }, [dreSummary]);

  const chartSeries = useMemo(() => {
    const totalsByType = new Map();
    dreSummary.forEach((item) => {
      const key = item.account_type || 'Outros';
      totalsByType.set(key, (totalsByType.get(key) || 0) + Math.abs(item.total_amount));
    });
    const result = Array.from(totalsByType.entries())
      .sort((a, b) => b[1] - a[1])
      .slice(0, 3)
      .map(([type]) => type);
    if (result.length === 0) {
      result.push('Total');
    }
    return result;
  }, [dreSummary]);

  const chartData = useMemo(() => {
    const grouped = new Map();
    dreSummary.forEach((item) => {
      const key = item.period;
      if (!grouped.has(key)) {
        grouped.set(key, { period: key });
      }
      const entry = grouped.get(key);
      const label = item.account_type || 'Outros';
      entry[label] = (entry[label] || 0) + item.total_amount;
      entry.Total = (entry.Total || 0) + item.total_amount;
    });

    return Array.from(grouped.values()).sort((a, b) => new Date(a.period) - new Date(b.period));
  }, [dreSummary]);

  const latestIndicators = useMemo(() => {
    const byCode = new Map();
    indicators.forEach((item) => {
      const existing = byCode.get(item.indicator_code);
      if (!existing || new Date(item.period) > new Date(existing.period)) {
        byCode.set(item.indicator_code, item);
      }
    });
    return Array.from(byCode.values());
  }, [indicators]);

  if (loading) {
    return <p>Carregando dashboard...</p>;
  }

  if (error) {
    return <p className="error">{error}</p>;
  }

  return (
    <>
      <section className="card-grid">
        <article className="card">
          <h3>Receita acumulada</h3>
          <strong>{currencyFormatter.format(totals.receita)}</strong>
        </article>
        <article className="card">
          <h3>Despesas acumuladas</h3>
          <strong>{currencyFormatter.format(totals.despesa)}</strong>
        </article>
        <article className="card">
          <h3>Resultado operacional</h3>
          <strong>{currencyFormatter.format(totals.resultado)}</strong>
        </article>
        <article className="card">
          <h3>Indicadores monitorados</h3>
          <strong>{latestIndicators.length}</strong>
        </article>
      </section>

      <section className="chart-container">
        <h2>Evolução da DRE por categoria</h2>
        {chartData.length === 0 ? (
          <p>Sem dados disponíveis.</p>
        ) : (
          <ResponsiveContainer width="100%" height={320}>
            <AreaChart data={chartData}>
              <defs>
                {chartSeries.map((type, index) => (
                  <linearGradient key={type} id={`color-${index}`} x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#3b82f6" stopOpacity={0.8 - index * 0.2} />
                    <stop offset="95%" stopColor="#3b82f6" stopOpacity={0} />
                  </linearGradient>
                ))}
              </defs>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="period" />
              <YAxis tickFormatter={(value) => currencyFormatter.format(value)} />
              <Tooltip formatter={(value) => currencyFormatter.format(value)} />
              <Legend />
              {chartSeries.map((type, index) => (
                <Area
                  key={type}
                  type="monotone"
                  dataKey={type}
                  stackId="1"
                  stroke="#1d4ed8"
                  fill={`url(#color-${index})`}
                  fillOpacity={0.6 - index * 0.15}
                />
              ))}
            </AreaChart>
          </ResponsiveContainer>
        )}
      </section>

      <section className="chart-container">
        <h2>Indicadores mais recentes</h2>
        {latestIndicators.length === 0 ? (
          <p>Sem indicadores registrados.</p>
        ) : (
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Indicador</th>
                  <th>Período</th>
                  <th>Empresa</th>
                  <th>Valor</th>
                </tr>
              </thead>
              <tbody>
                {latestIndicators.map((indicator) => (
                  <tr key={indicator.indicator_code}>
                    <td>
                      <strong>{indicator.indicator_name}</strong>
                      <div className="muted">{indicator.indicator_code}</div>
                    </td>
                    <td>{new Date(indicator.period).toLocaleDateString('pt-BR')}</td>
                    <td>{indicator.company_name || 'Consolidado'}</td>
                    <td>
                      {indicator.unit === '%'
                        ? `${indicator.value.toFixed(2)}%`
                        : indicator.unit && indicator.unit !== 'R$'
                        ? `${indicator.value.toLocaleString('pt-BR')} ${indicator.unit}`
                        : currencyFormatter.format(indicator.value)}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>
    </>
  );
};

export default Dashboard;
