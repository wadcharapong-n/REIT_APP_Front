import 'package:reit_app/routes.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:reit_app/services/authen_service.dart';
import 'package:reit_app/services/favorite_services.dart';
import 'package:reit_app/services/reit_detail_service.dart';
import 'package:reit_app/services/shared_preferences_service.dart';
import 'package:reit_app/services/location_page_service.dart';
import 'package:reit_app/services/map_search_service.dart';
import 'package:reit_app/services/search_service.dart';
import 'package:reit_app/services/splash_service.dart';
import 'package:reit_app/services/profile_service.dart';

void main() {
  ModuleContainer().initialise(Injector.getInjector());
  Routes();
}

class ModuleContainer {
  Injector initialise(Injector injector) {
    injector.map<ReitDetailService>((i) => new ReitDetailService(), isSingleton: true);
    injector.map<FavoriteService>((i) => new FavoriteService(), isSingleton: true);
    injector.map<SharedPreferencesService>((i) => new SharedPreferencesService(), isSingleton: true);
    injector.map<AuthenService>((i) => new AuthenService(), isSingleton: true);
    injector.map<LocationPageService>((i) => new LocationPageService(), isSingleton: true);
    injector.map<MapSearchService>((i) => new MapSearchService(), isSingleton: true);
    injector.map<SearchService>((i) => new SearchService(), isSingleton: true);
    injector.map<SplashService>((i) => new SplashService(), isSingleton: true);
    injector.map<ProfileService>((i) => new ProfileService(), isSingleton: true);
    return injector;
  }
}
