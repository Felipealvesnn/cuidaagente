import 'package:cuidaagente/app/modules/demandas/components/BottomNavigationvarDemanda.dart';
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
            bottomLeft: Radius.circular(1.0),
            bottomRight: Radius.circular(1.0),
          ),
          child: SizedBox(
            height: tamanho, // Ajusta a altura do AppBar
            child: AppBar(
              title: const Text(
                'Demandas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              elevation: 50, // Adiciona a elevação (sombra)
              shadowColor:
                  Colors.black.withOpacity(0.5), // Personaliza a cor da sombra
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Get.toNamed('/demandas/create');
        },
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(28.0), // Ajuste o valor se necessário
        ),
        child: const Icon(Icons.add, color: Colors.white,),
        //params
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavigationvarDemanda(),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.Refresh();
        },
        child: Obx(() {
          if (controller.isLoadingDemandaInicial.value) {
            // Mostra o indicador de carregamento enquanto está carregando
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Carregando demandas...'),
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
                      'Nenhuma demanda encontrada.',
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
