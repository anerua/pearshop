"use client";

import { useState } from "react";
import { Product } from "@/types";
import styles from "./ProductForm.module.css";

interface ProductFormProps {
  product?: Product;
  onSubmit: (data: Omit<Product, "id" | "created_at" | "updated_at">) => Promise<void>;
  onClose: () => void;
}

export default function ProductForm({
  product,
  onSubmit,
  onClose,
}: ProductFormProps) {
  const [formData, setFormData] = useState({
    name: product?.name || "",
    price: product?.price || "",
    image: product?.image || "",
    description: product?.description || "",
  });
  const [errors, setErrors] = useState<Record<string, string>>({});

  const validate = () => {
    const newErrors: Record<string, string> = {};
    if (!formData.name) newErrors.name = "Name is required";
    if (!formData.price) newErrors.price = "Price is required";
    if (Number(formData.price) <= 0)
      newErrors.price = "Price must be greater than 0";
    if (!formData.image) newErrors.image = "Image URL is required";
    return newErrors;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const newErrors = validate();

    if (Object.keys(newErrors).length === 0) {
      try {
        await onSubmit({
          name: formData.name,
          price: Number(formData.price),
          image: formData.image,
          description: formData.description,
        });
        onClose();
      } catch (error) {
        console.error("Error submitting form:", error);
      }
    } else {
      setErrors(newErrors);
    }
  };

  return (
    <div className={styles.modal}>
      <div className={styles.modalContent}>
        <h2 className="page-title">{product ? "Edit" : "Add"} Product</h2>
        <form onSubmit={handleSubmit} className={styles.form}>
          <div className={styles.formGroup}>
            <label className={styles.label}>Name</label>
            <input
              type="text"
              className={styles.input}
              value={formData.name}
              onChange={(e) =>
                setFormData({ ...formData, name: e.target.value })
              }
            />
            {errors.name && <span className={styles.error}>{errors.name}</span>}
          </div>

          <div className={styles.formGroup}>
            <label className={styles.label}>Price</label>
            <input
              type="number"
              step="0.01"
              className={styles.input}
              value={formData.price}
              onChange={(e) =>
                setFormData({ ...formData, price: e.target.value })
              }
            />
            {errors.price && (
              <span className={styles.error}>{errors.price}</span>
            )}
          </div>

          <div className={styles.formGroup}>
            <label className={styles.label}>Image URL</label>
            <input
              type="url"
              className={styles.input}
              value={formData.image}
              onChange={(e) =>
                setFormData({ ...formData, image: e.target.value })
              }
            />
            {errors.image && <span className={styles.error}>{errors.image}</span>}
          </div>

          <div className={styles.formGroup}>
            <label className={styles.label}>Description</label>
            <textarea
              className={styles.textarea}
              value={formData.description}
              onChange={(e) =>
                setFormData({ ...formData, description: e.target.value })
              }
            />
          </div>

          <div className={styles.actions}>
            <button type="button" className="button" onClick={onClose}>
              Cancel
            </button>
            <button type="submit" className="button button-primary">
              {product ? "Update" : "Create"} Product
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
