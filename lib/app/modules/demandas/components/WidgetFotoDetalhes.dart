import 'dart:convert';

import 'package:cuidaagente/app/data/models/log_VideoMonitoramento.dart';
import 'package:cuidaagente/app/modules/demandas/components/PhotoViewGalleryScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetFotoDetalhes extends StatelessWidget {
  const WidgetFotoDetalhes({
    super.key,
    required this.imagens_monitoramento,
  });

  final  RxList<ImagensMonitoramento> imagens_monitoramento;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        physics:
            const NeverScrollableScrollPhysics(), // Para desativar o scroll do GridView
        shrinkWrap:
            true, // Para ajustar o tamanho do GridView dentro do Sliver
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Número de miniaturas por linha
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: imagens_monitoramento!.length,
        itemBuilder: (context, index) {
          final fotoVistoria = imagens_monitoramento![index];
    
          // Verifica se a extensão do arquivo é ".jpg"
          bool isJpgFile = (fotoVistoria.nomeImagem! == "NomeIMagem");
    
          // Se a extensão for .jpg, mostrar o CircularProgressIndicator
          if (isJpgFile) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
    
          // Decodifica a string Base64 para bytes
          final imageBytes =
              const Base64Decoder().convert(fotoVistoria.nomeImagem!);
    
          return GestureDetector(
            onTap: () {
              // Quando a miniatura for clicada, abrir a visualização em tela cheia
              Get.to(
                () => PhotoViewGalleryScreen(
                  fotosVistoria: imagens_monitoramento.value!,
                  initialIndex: index,
                ),
              );
            },
            child: Image.memory(
              imageBytes,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
