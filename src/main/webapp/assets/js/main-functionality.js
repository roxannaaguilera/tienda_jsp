// ===== MAIN FUNCTIONALITY JAVASCRIPT =====

// Variables globales
let mobileMenuOpen = false;

// ===== MOBILE MENU FUNCTIONALITY =====
function toggleMobileMenu() {
    const mobileMenu = document.getElementById('mobileMenu');
    const menuOverlay = document.getElementById('menuOverlay');
    const hamburger = document.querySelector('.hamburger');
    
    mobileMenuOpen = !mobileMenuOpen;
    
    if (mobileMenuOpen) {
        mobileMenu.classList.add('active');
        menuOverlay.classList.add('active');
        hamburger.classList.add('active');
        document.body.style.overflow = 'hidden';
    } else {
        mobileMenu.classList.remove('active');
        menuOverlay.classList.remove('active');
        hamburger.classList.remove('active');
        document.body.style.overflow = 'auto';
    }
}

function closeMobileMenu() {
    const mobileMenu = document.getElementById('mobileMenu');
    const menuOverlay = document.getElementById('menuOverlay');
    const hamburger = document.querySelector('.hamburger');
    
    mobileMenu.classList.remove('active');
    menuOverlay.classList.remove('active');
    hamburger.classList.remove('active');
    document.body.style.overflow = 'auto';
    mobileMenuOpen = false;
}

// ===== CAROUSEL MOBILE FUNCTIONALITY =====
function handleCarouselForMobile() {
    const isMobile = window.innerWidth <= 768;
	document.querySelectorAll('.carousel').forEach(carousel => {
	    // lógica para cada carrusel encontrado
	});

    if (!carousel) return;
    
    if (isMobile) {
        console.log('Modo móvil: deshabilitando carrusel');
        
        // Deshabilitar carrusel en móvil
        carousel.classList.remove('slide');
        carousel.removeAttribute('data-bs-ride');
        
        // Mostrar todos los carousel-item
        const carouselItems = carousel.querySelectorAll('.carousel-item');
        carouselItems.forEach(function(item) {
            item.style.display = 'block';
            item.style.position = 'static';
            item.style.transform = 'none';
            item.style.opacity = '1';
            item.style.visibility = 'visible';
        });
        
        // Ocultar controles
        const prevControl = carousel.querySelector('.carousel-control-prev');
        const nextControl = carousel.querySelector('.carousel-control-next');
        
        if (prevControl) prevControl.style.display = 'none';
        if (nextControl) nextControl.style.display = 'none';
        
        // Destruir instancia de Bootstrap Carousel
        if (typeof bootstrap !== 'undefined' && bootstrap.Carousel) {
            const bsCarousel = bootstrap.Carousel.getInstance(carousel);
            if (bsCarousel) {
                bsCarousel.dispose();
            }
        }
        
    } else {
        console.log('Modo desktop: manteniendo carrusel original');
        
        // Restaurar funcionalidad de carrusel para desktop
        if (!carousel.classList.contains('slide')) {
            carousel.classList.add('slide');
        }
        
        if (!carousel.hasAttribute('data-bs-ride')) {
            carousel.setAttribute('data-bs-ride', 'carousel');
        }
        
        // Resetear estilos inline
        const carouselItems = carousel.querySelectorAll('.carousel-item');
        carouselItems.forEach(function(item, index) {
            item.style.display = '';
            item.style.position = '';
            item.style.transform = '';
            item.style.opacity = '';
            item.style.visibility = '';
            
            if (index === 0) {
                item.classList.add('active');
            } else {
                item.classList.remove('active');
            }
        });
        
        // Mostrar controles
        const prevControl = carousel.querySelector('.carousel-control-prev');
        const nextControl = carousel.querySelector('.carousel-control-next');
        
        if (prevControl) prevControl.style.display = '';
        if (nextControl) nextControl.style.display = '';
    }
}

// ===== NAVBAR SCROLL EFFECT =====
function handleNavbarScroll() {
    const navbar = document.querySelector('.modern-navbar');
    if (window.scrollY > 50) {
        navbar.style.background = 'rgba(255, 255, 255, 0.98)';
        navbar.style.boxShadow = '0 8px 32px rgba(0, 0, 0, 0.15)';
    } else {
        navbar.style.background = 'rgba(255, 255, 255, 0.95)';
        navbar.style.boxShadow = '0 8px 32px rgba(0, 0, 0, 0.1)';
    }
}

// ===== SMOOTH SCROLLING =====
function initSmoothScrolling() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}

// ===== INTERSECTION OBSERVER FOR ANIMATIONS =====
function initAnimationObserver() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    const fadeElements = document.querySelectorAll('.fade-in-up');
    fadeElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'all 0.8s ease';
        observer.observe(el);
    });
}

