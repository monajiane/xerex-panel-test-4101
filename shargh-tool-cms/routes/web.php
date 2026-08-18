<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\ExhibitionController;
use App\Http\Controllers\ContactController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\CategoryController as AdminCategoryController;
use App\Http\Controllers\Admin\ProductController as AdminProductController;
use App\Http\Controllers\Admin\ExhibitionController as AdminExhibitionController;
use App\Http\Controllers\Admin\ContactController as AdminContactController;

// Frontend Routes
Route::get('/', [HomeController::class, 'index'])->name('home');
Route::get('/products', [ProductController::class, 'index'])->name('products.index');
Route::get('/products/{slug}', [ProductController::class, 'show'])->name('products.show');
Route::get('/exhibitions', [ExhibitionController::class, 'index'])->name('exhibitions.index');
Route::get('/exhibitions/{slug}', [ExhibitionController::class, 'show'])->name('exhibitions.show');
Route::get('/contact', [ContactController::class, 'create'])->name('contact.create');
Route::post('/contact', [ContactController::class, 'store'])->name('contact.store');

// Admin Routes
Route::prefix('admin')->name('admin.')->group(function () {
    Route::get('/', [DashboardController::class, 'index'])->name('dashboard');
    
    // Categories
    Route::resource('categories', AdminCategoryController::class);
    
    // Products
    Route::resource('products', AdminProductController::class);
    
    // Exhibitions
    Route::resource('exhibitions', AdminExhibitionController::class);
    
    // Contacts
    Route::resource('contacts', AdminContactController::class)->only(['index', 'show', 'destroy']);
});
