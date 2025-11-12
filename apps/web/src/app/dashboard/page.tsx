'use client'

import { useEffect, useState } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'

export default function DashboardPage() {
  const [user, setUser] = useState<any>(null)

  useEffect(() => {
    // Check authentication
    const token = localStorage.getItem('token')
    const userStr = localStorage.getItem('user')

    if (!token || !userStr) {
      window.location.href = '/login'
      return
    }

    setUser(JSON.parse(userStr))
  }, [])

  const handleLogout = () => {
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    window.location.href = '/login'
  }

  if (!user) {
    return (
      <div className="flex min-h-screen items-center justify-center">
        <p>Carregando...</p>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <header className="border-b bg-white">
        <div className="container mx-auto flex h-16 items-center justify-between px-4">
          <div className="flex items-center gap-2">
            <h1 className="text-2xl font-bold text-primary">Orbit</h1>
            <span className="text-sm text-gray-500">ERP</span>
          </div>

          <div className="flex items-center gap-4">
            <div className="text-right">
              <p className="text-sm font-medium">{user.name}</p>
              <p className="text-xs text-gray-500">{user.email}</p>
            </div>
            <Button variant="outline" size="sm" onClick={handleLogout}>
              Sair
            </Button>
          </div>
        </div>
      </header>

      <main className="container mx-auto p-6">
        <div className="mb-6">
          <h2 className="text-3xl font-bold">Dashboard</h2>
          <p className="text-gray-600">
            Bem-vindo(a) ao Orbit ERP, {user.name}!
          </p>
        </div>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          <Card>
            <CardHeader>
              <CardTitle>Colaboradores</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-3xl font-bold">45</p>
              <p className="text-sm text-gray-500">Ativos</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Folha de Pagamento</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-3xl font-bold">R$ 180.000,00</p>
              <p className="text-sm text-gray-500">Mês atual</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Ponto Eletrônico</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-3xl font-bold">98%</p>
              <p className="text-sm text-gray-500">Taxa de conformidade</p>
            </CardContent>
          </Card>
        </div>

        <Card className="mt-6">
          <CardHeader>
            <CardTitle>Status do Projeto</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <span className="text-sm">Backend (Fastify)</span>
                <span className="rounded-full bg-green-100 px-2 py-1 text-xs font-medium text-green-800">
                  ✓ Configurado
                </span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm">Frontend (Next.js)</span>
                <span className="rounded-full bg-green-100 px-2 py-1 text-xs font-medium text-green-800">
                  ✓ Configurado
                </span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm">Database (PostgreSQL)</span>
                <span className="rounded-full bg-green-100 px-2 py-1 text-xs font-medium text-green-800">
                  ✓ Configurado
                </span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm">Autenticação</span>
                <span className="rounded-full bg-green-100 px-2 py-1 text-xs font-medium text-green-800">
                  ✓ Funcionando
                </span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm">Módulo de Colaboradores</span>
                <span className="rounded-full bg-yellow-100 px-2 py-1 text-xs font-medium text-yellow-800">
                  Em desenvolvimento
                </span>
              </div>
            </div>
          </CardContent>
        </Card>
      </main>
    </div>
  )
}
