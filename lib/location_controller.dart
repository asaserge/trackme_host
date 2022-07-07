import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:supabase/supabase.dart';

const supabaseUrl = 'https://cayeijyxfdvbkjmmoeiz.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNheWVpanl4ZmR2YmtqbW1vZWl6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTYzODIzMzksImV4cCI6MTk3MTk1ODMzOX0.VJMyYQsdAKWc-63HfQrVLA6oEDRecl29DtiK8XIYZvs';

class LocationController extends GetxController {
  var lon = 0.0.obs;
  var lat = 0.0.obs;
  var alt = 0.0.obs;
  var vel = 0.0.obs;
  var hea = 0.0.obs;
  var acc = 0.0.obs;
  var isTracking = false.obs;
  final client = SupabaseClient(supabaseUrl, supabaseKey);

  insertLocationData(LocationData data) async {
    final res = await client.from('gps').insert([
      {
        'name': 'Toyota Vitz',
        'longitude': data.longitude,
        'latitude': data.latitude,
        'altitude': data.altitude,
        'speed': data.speed,
        'heading': data.heading,
        'accuracy': data.accuracy
      }
    ]).execute();
    if (res.error != null) {
      print(res.error!.message.toString());
    } else {
      print(res.data.toString());
    }
  }

  updateLocationData(LocationData data) async {
    final res = await client
        .from('gps')
        .update({
          'longitude': data.longitude,
          'latitude': data.latitude,
          'altitude': data.altitude,
          'speed': data.speed,
          'heading': data.heading,
          'accuracy': data.accuracy,
        })
        .eq('id', 1)
        .execute();
    if (res.error != null) {
      print(res.error!.message.toString());
    } else {
      print(res.data.toString());
    }
  }
}
