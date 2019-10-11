///
//  Generated code. Do not modify.
//  source: easyrepay.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const PBTransactionType$json = const {
  '1': 'PBTransactionType',
  '2': const [
    const {'1': 'CREDIT', '2': 0},
    const {'1': 'DEBT', '2': 1},
    const {'1': 'SETTLE_CREDIT', '2': 2},
    const {'1': 'SETTLE_DEBT', '2': 3},
  ],
};

const PBDataStore$json = const {
  '1': 'PBDataStore',
  '2': const [
    const {'1': 'people', '3': 1, '4': 3, '5': 11, '6': '.PBPerson', '10': 'people'},
    const {'1': 'settings', '3': 2, '4': 1, '5': 11, '6': '.PBSettings', '10': 'settings'},
  ],
};

const PBPerson$json = const {
  '1': 'PBPerson',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'transactions', '3': 3, '4': 3, '5': 11, '6': '.PBTransaction', '10': 'transactions'},
    const {'1': 'reminderActive', '3': 4, '4': 1, '5': 8, '10': 'reminderActive'},
    const {'1': 'reminderTimestamp', '3': 5, '4': 1, '5': 4, '10': 'reminderTimestamp'},
  ],
};

const PBTransaction$json = const {
  '1': 'PBTransaction',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'type', '3': 2, '4': 1, '5': 14, '6': '.PBTransactionType', '10': 'type'},
    const {'1': 'amount', '3': 3, '4': 1, '5': 1, '10': 'amount'},
    const {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
    const {'1': 'completed', '3': 5, '4': 1, '5': 8, '10': 'completed'},
    const {'1': 'timestamp', '3': 6, '4': 1, '5': 4, '10': 'timestamp'},
  ],
};

const PBSettings$json = const {
  '1': 'PBSettings',
  '2': const [
    const {'1': 'icloud', '3': 1, '4': 1, '5': 8, '10': 'icloud'},
    const {'1': 'dark', '3': 2, '4': 1, '5': 8, '10': 'dark'},
  ],
};

