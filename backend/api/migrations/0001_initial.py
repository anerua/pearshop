# Generated by Django 5.1.3 on 2024-11-07 21:05

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='OrderItem',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('quantity', models.IntegerField(verbose_name='Quantity')),
            ],
            options={
                'ordering': ('-updated_at',),
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Product',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('name', models.CharField(max_length=255, verbose_name='Name of product')),
                ('price', models.IntegerField(verbose_name='Price of product in naira')),
                ('image', models.URLField(blank=True, verbose_name='URL to product image')),
            ],
            options={
                'ordering': ('-updated_at',),
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Order',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('delivery_address', models.CharField(max_length=255, verbose_name='Delivery address')),
                ('total_price', models.IntegerField(verbose_name='Total price of order')),
                ('order_items', models.ManyToManyField(related_name='orderitem_orders', to='api.orderitem')),
            ],
            options={
                'ordering': ('-updated_at',),
                'abstract': False,
            },
        ),
        migrations.AddField(
            model_name='orderitem',
            name='product',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='product_orderitems', to='api.product'),
        ),
    ]
