"use client";

import React from "react";
import { Order } from "@/types";
import { useState } from "react";
import { ChevronDown, ChevronUp } from "lucide-react";
import styles from "./orders.module.css";

interface OrderListProps {
  orders: Order[];
}

export default function OrderList({ orders }: OrderListProps) {
  const [expandedOrderId, setExpandedOrderId] = useState<number | null>(null);

  const toggleOrder = (orderId: number) => {
    setExpandedOrderId(expandedOrderId === orderId ? null : orderId);
  };

  return (
    <div className="table-container">
      <table className="table">
        <thead>
          <tr>
            <th></th>
            <th>Order ID</th>
            <th>User</th>
            <th>Total Amount</th>
            <th>Delivery Address</th>
            <th>Date of Order</th>
          </tr>
        </thead>
        <tbody>
          {orders.map((order) => (
            <React.Fragment key={order.id}>
              <tr
                onClick={() => toggleOrder(order.id)}
                className={styles.orderRow}
              >
                <td>
                  {expandedOrderId === order.id ? (
                    <ChevronUp size={20} />
                  ) : (
                    <ChevronDown size={20} />
                  )}
                </td>
                <td>#{order.id}</td>
                <td>{order.user.username}</td>
                <td>${order.total_price.toFixed(2)}</td>
                <td>{order.delivery_address}</td>
                <td>{new Date(order.created_at).toLocaleDateString()}</td>
              </tr>
              {expandedOrderId === order.id && (
                <tr>
                  <td colSpan={6}>
                    <div className={styles.orderDetails}>
                      <h4>Order Items</h4>
                      <table className={styles.itemsTable}>
                        <thead>
                          <tr>
                            <th>Product</th>
                            <th>Quantity</th>
                            <th>Price</th>
                            <th>Subtotal</th>
                          </tr>
                        </thead>
                        <tbody>
                          {order.order_items.map((item) => (
                            <tr key={item.id}>
                              <td>{item.product.name}</td>
                              <td>{item.quantity}</td>
                              <td>${item.product.price.toFixed(2)}</td>
                              <td>
                                ${(item.total_price).toFixed(2)}
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  </td>
                </tr>
              )}
            </React.Fragment>
          ))}
        </tbody>
      </table>
    </div>
  );
}
