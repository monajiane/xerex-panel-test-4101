@extends('layouts.app')

@section('title', $product->name . ' - شرکت ابزارسازی شرق')

@section('content')
<div class="card">
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
        <div>
            @if($product->image)
            <img src="{{ asset('storage/' . $product->image) }}" alt="{{ $product->name }}" style="width: 100%; height: 400px; object-fit: cover;">
            @endif
        </div>
        <div>
            <h2 style="color: #1e3c72; margin-bottom: 15px;">{{ $product->name }}</h2>
            <p style="color: #666; margin-bottom: 20px; font-size: 14px;">دسته‌بندی: {{ $product->category->name ?? 'بدون دسته‌بندی' }}</p>
            <p style="color: #1e3c72; font-weight: bold; font-size: 24px; margin-bottom: 20px;">{{ number_format($product->price) }} ریال</p>
            <p style="margin-bottom: 20px; line-height: 1.8;">{{ $product->description }}</p>
            
            @if($product->specifications)
            <h4 style="color: #2a5298; margin-bottom: 10px;">مشخصات فنی:</h4>
            <p style="color: #666; margin-bottom: 20px; white-space: pre-line;">{{ $product->specifications }}</p>
            @endif
            
            <p style="color: {{ $product->stock > 0 ? 'green' : 'red' }}; margin-bottom: 20px;">
                وضعیت موجودی: {{ $product->stock > 0 ? 'موجود در انبار' : 'ناموجود' }}
            </p>
            
            <a href="{{ route('products.index') }}" class="btn" style="display: inline-block;">بازگشت به لیست محصولات</a>
        </div>
    </div>
</div>
@endsection
