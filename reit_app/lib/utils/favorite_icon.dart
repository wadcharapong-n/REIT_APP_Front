// import 'package:flutter/material.dart';
// import 'package:flutter_simple_dependency_injection/injector.dart';
// import 'package:reit_app/services/favorite_services.dart';

// class DetailReit {
//   var favoriteService = Injector.getInjector().get<FavoriteService>();
  
//   IconButton iconFavorite(reitSymbol) {
//     return IconButton(
//         icon: Icon(
//           Icons.star_border,
//           color: Colors.blue,
//           size: 30,
//         ),
//         onPressed: () {
//           favoriteService.addReitFavorite(reitSymbol).then((result) {
//             setState(() {
//               isFavoriteReit = false;
//             });
//           });
//           reitDetailService.getReitDetailBySymbol(widget.reitSymbol).then((result) {
//             setState(() {
//               reitDetail = result;
//             });
//           });
//         });
//   }
// }


