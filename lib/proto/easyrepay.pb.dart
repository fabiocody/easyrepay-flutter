///
//  Generated code. Do not modify.
//  source: easyrepay.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'easyrepay.pbenum.dart';

export 'easyrepay.pbenum.dart';

class PBDataStore extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PBDataStore', createEmptyInstance: create)
    ..pc<PBPerson>(1, 'people', $pb.PbFieldType.PM, subBuilder: PBPerson.create)
    ..aOM<PBSettings>(2, 'settings', subBuilder: PBSettings.create)
    ..hasRequiredFields = false
  ;

  PBDataStore._() : super();
  factory PBDataStore() => create();
  factory PBDataStore.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PBDataStore.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PBDataStore clone() => PBDataStore()..mergeFromMessage(this);
  PBDataStore copyWith(void Function(PBDataStore) updates) => super.copyWith((message) => updates(message as PBDataStore));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PBDataStore create() => PBDataStore._();
  PBDataStore createEmptyInstance() => create();
  static $pb.PbList<PBDataStore> createRepeated() => $pb.PbList<PBDataStore>();
  @$core.pragma('dart2js:noInline')
  static PBDataStore getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PBDataStore>(create);
  static PBDataStore _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<PBPerson> get people => $_getList(0);

  @$pb.TagNumber(2)
  PBSettings get settings => $_getN(1);
  @$pb.TagNumber(2)
  set settings(PBSettings v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSettings() => $_has(1);
  @$pb.TagNumber(2)
  void clearSettings() => clearField(2);
  @$pb.TagNumber(2)
  PBSettings ensureSettings() => $_ensure(1);
}

class PBPerson extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PBPerson', createEmptyInstance: create)
    ..aOS(1, 'id')
    ..aOS(2, 'name')
    ..pc<PBTransaction>(3, 'transactions', $pb.PbFieldType.PM, subBuilder: PBTransaction.create)
    ..aOB(4, 'reminderActive', protoName: 'reminderActive')
    ..a<$fixnum.Int64>(5, 'reminderTimestamp', $pb.PbFieldType.OU6, protoName: 'reminderTimestamp', defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  PBPerson._() : super();
  factory PBPerson() => create();
  factory PBPerson.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PBPerson.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PBPerson clone() => PBPerson()..mergeFromMessage(this);
  PBPerson copyWith(void Function(PBPerson) updates) => super.copyWith((message) => updates(message as PBPerson));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PBPerson create() => PBPerson._();
  PBPerson createEmptyInstance() => create();
  static $pb.PbList<PBPerson> createRepeated() => $pb.PbList<PBPerson>();
  @$core.pragma('dart2js:noInline')
  static PBPerson getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PBPerson>(create);
  static PBPerson _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<PBTransaction> get transactions => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get reminderActive => $_getBF(3);
  @$pb.TagNumber(4)
  set reminderActive($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasReminderActive() => $_has(3);
  @$pb.TagNumber(4)
  void clearReminderActive() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get reminderTimestamp => $_getI64(4);
  @$pb.TagNumber(5)
  set reminderTimestamp($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasReminderTimestamp() => $_has(4);
  @$pb.TagNumber(5)
  void clearReminderTimestamp() => clearField(5);
}

class PBTransaction extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PBTransaction', createEmptyInstance: create)
    ..aOS(1, 'id')
    ..e<PBTransactionType>(2, 'type', $pb.PbFieldType.OE, defaultOrMaker: PBTransactionType.CREDIT, valueOf: PBTransactionType.valueOf, enumValues: PBTransactionType.values)
    ..a<$core.double>(3, 'amount', $pb.PbFieldType.OD)
    ..aOS(4, 'description')
    ..aOB(5, 'completed')
    ..a<$fixnum.Int64>(6, 'timestamp', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  PBTransaction._() : super();
  factory PBTransaction() => create();
  factory PBTransaction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PBTransaction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PBTransaction clone() => PBTransaction()..mergeFromMessage(this);
  PBTransaction copyWith(void Function(PBTransaction) updates) => super.copyWith((message) => updates(message as PBTransaction));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PBTransaction create() => PBTransaction._();
  PBTransaction createEmptyInstance() => create();
  static $pb.PbList<PBTransaction> createRepeated() => $pb.PbList<PBTransaction>();
  @$core.pragma('dart2js:noInline')
  static PBTransaction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PBTransaction>(create);
  static PBTransaction _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  PBTransactionType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(PBTransactionType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get completed => $_getBF(4);
  @$pb.TagNumber(5)
  set completed($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCompleted() => $_has(4);
  @$pb.TagNumber(5)
  void clearCompleted() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get timestamp => $_getI64(5);
  @$pb.TagNumber(6)
  set timestamp($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTimestamp() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimestamp() => clearField(6);
}

class PBSettings extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PBSettings', createEmptyInstance: create)
    ..aOB(1, 'icloud')
    ..hasRequiredFields = false
  ;

  PBSettings._() : super();
  factory PBSettings() => create();
  factory PBSettings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PBSettings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PBSettings clone() => PBSettings()..mergeFromMessage(this);
  PBSettings copyWith(void Function(PBSettings) updates) => super.copyWith((message) => updates(message as PBSettings));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PBSettings create() => PBSettings._();
  PBSettings createEmptyInstance() => create();
  static $pb.PbList<PBSettings> createRepeated() => $pb.PbList<PBSettings>();
  @$core.pragma('dart2js:noInline')
  static PBSettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PBSettings>(create);
  static PBSettings _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get icloud => $_getBF(0);
  @$pb.TagNumber(1)
  set icloud($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIcloud() => $_has(0);
  @$pb.TagNumber(1)
  void clearIcloud() => clearField(1);
}

