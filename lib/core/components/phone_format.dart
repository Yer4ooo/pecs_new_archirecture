class PhoneFormat {
  final String country;
  final String phoneCode;
  final String countryCode;
  final String phoneMask;

  PhoneFormat({
    required this.country,
    required this.phoneCode,
    required this.countryCode,
    required this.phoneMask,
  });

  factory PhoneFormat.kz() {
    return PhoneFormat(
      country: 'Kazakhstan',
      phoneCode: '7',
      countryCode: 'KZ',
      phoneMask: '+9 (999) 999 9999',
    );
  }

  factory PhoneFormat.parseJson(Map json) {
    return PhoneFormat(
      country: json['country'],
      phoneCode: json['phoneCode'],
      countryCode: json['countryCode'],
      phoneMask: json['phoneMask'],
    );
  }

  static List<PhoneFormat> parseList() {
    List<PhoneFormat> list =
        _data.map((e) => PhoneFormat.parseJson(e)).toList();
    return list;
  }

  static List<PhoneFormat> cisList() {
    List<PhoneFormat> list =
        _dataCis.map((e) => PhoneFormat.parseJson(e)).toList();
    return list;
  }

  String get getPhoneCode {
    String codeMask = phoneMask.split(' ').first;
    codeMask = codeMask.replaceFirst('+', '');
    return '+${phoneCode.substring(0, codeMask.length)}';
  }

  String get getPhone {
    String codeMask = phoneMask.split(' ').first;
    codeMask = codeMask.replaceFirst('+', '');
    if (codeMask.length == phoneCode.length) return '';
    return phoneCode.substring(codeMask.length);
  }

  String get getMask {
    String code = phoneMask.split(' ')[0];
    return phoneMask.replaceFirst('$code ', '');
  }

  String get hintText {
    return getMask.replaceAll('9', '-');
  }

  static final List<Map<String, dynamic>> _dataCis = <Map<String, dynamic>>[
    {
      'country': 'Kazakhstan',
      'phoneCode': '7',
      'countryCode': 'KZ',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Russia',
      'phoneCode': '7',
      'countryCode': 'RU',
      'phoneMask': '+9 (999) 999-99-99',
    },
    {
      'country': 'Ukraine',
      'phoneCode': '380',
      'countryCode': 'UA',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Uzbekistan',
      'phoneCode': '998',
      'countryCode': 'UZ',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Kyrgyzstan',
      'phoneCode': '996',
      'countryCode': 'KG',
      'phoneMask': '+999 999 999999',
    },
    {
      'country': 'Armenia',
      'phoneCode': '374',
      'countryCode': 'AM',
      'phoneMask': '+999 999 999 9999',
    },
    {
      'country': 'Azerbaijan',
      'phoneCode': '994',
      'countryCode': 'AZ',
      'phoneMask': '+999 999 999 9999',
    },
    {
      'country': 'Belarus',
      'phoneCode': '375',
      'countryCode': 'BY',
      'phoneMask': '+999 999 999 9999',
    },
    {
      'country': 'Romania',
      'phoneCode': '40',
      'countryCode': 'RO',
      'phoneMask': '+99 999 999 999',
    },
    {
      'country': 'Tajikistan',
      'phoneCode': '992',
      'countryCode': 'TJ',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Turkmenistan',
      'phoneCode': '993',
      'countryCode': 'TM',
      'phoneMask': '+999 99 999999',
    },
    {
      'country': 'Hungary',
      'phoneCode': '36',
      'countryCode': 'HU',
      'phoneMask': '+99 99 999 999',
    },
  ];

  static final List<Map<String, dynamic>> _data = <Map<String, dynamic>>[
    {
      'country': 'Afghanistan',
      'phoneCode': '93',
      'countryCode': 'AF',
      'phoneMask': '+99 999 999 9999',
    },
    {
      'country': 'Albania',
      'phoneCode': '355',
      'countryCode': 'AL',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Algeria',
      'phoneCode': '213',
      'countryCode': 'DZ',
      'phoneMask': '+999 9 999 9999',
    },
    {
      'country': 'American Samoa',
      'phoneCode': '1684',
      'countryCode': 'AS',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Andorra',
      'phoneCode': '376',
      'countryCode': 'AD',
      'phoneMask': '+999 999 999 9999',
    },
    {
      'country': 'Angola',
      'phoneCode': '244',
      'countryCode': 'AO',
      'phoneMask': '+999 9999 999 9999',
    },
    {
      'country': 'Anguilla',
      'phoneCode': '1264',
      'countryCode': 'AI',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Antigua and Barbuda',
      'phoneCode': '1268',
      'countryCode': 'AG',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Argentina',
      'phoneCode': '54',
      'countryCode': 'AR',
      'phoneMask': '+99 9 999 9999',
    },
    {
      'country': 'Armenia',
      'phoneCode': '374',
      'countryCode': 'AM',
      'phoneMask': '+999 999 999 9999',
    },
    {
      'country': 'Aruba',
      'phoneCode': '297',
      'countryCode': 'AW',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Australia',
      'phoneCode': '61',
      'countryCode': 'AU',
      'phoneMask': '+99 999 999 9999',
    },
    {
      'country': 'Austria',
      'phoneCode': '43',
      'countryCode': 'AT',
      'phoneMask': '+99 999 999 9999',
    },
    {
      'country': 'Azerbaijan',
      'phoneCode': '994',
      'countryCode': 'AZ',
      'phoneMask': '+999 999 999 9999',
    },
    {
      'country': 'Bahamas',
      'phoneCode': '1242',
      'countryCode': 'BS',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Bahrain',
      'phoneCode': '973',
      'countryCode': 'BH',
      'phoneMask': '+999 999 999 9999',
    },
    {
      'country': 'Bangladesh',
      'phoneCode': '880',
      'countryCode': 'BD',
      'phoneMask': '+999 999 999 9999',
    },
    {
      'country': 'Barbados',
      'phoneCode': '1246',
      'countryCode': 'BB',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Belarus',
      'phoneCode': '375',
      'countryCode': 'BY',
      'phoneMask': '+999 999 999 9999',
    },
    {
      'country': 'Belgium',
      'phoneCode': '32',
      'countryCode': 'BE',
      'phoneMask': '+99 999 999 9999',
    },
    {
      'country': 'Belize',
      'phoneCode': '501',
      'countryCode': 'BZ',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Benin',
      'phoneCode': '229',
      'countryCode': 'BJ',
      'phoneMask': '+999 999 999 9999',
    },
    {
      'country': 'Bermuda',
      'phoneCode': '1441',
      'countryCode': 'BM',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Bhutan',
      'phoneCode': '975',
      'countryCode': 'BT',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Bosnia and Herzegovina',
      'phoneCode': '387',
      'countryCode': 'BA',
      'phoneMask': '+999 999 999 9999',
    },
    {
      'country': 'Botswana',
      'phoneCode': '267',
      'countryCode': 'BW',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Brazil',
      'phoneCode': '55',
      'countryCode': 'BR',
      'phoneMask': '+99 (99) 9999-9999',
    },
    {
      'country': 'British Indian Ocean Territory',
      'phoneCode': '246',
      'countryCode': 'IO',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Bulgaria',
      'phoneCode': '359',
      'countryCode': 'BG',
      'phoneMask': '+999 9 999 9999',
    },
    {
      'country': 'Burkina Faso',
      'phoneCode': '226',
      'countryCode': 'BF',
      'phoneMask': '+999 9 999 9999',
    },
    {
      'country': 'Burundi',
      'phoneCode': '257',
      'countryCode': 'BI',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Cambodia',
      'phoneCode': '855',
      'countryCode': 'KH',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Cameroon',
      'phoneCode': '237',
      'countryCode': 'CM',
      'phoneMask': '+999 9 999 9999',
    },
    {
      'country': 'United States',
      'phoneCode': '1',
      'countryCode': 'US',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Canada',
      'phoneCode': '1',
      'countryCode': 'CA',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Cape Verde',
      'phoneCode': '238',
      'countryCode': 'CV',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Cayman Islands',
      'phoneCode': '345',
      'countryCode': 'KY',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Central African Republic',
      'phoneCode': '236',
      'countryCode': 'CF',
      'phoneMask': '+999 9 999 9999',
    },
    {
      'country': 'Chad',
      'phoneCode': '235',
      'countryCode': 'TD',
      'phoneMask': '+999 9 999 9999',
    },
    {
      'country': 'Chile',
      'phoneCode': '56',
      'countryCode': 'CL',
      'phoneMask': '+99 99 999 9999',
    },
    {
      'country': 'China',
      'phoneCode': '86',
      'countryCode': 'CN',
      'phoneMask': '+99 999 999 9999',
    },
    {
      'country': 'Christmas Island',
      'phoneCode': '61',
      'countryCode': 'CX',
      'phoneMask': '+99 9 9999 9999',
    },
    {
      'country': 'Colombia',
      'phoneCode': '57',
      'countryCode': 'CO',
      'phoneMask': '+99 999 999 9999',
    },
    {
      'country': 'Comoros',
      'phoneCode': '269',
      'countryCode': 'KM',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Congo',
      'phoneCode': '242',
      'countryCode': 'CG',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Cook Islands',
      'phoneCode': '682',
      'countryCode': 'CK',
      'phoneMask': '+682 99 999',
    },
    {
      'country': 'Costa Rica',
      'phoneCode': '506',
      'countryCode': 'CR',
      'phoneMask': '+999 9 999 9999',
    },
    {
      'country': 'Croatia',
      'phoneCode': '385',
      'countryCode': 'HR',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Cuba',
      'phoneCode': '53',
      'countryCode': 'CU',
      'phoneMask': '+99 999 999 9999',
    },
    {
      'country': 'Cyprus',
      'phoneCode': '357',
      'countryCode': 'CY',
      'phoneMask': '+999 9 999 9999',
    },
    {
      'country': 'Czech Republic',
      'phoneCode': '420',
      'countryCode': 'CZ',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Denmark',
      'phoneCode': '45',
      'countryCode': 'DK',
      'phoneMask': '+99 9 999 9999',
    },
    {
      'country': 'Djibouti',
      'phoneCode': '253',
      'countryCode': 'DJ',
      'phoneMask': '+999 9 999 9999',
    },
    {
      'country': 'Dominica',
      'phoneCode': '1767',
      'countryCode': 'DM',
      'phoneMask': '+9999 999 9999',
    },
    {
      'country': 'Dominican Republic',
      'phoneCode': '1809',
      'countryCode': 'DO',
      'phoneMask': '+9999 999 9999',
    },
    {
      'country': 'Ecuador',
      'phoneCode': '593',
      'countryCode': 'EC',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Egypt',
      'phoneCode': '20',
      'countryCode': 'EG',
      'phoneMask': '+99 999 999 9999',
    },
    {
      'country': 'El Salvador',
      'phoneCode': '503',
      'countryCode': 'SV',
      'phoneMask': '+999 99 9999 9999',
    },
    {
      'country': 'Equatorial Guinea',
      'phoneCode': '240',
      'countryCode': 'GQ',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Eritrea',
      'phoneCode': '291',
      'countryCode': 'ER',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Estonia',
      'phoneCode': '372',
      'countryCode': 'EE',
      'phoneMask': '+999 999 999',
    },
    {
      'country': 'Ethiopia',
      'phoneCode': '251',
      'countryCode': 'ET',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Faroe Islands',
      'phoneCode': '298',
      'countryCode': 'FO',
      'phoneMask': '+999 999999',
    },
    {
      'country': 'Fiji',
      'phoneCode': '679',
      'countryCode': 'FJ',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Finland',
      'phoneCode': '358',
      'countryCode': 'FI',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'France',
      'phoneCode': '33',
      'countryCode': 'FR',
      'phoneMask': '+99 9 99 99 99 99',
    },
    {
      'country': 'French Guiana',
      'phoneCode': '594',
      'countryCode': 'GF',
      'phoneMask': '+999 999 99 99 99',
    },
    {
      'country': 'French Polynesia',
      'phoneCode': '689',
      'countryCode': 'PF',
      'phoneMask': '+999 999999',
    },
    {
      'country': 'Gabon',
      'phoneCode': '241',
      'countryCode': 'GA',
      'phoneMask': '+999 999999',
    },
    {
      'country': 'Gambia',
      'phoneCode': '220',
      'countryCode': 'GM',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Georgia',
      'phoneCode': '995',
      'countryCode': 'GE',
      'phoneMask': '+999 999 999999',
    },
    {
      'country': 'Germany',
      'phoneCode': '49',
      'countryCode': 'DE',
      'phoneMask': '+99 99 999999999',
    },
    {
      'country': 'Ghana',
      'phoneCode': '233',
      'countryCode': 'GH',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Gibraltar',
      'phoneCode': '350',
      'countryCode': 'GI',
      'phoneMask': '+999 99999',
    },
    {
      'country': 'Greece',
      'phoneCode': '30',
      'countryCode': 'GR',
      'phoneMask': '+99 9 999 9999',
    },
    {
      'country': 'Greenland',
      'phoneCode': '299',
      'countryCode': 'GL',
      'phoneMask': '+999 999999',
    },
    {
      'country': 'Grenada',
      'phoneCode': '1473',
      'countryCode': 'GD',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Guadeloupe',
      'phoneCode': '590',
      'countryCode': 'GP',
      'phoneMask': '+999 999 99 99 99',
    },
    {
      'country': 'Guam',
      'phoneCode': '1671',
      'countryCode': 'GU',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Guatemala',
      'phoneCode': '502',
      'countryCode': 'GT',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Guinea',
      'phoneCode': '224',
      'countryCode': 'GN',
      'phoneMask': '+999 999 999999',
    },
    {
      'country': 'Guinea-Bissau',
      'phoneCode': '245',
      'countryCode': 'GW',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Guyana',
      'phoneCode': '592',
      'countryCode': 'GY',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Haiti',
      'phoneCode': '509',
      'countryCode': 'HT',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Honduras',
      'phoneCode': '504',
      'countryCode': 'HN',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Hungary',
      'phoneCode': '36',
      'countryCode': 'HU',
      'phoneMask': '+99 99 999 999',
    },
    {
      'country': 'Iceland',
      'phoneCode': '354',
      'countryCode': 'IS',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'India',
      'phoneCode': '91',
      'countryCode': 'IN',
      'phoneMask': '+99 999 999 9999',
    },
    {
      'country': 'Indonesia',
      'phoneCode': '62',
      'countryCode': 'ID',
      'phoneMask': '+99 99 9999 9999',
    },
    {
      'country': 'Iraq',
      'phoneCode': '964',
      'countryCode': 'IQ',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Ireland',
      'phoneCode': '353',
      'countryCode': 'IE',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Israel',
      'phoneCode': '972',
      'countryCode': 'IL',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Italy',
      'phoneCode': '39',
      'countryCode': 'IT',
      'phoneMask': '+99 99 999 9999',
    },
    {
      'country': 'Jamaica',
      'phoneCode': '1876',
      'countryCode': 'JM',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Japan',
      'phoneCode': '81',
      'countryCode': 'JP',
      'phoneMask': '+99 99 999 9999',
    },
    {
      'country': 'Jordan',
      'phoneCode': '962',
      'countryCode': 'JO',
      'phoneMask': '+999 9 999 9999',
    },
    {
      'country': 'Kazakhstan',
      'phoneCode': '7',
      'countryCode': 'KZ',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Kenya',
      'phoneCode': '254',
      'countryCode': 'KE',
      'phoneMask': '+999 999 999999',
    },
    {
      'country': 'Kiribati',
      'phoneCode': '686',
      'countryCode': 'KI',
      'phoneMask': '+999 99999',
    },
    {
      'country': 'Kuwait',
      'phoneCode': '965',
      'countryCode': 'KW',
      'phoneMask': '+999 9999 9999',
    },
    {
      'country': 'Kyrgyzstan',
      'phoneCode': '996',
      'countryCode': 'KG',
      'phoneMask': '+999 999 999999',
    },
    {
      'country': 'Latvia',
      'phoneCode': '371',
      'countryCode': 'LV',
      'phoneMask': '+999 9999 9999',
    },
    {
      'country': 'Lebanon',
      'phoneCode': '961',
      'countryCode': 'LB',
      'phoneMask': '+999 99 999 999',
    },
    {
      'country': 'Lesotho',
      'phoneCode': '266',
      'countryCode': 'LS',
      'phoneMask': '+999 9999 9999',
    },
    {
      'country': 'Liberia',
      'phoneCode': '231',
      'countryCode': 'LR',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Liechtenstein',
      'phoneCode': '423',
      'countryCode': 'LI',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Lithuania',
      'phoneCode': '370',
      'countryCode': 'LT',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Luxembourg',
      'phoneCode': '352',
      'countryCode': 'LU',
      'phoneMask': '+999 999999',
    },
    {
      'country': 'Madagascar',
      'phoneCode': '261',
      'countryCode': 'MG',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Malawi',
      'phoneCode': '265',
      'countryCode': 'MW',
      'phoneMask': '+999 999999999',
    },
    {
      'country': 'Malaysia',
      'phoneCode': '60',
      'countryCode': 'MY',
      'phoneMask': '+99 9 999 9999',
    },
    {
      'country': 'Maldives',
      'phoneCode': '960',
      'countryCode': 'MV',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Mali',
      'phoneCode': '223',
      'countryCode': 'ML',
      'phoneMask': '+999 9999 9999',
    },
    {
      'country': 'Malta',
      'phoneCode': '356',
      'countryCode': 'MT',
      'phoneMask': '+999 9999 9999',
    },
    {
      'country': 'Marshall Islands',
      'phoneCode': '692',
      'countryCode': 'MH',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Martinique',
      'phoneCode': '596',
      'countryCode': 'MQ',
      'phoneMask': '+999 999 99 99 99',
    },
    {
      'country': 'Mauritania',
      'phoneCode': '222',
      'countryCode': 'MR',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Mauritius',
      'phoneCode': '230',
      'countryCode': 'MU',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Mayotte',
      'phoneCode': '262',
      'countryCode': 'YT',
      'phoneMask': '+999 999 99 99 99',
    },
    {
      'country': 'Mexico',
      'phoneCode': '52',
      'countryCode': 'MX',
      'phoneMask': '+99 999 999 9999',
    },
    {
      'country': 'Monaco',
      'phoneCode': '377',
      'countryCode': 'MC',
      'phoneMask': '+999 9999 9999',
    },
    {
      'country': 'Mongolia',
      'phoneCode': '976',
      'countryCode': 'MN',
      'phoneMask': '+999 99 999999',
    },
    {
      'country': 'Montenegro',
      'phoneCode': '382',
      'countryCode': 'ME',
      'phoneMask': '+999 99 999999',
    },
    {
      'country': 'Montserrat',
      'phoneCode': '1664',
      'countryCode': 'MS',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Morocco',
      'phoneCode': '212',
      'countryCode': 'MA',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Myanmar',
      'phoneCode': '95',
      'countryCode': 'MM',
      'phoneMask': '+99 99 999 9999',
    },
    {
      'country': 'Namibia',
      'phoneCode': '264',
      'countryCode': 'NA',
      'phoneMask': '+999 99 999999',
    },
    {
      'country': 'Nauru',
      'phoneCode': '674',
      'countryCode': 'NR',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Nepal',
      'phoneCode': '977',
      'countryCode': 'NP',
      'phoneMask': '+999 999 999 9999',
    },
    {
      'country': 'Netherlands',
      'phoneCode': '31',
      'countryCode': 'NL',
      'phoneMask': '+99 99 999 9999',
    },
    {
      'country': 'Netherlands Antilles',
      'phoneCode': '599',
      'countryCode': 'AN',
      'phoneMask': '+999 99999999',
    },
    {
      'country': 'New Caledonia',
      'phoneCode': '687',
      'countryCode': 'NC',
      'phoneMask': '+999 999999',
    },
    {
      'country': 'New Zealand',
      'phoneCode': '64',
      'countryCode': 'NZ',
      'phoneMask': '+99 9 999 9999',
    },
    {
      'country': 'Nicaragua',
      'phoneCode': '505',
      'countryCode': 'NI',
      'phoneMask': '+999 9999 9999',
    },
    {
      'country': 'Niger',
      'phoneCode': '227',
      'countryCode': 'NE',
      'phoneMask': '+999 99 999999',
    },
    {
      'country': 'Nigeria',
      'phoneCode': '234',
      'countryCode': 'NG',
      'phoneMask': '+999 999 999 9999',
    },
    {
      'country': 'Niue',
      'phoneCode': '683',
      'countryCode': 'NU',
      'phoneMask': '+999 9999999',
    },
    {
      'country': 'Norfolk Island',
      'phoneCode': '672',
      'countryCode': 'NF',
      'phoneMask': '+999 9 99 999',
    },
    {
      'country': 'Northern Mariana Islands',
      'phoneCode': '1670',
      'countryCode': 'MP',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Norway',
      'phoneCode': '47',
      'countryCode': 'NO',
      'phoneMask': '+99 9999 9999',
    },
    {
      'country': 'Oman',
      'phoneCode': '968',
      'countryCode': 'OM',
      'phoneMask': '+999 9999 9999',
    },
    {
      'country': 'Pakistan',
      'phoneCode': '92',
      'countryCode': 'PK',
      'phoneMask': '+99 9999999',
    },
    {
      'country': 'Palau',
      'phoneCode': '680',
      'countryCode': 'PW',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Panama',
      'phoneCode': '507',
      'countryCode': 'PA',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Papua New Guinea',
      'phoneCode': '675',
      'countryCode': 'PG',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Paraguay',
      'phoneCode': '595',
      'countryCode': 'PY',
      'phoneMask': '+999 999 999999',
    },
    {
      'country': 'Peru',
      'phoneCode': '51',
      'countryCode': 'PE',
      'phoneMask': '+99 99 999999999',
    },
    {
      'country': 'Philippines',
      'phoneCode': '63',
      'countryCode': 'PH',
      'phoneMask': '+99 99 999 9999',
    },
    {
      'country': 'Poland',
      'phoneCode': '48',
      'countryCode': 'PL',
      'phoneMask': '+99 99 999 9999',
    },
    {
      'country': 'Portugal',
      'phoneCode': '351',
      'countryCode': 'PT',
      'phoneMask': '+999 999 999 999',
    },
    {
      'country': 'Puerto Rico',
      'phoneCode': '1939',
      'countryCode': 'PR',
      'phoneMask': '+9999 999 9999',
    },
    {
      'country': 'Qatar',
      'phoneCode': '974',
      'countryCode': 'QA',
      'phoneMask': '+999 9999 9999',
    },
    {
      'country': 'Romania',
      'phoneCode': '40',
      'countryCode': 'RO',
      'phoneMask': '+99 999 999 999',
    },
    {
      'country': 'Rwanda',
      'phoneCode': '250',
      'countryCode': 'RW',
      'phoneMask': '999 999 999',
    },
    {
      'country': 'Samoa',
      'phoneCode': '685',
      'countryCode': 'WS',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'San Marino',
      'phoneCode': '378',
      'countryCode': 'SM',
      'phoneMask': '+999 9999 999999',
    },
    {
      'country': 'Saudi Arabia',
      'phoneCode': '966',
      'countryCode': 'SA',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Senegal',
      'phoneCode': '221',
      'countryCode': 'SN',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Serbia',
      'phoneCode': '381',
      'countryCode': 'RS',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Seychelles',
      'phoneCode': '248',
      'countryCode': 'SC',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Sierra Leone',
      'phoneCode': '232',
      'countryCode': 'SL',
      'phoneMask': '+999 99 999999',
    },
    {
      'country': 'Singapore',
      'phoneCode': '65',
      'countryCode': 'SG',
      'phoneMask': '+99 9999 9999',
    },
    {
      'country': 'Slovakia',
      'phoneCode': '421',
      'countryCode': 'SK',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Slovenia',
      'phoneCode': '386',
      'countryCode': 'SI',
      'phoneMask': '+999 9 999 99 99',
    },
    {
      'country': 'Solomon Islands',
      'phoneCode': '677',
      'countryCode': 'SB',
      'phoneMask': '+999 99999',
    },
    {
      'country': 'South Africa',
      'phoneCode': '27',
      'countryCode': 'ZA',
      'phoneMask': '+99 99 999 9999',
    },
    {
      'country': 'South Georgia and the South Sandwich Islands',
      'phoneCode': '500',
      'countryCode': 'GS',
      'phoneMask': '+999 99999',
    },
    {
      'country': 'Spain',
      'phoneCode': '34',
      'countryCode': 'ES',
      'phoneMask': '+99 999 999 999',
    },
    {
      'country': 'Sri Lanka',
      'phoneCode': '94',
      'countryCode': 'LK',
      'phoneMask': '+99 99 999 9999',
    },
    {
      'country': 'Sudan',
      'phoneCode': '249',
      'countryCode': 'SD',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Suriname',
      'phoneCode': '597',
      'countryCode': 'SR',
      'phoneMask': '+999 999999',
    },
    {
      'country': 'Swaziland',
      'phoneCode': '268',
      'countryCode': 'SZ',
      'phoneMask': '+999 9 999 9999',
    },
    {
      'country': 'Sweden',
      'phoneCode': '46',
      'countryCode': 'SE',
      'phoneMask': '+99 99 999 9999',
    },
    {
      'country': 'Switzerland',
      'phoneCode': '41',
      'countryCode': 'CH',
      'phoneMask': '+99 99 999 9999',
    },
    {
      'country': 'Tajikistan',
      'phoneCode': '992',
      'countryCode': 'TJ',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Thailand',
      'phoneCode': '66',
      'countryCode': 'TH',
      'phoneMask': '+99 9 999 9999',
    },
    {
      'country': 'Togo',
      'phoneCode': '228',
      'countryCode': 'TG',
      'phoneMask': '+999 9 999 9999',
    },
    {
      'country': 'Tokelau',
      'phoneCode': '690',
      'countryCode': 'TK',
      'phoneMask': '+999 9999',
    },
    {
      'country': 'Tonga',
      'phoneCode': '676',
      'countryCode': 'TO',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Trinidad and Tobago',
      'phoneCode': '1868',
      'countryCode': 'TT',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Tunisia',
      'phoneCode': '216',
      'countryCode': 'TN',
      'phoneMask': '+999 9999 9999',
    },
    {
      'country': 'Turkey',
      'phoneCode': '90',
      'countryCode': 'TR',
      'phoneMask': '+99 999 999 9999',
    },
    {
      'country': 'Turkmenistan',
      'phoneCode': '993',
      'countryCode': 'TM',
      'phoneMask': '+999 99 999999',
    },
    {
      'country': 'Turks and Caicos Islands',
      'phoneCode': '1649',
      'countryCode': 'TC',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Tuvalu',
      'phoneCode': '688',
      'countryCode': 'TV',
      'phoneMask': '+999 99999',
    },
    {
      'country': 'Uganda',
      'phoneCode': '256',
      'countryCode': 'UG',
      'phoneMask': '+999 999 999999',
    },
    {
      'country': 'Ukraine',
      'phoneCode': '380',
      'countryCode': 'UA',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'United Arab Emirates',
      'phoneCode': '971',
      'countryCode': 'AE',
      'phoneMask': '+999 9 9999999',
    },
    {
      'country': 'United Kingdom',
      'phoneCode': '44',
      'countryCode': 'GB',
      'phoneMask': '+99 9999 999999',
    },
    {
      'country': 'Uruguay',
      'phoneCode': '598',
      'countryCode': 'UY',
      'phoneMask': '+999 9999 9999',
    },
    {
      'country': 'Uzbekistan',
      'phoneCode': '998',
      'countryCode': 'UZ',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Vanuatu',
      'phoneCode': '678',
      'countryCode': 'VU',
      'phoneMask': '+999 99999',
    },
    {
      'country': 'Wallis and Futuna',
      'phoneCode': '681',
      'countryCode': 'WF',
      'phoneMask': '‎+999 99 9999',
    },
    {
      'country': 'Yemen',
      'phoneCode': '967',
      'countryCode': 'YE',
      'phoneMask': '+999 9 999999',
    },
    {
      'country': 'Zambia',
      'phoneCode': '260',
      'countryCode': 'ZM',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Zimbabwe',
      'phoneCode': '263',
      'countryCode': 'ZW',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Land Islands',
      'phoneCode': '354',
      'countryCode': 'AX',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Bolivia, Plurinational State of',
      'phoneCode': '591',
      'countryCode': 'BO',
      'phoneMask': '+999 999 999 9999',
    },
    {
      'country': 'Brunei Darussalam',
      'phoneCode': '673',
      'countryCode': 'BN',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Cocos (Keeling) Islands',
      'phoneCode': '61',
      'countryCode': 'CC',
      'phoneMask': '+99 9 9999 9999',
    },
    {
      'country': 'Congo, The Democratic Republic of the',
      'phoneCode': '243',
      'countryCode': 'CD',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Cote d\'Ivoire',
      'phoneCode': '225',
      'countryCode': 'CI',
      'phoneMask': '+999 99999999',
    },
    {
      'country': 'Falkland Islands (Malvinas)',
      'phoneCode': '500',
      'countryCode': 'FK',
      'phoneMask': '+999 99999',
    },
    {
      'country': 'Guernsey',
      'phoneCode': '44',
      'countryCode': 'GG',
      'phoneMask': '+99 (9) 9999 999999',
    },
    {
      'country': 'Hong Kong',
      'phoneCode': '852',
      'countryCode': 'HK',
      'phoneMask': '+999 9999 9999',
    },
    {
      'country': 'Iran, Islamic Republic of',
      'phoneCode': '98',
      'countryCode': 'IR',
      'phoneMask': '+99 999 999 9999',
    },
    {
      'country': 'Korea, Democratic People\'s Republic of',
      'phoneCode': '850',
      'countryCode': 'KP',
      'phoneMask': '+999 9 999 9999',
    },
    {
      'country': 'Korea, Republic of',
      'phoneCode': '82',
      'countryCode': 'KR',
      'phoneMask': '+99 9 999 9999',
    },
    {
      'country': '(Laos) Lao People\'s Democratic Republic',
      'phoneCode': '856',
      'countryCode': 'LA',
      'phoneMask': '+999 99 9999 9999',
    },
    {
      'country': 'Libyan Arab Jamahiriya',
      'phoneCode': '218',
      'countryCode': 'LY',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Macao',
      'phoneCode': '853',
      'countryCode': 'MO',
      'phoneMask': '+999 9999 9999',
    },
    {
      'country': 'Macedonia',
      'phoneCode': '389',
      'countryCode': 'MK',
      'phoneMask': '+999 9 999 9999',
    },
    {
      'country': 'Micronesia, Federated States of',
      'phoneCode': '691',
      'countryCode': 'FM',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Moldova, Republic of',
      'phoneCode': '373',
      'countryCode': 'MD',
      'phoneMask': '+999 999 99999',
    },
    {
      'country': 'Mozambique',
      'phoneCode': '258',
      'countryCode': 'MZ',
      'phoneMask': '+999 999 999999',
    },
    {
      'country': 'Palestina',
      'phoneCode': '970',
      'countryCode': 'PS',
      'phoneMask': '+999 9 999 9999',
    },
    {
      'country': 'Pitcairn',
      'phoneCode': '64',
      'countryCode': 'PN',
      'phoneMask': '+99 9 999 9999',
    },
    {
      'country': 'Réunion',
      'phoneCode': '262',
      'countryCode': 'RE',
      'phoneMask': '+999 999 99 99 99',
    },
    {
      'country': 'Russia',
      'phoneCode': '7',
      'countryCode': 'RU',
      'phoneMask': '+9 (999) 999-99-99',
    },
    {
      'country': 'Saint Barthélemy',
      'phoneCode': '590',
      'countryCode': 'BL',
      'phoneMask': '+999 999 99 99 99',
    },
    {
      'country': 'Saint Helena, Ascension and Tristan Da Cunha',
      'phoneCode': '290',
      'countryCode': 'SH',
      'phoneMask': '+999 9999',
    },
    {
      'country': 'Saint Kitts and Nevis',
      'phoneCode': '1869',
      'countryCode': 'KN',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Saint Lucia',
      'phoneCode': '1758',
      'countryCode': 'LC',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Saint Martin',
      'phoneCode': '590',
      'countryCode': 'MF',
      'phoneMask': '+999 999 999999',
    },
    {
      'country': 'Saint Pierre and Miquelon',
      'phoneCode': '508',
      'countryCode': 'PM',
      'phoneMask': '+508 99 99 99',
    },
    {
      'country': 'Saint Vincent and the Grenadines',
      'phoneCode': '1784',
      'countryCode': 'VC',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Sao Tome and Principe',
      'phoneCode': '239',
      'countryCode': 'ST',
      'phoneMask': '+999 999 9999',
    },
    {
      'country': 'Somalia',
      'phoneCode': '252',
      'countryCode': 'SO',
      'phoneMask': '+999 99 999 999',
    },
    {
      'country': 'Svalbard and Jan Mayen',
      'phoneCode': '47',
      'countryCode': 'SJ',
      'phoneMask': '+99 9999 9999',
    },
    {
      'country': 'Syrian Arab Republic',
      'phoneCode': '963',
      'countryCode': 'SY',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Taiwan',
      'phoneCode': '886',
      'countryCode': 'TW',
      'phoneMask': '+999 9 9999 9999',
    },
    {
      'country': 'Tanzania',
      'phoneCode': '255',
      'countryCode': 'TZ',
      'phoneMask': '+999 99 999 9999',
    },
    {
      'country': 'Timor-Leste',
      'phoneCode': '670',
      'countryCode': 'TL',
      'phoneMask': '+999 999 999',
    },
    {
      'country': 'Venezuela, Bolivarian Republic of',
      'phoneCode': '58',
      'countryCode': 'VE',
      'phoneMask': '+99 999 999 9999',
    },
    {
      'country': 'Viet Nam',
      'phoneCode': '84',
      'countryCode': 'VN',
      'phoneMask': '+99 999 999 9999',
    },
    {
      'country': 'Virgin Islands, British',
      'phoneCode': '1284',
      'countryCode': 'VG',
      'phoneMask': '+9 (999) 999 9999',
    },
    {
      'country': 'Virgin Islands, U.S.',
      'phoneCode': '1340',
      'countryCode': 'VI',
      'phoneMask': '+9 (999) 999 9999',
    }
  ];

  static PhoneFormat getPhoneFormatByRawPhone(String rawPhone) {
    // Strip out all non-numeric characters to get a clean numeric string
    String numericPhone = rawPhone.replaceAll(RegExp(r'\D'), '');

    // Search through the list of phone formats to find a matching one
    for (PhoneFormat format in PhoneFormat.parseList()) {
      // Check if the raw phone number starts with the phoneCode of the format
      if (numericPhone.startsWith(format.phoneCode)) {
        return format;
      }
    }

    // Fallback to a default format if no specific format is found
    return PhoneFormat.kz(); // Example fallback
  }

  static String applyMask(String phone, PhoneFormat phoneFormat) {
    // Remove all non-numeric characters to ensure we're working with only the numbers
    String numericPhone = phone.replaceAll(RegExp(r'\D'), '');

    // Separate the country code based on the length of the phoneCode in PhoneFormat
    String countryCode = '';
    String phoneWithoutCountryCode = numericPhone;
    if (numericPhone.startsWith(phoneFormat.phoneCode)) {
      countryCode = '+${phoneFormat.phoneCode}';
      phoneWithoutCountryCode =
          numericPhone.substring(phoneFormat.phoneCode.length);
    }

    // Apply the mask to the phone number, starting after the country code
    String maskedPhone =
        '$countryCode '; // Start with the country code and a space
    int maskIndex = 0;
    int phoneIndex = 0;

    while (phoneIndex < phoneWithoutCountryCode.length &&
        maskIndex < phoneFormat.getMask.length) {
      if (phoneFormat.getMask[maskIndex] == '9') {
        maskedPhone += phoneWithoutCountryCode[phoneIndex];
        phoneIndex++;
      } else {
        maskedPhone += phoneFormat.getMask[maskIndex];
      }
      maskIndex++;
    }

    // Append the remaining part of the phone number if any
    if (phoneIndex < phoneWithoutCountryCode.length) {
      maskedPhone += phoneWithoutCountryCode.substring(phoneIndex);
    }
    return maskedPhone.trim().replaceAll(countryCode, '');
  }
}
