import { prisma } from '@orbit/database'
import * as bcrypt from 'bcryptjs'

class AuthService {
  async login(email: string, password: string) {
    // Find user by email
    const user = await prisma.user.findFirst({
      where: {
        email: email.toLowerCase(),
        active: true,
      },
      include: {
        company: {
          select: {
            id: true,
            name: true,
            active: true,
          },
        },
      },
    })

    if (!user) {
      return null
    }

    // Check if company is active
    if (!user.company.active) {
      throw new Error('Company is not active')
    }

    // Verify password
    const isPasswordValid = await bcrypt.compare(password, user.password)
    if (!isPasswordValid) {
      return null
    }

    // Update last login
    await prisma.user.update({
      where: { id: user.id },
      data: { lastLoginAt: new Date() },
    })

    // Remove password from response
    const { password: _, ...userWithoutPassword } = user

    return {
      user: userWithoutPassword,
    }
  }

  async getCurrentUser(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        name: true,
        email: true,
        role: true,
        avatar: true,
        companyId: true,
        company: {
          select: {
            id: true,
            name: true,
            tradeName: true,
            logo: true,
          },
        },
        employee: {
          select: {
            id: true,
            name: true,
            registration: true,
            role: {
              select: {
                id: true,
                name: true,
              },
            },
            department: {
              select: {
                id: true,
                name: true,
              },
            },
          },
        },
      },
    })

    return user
  }

  async register(data: {
    name: string
    email: string
    password: string
    companyId: string
  }) {
    // Hash password
    const hashedPassword = await bcrypt.hash(data.password, 10)

    // Create user
    const user = await prisma.user.create({
      data: {
        name: data.name,
        email: data.email.toLowerCase(),
        password: hashedPassword,
        companyId: data.companyId,
        role: 'EMPLOYEE',
      },
    })

    const { password: _, ...userWithoutPassword } = user

    return userWithoutPassword
  }
}

export const authService = new AuthService()
