import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'


class ConnectionSuccesfulScreen extends StatelessWidget {
  ConnectionSuccesfulScreen({Key? key})
    : super(
      key: key,
    );
  Completer<GoogleMapController> googleMapController = Completer ();

  @override
  Widget build(BuildContext context){
    return SafeArea (
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_buildBasemapImage(context)],
          ),
        ),
      ),
    );
  }


  /// Section Widget
  Widget _buildBasemapImage(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            37.43296265331129,
            -122.08832357078792,
          ),
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          googleMapController.complete(controller);
        },
        zoomControlsEnabled: false,
        ZoomGesturesEnabled: false,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
      ),
    );
  }
}