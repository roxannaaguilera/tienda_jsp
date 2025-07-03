<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<!-- Search Modal -->
<div class="modal fade" id="searchModal" tabindex="-1" aria-labelledby="searchModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold" id="searchModalLabel">
                    <i class="fa fa-search me-2 text-primary"></i>
                    Buscar Productos
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="Shop.jsp" method="GET" id="searchForm">
                    <div class="input-group input-group-lg mb-3">
                        <input type="text" 
                               class="form-control" 
                               name="search"
                               id="searchInput"
                               placeholder="¿Qué estás buscando?"
                               style="border-radius: 25px 0 0 25px; border: 2px solid #e9ecef; font-size: 1.1rem;">
                        <button class="btn btn-primary px-4" 
                                type="submit"
                                style="border-radius: 0 25px 25px 0; background: var(--secondary-gradient); border: none; font-size: 1.1rem;">
                            <i class="fa fa-search"></i>
                        </button>
                    </div>
                </form>

                <!-- Sugerencias de búsqueda -->
                <div class="search-suggestions">
                    <small class="text-muted d-block mb-2">Sugerencias populares:</small>
                    <div class="d-flex flex-wrap gap-2">
                        <span class="badge bg-light text-dark search-suggestion" 
                              style="cursor: pointer; padding: 0.5rem 1rem; font-size: 0.85rem;"
                              onclick="searchSuggestion('mallas')">
                            Mallas
                        </span>
                        <span class="badge bg-light text-dark search-suggestion" 
                              style="cursor: pointer; padding: 0.5rem 1rem; font-size: 0.85rem;"
                              onclick="searchSuggestion('sports bra')">
                            Sports Bra
                        </span>
                        <span class="badge bg-light text-dark search-suggestion" 
                              style="cursor: pointer; padding: 0.5rem 1rem; font-size: 0.85rem;"
                              onclick="searchSuggestion('running')">
                            Running
                        </span>
                        <span class="badge bg-light text-dark search-suggestion" 
                              style="cursor: pointer; padding: 0.5rem 1rem; font-size: 0.85rem;"
                              onclick="searchSuggestion('yoga')">
                            Yoga
                        </span>
                        <span class="badge bg-light text-dark search-suggestion" 
                              style="cursor: pointer; padding: 0.5rem 1rem; font-size: 0.85rem;"
                              onclick="searchSuggestion('fitness')">
                            Fitness
                        </span>
                        <span class="badge bg-light text-dark search-suggestion" 
                              style="cursor: pointer; padding: 0.5rem 1rem; font-size: 0.85rem;"
                              onclick="searchSuggestion('ofertas')">
                            Ofertas
                        </span>
                    </div>
                </div>

                <!-- Búsqueda rápida por categorías -->
                <div class="quick-categories mt-4">
                    <small class="text-muted d-block mb-2">Buscar por categoría:</small>
                    <div class="row">
                        <div class="col-6 col-md-4 mb-2">
                            <a href="Shop.jsp?categoria=sujetadores" class="btn btn-outline-secondary btn-sm w-100">
                                <i class="fa fa-heart me-1"></i>Sujetadores
                            </a>
                        </div>
                        <div class="col-6 col-md-4 mb-2">
                            <a href="Shop.jsp?categoria=mallas" class="btn btn-outline-secondary btn-sm w-100">
                                <i class="fa fa-running me-1"></i>Mallas
                            </a>
                        </div>
                        <div class="col-6 col-md-4 mb-2">
                            <a href="Shop.jsp?categoria=tops" class="btn btn-outline-secondary btn-sm w-100">
                                <i class="fa fa-tshirt me-1"></i>Tops
                            </a>
                        </div>
                        <div class="col-6 col-md-4 mb-2">
                            <a href="Shop.jsp?categoria=calzado" class="btn btn-outline-secondary btn-sm w-100">
                                <i class="fa fa-shoe-prints me-1"></i>Calzado
                            </a>
                        </div>
                        <div class="col-6 col-md-4 mb-2">
                            <a href="Shop.jsp?categoria=accesorios" class="btn btn-outline-secondary btn-sm w-100">
                                <i class="fa fa-dumbbell me-1"></i>Accesorios
                            </a>
                        </div>
                        <div class="col-6 col-md-4 mb-2">
                            <a href="Shop.jsp?categoria=ofertas" class="btn btn-outline-danger btn-sm w-100">
                                <i class="fa fa-fire me-1"></i>Ofertas
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Quick View Product Modal -->
<div class="modal fade" id="quickViewModal" tabindex="-1" aria-labelledby="quickViewModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header border-0">
                <h5 class="modal-title fw-bold" id="quickViewModalLabel">
                    <i class="fa fa-eye me-2 text-primary"></i>
                    Vista Rápida
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="quickViewContent">
                <!-- Contenido cargado dinámicamente -->
                <div class="text-center py-5">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Cargando...</span>
                    </div>
                    <p class="mt-3 text-muted">Cargando información del producto...</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Newsletter Signup Modal -->
