@extends('layouts.app')

@section('title', 'نمایشگاه‌ها - شرکت ابزارسازی شرق')

@section('content')
<h2 style="margin-bottom: 30px; color: #1e3c72;">نمایشگاه‌ها و رویدادها</h2>

<div class="grid">
    @forelse($exhibitions as $exhibition)
    <div class="card">
        @if($exhibition->image)
        <img src="{{ asset('storage/' . $exhibition->image) }}" alt="{{ $exhibition->title }}" style="width: 100%; height: 200px; object-fit: cover; margin-bottom: 15px;">
        @endif
        <h3 style="color: #2a5298; margin-bottom: 10px;">{{ $exhibition->title }}</h3>
        <p style="color: #666; margin-bottom: 10px; font-size: 14px;">{{ Str::limit($exhibition->description, 100) }}</p>
        @if($exhibition->start_date)
        <p style="color: #666; font-size: 13px; margin-bottom: 15px;">
            تاریخ: {{ $exhibition->start_date->format('Y/m/d') }}
            @if($exhibition->end_date)
            تا {{ $exhibition->end_date->format('Y/m/d') }}
            @endif
        </p>
        @endif
        <a href="{{ route('exhibitions.show', $exhibition->slug) }}" class="btn" style="display: block; text-align: center;">جزئیات بیشتر</a>
    </div>
    @empty
    <p style="text-align: center; grid-column: 1/-1; padding: 40px;">هیچ نمایشگاهی یافت نشد.</p>
    @endforelse
</div>
@endsection
