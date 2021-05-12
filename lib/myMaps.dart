import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
class Mapas extends StatefulWidget {
  @override
  _MapasState createState() => _MapasState();
}

class _MapasState extends State<Mapas> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _posicaoInicial = CameraPosition(
      target: LatLng(-23.600941, -48.05151),
      zoom: 19.5
  );


  static final CameraPosition _posicaoPraia = CameraPosition(
      target: LatLng(-28.128324, -48.641435),
      zoom: 18.15
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exemplo mapas"),
        actions: [
          IconButton(
              onPressed: _goToTheBeach,
              icon: Icon(
                Icons.pin_drop
              )),
          IconButton(
              onPressed: _suaCasa,
              icon: Icon(
                Icons.home
              )),
        ],
      ),
      body: _mapaExemplo(),
    );
  }

  Future <void> _suaCasa() async{
    print("entrou e atualizou via git");
    final GoogleMapController controller = await _controller.future;
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted){
        return;
      }
    }

     _locationData = await location.getLocation();
    print("Long"+_locationData.longitude.toString());
      CameraPosition _posicaoGPS = CameraPosition(
          target: LatLng(_locationData.latitude, _locationData.longitude),
          zoom: 19.5
      );

      controller.animateCamera(CameraUpdate.newCameraPosition(_posicaoGPS));
    }




  Future<void> _goToTheBeach() async{
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_posicaoPraia));
  }

  _mapaExemplo(){
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.satellite,
        initialCameraPosition: _posicaoInicial,
        markers: {fatecMark},
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },
      ),
    );
  }

  Marker fatecMark = Marker(
    markerId: MarkerId("FatecItape"),
    position: LatLng(-23.600941, -48.05151),
    infoWindow: InfoWindow(title: "Fatec Itape"),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueGreen
    )
  );

}
