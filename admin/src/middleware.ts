import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
import { apiService } from '@/lib/apiService';

export async function middleware(request: NextRequest) {
  // Check if the user is authenticated, if not, redirect to login
  try {
    await apiService('/check');
    return NextResponse.next();
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  } catch (error) {
    return NextResponse.redirect(new URL('/login', request.url));
  }
}

export const config = {
  matcher: [
    '/((?!login|api|_next/static|_next/image|favicon.ico).*)',
  ],
};