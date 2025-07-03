<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<!-- Hero Carousel -->
<div id="heroCarousel" class="carousel slide hero-carousel" data-bs-ride="carousel" data-bs-wrap="true">
    <div class="carousel-inner">
        
        <!-- Slide 1: VIDEO -->
        <div class="carousel-item active">
            <div class="hero-video-slide">
                <video class="hero-video" autoplay muted loop playsinline>
                    <source src="./videos/mujer-corriendo.mp4" type="video/mp4">
                    <source src="./videos/mujer-corriendo.webm" type="video/webm">
                </video>
                <div class="hero-overlay"></div>
                <div class="container">
                    <div class="hero-content">
                        <h1 class="hero-title">Eleva Tu Estilo Atlético</h1>
                        <p class="hero-subtitle">
                            Descubre la nueva colección GÖT Sportwear donde el rendimiento se encuentra con el estilo
                        </p>
                        <a href="Shop.jsp" class="cta-button">Explorar Colección</a>
                        <a href="ShopSingle.jsp?id=4" class="cta-button">Ver Productos</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Slide 2: VIDEO -->
        <div class="carousel-item">
            <div class="hero-video-slide">
                <video class="hero-video" autoplay muted loop playsinline>
                    <source src="./videos/rendimiento.mp4" type="video/mp4">
                    <source src="./videos/rendimiento.webm" type="video/webm">
                </video>
                <div class="hero-overlay"></div>
                <div class="container">
                    <div class="hero-content">
                        <h1 class="hero-title">Rendimiento Extremo</h1>
                        <p class="hero-subtitle">
                            Ropa deportiva diseñada para atletas que buscan la excelencia
                        </p>
                        <a href="ShopSingle.jsp?id=5" class="cta-button">Ver Productos</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Slide 3: VIDEO -->
        <div class="carousel-item">
            <div class="hero-video-slide">
                <video class="hero-video" autoplay muted loop playsinline>
                    <source src="./videos/urbano.mp4" type="video/mp4">
                    <source src="./videos/urbano.webm" type="video/webm">
                </video>
                <div class="hero-overlay"></div>
                <div class="container">
                    <div class="hero-content">
                        <h1 class="hero-title">Estilo Urbano</h1>
                        <p class="hero-subtitle">
                            Combina comodidad y moda en cada movimiento
                        </p>
                        <a href="ShopSingle.jsp?id=6" class="cta-button">Comprar Ahora</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Controles -->
    <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
        <i class="fa fa-chevron-left" aria-hidden="true"></i>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
        <i class="fa fa-chevron-right" aria-hidden="true"></i>
    </button>

    <!-- Indicadores -->
    <div class="carousel-indicators">
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active" aria-current="true"></button>
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
    </div>
</div>

</body>
</html>