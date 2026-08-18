<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'شرکت ابزارسازی شرق')</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: Tahoma, Arial, sans-serif;
            background-color: #f5f5f5;
            color: #333;
            line-height: 1.6;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        header {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            padding: 20px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo h1 {
            font-size: 24px;
            font-weight: bold;
        }
        nav ul {
            list-style: none;
            display: flex;
            gap: 20px;
        }
        nav a {
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            transition: background 0.3s;
        }
        nav a:hover {
            background: rgba(255,255,255,0.2);
        }
        main {
            padding: 40px 0;
            min-height: calc(100vh - 200px);
        }
        footer {
            background: #2c3e50;
            color: white;
            padding: 30px 0;
            text-align: center;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: #1e3c72;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn:hover {
            background: #2a5298;
        }
        .card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
        }
    </style>
    @stack('styles')
</head>
<body>
    <header>
        <div class="container header-content">
            <div class="logo">
                <h1>شرکت ابزارسازی شرق</h1>
            </div>
            <nav>
                <ul>
                    <li><a href="{{ route('home') }}">خانه</a></li>
                    <li><a href="{{ route('products.index') }}">محصولات</a></li>
                    <li><a href="{{ route('exhibitions.index') }}">نمایشگاه‌ها</a></li>
                    <li><a href="{{ route('contact.create') }}">تماس با ما</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <main>
        <div class="container">
            @yield('content')
        </div>
    </main>

    <footer>
        <div class="container">
            <p>&copy; {{ date('Y') }} شرکت ابزارسازی شرق. تمامی حقوق محفوظ است.</p>
        </div>
    </footer>

    @stack('scripts')
</body>
</html>
