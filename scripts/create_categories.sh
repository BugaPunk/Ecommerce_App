#!/bin/bash

# Script para crear las categorías por defecto en la API
# Asegúrate de tener un usuario vendedor creado antes de ejecutar este script

API_BASE_URL="https://ecommerce-springboot-backend-xen4.onrender.com/api"

echo "🚀 Creando categorías por defecto..."
echo "=================================="

# Paso 1: Obtener token de autenticación
echo "📝 Paso 1: Obteniendo token de autenticación..."
echo "Por favor, ingresa las credenciales de un usuario vendedor:"
read -p "Username: " USERNAME
read -s -p "Password: " PASSWORD
echo ""

# Login para obtener token
LOGIN_RESPONSE=$(curl -s -X POST "$API_BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}")

echo "Login response: $LOGIN_RESPONSE"

# Extraer token del response
TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
    echo "❌ Error: No se pudo obtener el token de autenticación"
    echo "Respuesta del login: $LOGIN_RESPONSE"
    exit 1
fi

echo "✅ Token obtenido exitosamente"
echo "Token: ${TOKEN:0:20}..."

# Paso 2: Crear categorías
echo ""
echo "📦 Paso 2: Creando categorías..."

# Array de categorías a crear
declare -a CATEGORIES=(
    '{"nombre":"Electrónicos","descripcion":"Productos electrónicos y tecnología","tiendaId":1}'
    '{"nombre":"Moda","descripcion":"Ropa y accesorios de moda","tiendaId":1}'
    '{"nombre":"Hogar","descripcion":"Artículos para el hogar y decoración","tiendaId":1}'
    '{"nombre":"Deportes","descripcion":"Artículos deportivos y fitness","tiendaId":1}'
    '{"nombre":"Libros","descripcion":"Libros y literatura","tiendaId":1}'
)

# Crear cada categoría
for i in "${!CATEGORIES[@]}"; do
    CATEGORY_DATA="${CATEGORIES[$i]}"
    CATEGORY_NAME=$(echo $CATEGORY_DATA | grep -o '"nombre":"[^"]*' | cut -d'"' -f4)
    
    echo "Creando categoría: $CATEGORY_NAME"
    
    RESPONSE=$(curl -s -X POST "$API_BASE_URL/categorias" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $TOKEN" \
      -d "$CATEGORY_DATA")
    
    echo "Respuesta: $RESPONSE"
    
    # Verificar si la creación fue exitosa
    if echo "$RESPONSE" | grep -q '"id"'; then
        echo "✅ Categoría '$CATEGORY_NAME' creada exitosamente"
    else
        echo "❌ Error creando categoría '$CATEGORY_NAME'"
        echo "Respuesta completa: $RESPONSE"
    fi
    
    echo "---"
done

echo ""
echo "🎉 Proceso completado!"
echo "Verificando categorías creadas..."

# Paso 3: Verificar categorías creadas
echo ""
echo "📋 Paso 3: Listando todas las categorías..."

CATEGORIES_LIST=$(curl -s -X GET "$API_BASE_URL/categorias" \
  -H "Content-Type: application/json")

echo "Categorías disponibles:"
echo "$CATEGORIES_LIST" | python3 -m json.tool 2>/dev/null || echo "$CATEGORIES_LIST"

echo ""
echo "✨ ¡Listo! Las categorías han sido creadas."
echo "Ahora puedes crear productos usando estas categorías en la app Flutter."