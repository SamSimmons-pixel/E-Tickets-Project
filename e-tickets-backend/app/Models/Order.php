<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;
    protected $guarded = ['id'];
    protected $table = 'orders';
    protected $fillable = [
        'transaction_time',
        'total_item',
        'payment_amount',
        'cashier_id',
        'cashier_name',
        'payment_method',
        'total_price',
    ];

    public function order_items() {
        return $this->hasMany(OrderItem::class);
    }
}
