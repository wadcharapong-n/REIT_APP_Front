import 'package:reit_app/routes.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:reit_app/services/authen_service.dart';
import 'package:reit_app/services/favorite_services.dart';
import 'package:reit_app/services/reit_detail_service.dart';
import 'package:reit_app/services/shared_preferences_service.dart';

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
    // injector.map<List<ReitFavorite>>((i) => new List<ReitFavorite>(), isSingleton: true);
    // injector.map<DetailReit>((i) => DetailReit(reitDetailService: i.get<ReitDetailService>()));
    return injector;
  }
}
