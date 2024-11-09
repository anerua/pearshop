export interface Product {
  id: number;
  name: string;
  image: string;
  price: number;
  created_at: string;
  updated_at: string;
}

export type ProductFormData = Omit<Product, "id" | "created_at" | "updated_at">;
