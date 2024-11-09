"use server";

import { apiService } from "./apiService";

export async function getOrders() {
  const response = await apiService('/order');
  return response.json();
}
