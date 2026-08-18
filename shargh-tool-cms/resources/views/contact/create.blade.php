@extends('layouts.app')

@section('title', 'تماس با ما - شرکت ابزارسازی شرق')

@section('content')
<div class="card" style="max-width: 600px; margin: 0 auto;">
    <h2 style="margin-bottom: 30px; color: #1e3c72; text-align: center;">تماس با ما</h2>
    
    @if(session('success'))
    <div style="background: #d4edda; color: #155724; padding: 15px; border-radius: 5px; margin-bottom: 20px;">
        {{ session('success') }}
    </div>
    @endif
    
    <form action="{{ route('contact.store') }}" method="POST">
        @csrf
        
        <div style="margin-bottom: 20px;">
            <label for="name" style="display: block; margin-bottom: 8px; color: #333;">نام و نام خانوادگی *</label>
            <input type="text" name="name" id="name" value="{{ old('name') }}" required 
                style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px; font-family: inherit;"
                placeholder="نام خود را وارد کنید">
            @error('name')
            <p style="color: red; font-size: 13px; margin-top: 5px;">{{ $message }}</p>
            @enderror
        </div>
        
        <div style="margin-bottom: 20px;">
            <label for="email" style="display: block; margin-bottom: 8px; color: #333;">ایمیل *</label>
            <input type="email" name="email" id="email" value="{{ old('email') }}" required 
                style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px; font-family: inherit;"
                placeholder="example@email.com">
            @error('email')
            <p style="color: red; font-size: 13px; margin-top: 5px;">{{ $message }}</p>
            @enderror
        </div>
        
        <div style="margin-bottom: 20px;">
            <label for="phone" style="display: block; margin-bottom: 8px; color: #333;">شماره تماس</label>
            <input type="tel" name="phone" id="phone" value="{{ old('phone') }}" 
                style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px; font-family: inherit;"
                placeholder="09123456789">
            @error('phone')
            <p style="color: red; font-size: 13px; margin-top: 5px;">{{ $message }}</p>
            @enderror
        </div>
        
        <div style="margin-bottom: 20px;">
            <label for="subject" style="display: block; margin-bottom: 8px; color: #333;">موضوع</label>
            <input type="text" name="subject" id="subject" value="{{ old('subject') }}" 
                style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px; font-family: inherit;"
                placeholder="موضوع پیام خود را وارد کنید">
            @error('subject')
            <p style="color: red; font-size: 13px; margin-top: 5px;">{{ $message }}</p>
            @enderror
        </div>
        
        <div style="margin-bottom: 20px;">
            <label for="message" style="display: block; margin-bottom: 8px; color: #333;">پیام *</label>
            <textarea name="message" id="message" rows="5" required 
                style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px; font-family: inherit; resize: vertical;"
                placeholder="پیام خود را بنویسید...">{{ old('message') }}</textarea>
            @error('message')
            <p style="color: red; font-size: 13px; margin-top: 5px;">{{ $message }}</p>
            @enderror
        </div>
        
        <button type="submit" class="btn" style="width: 100%;">ارسال پیام</button>
    </form>
</div>
@endsection
