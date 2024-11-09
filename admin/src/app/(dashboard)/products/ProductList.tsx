"use client";

import { useState } from "react";
import { Product } from "@/types";
import styles from "./products.module.css";
import {
  createProduct,
  deleteProduct,
  updateProduct,
} from "@/lib/productService";
import ProductForm from "@/components/ProductForm";

interface ProductListProps {
  products: Product[];
}

export default function ProductList({
  products: initialProducts,
}: ProductListProps) {
  const [products, setProducts] = useState(initialProducts);

  const [isFormOpen, setIsFormOpen] = useState(false);
  const [selectedProduct, setSelectedProduct] = useState<Product | undefined>();

  const handleAddNew = () => {
    setSelectedProduct(undefined);
    setIsFormOpen(true);
  };

  const handleEdit = (product: Product) => {
    setSelectedProduct(product);
    setIsFormOpen(true);
  };

  const handleSubmit = async (
    data: Omit<Product, "id" | "created_at" | "updated_at">
  ) => {
    try {
      if (selectedProduct) {
        // Edit existing product
        await updateProduct(selectedProduct.id, data);
      } else {
        // Create new product
        await createProduct(data);
      }
      window.location.reload();
    } catch (error) {
      console.error("Error saving product:", error);
    }
  };

  const handleClose = () => {
    setIsFormOpen(false);
    setSelectedProduct(undefined);
  };

  const handleDelete = async (id: number) => {
    if (confirm("Are you sure you want to delete this product?")) {
      await deleteProduct(id);
      setProducts(products.filter((p) => p.id !== id));
    }
  };

  return (
    <>
      <div className={styles.header}>
        <h1 className="page-title">Products</h1>
        <button className="button button-primary" onClick={handleAddNew}>
          Add Product
        </button>
      </div>

      <div className="table-container">
        <table className="table">
          <thead>
            <tr>
              <th>SKU</th>
              <th>Name</th>
              <th>Price</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {products.map((product) => (
              <tr key={product.id}>
                <td>{"#1234"}</td>
                <td>{product.name}</td>
                <td>&#x20A6;{product.price}</td>
                <td>
                  <div className={styles.actions}>
                    <button
                      className="button button-primary"
                      onClick={() => handleEdit(product)}
                    >
                      Edit
                    </button>
                    <button
                      className="button button-danger"
                      onClick={() => handleDelete(product.id)}
                    >
                      Delete
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {isFormOpen && (
        <ProductForm
          product={selectedProduct}
          onSubmit={handleSubmit}
          onClose={handleClose}
        />
      )}
    </>
  );
}
