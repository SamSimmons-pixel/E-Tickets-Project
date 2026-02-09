<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderItem;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'transaction_time' => 'required',
            'total_price' => 'required|integer',
            'total_item' => 'required|integer',
            'payment_amount' => 'required|integer',
            'payment_method' => 'required|string',
            'cashier_id' => 'required|exists:users,id',
            'cashier_name' => 'required|string',
            'orders_items' => 'required|array',
        ]);

        $order = new Order;
        $order->transaction_time = $request->transaction_time;
        $order->total_price = $request->total_price;
        $order->total_item = $request->total_item;
        $order->payment_amount = $request->payment_amount;
        $order->payment_method = $request->payment_method;
        $order->cashier_id = $request->cashier_id;
        $order->cashier_name = $request->cashier_name;
        $order->save();

        foreach ($request->orders_items as $item) {
            $orderItem = new OrderItem();
            $orderItem->order_id = $order->id;
            $orderItem->product_id = $item['product_id'];
            $orderItem->quantity = $item['quantity'];
            $orderItem->price = $item['price'];
            $orderItem->total_price = $item['total_price'];
            $orderItem->save();
        }


        return response()->json([
            'status' => 'success',
            'data' => $order
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