// ===== VIDEO CONTROL =====
function initVideoControl() {
    const heroCarousel = document.getElementById('heroCarousel');
    if (heroCarousel) {
        heroCarousel.addEventListener('slide.bs.carousel', function (e) {
            const videos = document.querySelectorAll('.hero-video');
            videos.forEach((video, index) => {
                if (index === e.to) {
                    video.play().catch(error => console.log('Video autoplay blocked:', error));
                } else {
                    video.pause();
                }
            });
        });

        // Reproducir primer video al cargar
        const firstVideo = document.querySelector('.hero-video');
        if (firstVideo) {
            firstVideo.play().catch(error => console.log('Video autoplay blocked:', error));
        }
    }
}

// ===== NOTIFICATION SYSTEM =====
function showNotification(message, type = 'success') {
    const toast = document.createElement('div');
    toast.className = `toast-notification toast-${type}`;
    toast.innerHTML = message;
    toast.style.cssText = `
        position: fixed;
        top: 100px;
        right: 20px;
        background: var(--secondary-gradient);
        color: white;
        padding: 1rem 1.5rem;
        border-radius: 25px;
        z-index: 9999;
        animation: slideIn 0.3s ease;
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
    `;
    
    document.body.appendChild(toast);
    
    setTimeout(() => {
        toast.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

// ===== NEWSLETTER SUBSCRIPTION =====
function handleNewsletterSubscription() {
    const newsletterBtn = document.querySelector('.newsletter-btn');
    const newsletterInput = document.querySelector('.newsletter-input');
    
    if (newsletterBtn && newsletterInput) {
        newsletterBtn.addEventListener('click', function() {
            const email = newsletterInput.value.trim();
            if (email && isValidEmail(email)) {
                // Aquí conectar con tu backend
                showNotification(`¡Gracias por suscribirte! Recibirás nuestras novedades en ${email}`);
                newsletterInput.value = '';
            } else {
                showNotification('Por favor, ingresa un email válido', 'error');
            }
        });
    }
}

// ===== EMAIL VALIDATION =====
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// ===== EVENT LISTENERS =====
function initEventListeners() {
    // Resize handler
    let wasDesktop = window.innerWidth > 768;
    window.addEventListener('resize', function() {
        const isDesktopNow = window.innerWidth > 768;
        
        // Mobile menu close on resize
        if (window.innerWidth > 768 && mobileMenuOpen) {
            closeMobileMenu();
        }
        
        // Carousel handling
        if (wasDesktop !== isDesktopNow) {
            setTimeout(function() {
                handleCarouselForMobile();
                wasDesktop = isDesktopNow;
            }, 100);
        }
    });

    // Scroll handler
    window.addEventListener('scroll', handleNavbarScroll);

    // ESC key handler
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && mobileMenuOpen) {
            closeMobileMenu();
        }
    });

    // Newsletter subscription
    handleNewsletterSubscription();
}

// ===== INITIALIZATION =====
document.addEventListener('DOMContentLoaded', function() {
    console.log('Inicializando funcionalidades...');
    
    // Inicializar todas las funcionalidades
    initSmoothScrolling();
    initAnimationObserver();
    initVideoControl();
    initEventListeners();
    handleCarouselForMobile();
    
    console.log('Todas las funcionalidades inicializadas correctamente');
});

// Ejecutar también en load para asegurar compatibilidad
window.addEventListener('load', function() {
    // Forzar productos visibles en móvil
    if (window.innerWidth <= 768) {
        const carousel = document.getElementById('featuredCarousel');
        if (carousel) {
            const allItems = carousel.querySelectorAll('.carousel-item');
            allItems.forEach(function(item) {
                item.style.display = 'block';
                item.style.position = 'static';
                item.style.transform = 'translateX(0px)';
                item.style.opacity = '1';
            });
        }
    }
});

// ===== CSS ANIMATIONS =====
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    
    @keyframes slideOut {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }
    
    .toast-error {
        background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%) !important;
    }
