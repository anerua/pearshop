"use server";

import { Product } from "@/types";
import { apiService } from "./apiService";

export async function getProducts() {
  const response = await apiService('/product');
  return response.json();
}

export async function createProduct(data: Omit<Product, 'id' | 'created_at' | 'updated_at'>) {
  await apiService('/product', { method: 'POST', body: JSON.stringify(data) });
}

export async function updateProduct(id: number, data: Omit<Product, 'id' | 'created_at' | 'updated_at'>) {
  await apiService(`/product/${id}`, { method: 'PATCH', body: JSON.stringify(data) });
}

export async function deleteProduct(id: number) {
  await apiService(`/product/${id}`, { method: 'DELETE' });
}