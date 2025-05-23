import 'package:jima/src/tools/tools_barrel.dart';

enum AppRoute {
  /// ============== starter ==============
  splash('/'),
  onboarding('/onboarding'),
  authAction('/auth-action'),
  signup('signup', '/auth-action/signup'),
  login('login', '/auth-action/login'),
  forgotPassword('forgot-password', '/auth-action/login/forgot-password'),
  forgotPasswordOtp('forgot-password-otp', '/auth-action/login/forgot-password/forgot-password-otp'),
  changePassword('change-password', '/auth-action/login/change-password'),
  dashboard('/dashboard', '/dashboard'),
  categorizedMedia('/categorized-media', '/categorized-media'),
  allMediaSearch('all-media-search', '/dashboard/all-media-search'),
  books('/books', '/books'),
  bookPreview('/book-preview', '/book-preview'),
  videos('/videos', '/videos'),
  videoPreview('/video-preview', '/video-preview'),
  audios('/audios', '/audios'),
  audioPreview('/audio-preview', '/audio-preview'),
  profile('/profile', '/profile'),
  donation('/donation', '/donation'),
  admin('/admin', '/admin'),
  uploadVideo('upload-video', '/admin/upload-video'),
  uploadAudio('upload-audio', '/admin/upload-audio'),
  uploadBook('upload-book', '/admin/upload-book'),
  uploadDonation('upload-donation', '/admin/upload-donation'),
  manageAdmins('manage-admins', '/admin/manage-admins'),
  editCategories('edit-categories', '/admin/edit-categories'),
  ;

  final String path;
  final String fullPath;

  String get simplePath => path.split('/').last;

  const AppRoute(this.path, [String? fullPath]) : fullPath = fullPath ?? path;

  /// adds each route to the full path in order of entry
  static String buildPath(List<AppRoute> routes) {
    assert(routes.isNotEmpty);
    String path = '';
    if (routes.first.path.chars.first != '/') path += '/';
    for (int i = 0; i < (routes.length - 1); i++) {
      path += '${routes[i].path}/';
    }
    path += routes.last.path;
    Logger.info('built path: $path');
    return path;
  }

  List<AppRoute> resolveSubRoutes() {
    final List<AppRoute> subRoutes = [];

    for (final AppRoute route in AppRoute.values) {
      if (route.fullPath.contains(fullPath) && route != this) {
        subRoutes.add(route);
      }
    }
    return subRoutes;
  }

  factory AppRoute.fromRouteName(String routeName) {
    return AppRoute.values.firstWhere(
      (route) =>
          route.fullPath.contains(routeName) || route.name.contains(routeName),
      orElse: () => throw Exception('route not found $routeName'),
    );
  }
}
