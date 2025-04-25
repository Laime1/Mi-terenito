import 'package:flutter/material.dart';

class FormScreen extends StatelessWidget{
  const FormScreen({super.key});

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
              formInput( 'Titulo de propiedad'),
               SizedBox(height: 16,),
               formInput('Tamaño de Terreno'),
               SizedBox(height: 16,),
               formInput('Descripcion'),
             ],
           ),
       ),
     );
  }
  
 TextFormField formInput(String title){
    return TextFormField(
      maxLines: 1,
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