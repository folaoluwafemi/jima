import 'package:jima/src/tools/constants/rpc_functions.dart';

enum CategorizedMedia {
  audio,
  video,
  ;
}

extension CategorizedMediaExtension on CategorizedMedia? {
  String get filterCategoryRpcFunction {
    return switch (this) {
      CategorizedMedia.audio => RpcFunctions.fetchCategoriesWithAudio,
      CategorizedMedia.video => RpcFunctions.fetchCategoriesWithVideo,
      null => RpcFunctions.fetchCategoriesWithAudioOrVideo,
    };
  }
}