`;
document.head.appendChild(style);

/**
 * FEATURED PRODUCTS FUNCTIONALITY
 * Funcionalidades para la sección de productos destacados
 */

document.addEventListener('DOMContentLoaded', function() {
    
    // ===== LAZY LOADING DE IMÁGENES =====
    function initLazyLoading() {
        const images = document.querySelectorAll('.product-main-image, .product-hover-image');
        
        if ('IntersectionObserver' in window) {
            const imageObserver = new IntersectionObserver((entries, observer) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        img.classList.add('loaded');
                        observer.unobserve(img);
                    }
                });
            }, {
                threshold: 0.1,
                rootMargin: '50px'
            });
            
            images.forEach(img => imageObserver.observe(img));
        } else {
            // Fallback para navegadores sin soporte
            images.forEach(img => img.classList.add('loaded'));
        }
    }

    // ===== FUNCIONALIDAD DE SELECCIÓN DE COLORES =====
    function initColorSelection() {
        const colorCircles = document.querySelectorAll('.color-circle');
        
        colorCircles.forEach(circle => {
            circle.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                // Remover selección previa en la tarjeta actual
                const parentCard = this.closest('.modern-product-card');
                const siblingCircles = parentCard.querySelectorAll('.color-circle');
                siblingCircles.forEach(c => c.classList.remove('active'));
                
                // Agregar selección al color clickeado
                this.classList.add('active');
                
                // Feedback visual opcional
                const colorName = this.getAttribute('title') || 'Color seleccionado';
                console.log(`Color seleccionado: ${colorName}`);
                
                // Opcional: Mostrar notificación temporal
                showColorFeedback(this, colorName);
            });
        });
    }

    // ===== PREVENIR CONFLICTOS DE NAVEGACIÓN =====
    function initNavigationHandling() {
        // Prevenir navegación cuando se hace click en el carrito
        const cartIcons = document.querySelectorAll('.shopping-bag-icon');
        cartIcons.forEach(icon => {
            icon.addEventListener('click', function(e) {
                e.stopPropagation();
            });
        });

        // Prevenir navegación en la fila de colores
        const colorRows = document.querySelectorAll('.product-colors-row');
        colorRows.forEach(row => {
            row.addEventListener('click', function(e) {
                e.stopPropagation();
            });
        });
    }

    // ===== FEEDBACK VISUAL PARA SELECCIÓN DE COLOR =====
    function showColorFeedback(element, colorName) {
        // Crear elemento de feedback temporal
        const feedback = document.createElement('div');
        feedback.className = 'color-feedback';
        feedback.textContent = colorName;
        feedback.style.cssText = `
            position: absolute;
            background: rgba(0,0,0,0.8);
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 10px;
            z-index: 1000;
            pointer-events: none;
            opacity: 0;
            transition: opacity 0.2s ease;
            white-space: nowrap;
        `;

        // Posicionar el feedback
        const rect = element.getBoundingClientRect();
        feedback.style.left = `${rect.left}px`;
        feedback.style.top = `${rect.top - 30}px`;

        document.body.appendChild(feedback);

        // Mostrar y ocultar
        setTimeout(() => feedback.style.opacity = '1', 10);
        setTimeout(() => {
            feedback.style.opacity = '0';
            setTimeout(() => {
                if (feedback.parentNode) {
                    feedback.parentNode.removeChild(feedback);
                }
            }, 200);
        }, 1500);
    }

    // ===== ANIMACIONES DE HOVER MEJORADAS =====
    function initHoverAnimations() {
        const productCards = document.querySelectorAll('.modern-product-card');
        
        productCards.forEach(card => {
            const imageWrapper = card.querySelector('.product-image-wrapper');
            
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });
    }

    // ===== MANEJO DE ERRORES DE IMÁGENES =====
    function initImageErrorHandling() {
        const images = document.querySelectorAll('.product-main-image, .product-hover-image');
        
        images.forEach(img => {
            img.addEventListener('error', function() {
                if (!this.dataset.fallbackAttempted) {
                    this.dataset.fallbackAttempted = 'true';
                    
                    // Intentar con imagen por defecto
                    if (this.classList.contains('product-main-image')) {
                        this.src = 'assets/img/default_product.jpg';
                    } else {
                        this.src = 'assets/img/default_product_hover.jpg';
                    }
                }
            });
        });
    }

    // ===== ANALYTICS Y TRACKING (OPCIONAL) =====
    function initAnalytics() {
        const productLinks = document.querySelectorAll('.product-title, .product-image-wrapper a');
        
        productLinks.forEach(link => {
            link.addEventListener('click', function() {
                const productCard = this.closest('.modern-product-card');
                const productTitle = productCard.querySelector('.product-title').textContent;
                const productPrice = productCard.querySelector('.product-price').textContent;
                
                // Ejemplo de tracking (Google Analytics, etc.)
                if (typeof gtag !== 'undefined') {
                    gtag('event', 'product_click', {
                        'product_name': productTitle,
                        'product_price': productPrice,
                        'section': 'featured_products'
                    });
                }
                
                console.log(`Producto clickeado: ${productTitle} - ${productPrice}`);
            });
        });
    }

    // ===== INICIALIZAR TODAS LAS FUNCIONALIDADES =====
    function initFeaturedProducts() {
        try {
            initLazyLoading();
            initColorSelection();
            initNavigationHandling();
            initHoverAnimations();
            initImageErrorHandling();
            initAnalytics();
            
            console.log('✅ Featured Products initialized successfully');
        } catch (error) {
            console.error('❌ Error initializing Featured Products:', error);
        }
    }

    // Ejecutar inicialización
    initFeaturedProducts();

    // ===== UTILIDADES PÚBLICAS =====
    window.FeaturedProducts = {
        refreshLazyLoading: initLazyLoading,
        refreshColorSelection: initColorSelection,
        init: initFeaturedProducts
    };
});

/**
 * UTILIDADES ADICIONALES
 */

// Función para actualizar productos dinámicamente (si cargas vía AJAX)
function refreshFeaturedProducts() {
    if (window.FeaturedProducts) {
        window.FeaturedProducts.init();
    }
}

// Función para obtener color seleccionado de un producto
function getSelectedColor(productCard) {
    const activeColor = productCard.querySelector('.color-circle.active');
    return activeColor ? activeColor.getAttribute('title') : null;
}