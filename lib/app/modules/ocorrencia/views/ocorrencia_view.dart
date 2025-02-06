import 'dart:ui';

import 'package:cuidaagente/app/data/models/classificacao_gravidade.dart';
import 'package:cuidaagente/app/data/models/naturezaOcorrencia.dart';
import 'package:cuidaagente/app/data/models/tipoOcorrencia.dart';
import 'package:cuidaagente/app/modules/ocorrencia/components/BottomNavigationvarOcorrencia.dart';
import 'package:cuidaagente/app/modules/ocorrencia/components/floatibutonOcorrencia.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../controllers/ocorrencia_controller.dart';

class OcorrenciaView extends GetView<OcorrenciaController> {
  OcorrenciaView({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Criar Ocorrência"),
          centerTitle: true,
        ),
        floatingActionButton: FloatibuttonOcorrencia(
            controller: controller,
            formKey: _formKey), // Adiciona o botão flutuante
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationvarocorencia(
          onImageSourceSelection: () {
            _showImageSourceSelection(context);
          },
        ),
        body: Obx(
          () => controller.listNatureza.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() => SizedBox(
                                width: double.infinity,
                                child: DropdownButtonFormField<
                                    natureza_ocorrencia>(
                                  isExpanded: true,
                                  borderRadius:
                                      BorderRadius.circular(20).copyWith(
                                    topLeft: const Radius.circular(0),
                                  ),
                                  hint: const Text('Selecione a Natureza'),
                                  value: controller.selectedNatureza.value,
                                  onChanged: (natureza) {
                                    controller.selectNatureza(natureza);
                                  },
                                  items:
                                      controller.listNatureza.map((natureza) {
                                    return DropdownMenuItem<
                                        natureza_ocorrencia>(
                                      value: natureza,
                                      child: Text(natureza
                                              .descricao_natureza_ocorrencia ??
                                          ''),
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Campo obrigatório';
                                    }
                                    return null;
                                  },
                                ),
                              )),
                          const SizedBox(height: 20),
                          Obx(() {
                            if (controller.selectedNatureza.value != null) {
                              return SizedBox(
                                width: double.infinity,
                                child: DropdownButtonFormField<tipo_ocorrencia>(
                                  borderRadius:
                                      BorderRadius.circular(20).copyWith(
                                    topLeft: const Radius.circular(0),
                                  ),
                                  hint: const Text(
                                      'Selecione o Tipo de Ocorrência'),
                                  value:
                                      controller.selectedTipoOcorrencia.value,
                                  onChanged: (tipo) {
                                    controller.selectTipoOcorrencia(tipo);
                                  },
                                  isExpanded: true,
                                  items:
                                      controller.listTipoOcorrencia.map((tipo) {
                                    return DropdownMenuItem<tipo_ocorrencia>(
                                      value: tipo,
                                      child: Text(
                                          tipo.descricao_tipo_ocorrencia ?? ''),
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Campo obrigatório';
                                    }
                                    return null;
                                  },
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                          const SizedBox(height: 20),
                          Obx(() {
                            if (controller
                                    .selectedClassificacao_gravidade.value !=
                                null) {
                              return SizedBox(
                                width: double.infinity,
                                child: DropdownButtonFormField<
                                    classificacao_gravidade>(
                                  borderRadius:
                                      BorderRadius.circular(20).copyWith(
                                    topLeft: const Radius.circular(0),
                                  ),
                                  hint: const Text(
                                      'Selecione a Classificação de Gravidade'),
                                  value: controller
                                      .selectedClassificacao_gravidade.value,
                                  onChanged: (gravidade) {
                                    controller.selectedClassificacao_gravidade
                                        .value = gravidade;
                                  },
                                  isExpanded: true,
                                  items: controller.listClassificacao_gravidade
                                      .map((gravidade) {
                                    return DropdownMenuItem<
                                        classificacao_gravidade>(
                                      value: gravidade,
                                      child: Text(gravidade
                                              .descricao_classificacao_gravidade ??
                                          ''),
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Campo obrigatório';
                                    }
                                    return null;
                                  },
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                          Obx(() {
                            if (controller
                                    .selectedClassificacao_gravidade.value !=
                                null) {
                              return Column(
                                children: [
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () async {
                                      await controller.getLocation();
                                      await controller.openMapDialog(context);
                                    },
                                    child: TextFormField(
                                      enabled: false,
                                      controller: controller.enderecoController,
                                      decoration: InputDecoration(
                                        labelText: 'Endereço',
                                        prefixIcon: IconButton(
                                          icon: const Icon(Icons.location_on),
                                          onPressed: () async {},
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Campo obrigatório';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: controller.Bairro,
                                    decoration: const InputDecoration(
                                      labelText: 'Bairro',
                                    ),
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      // if (value == null || value.isEmpty) {
                                      //   return 'Campo obrigatório';
                                      // }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: controller.numeroController,
                                    decoration: const InputDecoration(
                                      labelText: 'Número',
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Campo obrigatório';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101),
                                            );
                                            if (pickedDate != null) {
                                              controller.dataController.text =
                                                  DateFormat('dd/MM/yy')
                                                      .format(pickedDate);
                                            }
                                          },
                                          controller: controller.dataController,
                                          decoration: InputDecoration(
                                            labelText: 'Data (DD/MM/AA)',
                                            suffixIcon: IconButton(
                                              icon: const Icon(
                                                  Icons.calendar_today),
                                              onPressed: () async {},
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          onTap: () async {
                                            TimeOfDay? pickedTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            );
                                            if (pickedTime != null) {
                                              final now = DateTime.now();
                                              final selectedTime = DateTime(
                                                now.year,
                                                now.month,
                                                now.day,
                                                pickedTime.hour,
                                                pickedTime.minute,
                                              );
                                              controller.horaController.text =
                                                  DateFormat('HH:mm')
                                                      .format(selectedTime);
                                            }
                                          },
                                          controller: controller.horaController,
                                          decoration: InputDecoration(
                                            labelText: 'Hora (HH:MM)',
                                            suffixIcon: IconButton(
                                              icon:
                                                  const Icon(Icons.access_time),
                                              onPressed: () async {
                                                TimeOfDay? pickedTime =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
                                                );
                                                if (pickedTime != null) {
                                                  final now = DateTime.now();
                                                  final selectedTime = DateTime(
                                                    now.year,
                                                    now.month,
                                                    now.day,
                                                    pickedTime.hour,
                                                    pickedTime.minute,
                                                  );
                                                  controller
                                                          .horaController.text =
                                                      DateFormat('HH:mm')
                                                          .format(selectedTime);
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: controller.relatoController,
                                    decoration: const InputDecoration(
                                      labelText: 'Relato do Autor',
                                    ),
                                    maxLines: 4,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Campo obrigatório';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  _buildSelectedImages(context),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
        ));
  }

  Widget _buildSelectedImages(BuildContext context) {
    return Obx(
      () {
        return controller.selectedImages.isEmpty
            ? const Text("Nenhuma imagem selecionada")
            : Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: controller.selectedImages.map((imageFile) {
                  return Stack(
                    alignment: Alignment
                        .center, // Alinhar o conteúdo do Stack ao centro
                    children: [
                      ClipOval(
                        child: Image.file(
                          imageFile,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            Get.dialog(AlertDialog(
                              title: const Text("Confirmar"),
                              content:
                                  const Text("Você deseja excluir a imagem?"),
                              actions: [
                                TextButton(
                                  child: const Text("Cancelar"),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                TextButton(
                                  child: const Text("Excluir"),
                                  onPressed: () {
                                    controller.selectedImages.remove(imageFile);
                                    Get.back();
                                  },
                                ),
                              ],
                            ));
                          })
                    ],
                  );
                }).toList(),
              );
      },
    );
  }

  void _showImageSourceSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              _imageSourceTile(
                icon: Icons.photo_library,
                label: 'Selecionar da galeria',
                source: ImageSource.gallery,
              ),
              _imageSourceTile(
                icon: Icons.camera_alt,
                label: 'Tirar foto',
                source: ImageSource.camera,
              ),
            ],
          ),
        );
      },
    );
  }

  ListTile _imageSourceTile({
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () async {
        await controller.pickImage(source);
        Get.back();
      },
    );
  }

  
}
