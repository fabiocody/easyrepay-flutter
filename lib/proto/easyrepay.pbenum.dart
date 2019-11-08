///
//  Generated code. Do not modify.
//  source: easyrepay.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class PBTransactionType extends $pb.ProtobufEnum {
  static const PBTransactionType CREDIT = PBTransactionType._(0, 'CREDIT');
  static const PBTransactionType DEBT = PBTransactionType._(1, 'DEBT');
  static const PBTransactionType SETTLE_CREDIT = PBTransactionType._(2, 'SETTLE_CREDIT');
  static const PBTransactionType SETTLE_DEBT = PBTransactionType._(3, 'SETTLE_DEBT');

  static const $core.List<PBTransactionType> values = <PBTransactionType> [
    CREDIT,
    DEBT,
    SETTLE_CREDIT,
    SETTLE_DEBT,
  ];

  static final $core.Map<$core.int, PBTransactionType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PBTransactionType valueOf($core.int value) => _byValue[value];

  const PBTransactionType._($core.int v, $core.String n) : super(v, n);
}

