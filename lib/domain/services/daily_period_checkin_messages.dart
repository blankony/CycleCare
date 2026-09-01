class DailyPeriodCheckinMessages {
  static const _idLocaleBodies = {
    'id': [
      'Selamat pagi! \u{1F496} Bagaimana kabarmu di hari haid ini? Ceritakan perasaanmu yuk.',
      'Pagi sayang \u{1F338} Jangan lupa istirahat yang cukup dan minum air putih yang banyak ya.',
      'Kirim pelukan hangat untukmu hari ini \u{2728} Kamu kuat dan hebat!',
      'Selamat pagi, cantik! \u{1F496} Bagaimana perasaanmu pagi ini? Tap untuk berbagi ceritamu.',
      'Semangat untuk hari ini! \u{1F33C} Dengarkan tubuhmu dan beri ia cinta yang ia butuhkan.',
      'Halo bidadari \u{1F90D} Hari haid bukan halangan untuk bersinar. Bagaimana mood-mu pagi ini?',
      'Pagi yang indah \u{263A} Ingat, setiap cerita period-mu berarti. Yuk catat perasaanmu hari ini!',
    ],
    'en': [
      'Good morning, beautiful! \u{1F338} How are you feeling on your period today? Tap to check in \u{2728}',
      'Sending you warm vibes today \u{2728} Remember to rest up and stay hydrated!',
      'Good morning, sunshine \u{2600} Your body is doing something amazing. How do you feel today?',
      'Hey lovely! \u{1F90D} Quick check-in: how is your mood on this period day?',
      'Rise and shine, warrior \u{1F49B} You are strong. How are you feeling this morning?',
      'Gentle reminder \u{1F49C} Be kind to yourself today. Tap to share how you are doing.',
      'Morning love \u{1F33C} Small check-in, big self-care. How is your period day going?',
    ],
  };

  static const _idLocaleTitles = {
    'id': 'Selamat Pagi \u{1F338}',
    'en': 'Good Morning \u{1F338}',
  };

  static String title(String localeCode) {
    return _idLocaleTitles[localeCode] ?? _idLocaleTitles['en']!;
  }

  static String body(String localeCode, int dayOfYear) {
    final list = _idLocaleBodies[localeCode] ?? _idLocaleBodies['en']!;
    return list[dayOfYear % list.length];
  }
}
