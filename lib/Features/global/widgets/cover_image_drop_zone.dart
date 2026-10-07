import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:sell_your_books/Core/Values/colors.dart';

class CoverImageDropzone extends StatefulWidget {
  const CoverImageDropzone({super.key});

  @override
  State<CoverImageDropzone> createState() => _CoverImageDropzoneState();
}

class _CoverImageDropzoneState extends State<CoverImageDropzone> {
  bool _hovering = false;

  void _pickFile() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('This feature is not implemented yet...')));
  }

  @override
  Widget build(BuildContext context) {
    final color = _hovering ? ColorsApp.primary : ColorsApp.onSurfaceVariant;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: _pickFile,
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            color: _hovering ? Colors.transparent : ColorsApp.outlineVariant,
            radius: const Radius.circular(8),
            strokeWidth: 2,
            dashPattern: const [6, 4],
            padding: EdgeInsets.zero,
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: _hovering
                  ? ColorsApp.surfaceContainerLow
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: Column(
                children: [
                  Icon(Icons.cloud_upload_outlined, size: 36, color: color),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        'Upload a file',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorsApp.primary,
                        ),
                      ),
                      Text(
                        ' or drag and drop',
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorsApp.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PNG, JPG, GIF up to 10MB',
                    style: TextStyle(fontSize: 12, color: ColorsApp.outline),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}