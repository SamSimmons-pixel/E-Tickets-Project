<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Product;

class ProductController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $request = request();
        $product = Product::when(request()->has('category_id'), function ($query) use ($request) {
            $query->where('category_id', $request->category_id);
        })->get();

        $product->load('category');

        return response()->json([
            'status' => 'success',
            'data' => $product
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'price' => 'required|integer',
            'category_id' => 'required',
            'stock' => 'required|integer',
            'image' => 'image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);
        $data = $request->all();
        if ($request->hasFile('image')) {
            $image = $request->file('image');
            $imageName = time() . '.' . $image->getClientOriginalExtension();
            $image->move(public_path('images'), $imageName);
            $data['image'] = $imageName;
        }

        $product = Product::create($data);
        return response()->json([
            'status' => 'success',
            'data' => $product
        ]);

        return response()->json([
            'status' => 'success',
            'message' => $product
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $product = Product::find($id);
        $product->load('category');
        return response()->json([
            'status' => 'success',
            'data' => $product
        ]);
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
        $product = Product::find($id);
        $product->delete();
        return response()->json([
            'status' => 'success',
            'message' => $product->name . " Deleted Successfully!"
        ]);
    }
}
