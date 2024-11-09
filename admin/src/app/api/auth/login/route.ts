import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    const response = await fetch(`${process.env.API_URL}/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(body),
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.message);
    }

    // Set HTTP-only cookies
    const responseObj = NextResponse.json({ success: true });
    responseObj.cookies.set('accessToken', data.access, {
      httpOnly: true,
      secure: false,
      sameSite: 'lax',
      maxAge: 15 * 60, // 15 minutes
    });
    responseObj.cookies.set('refreshToken', data.refresh, {
      httpOnly: true,
      secure: false,
      sameSite: 'lax',
      maxAge: 7 * 24 * 60 * 60, // 7 days
    });

    return responseObj;
  } catch (error) {
    return NextResponse.json(
      { error: error },
      { status: 401 }
    );
  }
}