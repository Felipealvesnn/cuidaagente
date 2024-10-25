import 'package:cuidaagente/app/data/models/demandas.dart';
import 'package:cuidaagente/app/modules/demandas/components/ListDemandas.dart';
import 'package:cuidaagente/app/modules/demandas/components/MyDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/demandas_controller.dart';

class DemandasView extends GetView<DemandasController> {
  const DemandasView({super.key});

  @override
  Widget build(BuildContext context) {
    double tamanho = 100;
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          tamanho, // Define a altura do AppBar
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
          child: SizedBox(
            height: tamanho, // Ajusta a altura do AppBar
            child: AppBar(
              actions: const [
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: null,
                ),
              ],
              title: const Text(
                'Demandas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              elevation: 10, // Adiciona a elevação (sombra)
              shadowColor:
                  Colors.black.withOpacity(0.5), // Personaliza a cor da sombra
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(16),
        child: FloatingActionButton(
          onPressed: () {
            //Get.to(() => VistoriaFormPage());
          },
          // Cor do botão e do ícone
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.add),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.hasMoreDemandas.value = true;
          controller.isLoadingDemandaInicial.value = true;
          controller.demandasList.clear();
          controller.isLoadingDemandaInicial.value = false;
        },
        child: Obx(() {
          if (controller.isLoadingDemandaInicial.value) {
            // Mostra o indicador de carregamento enquanto está carregando
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Carregando vistorias...'),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }

          if (controller.demandasList.isEmpty) {
            // Mostra a mensagem somente após o carregamento estar completo
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Nenhuma vistoria encontrada.',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            );
          }

          // Exibe a lista de vistorias
          return ListDemandas(controller: controller);
        }),
      ),
    );
  }
}
