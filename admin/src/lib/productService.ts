"use server";

import { apiService } from "./apiService";

export async function getProducts() {
  const response = await apiService('/product');
  return response.json();
}

export async function deleteProduct(id: number) {
  await apiService(`/product/${id}`, { method: 'DELETE' });
}