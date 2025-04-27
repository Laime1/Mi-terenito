import 'package:flutter/material.dart';

class FormScreen extends  StatefulWidget{
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();

}

class _FormScreenState extends State<FormScreen>{

  //controladores
  final TextEditingController _title = TextEditingController();
  final TextEditingController _size = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Registro de Propiedad'),
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(32),
        child: Column(
          children: [
            formInput( title: 'Titulo de propiedad', type: TextInputType.name),
            SizedBox(height: 16,),
            formInput(title: 'Tamaño de Terreno',),
            SizedBox(height: 16,),
            formInput(title: 'Descripcion', max: 3),
            SizedBox(height: 16,),
            Row(
              children: [

                Expanded(flex: 5, child: formInput(title: 'Precio Minimo', type: TextInputType.number)),
                 SizedBox(width: 10,),
                 Expanded(flex: 5, child: formInput(title: 'Pecio Maximo', type: TextInputType.number ))
              ],
            ),
            SizedBox(height: 16,),
            Row(
              children: [
                Expanded(child: formInput(title: 'Ubicacion')),
                SizedBox(width: 10,),
                Expanded(child: formInput(title: 'Zona'))
              ],
            )
          ],
        ),
      ),
    );
  }

  TextFormField formInput({String? title, int? max = 1, TextInputType? type }){
    return TextFormField(
      maxLines: max,
      keyboardType: type,
      decoration:  InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border:  OutlineInputBorder(
          gapPadding: 5,
        ),
        labelText: title,
      ),
    );
  }

}