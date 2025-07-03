<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- Modern Header Navigation -->
<nav class="modern-navbar">
    <div class="navbar-container">
        <!-- Logo -->
        <a href="Index.jsp" class="logo">GÖT</a>

        <!-- Desktop Menu -->
        <ul class="nav-menu">
            <li><a href="Index.jsp" class="nav-link">Inicio</a></li>
            <li><a href="Shop.jsp" class="nav-link">Tienda</a></li>
            <li><a href="Clientes.jsp" class="nav-link">Clientes</a></li>
            
            <li><a href="./admin/dashboard.jsp" class="nav-link">Admin</a></li>
        </ul>

        <!-- Desktop Icons -->
        <div class="nav-icons">
            <a href="#" class="nav-icon" data-bs-toggle="modal" data-bs-target="#searchModal">
                <i class="fa fa-search"></i>
            </a>
            <a href="#" class="nav-icon">
                <i class="fa fa-shopping-bag"></i>
                <span class="badge">3</span>
            </a>
            <a href="#" class="nav-icon">
                <i class="fa fa-heart"></i>
                <span class="badge">5</span>
            </a>
            <a href="#" class="nav-icon">
                <i class="fa fa-user"></i>
            </a>
        </div>

        <!-- Mobile Hamburger -->
        <button class="hamburger" onclick="toggleMobileMenu()">
            <span></span>
            <span></span>
            <span></span>
        </button>
    </div>
</nav>

<!-- Mobile Menu -->
<div class="mobile-menu" id="mobileMenu">
    <ul class="mobile-nav-menu">
        <li class="mobile-nav-item">
            <a href="Index.jsp" class="mobile-nav-link" onclick="closeMobileMenu()">Inicio</a>
        </li>
        <li class="mobile-nav-item">
            <a href="Shop.jsp" class="mobile-nav-link" onclick="closeMobileMenu()">Tienda</a>
        </li>
        <li class="mobile-nav-item">
            <a href="About.jsp" class="mobile-nav-link" onclick="closeMobileMenu()">Nosotros</a>
        </li>
        <li class="mobile-nav-item">
            <a href="Contact.jsp" class="mobile-nav-link" onclick="closeMobileMenu()">Contacto</a>
        </li>
    </ul>

    <!-- Mobile Icons -->
    <div class="mobile-nav-icons">
        <a href="#" class="mobile-nav-icon" onclick="closeMobileMenu()">
            <i class="fa fa-shopping-bag"></i>
            <span class="mobile-badge">3</span>
        </a>
        <a href="#" class="mobile-nav-icon" onclick="closeMobileMenu()">
            <i class="fa fa-heart"></i>
            <span class="mobile-badge">5</span>
        </a>
        <a href="#" class="mobile-nav-icon" onclick="closeMobileMenu()">
            <i class="fa fa-user"></i>
        </a>
    </div>
</div>

<!-- Menu Overlay -->
<div class="menu-overlay" id="menuOverlay" onclick="closeMobileMenu()"></div>
</head>
<body>

</body>
</html>