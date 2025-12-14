# 📁 Assets - Guía de Especificaciones

Esta carpeta contiene todos los recursos gráficos de la aplicación.

## 🎨 Logos y Imágenes

### **Logo Principal de la App**

#### Ubicación:
- `assets/images/logo.png`

#### Especificaciones:
- **Formato**: PNG con transparencia (fondo transparente)
- **Tamaño recomendado**: **512x512 px** (cuadrado)
- **Resolución**: 72-300 DPI
- **Peso**: Máximo 200 KB (optimizado)
- **Uso**: AppBar, Splash Screen, Login Screen

#### Variantes opcionales:
- `logo_light.png` - Para modo claro (512x512 px)
- `logo_dark.png` - Para modo oscuro (512x512 px)

---

### **Logo Horizontal (con texto)**

#### Ubicación:
- `assets/images/logo_horizontal.png`

#### Especificaciones:
- **Formato**: PNG con transparencia
- **Tamaño recomendado**: **1024x256 px** (ratio 4:1)
- **Resolución**: 72-300 DPI
- **Peso**: Máximo 150 KB
- **Uso**: Headers, pantallas de bienvenida

---

### **Favicon / App Icon**

#### Ubicación:
- `assets/icons/app_icon.png`

#### Especificaciones:
- **Formato**: PNG con transparencia
- **Tamaño recomendado**: **1024x1024 px**
- **Resolución**: 300 DPI
- **Peso**: Máximo 500 KB
- **Uso**: Icono de la aplicación (se generarán versiones adaptativas)

**Nota**: Para generar los iconos de la app en todas las resoluciones, usa el paquete `flutter_launcher_icons`.

---

## 📐 Tamaños Recomendados por Uso

| Uso | Tamaño | Formato | Ubicación |
|-----|--------|---------|-----------|
| **Logo AppBar** | 120x120 px | PNG | `assets/images/logo.png` |
| **Logo Login** | 256x256 px | PNG | `assets/images/logo.png` |
| **Logo Splash** | 512x512 px | PNG | `assets/images/logo.png` |
| **Banner** | 1024x256 px | PNG | `assets/images/logo_horizontal.png` |
| **App Icon** | 1024x1024 px | PNG | `assets/icons/app_icon.png` |
| **Imágenes generales** | Variable | PNG/JPG | `assets/images/` |

---

## 🎯 Formatos Aceptados

### Preferidos:
- **PNG**: Para logos, iconos, imágenes con transparencia
- **SVG**: Para gráficos vectoriales (requiere paquete `flutter_svg`)

### Alternativos:
- **JPG/JPEG**: Para fotografías sin transparencia
- **WebP**: Para imágenes optimizadas (mejor compresión)

---

## 📱 Densidades de Pantalla (Opcional)

Si quieres optimizar para diferentes densidades, crea subcarpetas:

```
assets/
  ├── images/
  │   ├── 1.5x/
  │   │   └── logo.png (768x768 px)
  │   ├── 2.0x/
  │   │   └── logo.png (1024x1024 px)
  │   ├── 3.0x/
  │   │   └── logo.png (1536x1536 px)
  │   └── logo.png (512x512 px - base)
```

---

## ⚙️ Configuración en pubspec.yaml

Asegúrate de declarar los assets en `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
```

---

## 🚀 Uso en el Código

```dart
// Logo simple
Image.asset(
  'assets/images/logo.png',
  width: 120,
  height: 120,
)

// Logo con ajuste
Image.asset(
  'assets/images/logo.png',
  fit: BoxFit.contain,
)
```

---

## 📝 Checklist de Assets

- [ ] Logo principal (512x512 px, PNG)
- [ ] Logo horizontal (1024x256 px, PNG)
- [ ] App icon (1024x1024 px, PNG)
- [ ] Logo modo claro (opcional)
- [ ] Logo modo oscuro (opcional)
- [ ] Imágenes adicionales según necesidad

---

## 🎨 Recomendaciones de Diseño

1. **Fondo transparente**: Siempre usa PNG con canal alpha
2. **Colores**: Asegúrate que el logo se vea bien en fondos claros y oscuros
3. **Simplicidad**: Logos simples escalan mejor en diferentes tamaños
4. **Optimización**: Comprime las imágenes sin perder calidad (usa TinyPNG, ImageOptim)
5. **Consistencia**: Mantén el mismo estilo visual en todos los assets

---

**Última actualización**: 14 de diciembre de 2025
