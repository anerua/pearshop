import ProductList from './ProductList';
import { getProducts } from '@/lib/productService';

export default async function ProductsPage() {
  const products = await getProducts();
  
  return (
    <div>
      <ProductList products={products} />
    </div>
  );
}