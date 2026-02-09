<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Casts\Attribute;

class Product extends Model
{
    use HasFactory;

    protected $guarded = ['id'];

    public function category() {
        return $this->belongsTo(Category::class);
    }

    public function image() {
        return Attribute::make(
            get: fn($image) => $image ? url('/storage/', $image) : null,
        );
    }

    protected $fillable = [
        'category_id',
        'name',
        'description',
        'image',
        'price',
        'stock',
        'status',
        'criteria',
        'favorite',
    ];
}
