/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/whatsapp.svg
  SvgGenImage get whatsapp => const SvgGenImage('assets/icons/whatsapp.svg');

  /// List of all assets
  List<SvgGenImage> get values => [whatsapp];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/backhome.png
  AssetGenImage get backhome =>
      const AssetGenImage('assets/images/backhome.png');

  /// File path: assets/images/call.png
  AssetGenImage get call => const AssetGenImage('assets/images/call.png');

  /// File path: assets/images/disconnect.png
  AssetGenImage get disconnect =>
      const AssetGenImage('assets/images/disconnect.png');

  /// File path: assets/images/envalop.png
  AssetGenImage get envalop => const AssetGenImage('assets/images/envalop.png');

  /// File path: assets/images/exit.png
  AssetGenImage get exit => const AssetGenImage('assets/images/exit.png');

  /// File path: assets/images/home-page-header.svg
  SvgGenImage get homePageHeader =>
      const SvgGenImage('assets/images/home-page-header.svg');

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// File path: assets/images/logomark.png
  AssetGenImage get logomark =>
      const AssetGenImage('assets/images/logomark.png');

  /// File path: assets/images/madad.png
  AssetGenImage get madad => const AssetGenImage('assets/images/madad.png');

  /// File path: assets/images/mapa.png
  AssetGenImage get mapa => const AssetGenImage('assets/images/mapa.png');

  /// File path: assets/images/no-messages.svg
  SvgGenImage get noMessages =>
      const SvgGenImage('assets/images/no-messages.svg');

  /// File path: assets/images/no-tasks.svg
  SvgGenImage get noTasks => const SvgGenImage('assets/images/no-tasks.svg');

  /// File path: assets/images/noData.png
  AssetGenImage get noData => const AssetGenImage('assets/images/noData.png');

  /// File path: assets/images/pencil2.png
  AssetGenImage get pencil2 => const AssetGenImage('assets/images/pencil2.png');

  /// File path: assets/images/pencile.png
  AssetGenImage get pencile => const AssetGenImage('assets/images/pencile.png');

  /// File path: assets/images/person.png
  AssetGenImage get person => const AssetGenImage('assets/images/person.png');

  /// File path: assets/images/person2.png
  AssetGenImage get person2 => const AssetGenImage('assets/images/person2.png');

  /// File path: assets/images/setting.png
  AssetGenImage get setting => const AssetGenImage('assets/images/setting.png');

  /// File path: assets/images/success-smile.png
  AssetGenImage get successSmile =>
      const AssetGenImage('assets/images/success-smile.png');

  /// File path: assets/images/success.svg
  SvgGenImage get success => const SvgGenImage('assets/images/success.svg');

  /// File path: assets/images/vi.png
  AssetGenImage get vi => const AssetGenImage('assets/images/vi.png');

  /// List of all assets
  List<dynamic> get values => [
        backhome,
        call,
        disconnect,
        envalop,
        exit,
        homePageHeader,
        logo,
        logomark,
        madad,
        mapa,
        noMessages,
        noTasks,
        noData,
        pencil2,
        pencile,
        person,
        person2,
        setting,
        successSmile,
        success,
        vi
      ];
}

class $AssetsVectorsGen {
  const $AssetsVectorsGen();

  /// File path: assets/vectors/no-complete-tasks.svg
  SvgGenImage get noCompleteTasks =>
      const SvgGenImage('assets/vectors/no-complete-tasks.svg');

  /// List of all assets
  List<SvgGenImage> get values => [noCompleteTasks];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsVectorsGen vectors = $AssetsVectorsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
