import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class InAppWebViewPage extends StatefulWidget {
  final String url;
  final String title;
  final String? heroTag; // لانتقال أنيق من أيقونة الاختصار

  const InAppWebViewPage({
    super.key,
    required this.url,
    required this.title,
    this.heroTag,
  });

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  late final WebViewController _controller;
  double _progress = 0;
  bool _hasError = false;
  String _currentUrl = '';
  bool _canBack = false;
  bool _canForward = false;

  @override
  void initState() {
    super.initState();

    // اختيار Params لكل منصة
    final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) => setState(() => _progress = p / 100),
          onUrlChange: (change) {
            if (change.url != null) {
              _currentUrl = change.url!;
              _updateNavState();
            }
          },
          onPageFinished: (_) => _updateNavState(),
          onWebResourceError: (err) {
            setState(() => _hasError = true);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    // إعدادات إضافية للأندرويد
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  Future<void> _updateNavState() async {
    final back = await _controller.canGoBack();
    final forward = await _controller.canGoForward();
    setState(() {
      _canBack = back;
      _canForward = forward;
      _hasError = false; // في حال صفحة جديدة بعد خطأ
    });
  }

  String get _displayTitle {
    if (widget.title.isNotEmpty) return widget.title;
    if (_currentUrl.isNotEmpty) return Uri.tryParse(_currentUrl)?.host ?? 'Web';
    return 'Web';
  }

  String get _faviconUrl {
    final uri = Uri.tryParse(_currentUrl.isNotEmpty ? _currentUrl : widget.url);
    final host = uri?.host ?? 'google.com';
    // خدمة فافيكون من جوجل
    return 'https://www.google.com/s2/favicons?domain=$host&sz=64';
  }

  Future<void> _openExternal() async {
    final url = _currentUrl.isNotEmpty ? _currentUrl : widget.url;
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذّر فتح الرابط خارج التطبيق')),
      );
    }
  }

  Future<void> _share(String url, String title) async {
    try {
      await Share.share('$title\n$url');
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: url));
      Get.snackbar('Copied', 'Link copied to clipboard');
    }
  }

  Future<void> _reload() async {
    setState(() {
      _hasError = false;
      _progress = 0;
    });
    await _controller.reload();
  }

  Widget _buildError() {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, size: 44),
                const SizedBox(height: 12),
                Text(
                  'تعذّر تحميل الصفحة',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'افحص اتصالك بالإنترنت أو أعد المحاولة.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _reload,
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);
    final showProgress = _progress > 0 && _progress < 1;

    return AppBar(
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      title: Row(
        children: [
          Hero(
            tag: widget.heroTag ?? _faviconUrl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(
                _faviconUrl,
                width: 18,
                height: 18,
                errorBuilder: (_, __, ___) => const Icon(Icons.public, size: 18),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_displayTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Opacity(
                  opacity: 0.7,
                  child: Text(
                    Uri.tryParse(_currentUrl.isNotEmpty ? _currentUrl : widget.url)?.host ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'رجوع',
          onPressed: _canBack ? () async { await _controller.goBack(); _updateNavState(); } : null,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        IconButton(
          tooltip: 'تقدم',
          onPressed: _canForward ? () async { await _controller.goForward(); _updateNavState(); } : null,
          icon: const Icon(Icons.arrow_forward_ios_rounded),
        ),
        IconButton(
          tooltip: 'إعادة تحميل',
          onPressed: _reload,
          icon: const Icon(Icons.refresh_rounded),
        ),
        PopupMenuButton<String>(
          tooltip: 'خيارات',
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'share', child: ListTile(leading: Icon(Icons.ios_share), title: Text('مشاركة'))),
            const PopupMenuItem(value: 'open',  child: ListTile(leading: Icon(Icons.open_in_new), title: Text('فتح خارجي'))),
            const PopupMenuItem(value: 'copy',  child: ListTile(leading: Icon(Icons.copy_all), title: Text('نسخ الرابط'))),
          ],
          onSelected: (value) async {
            final link = _currentUrl.isNotEmpty ? _currentUrl : widget.url;
            switch (value) {
              case 'share': await _share(_currentUrl, widget.title ?? 'Share'); break;
              case 'open':  await _openExternal(); break;
              case 'copy':
                await Clipboard.setData(ClipboardData(text: link));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ الرابط')));
                }
                break;
            }
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: showProgress ? 1 : 0,
          child: LinearProgressIndicator(value: showProgress ? _progress : null),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
          ),
          child: Stack(
            children: [
              if (!_hasError) WebViewWidget(controller: _controller),
              if (_hasError) _buildError(),
            ],
          ),
        ),
      ),
    );
  }
}
