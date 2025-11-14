import { redirect } from 'next/navigation'

export default function HomePage() {
  // Redirect to login for now
  // Later this will check authentication and redirect accordingly
  redirect('/login')
}
