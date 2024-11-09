import { getOrders } from '@/lib/orderService';
import OrderList from './OrderList';

export default async function OrdersPage() {
  const orders = await getOrders();

  return (
    <div>
      <h1 className="page-title">Orders</h1>
      <OrderList orders={orders} />
    </div>
  );
}