import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestorehelpertest/location.dart';
import 'package:firestore_helpers/firestore_helpers.dart';

class DatabaseService
{
    final locationCollection = Firestore.instance.collection("locations");

    Future<void> createLocation(Location loc) async
    {
        locationCollection.document().setData(LocationSerializer().toMap(loc));
    }

    Stream<List<Location>> getLocations({GeoPoint center, double radiusInKm})
    {
        return getDataInArea<Location>(source: locationCollection,
        area: Area(center, radiusInKm),
        locationFieldNameInDB: 'position',
        mapper: (doc) => LocationSerializer().fromMap(doc.data),
        locationAccessor: (item) => item.position,
        // The distancemapper is applied after the mapper
        distanceMapper: (item, dist) {
            item.distance = dist;
            return item;
        } 

        );
    }
}