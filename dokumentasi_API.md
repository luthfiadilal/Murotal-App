**API Al Quran**

- API GET MP3
https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/1.mp3

penjelasan
    - {edition} - An audio edition available on https://cdn.islamic.network/quran/info/by-surah/info.json . (Example - ar.alafasy).
    - {number} - A surah number. The Quran contains 114 surahs, so this must be a number between 1 and 114.
    - {bitrate} - Quality of audio served. Different editions are available at different bitrates. You can see which edition is available at what bitrate on

- API GET Edition - Available text and audio editions
    1. https://api.alquran.cloud/v1/edition

    {
        "code": 200,
        "status": "OK",
        "data": [
        {
        "identifier": "ar.muyassar",
        "language": "ar",
        "name": "تفسير المیسر",
        "englishName": "King Fahad Quran Complex",
        "format": "text",
        "type": "tafsir",
        "direction": "rtl"
        },
        ]
    }

    2. https://api.alquran.cloud/v1/edition?format=audio&language=fr&type=versebyverse

    {
        "code": 200,
        "status": "OK",
        "data": [
            {
                "identifier": "fr.leclerc",
                "language": "fr",
                "name": "Youssouf Leclerc",
                "englishName": "Youssouf Leclerc",
                "format": "audio",
                "type": "versebyverse",
                "direction": null
            }
        ]
    }

- API GET Quran - Get a complete Quran edition
    https://api.alquran.cloud/v1/quran/en.asad

    {
            "code": 200,
            "status": "OK",
            "data": {
            "surahs": [
                        {
                        "number": 1,
                        "name": "سُورَةُ ٱلْفَاتِحَةِ",
                        "englishName": "Al-Faatiha",
                        "englishNameTranslation": "The Opening",
                        "revelationType": "Meccan",
                        "ayahs": [
                        {
                        "number": 1,
                        "text": "In the name of God, The Most Gracious, The Dispenser of Grace:",
                        "numberInSurah": 1,
                        "juz": 1,
                        "manzil": 1,
                        "page": 1,
                        "ruku": 1,
                        "hizbQuarter": 1,
                        "sajda": false
                        },
                        {
                        "number": 2,
                        "text": "All praise is due to God alone, the Sustainer of all the worlds,",
                        "numberInSurah": 2,
                        "juz": 1,
                        "manzil": 1,
                        "page": 1,
                        "ruku": 1,
                        "hizbQuarter": 1,
                        "sajda": false
                        },
                        ]
                    }
                ],
                "edition": {
                "identifier": "ar.alafasy",
                "language": "ar",
                "name": "مشاري العفاسي",
                "englishName": "Alafasy",
                "format": "audio",
                "type": "versebyverse",
                "direction": null
                }
            }
        }

- API GET Surah - Get a Surah of the Quran
    1. https://api.alquran.cloud/v1/surah/114/ar.alafasy

        {
            "code": 200,
            "status": "OK",
            "data": {
                "number": 114,
                "name": "سُورَةُ النَّاسِ",
                "englishName": "An-Naas",
                "englishNameTranslation": "Mankind",
                "revelationType": "Meccan",
                "numberOfAyahs": 6,
            "ayahs": [
                        {
                            "number": 6231,
                            "audio": "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6231.mp3",
                            "audioSecondary": [
                            "https://cdn.islamic.network/quran/audio/64/ar.alafasy/6231.mp3"
                            ],
                            "text": "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ",
                            "numberInSurah": 1,
                            "juz": 30,
                            "manzil": 7,
                            "page": 604,
                            "ruku": 556,
                            "hizbQuarter": 240,
                            "sajda": false
                            },
                            {
                            "number": 6232,
                            "audio": "https://cdn.islamic.network/quran/audio/128/ar.alafasy/6232.mp3",
                            "audioSecondary": [
                            "https://cdn.islamic.network/quran/audio/64/ar.alafasy/6232.mp3"
                            ],
                            "text": "مَلِكِ ٱلنَّاسِ",
                            "numberInSurah": 2,
                            "juz": 30,
                            "manzil": 7,
                            "page": 604,
                            "ruku": 556,
                            "hizbQuarter": 240,
                            "sajda": false
                        },
                    ]
                }
            }

    2. https://api.alquran.cloud/v1/surah/114

        {
            "code": 200,
            "status": "OK",
            "data": {
            "number": 114,
            "name": "سُورَةُ النَّاسِ",
            "englishName": "An-Naas",
            "englishNameTranslation": "Mankind",
            "revelationType": "Meccan",
            "numberOfAyahs": 6,
            "ayahs": [
                        {
                            "number": 6231,
                            "text": "بِسۡمِ ٱللَّهِ ٱلرَّحۡمَـٰنِ ٱلرَّحِیمِ قُلۡ أَعُوذُ بِرَبِّ ٱلنَّاسِ\n",
                            "numberInSurah": 1,
                            "juz": 30,
                            "manzil": 7,
                            "page": 604,
                            "ruku": 556,
                            "hizbQuarter": 240,
                            "sajda": false
                        },
                        {
                            "number": 6232,
                            "text": "مَلِكِ ٱلنَّاسِ\n",
                            "numberInSurah": 2,
                            "juz": 30,
                            "manzil": 7,
                            "page": 604,
                            "ruku": 556,
                            "hizbQuarter": 240,
                            "sajda": false
                        },
            ],
            "edition": {
            "identifier": "quran-uthmani-quran-academy",
            "language": "ar",
            "name": "القرآن الكريم برسم العثماني (quran-academy)",
            "englishName": "Modified Quran Uthmani Text from the Quran Academy to work with the Kitab font",
            "format": "text",
            "type": "quran",
            "direction": "rtl"
            }
        }
    }
        

 