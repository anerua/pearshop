import { Product } from "./product";

export interface Order {
  id: number;
  user: {
    id: number;
    username: string;
  };
  total_price: number;
  delivery_address: string;
  created_at: string;
  updated_at: string;
  order_items: OrderItem[];
}

export interface OrderItem {
  id: number;
  user: {
    id: number;
    username: string;
  };
  product: Product;
  quantity: number;
  total_price: number;
}
