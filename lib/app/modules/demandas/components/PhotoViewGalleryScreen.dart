import 'dart:convert';

import 'package:cuidaagente/app/data/models/log_VideoMonitoramento.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewGalleryScreen extends StatelessWidget {
  final List<ImagensMonitoramento> fotosVistoria;
  final int initialIndex;

  const PhotoViewGalleryScreen({
    super.key,
    required this.fotosVistoria,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar Imagem'),
      ),
      body: PhotoViewGallery.builder(
        itemCount: fotosVistoria.length,
        pageController: PageController(initialPage: initialIndex),
        builder: (context, index) {
          final foto = fotosVistoria[index];
          final imageBytes = const Base64Decoder().convert(foto.nomeImagem!);

          return PhotoViewGalleryPageOptions(
            imageProvider: MemoryImage(imageBytes),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
      ),
    );
  }
}
