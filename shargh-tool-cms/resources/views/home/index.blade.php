@extends('layouts.app')

@section('title', 'خانه - شرکت ابزارسازی شرق')

@section('content')
<div class="card">
    <h2 style="margin-bottom: 20px; color: #1e3c72;">به شرکت ابزارسازی شرق خوش آمدید</h2>
    <p style="margin-bottom: 30px; font-size: 16px; line-height: 1.8;">
        شرکت ابزارسازی شرق با سال‌ها تجربه در زمینه تولید و تأمین ابزارآلات صنعتی، آماده ارائه بهترین محصولات و خدمات به مشتریان گرامی می‌باشد.
    </p>
    
    <div class="grid">
        <div class="card" style="text-align: center;">
            <h3 style="color: #2a5298; margin-bottom: 15px;">محصولات ما</h3>
            <p style="margin-bottom: 20px;">مجموعه‌ای کامل از ابزارآلات صنعتی با کیفیت بالا</p>
            <a href="{{ route('products.index') }}" class="btn">مشاهده محصولات</a>
        </div>
        
        <div class="card" style="text-align: center;">
            <h3 style="color: #2a5298; margin-bottom: 15px;">نمایشگاه‌ها</h3>
            <p style="margin-bottom: 20px;">آخرین رویدادها و نمایشگاه‌های شرکت</p>
            <a href="{{ route('exhibitions.index') }}" class="btn">مشاهده نمایشگاه‌ها</a>
        </div>
        
        <div class="card" style="text-align: center;">
            <h3 style="color: #2a5298; margin-bottom: 15px;">تماس با ما</h3>
            <p style="margin-bottom: 20px;">برای دریافت مشاوره با ما تماس بگیرید</p>
            <a href="{{ route('contact.create') }}" class="btn">تماس با ما</a>
        </div>
    </div>
</div>

@if($featuredProducts->count() > 0)
<div class="card" style="margin-top: 30px;">
    <h3 style="margin-bottom: 20px; color: #1e3c72;">محصولات ویژه</h3>
    <div class="grid">
        @foreach($featuredProducts as $product)
        <div class="card">
            @if($product->image)
            <img src="{{ asset('storage/' . $product->image) }}" alt="{{ $product->name }}" style="width: 100%; height: 200px; object-fit: cover; margin-bottom: 15px;">
            @endif
            <h4 style="color: #2a5298; margin-bottom: 10px;">{{ $product->name }}</h4>
            <p style="color: #666; margin-bottom: 10px; font-size: 14px;">{{ Str::limit($product->description, 100) }}</p>
            <p style="color: #1e3c72; font-weight: bold; margin-bottom: 15px;">{{ number_format($product->price) }} ریال</p>
            <a href="{{ route('products.show', $product->slug) }}" class="btn" style="display: block; text-align: center;">جزئیات بیشتر</a>
        </div>
        @endforeach
    </div>
</div>
@endif
@endsection
