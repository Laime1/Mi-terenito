
import 'package:flutter/material.dart';
import 'package:mi_terrenito/models/property.dart';

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

class PropertyCard extends StatelessWidget{
  final Property property;
  const PropertyCard({super.key, required this.property});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Image.network(
                property.images.first,
              ),
            ),
            SizedBox(width: 16,),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.name,
                    style: TextStyle(
                       fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    property.description,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Text('${property.size} m2'),
                  Row(
                    children: [Text("\$${property.maxPrice}-\$${property.minPrice}",
                     style: TextStyle(
                       fontSize: 15,
                       fontWeight: FontWeight.bold
                     ),
                    ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ) ;
  }
}
