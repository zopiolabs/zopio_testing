
import type { NextRequest } from 'next/server'
import { NextResponse } from 'next/server'
import { apiKeyAuthMiddleware } from '@repo/auth/apiKeyAuthMiddleware'

export async function GET(req: NextRequest) {
  const validatedReq = await apiKeyAuthMiddleware(req)
  if (validatedReq instanceof Response) {
    return validatedReq
  }

  const userId = (validatedReq as { user?: { id: string } }).user?.id || 'unknown'

  return NextResponse.json({
    message: 'Private API key-protected endpoint',
    user: userId,
    timestamp: new Date().toISOString(),
  })
}