<div class="modal fade" id="newsletterModal" tabindex="-1" aria-labelledby="newsletterModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
            <div class="modal-header border-0 text-white">
                <h5 class="modal-title fw-bold" id="newsletterModalLabel">
                    <i class="fa fa-envelope me-2"></i>
                    ¡Únete a nuestra comunidad!
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-white">
                <div class="text-center mb-4">
                    <i class="fa fa-gift fa-3x mb-3" style="color: #ff6b9d;"></i>
                    <h4 class="fw-bold">10% de descuento</h4>
                    <p>En tu primera compra + ofertas exclusivas</p>
                </div>
                
                <form id="newsletterSignupForm">
                    <div class="mb-3">
                        <input type="email" 
                               class="form-control form-control-lg" 
                               id="newsletterEmail"
                               placeholder="Tu email"
                               required
                               style="border-radius: 25px; border: 2px solid rgba(255,255,255,0.3); background: rgba(255,255,255,0.1); color: white;">
                    </div>
                    <div class="mb-3">
                        <input type="text" 
                               class="form-control form-control-lg" 
                               id="newsletterName"
                               placeholder="Tu nombre (opcional)"
                               style="border-radius: 25px; border: 2px solid rgba(255,255,255,0.3); background: rgba(255,255,255,0.1); color: white;">
                    </div>
                    <button type="submit" 
                            class="btn btn-light btn-lg w-100 fw-bold"
                            style="border-radius: 25px; color: #667eea;">
                        <i class="fa fa-paper-plane me-2"></i>
                        ¡Quiero mi descuento!
                    </button>
                </form>
                
                <div class="text-center mt-3">
                    <small style="opacity: 0.8;">
                        *Válido para nuevos suscriptores. Términos y condiciones aplican.
                    </small>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Cart Preview Modal -->
<div class="modal fade" id="cartModal" tabindex="-1" aria-labelledby="cartModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header border-0">
                <h5 class="modal-title fw-bold" id="cartModalLabel">
                    <i class="fa fa-shopping-bag me-2 text-primary"></i>
                    Mi Carrito
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="cartContent">
                <!-- Contenido del carrito cargado dinámicamente -->
                <div class="text-center py-5">
                    <i class="fa fa-shopping-bag fa-3x text-muted mb-3"></i>
                    <h5 class="text-muted">Tu carrito está vacío</h5>
                    <p class="text-muted">¡Agrega algunos productos increíbles!</p>
                    <a href="Shop.jsp" class="btn btn-primary">
                        <i class="fa fa-shopping-cart me-2"></i>
                        Ir de compras
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Funciones para los modales
function searchSuggestion(term) {
    document.getElementById('searchInput').value = term;
    document.getElementById('searchForm').submit();
}

// Auto-focus en el input de búsqueda cuando se abre el modal
document.getElementById('searchModal').addEventListener('shown.bs.modal', function () {
    document.getElementById('searchInput').focus();
});

// Newsletter signup
document.getElementById('newsletterSignupForm')?.addEventListener('submit', function(e) {
    e.preventDefault();
    const email = document.getElementById('newsletterEmail').value;
    const name = document.getElementById('newsletterName').value;
    
    // Aquí conectar con el backend
    showNotification(`¡Gracias ${name || 'por suscribirte'}! Recibirás tu código de descuento en ${email}`);
    
    // Cerrar modal
    const modal = bootstrap.Modal.getInstance(document.getElementById('newsletterModal'));
    modal.hide();
    
    // Limpiar formulario
    this.reset();
});

// Mostrar modal de newsletter después de 30 segundos (opcional)
setTimeout(function() {
    if (!localStorage.getItem('newsletterShown')) {
        const newsletterModal = new bootstrap.Modal(document.getElementById('newsletterModal'));
        newsletterModal.show();
        localStorage.setItem('newsletterShown', 'true');
    }
}, 30000);
</script>

<style>
/* Estilos adicionales para los modales */
.search-suggestion:hover {
    background: var(--secondary-gradient) !important;
    color: white !important;
    transform: translateY(-2px);
}

.quick-categories .btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

#newsletterModal .form-control::placeholder {
    color: rgba(255,255,255,0.7);
}

#newsletterModal .form-control:focus {
    border-color: #ff6b9d;
    box-shadow: 0 0 0 0.2rem rgba(255, 107, 157, 0.25);
    background: rgba(255,255,255,0.2);
}
</style>

</body>
</html>