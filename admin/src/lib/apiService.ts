"use server";

import { cookies } from 'next/headers';
import { redirect } from 'next/navigation';

const API_URL = process.env.API_URL;

export async function apiService(
  endpoint: string,
  options: RequestInit = {}
) {
  const cookieStore = await cookies();
  const accessToken = cookieStore.get('accessToken')?.value;

  const defaultHeaders: HeadersInit = {
    'Content-Type': 'application/json',
  };

  if (accessToken) {
    defaultHeaders['Authorization'] = `Bearer ${accessToken}`;
  }

  const response = await fetch(`${API_URL}${endpoint}`, {
    ...options,
    headers: {
      ...defaultHeaders,
      ...options.headers,
    },
  });

  if (response.status === 401) {
    const refreshToken = cookieStore.get('refreshToken')?.value;

    if (refreshToken) {
      try {
        // Try to refresh the token
        const refreshResponse = await fetch(`${API_URL}/token/refresh/`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ refresh: refreshToken }),
        });

        if (refreshResponse.ok) {
          const { access } = await refreshResponse.json();

          // Set the new access token cookie
          const cookieStore = await cookies();
          cookieStore.set('accessToken', access, {
            httpOnly: true,
            secure: false,
            sameSite: 'lax',
            maxAge: 15 * 60, // 15 minutes
          });
          
          // Retry the original request with the new token
          return fetch(`${API_URL}${endpoint}`, {
            ...options,
            headers: {
              ...defaultHeaders,
              Authorization: `Bearer ${access}`,
              ...options.headers,
            },
          });
        }
      } catch (error) {
        console.error('Token refresh failed:', error);
      }
    }

    // If refresh failed or no refresh token, redirect to login
    redirect('/login');
  }

  if (!response.ok) {
    throw new Error(`API error: ${response.status}`);
  }

  return response;
}