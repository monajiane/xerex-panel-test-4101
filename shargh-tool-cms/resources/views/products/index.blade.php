@extends('layouts.app')

@section('title', 'محصولات - شرکت ابزارسازی شرق')

@section('content')
<h2 style="margin-bottom: 30px; color: #1e3c72;">محصولات</h2>

<div class="grid">
    @forelse($products as $product)
    <div class="card">
        @if($product->image)
        <img src="{{ asset('storage/' . $product->image) }}" alt="{{ $product->name }}" style="width: 100%; height: 200px; object-fit: cover; margin-bottom: 15px;">
        @endif
        <h3 style="color: #2a5298; margin-bottom: 10px;">{{ $product->name }}</h3>
        <p style="color: #666; margin-bottom: 10px; font-size: 14px;">{{ Str::limit($product->description, 100) }}</p>
        <p style="color: #1e3c72; font-weight: bold; margin-bottom: 15px;">{{ number_format($product->price) }} ریال</p>
        <a href="{{ route('products.show', $product->slug) }}" class="btn" style="display: block; text-align: center;">جزئیات بیشتر</a>
    </div>
    @empty
    <p style="text-align: center; grid-column: 1/-1; padding: 40px;">هیچ محصولی یافت نشد.</p>
    @endforelse
</div>
@endsection
