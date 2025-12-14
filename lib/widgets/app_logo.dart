import 'package:flutter/material.dart';

/// Widget helper para mostrar el logo de la aplicación
/// Automáticamente selecciona el logo correcto según el tema (claro/oscuro)
class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final bool isHorizontal;
  final bool isMain; // true para logo_main (con diseño completo), false para logo simplificado
  final bool isLarge; // true para usar la versión de alta resolución (portada)

  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.isHorizontal = false,
    this.isMain = false,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    // Nota: Las nuevas imágenes PNG son universales (no tienen variantes específicas dark/light por el momento)
    // Si se agregan versiones dark/light en el futuro, se puede re-incorporar la lógica de isDark.
    
    String assetPath;
    
    if (isLarge) {
      // Logo portada 512x512
      assetPath = 'assets/images/app_logo_rl_main_512x512.png';
    } else if (isHorizontal) {
      // Logos horizontales 150x50
      assetPath = 'assets/images/app_logo_rl_150x50.png';
    } else {
      // Logos normales 48x48 (usado tanto para isMain pequeño como para default)
      assetPath = 'assets/images/app_logo_rl_48x48.png';
    }

    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}

/// Widget helper para logo cuadrado (48x48 por defecto)
class AppLogoSquare extends StatelessWidget {
  final double size;
  final bool isMain;
  final bool isLarge;

  const AppLogoSquare({
    super.key,
    this.size = 48,
    this.isMain = false,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppLogo(
      width: size,
      height: size,
      isMain: isMain,
      isLarge: isLarge,
    );
  }
}

/// Widget helper para logo horizontal (150x50 por defecto)
class AppLogoHorizontal extends StatelessWidget {
  final double? width;
  final double? height;

  const AppLogoHorizontal({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AppLogo(
      width: width ?? 150,
      height: height ?? 50,
      isHorizontal: true,
    );
  }
}
