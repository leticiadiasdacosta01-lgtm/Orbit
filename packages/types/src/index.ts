// API Response Types
export interface ApiResponse<T = any> {
  success: boolean
  data?: T
  error?: ApiError
  meta?: PaginationMeta
}

export interface ApiError {
  code: string
  message: string
  details?: any
}

export interface PaginationMeta {
  page: number
  limit: number
  total: number
  pages: number
}

// Auth Types
export interface LoginRequest {
  email: string
  password: string
}

export interface LoginResponse {
  user: UserSession
  token: string
  refreshToken: string
}

export interface UserSession {
  id: string
  name: string
  email: string
  role: string
  companyId: string
  avatar?: string
}

// Employee Types
export interface EmployeeListItem {
  id: string
  registration: string
  name: string
  email?: string
  status: string
  role: {
    id: string
    name: string
  }
  department: {
    id: string
    name: string
  }
  salary: number
  admissionDate: string
}

// Export all types
export * from './api'
export * from './employee'
