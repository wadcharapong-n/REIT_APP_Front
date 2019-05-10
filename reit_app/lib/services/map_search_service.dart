import 'dart:async';
import 'package:reit_app/app_config.dart';
import "package:google_maps_webservice/places.dart";

class MapSearchService {
  final places = GoogleMapsPlaces(apiKey: AppConfig.googleApiKey);

  Future<List> placesSearch(String searchText) async {
    List placesList = List();
    List placesDetail = List();
    PlacesAutocompleteResponse reponse =
        await places.autocomplete(searchText, language: 'th');
    if (reponse.isOkay) {
      reponse.predictions.forEach((Prediction place) {
        placesList.add(place);
      });
    }

    for (var place in placesList) {
      PlacesDetailsResponse details =
          await places.getDetailsByPlaceId(place.placeId, language: 'th');
      placesDetail.add(details);
    }
    return placesDetail;
  }

  Future<PlacesSearchResponse> textSearch(String searchText) async {
    PlacesSearchResponse reponse =
        await places.searchByText(searchText, language: 'th');
    return reponse;
  }
}
