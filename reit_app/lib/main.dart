import 'package:reit_app/routes.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:reit_app/screens/detail_reit/detail_reit.dart';
import 'package:reit_app/services/reit_detail_service.dart';

void main() {
  ModuleContainer().initialise(Injector.getInjector());
  Routes();
}


class ModuleContainer {
  Injector initialise(Injector injector) {
    injector.map<ReitDetailService>((i) => new ReitDetailService(), isSingleton: true);
    injector.map<DetailReit>((i) => DetailReit(reitDetailService: i.get<ReitDetailService>()));
    return injector;
  }
}
