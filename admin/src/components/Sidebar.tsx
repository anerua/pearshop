'use client';

import { useState } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { ShoppingBag, Package2, Menu } from 'lucide-react';
import styles from './Sidebar.module.css';
import Image from 'next/image';

export default function Sidebar() {
  const pathname = usePathname();
  const [isOpen, setIsOpen] = useState(false);

  const links = [
    { href: '/products', label: 'Products', icon: Package2 },
    { href: '/orders', label: 'Orders', icon: ShoppingBag },
  ];

  return (
    <>
      <button 
        className={styles.menuButton}
        onClick={() => setIsOpen(!isOpen)}
      >
        <Menu size={24} />
      </button>

      <aside className={`${styles.sidebar} ${isOpen ? styles.open : ''}`}>
        <div className={styles.logo}>
            <Image
                src="/img/pearshop.jpeg"
                alt="PearShop Logo"
                width={24}
                height={24}
            />
            <span>PearShop Admin</span>
        </div>
        <nav className={styles.nav}>
          {links.map((link) => {
            const Icon = link.icon;
            return (
              <Link
                key={link.href}
                href={link.href}
                className={`${styles.navLink} ${
                  pathname.startsWith(link.href) ? styles.active : ''
                }`}
              >
                <Icon size={20} />
                <span>{link.label}</span>
              </Link>
            );
          })}
        </nav>
      </aside>
    </>
  );
}