import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/modules/media/domain/entities/books.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BookPreviewScreen extends StatelessWidget {
  final Book book;

  const BookPreviewScreen({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.glassBlack,
      appBar: AppBar(
        foregroundColor: AppColors.blue,
        centerTitle: true,
        title: Text(
          book.title,
          style: Textstyles.bold.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 18.sp,
            height: 1.5,
            color: AppColors.blackVoid,
          ),
        ),
      ),
      body: WebviewDocumentViewer(book: book),
    );
  }
}

// class EasyPdfViewerWidget extends StatefulWidget {
//   final Book book;
//
//   const EasyPdfViewerWidget({
//     super.key,
//     required this.book,
//   });
//
//   @override
//   State<EasyPdfViewerWidget> createState() => _EasyPdfViewerWidgetState();
// }
//
// class _EasyPdfViewerWidgetState extends State<EasyPdfViewerWidget> {
//   final controller = WebViewController();
//   late final PDFDocument doc;
//   final progressNotifier = ValueNotifier<bool>(false);
//
//   @override
//   void initState() {
//     super.initState();
//     loadPage();
//     updateViewCount();
//   }
//
//   Future<void> updateViewCount() async {
//     await Future.delayed(const Duration(seconds: 5));
//     if (!mounted) return;
//     container<MediaDataSource>().increaseMediaViewedCount(
//       id: widget.book.id,
//       type: GenericMediaType.book,
//     );
//   }
//
//   Future<void> loadPage() async {
//     progressNotifier.value = true;
//     final result = await () async {
//       doc = await PDFDocument.fromURL(widget.book.url);
//     }()
//         .tryCatch();
//     if (!mounted) return;
//     progressNotifier.value = false;
//     return switch (result) {
//       Left(:final value) => context.showErrorToast(value.displayMessage),
//       Right() => null,
//     };
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     progressNotifier.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: ValueListenableBuilder<bool>(
//         valueListenable: progressNotifier,
//         builder: (_, value, __) {
//           if (!value) {
//             return PDFViewer(document: doc);
//           }
//           return Center(
//             child: SizedBox.square(
//               dimension: 56.sp,
//               child: CircularProgressIndicator(
//                 strokeWidth: 6.sp,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class WebviewDocumentViewer extends StatefulWidget {
  final Book book;

  const WebviewDocumentViewer({
    super.key,
    required this.book,
  });

  @override
  State<WebviewDocumentViewer> createState() => _WebviewDocumentViewerState();
}

class _WebviewDocumentViewerState extends State<WebviewDocumentViewer> {
  final controller = WebViewController();
  final progressNotifier = ValueNotifier<double?>(null);

  @override
  void dispose() {
    super.dispose();
    progressNotifier.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller
      ..loadRequest(
        Uri.parse(
          'https://docs.google.com/gview?embedded=true&'
          'url=${widget.book.url}',
        ),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (!mounted) return;
            progressNotifier.value =
                (progress / 100 == 0 || progress / 100 == 1)
                    ? null
                    : progress / 100;
          },
          onPageStarted: debugPrint,
          onPageFinished: debugPrint,
          onUrlChange: (UrlChange change) {
            if (!mounted) return;
            if (change.url?.contains('cancel') ?? false) {
              context.pop();
            }
          },
          onNavigationRequest: (request) => NavigationDecision.navigate,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ValueListenableBuilder<double?>(
            valueListenable: progressNotifier,
            builder: (_, value, __) {
              if (value == null) return const SizedBox.shrink();
              return LinearProgressIndicator(value: value);
            },
          ),
          Expanded(
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}
