@extends('layouts.app')

@section('title', $exhibition->title . ' - شرکت ابزارسازی شرق')

@section('content')
<div class="card">
    @if($exhibition->image)
    <img src="{{ asset('storage/' . $exhibition->image) }}" alt="{{ $exhibition->title }}" style="width: 100%; height: 400px; object-fit: cover; margin-bottom: 30px;">
    @endif
    
    <h2 style="color: #1e3c72; margin-bottom: 15px;">{{ $exhibition->title }}</h2>
    
    <div style="display: flex; gap: 20px; margin-bottom: 30px; flex-wrap: wrap;">
        @if($exhibition->start_date)
        <p style="color: #666; font-size: 14px;">
            <strong>تاریخ شروع:</strong> {{ $exhibition->start_date->format('Y/m/d') }}
        </p>
        @endif
        @if($exhibition->end_date)
        <p style="color: #666; font-size: 14px;">
            <strong>تاریخ پایان:</strong> {{ $exhibition->end_date->format('Y/m/d') }}
        </p>
        @endif
        @if($exhibition->location)
        <p style="color: #666; font-size: 14px;">
            <strong>مکان:</strong> {{ $exhibition->location }}
        </p>
        @endif
    </div>
    
    <div style="line-height: 1.8; color: #333;">
        {!! nl2br(e($exhibition->content)) !!}
    </div>
    
    <a href="{{ route('exhibitions.index') }}" class="btn" style="display: inline-block; margin-top: 30px;">بازگشت به لیست نمایشگاه‌ها</a>
</div>
@endsection
