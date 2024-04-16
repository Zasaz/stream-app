class ChannelModel {
  final int id;
  final String uid;
  final int position;
  final String type;
  final String resolution;
  final bool isMcast;
  final bool isOtt;
  final bool isDvbt;
  final String? urlMcast;
  final String? urlOtt;
  final bool recordable;
  final int? recDuration;
  final bool timeshiftable;
  final int? tsRecDuration;
  final bool parentalHidden;
  final String? dvbtTag;
  final String streamPriority;
  final String? backgroundImageId;
  final String metadata;
  final bool highlightsEnabled;
  final String ottType;
  final String name;
  final String shortName;
  final String epgChannel;
  final Logos logos;
  final MosaicAlignmentValues mosaicAlignmentValues;
  final String? cmChannel;

  ChannelModel({
    required this.id,
    required this.uid,
    required this.position,
    required this.type,
    required this.resolution,
    required this.isMcast,
    required this.isOtt,
    required this.isDvbt,
    this.urlMcast,
    this.urlOtt,
    required this.recordable,
    this.recDuration,
    required this.timeshiftable,
    this.tsRecDuration,
    required this.parentalHidden,
    this.dvbtTag,
    required this.streamPriority,
    this.backgroundImageId,
    required this.metadata,
    required this.highlightsEnabled,
    required this.ottType,
    required this.name,
    required this.shortName,
    required this.epgChannel,
    required this.logos,
    required this.mosaicAlignmentValues,
    this.cmChannel,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'],
      uid: json['uid'],
      position: json['position'],
      type: json['type'],
      resolution: json['resolution'],
      isMcast: json['is_mcast'],
      isOtt: json['is_ott'],
      isDvbt: json['is_dvbt'],
      urlMcast: json['url_mcast'],
      urlOtt: json['url_ott'],
      recordable: json['recordable'],
      recDuration: json['rec_duration'],
      timeshiftable: json['timeshiftable'],
      tsRecDuration: json['ts_rec_duration'],
      parentalHidden: json['parental_hidden'],
      dvbtTag: json['dvbt_tag'],
      streamPriority: json['stream_priority'],
      backgroundImageId: json['background_image_id'],
      metadata: json['metadata'],
      highlightsEnabled: json['highlights_enabled'],
      ottType: json['ott_type'],
      name: json['name'],
      shortName: json['short_name'],
      epgChannel: json['epg_channel'],
      logos: Logos.fromJson(json['logos']),
      mosaicAlignmentValues:
          MosaicAlignmentValues.fromJson(json['mosaic_alignment_values']),
      cmChannel: json['cm_channel'],
    );
  }
}

class Logos {
  final int? card;
  final int? legacy;
  final int? normal;
  final int? shadow;

  Logos({this.card, this.legacy, this.normal, this.shadow});

  factory Logos.fromJson(Map<String, dynamic> json) {
    return Logos(
      card: json['CARD'] as int?,
      legacy: json['LEGACY'] as int?,
      normal: json['NORMAL'] as int?,
      shadow: json['SHADOW'] as int?,
    );
  }
}

class MosaicAlignmentValues {
  final int? gridHeight;
  final int? gridWidth;
  final int? offsetX;
  final int? offsetY;

  MosaicAlignmentValues(
      {this.gridHeight, this.gridWidth, this.offsetX, this.offsetY});

  factory MosaicAlignmentValues.fromJson(Map<String, dynamic> json) {
    return MosaicAlignmentValues(
      gridHeight: json['gridHeight'] as int?,
      gridWidth: json['gridWidth'] as int?,
      offsetX: json['offsetX'] as int?,
      offsetY: json['offsetY'] as int?,
    );
  }
}
