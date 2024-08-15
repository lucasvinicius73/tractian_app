import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tractian_app/models/asset_model.dart';
import 'package:tractian_app/models/companie_model.dart';
import 'package:tractian_app/models/location_model.dart';

class ServiceJson {
  String urlCompanies = "https://fake-api.tractian.com/companies";
  //String urlLocations = "https://fake-api.tractian.com/";
  //String urlAssets = "https://fake-api.tractian.com/";

  Future<List<Companie>> fetchCompaniesJson() async {
    print("Iniciando Fetch em $urlCompanies");
    final response = await http.get(Uri.parse(urlCompanies));
    final data = utf8.decode(response.bodyBytes);
    List body = json.decode(data);
    final companies = body.map((json) => Companie.fromJson(json)).toList();
    print(companies);

    return companies;
  }

  Future fetchLocationsJson(String companieID) async {
    String urlLocation = '${urlCompanies}/$companieID/locations';
    print("Iniciando Fetch dos Locais em $urlLocation");

    final response = await http.get(Uri.parse(urlLocation));

    final data = utf8.decode(response.bodyBytes);
    List body = json.decode(data);
    final locations = body.map((json) => LocationModel.fromJson(json)).toList();

    return locations;
  }

  Future fetchAssetsJson(String companieID) async {
    String urlAssets = '${urlCompanies}/$companieID/assets';
    print("Iniciando Fetch dos Assets em $urlAssets");

    final response = await http.get(Uri.parse(urlAssets));
    final data = utf8.decode(response.bodyBytes);
    List body = json.decode(data);
    final assets = body.map((json) => AssetModel.fromJson(json)).toList();

    return assets;
  }
}
