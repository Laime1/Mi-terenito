import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/property.dart';

import '../widgets/card_lands.dart';

class LandScreen extends StatefulWidget {
  final List<Property> properties;

  const LandScreen({super.key, required this.properties});

  @override
  LandScreenState createState() => LandScreenState();
}
  class LandScreenState extends State<LandScreen>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
     body: widget.properties.isEmpty
      ?Center(child: CircularProgressIndicator(),)
      :ListView.builder(
       itemCount: widget.properties.length,
         itemBuilder: (context, index){
            final property = widget.properties[index];
            return PropertyCard(
              property: property
            );
         }
     ),
    );
  }

  }


