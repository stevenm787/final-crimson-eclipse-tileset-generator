import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/generation_state.dart';
import '../../state/settings_state.dart';

/// Displays the generated tileset image with zoom/pan support and optional
/// grid overlay.
class TilesetPreview extends StatelessWidget {
  const TilesetPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final generationState = context.watch<GenerationState>();
    final settingsState = context.watch<SettingsState>();
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF8B0000).withAlpha(40),
        ),
      ),
      child: _buildContent(context, generationState, settingsState, theme),
    );
  }

  Widget _buildContent(
    BuildContext context,
    GenerationState generationState,
    SettingsState settingsState,
    ThemeData theme,
  ) {
    // Error state
    if (generationState.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Color(0xFFE94560),
              ),
              const SizedBox(height: 16),
              Text(
                'Generation Failed',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFFE94560),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                generationState.errorMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFCF6679),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Result state
    final result = generationState.currentResult;
    if (result != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 8.0,
              child: Image.memory(
                result.imageBytes,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.none,
              ),
            ),
            if (settingsState.gridOverlay)
              IgnorePointer(
                child: CustomPaint(
                  painter: _GridOverlayPainter(
                    tileWidth: 48,
                    tileHeight: 48,
                    imageWidth: result.width,
                    imageHeight: result.height,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Generating state
    if (generationState.isGenerating) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                color: Color(0xFFE94560),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Generating tileset...',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: const Color(0xFFE94560),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: generationState.progress,
                backgroundColor: const Color(0xFF16213E),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFE94560),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Empty state
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 80,
            color: const Color(0xFF8B0000).withAlpha(80),
          ),
          const SizedBox(height: 16),
          Text(
            'Generate a tileset to preview',
            style: theme.textTheme.titleLarge?.copyWith(
              color: const Color(0xFFB0B0B0).withAlpha(120),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a location and tileset type, then click Generate',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFFB0B0B0).withAlpha(80),
            ),
          ),
        ],
      ),
    );
  }
}

/// Paints a grid overlay to visualise tile boundaries.
class _GridOverlayPainter extends CustomPainter {
  final int tileWidth;
  final int tileHeight;
  final int imageWidth;
  final int imageHeight;

  _GridOverlayPainter({
    required this.tileWidth,
    required this.tileHeight,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(30)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final scaleX = size.width / imageWidth;
    final scaleY = size.height / imageHeight;

    // Vertical lines.
    for (int x = 0; x <= imageWidth; x += tileWidth) {
      final dx = x * scaleX;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }

    // Horizontal lines.
    for (int y = 0; y <= imageHeight; y += tileHeight) {
      final dy = y * scaleY;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridOverlayPainter oldDelegate) {
    return tileWidth != oldDelegate.tileWidth ||
        tileHeight != oldDelegate.tileHeight ||
        imageWidth != oldDelegate.imageWidth ||
        imageHeight != oldDelegate.imageHeight;
  }
}
