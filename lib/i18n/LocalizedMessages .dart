import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'messages_en.dart';
import 'messages_es.dart';

class LocalizedMessages {
  static String errorMessage(BuildContext context, String code) {
    final locale = Localizations.localeOf(context).toString();

    if (locale.startsWith('en')) {
      return MessagesEn.errorMessage(code);
    } else if (locale.startsWith('es')) {
      return MessagesEs.errorMessage(code);
    }

    // Usa inglés como idioma predeterminado si no se encuentra el idioma actual
    return MessagesEn.errorMessage(code);
  }
}
