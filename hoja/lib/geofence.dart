import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class MyMapPage extends StatefulWidget {
  @override
  _MyMapPageState createState() => _MyMapPageState();
}

class _MyMapPageState extends State<MyMapPage> {
  late GoogleMapController _controller;
  LocationData? _currentLocation;
  Location _location = Location();
  Set<Polygon> _polygons = {};
  List<Marker> _markers = [];
  List<LatLng> geofenceVertices = [];
  List<Geofence> savedGeofences = [];

  @override
  void initState() {
    super.initState();
    loadGeofences();
    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLocation = locationData;
      });
      updateMap();
    });
    _location.getLocation().then((locationData) {
      setState(() {
        _currentLocation = locationData;
      });
      updateMap();
    });
  }

  Future<void> loadGeofences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedGeofencesJson = prefs.getString('geofences');
    if (savedGeofencesJson != null) {
      final decodedGeofences = json.decode(savedGeofencesJson) as List<dynamic>;
      savedGeofences = decodedGeofences.map((geofence) {
        return Geofence(
            geofence['name'],
            (geofence['vertices'] as List)
                .map((vertex) =>
                    LatLng(vertex['latitude'], vertex['longitude']))
                .toList());
      }).toList();
      updateMap();
    }
  }

  Future<void> saveGeofences() async {
    final prefs = await SharedPreferences.getInstance();
    final geofencesJson = json.encode(savedGeofences.map((geofence) {
      return {
        'name': geofence.name,
        'vertices': geofence.vertices
            .map((vertex) {
              return {
                'latitude': vertex.latitude,
                'longitude': vertex.longitude,
              };
            })
            .toList()
      };
    }).toList());
    await prefs.setString('geofences', geofencesJson);
  }

  void updateMap() {
    _markers.clear();
    _polygons.clear();

    if (savedGeofences.isNotEmpty) {
      for (final geofence in savedGeofences) {
        if (geofence.vertices.isNotEmpty) {
          _polygons.add(Polygon(
            polygonId: PolygonId(geofence.name),
            points: geofence.vertices,
            strokeWidth: 2,
            strokeColor: Colors.green,
            fillColor: Colors.green.withOpacity(0.2),
          ));
        }
      }
    }

    if (geofenceVertices.isNotEmpty) {
      _polygons.add(Polygon(
        polygonId: PolygonId('currentGeofence'),
        points: geofenceVertices,
        strokeWidth: 2,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.2),
      ));
    }

    if (_currentLocation != null) {
      final currentLatLng = LatLng(
        _currentLocation!.latitude!,
        _currentLocation!.longitude!,
      );
      _markers.add(Marker(
        markerId: MarkerId('currentLocation'),
        position: currentLatLng,
        infoWindow: InfoWindow(title: 'Your Location'),
      ));
    }
  }

  void setGeofence(List<LatLng> vertices) {
    showDialog(
      context: context,
      builder: (context) {
        String geofenceName = '';

        return AlertDialog(
          title: Text('Name Your Geofence'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  geofenceName = value;
                },
                decoration: InputDecoration(labelText: 'Geofence Name'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (geofenceName.isNotEmpty) {
                    savedGeofences.add(Geofence(geofenceName, [...geofenceVertices]));
                    saveGeofences();
                    setState(() {
                      geofenceVertices.clear();
                      updateMap();
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  void saveCurrentGeofence() {
    if (geofenceVertices.isNotEmpty) {
      savedGeofences.add(Geofence('Unnamed', [...geofenceVertices]));
      saveGeofences();
      setState(() {
        geofenceVertices.clear();
        updateMap();
      });
    }
  }

  void deleteGeofence(String name) {
    savedGeofences.removeWhere((geofence) => geofence.name == name);
    saveGeofences();
    setState(() {
      updateMap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Location on Google Maps with Geofence'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                _controller = controller;
                updateMap();
              },
              initialCameraPosition: CameraPosition(
                target: _currentLocation != null
                    ? LatLng(
                        _currentLocation!.latitude!,
                        _currentLocation!.longitude!,
                      )
                    : LatLng(19.0390, 72.8619),
                zoom: 15.0,
              ),
              markers: Set<Marker>.from(_markers),
              polygons: _polygons,
              onTap: (LatLng point) {
                setState(() {
                  geofenceVertices.add(point);
                });
                updateMap();
              },
            ),
          ),
          savedGeofences.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: savedGeofences.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(savedGeofences[index].name),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteGeofence(savedGeofences[index].name);
                          },
                        ),
                      );
                    },
                  ),
                )
              : Container(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setGeofence(geofenceVertices);
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              saveCurrentGeofence();
            },
            child: Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}

class Geofence {
  String name;
  List<LatLng> vertices;

  Geofence(this.name, this.vertices);
}