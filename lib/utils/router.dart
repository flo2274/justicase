import 'package:flutter/material.dart';

class Navigate {
  //Funktion setzt neue Seite auf den Stapel um zu dieser Seite zu navigieren
  // (Navigation zu einer neuen Seite innerhalb der App)
  static Future pushPage(BuildContext context, Widget page) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }

  // (Popup-Fenster, die den gesamten Bildschirm bedecken)
  static pushPageDialog(BuildContext context, Widget page) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
        fullscreenDialog: true,
      ),
    );
  }

  // Funktion ersetzt die aktuelle Seite im Stapel durch die neue Seite
  // (Für Registrierungsvorgänge wenn vorherige Seite nicht mehr benötigt wird)
  static pushPageReplacement(BuildContext context, Widget page) async {
    return await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }
}