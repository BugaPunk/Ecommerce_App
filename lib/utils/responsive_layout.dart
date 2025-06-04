import 'package:flutter/material.dart';

enum DeviceType {
  mobile,
  tablet,
  desktop,
  largeDesktop,
  extraLargeDesktop,
}

class ResponsiveLayout {
  // Breakpoints para diferentes tamaños de pantalla
  static const double mobileMaxWidth = 650;
  static const double tabletMaxWidth = 1100;
  static const double desktopMaxWidth = 1400;
  static const double largeDesktopMaxWidth = 1800;

  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < mobileMaxWidth) {
      return DeviceType.mobile;
    } else if (width < tabletMaxWidth) {
      return DeviceType.tablet;
    } else if (width < desktopMaxWidth) {
      return DeviceType.desktop;
    } else if (width < largeDesktopMaxWidth) {
      return DeviceType.largeDesktop;
    } else {
      return DeviceType.extraLargeDesktop;
    }
  }

  /// Verifica si el dispositivo actual es un móvil
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  /// Verifica si el dispositivo actual es una tablet
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  /// Verifica si el dispositivo actual es un escritorio
  static bool isDesktop(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.desktop || 
           deviceType == DeviceType.largeDesktop || 
           deviceType == DeviceType.extraLargeDesktop;
  }

  /// Verifica si el dispositivo actual es un escritorio grande
  static bool isLargeDesktop(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.largeDesktop || 
           deviceType == DeviceType.extraLargeDesktop;
  }

  /// Verifica si el dispositivo actual es un escritorio extra grande
  static bool isExtraLargeDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.extraLargeDesktop;
  }

  /// Verifica si la tablet está en modo landscape
  static bool isTabletLandscape(BuildContext context) {
    return isTablet(context) && 
           MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Devuelve un widget diferente según el tamaño de la pantalla
  static Widget builder({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    required Widget desktop,
    Widget? largeDesktop,
    Widget? extraLargeDesktop,
  }) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? (isTabletLandscape(context) ? desktop : mobile);
      case DeviceType.desktop:
        return desktop;
      case DeviceType.largeDesktop:
        return largeDesktop ?? desktop;
      case DeviceType.extraLargeDesktop:
        return extraLargeDesktop ?? largeDesktop ?? desktop;
    }
  }
  
  /// Calcula un valor adaptativo basado en el ancho de la pantalla
  static double getAdaptiveSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
    double? extraLargeDesktop,
  }) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
      case DeviceType.extraLargeDesktop:
        return extraLargeDesktop ?? largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }
}