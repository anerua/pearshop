import ProductList from './ProductList';
import styles from './products.module.css';
import { getProducts } from '@/lib/productService';

export default async function ProductsPage() {
  const products = await getProducts();
  
  return (
    <div>
      <div className={styles.header}>
        <h1 className="page-title">Products</h1>
        <button className="button button-primary">Add Product</button>
      </div>
      <ProductList products={products} />
    </div>
  );
}