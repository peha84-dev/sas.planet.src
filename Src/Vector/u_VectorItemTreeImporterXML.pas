{******************************************************************************}
{* This file is part of SAS.Planet project.                                   *}
{*                                                                            *}
{* Copyright (C) 2007-2022, SAS.Planet development team.                      *}
{*                                                                            *}
{* SAS.Planet is free software: you can redistribute it and/or modify         *}
{* it under the terms of the GNU General Public License as published by       *}
{* the Free Software Foundation, either version 3 of the License, or          *}
{* (at your option) any later version.                                        *}
{*                                                                            *}
{* SAS.Planet is distributed in the hope that it will be useful,              *}
{* but WITHOUT ANY WARRANTY; without even the implied warranty of             *}
{* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the               *}
{* GNU General Public License for more details.                               *}
{*                                                                            *}
{* You should have received a copy of the GNU General Public License          *}
{* along with SAS.Planet. If not, see <http://www.gnu.org/licenses/>.         *}
{*                                                                            *}
{* https://github.com/sasgis/sas.planet.src                                   *}
{******************************************************************************}

unit u_VectorItemTreeImporterXML;

interface

uses
  Classes,
  SysUtils,
  t_GeoTypes,
  i_VectorDataFactory,
  i_VectorItemSubsetBuilder,
  i_VectorItemTree,
  i_GeometryLonLatFactory,
  i_VectorDataLoader,
  i_VectorItemTreeImporter,
  i_XmlVectorObjects,
  i_NotifierOperation,
  i_ImportConfig,
  i_MarkPicture,
  i_AppearanceOfMarkFactory,
  u_VectorItemTreeImporterXmlHelpers,
  u_BaseInterfacedObject,
  vsagps_public_sysutils,
  vsagps_public_print,
  vsagps_public_gpx,
  vsagps_public_kml,
  vsagps_public_xml_parser;

type
  IVectorItemTreeImporterXMLInternal = interface
    function LoadFromStream(
      const AContext: TVectorLoadContext;
      const AStream: TStream
    ): IVectorItemTree;
  end;

type
  TVectorItemTreeImporterXML = class(TBaseInterfacedObject, IVectorItemTreeImporter, IVectorItemTreeImporterXMLInternal)
  private
    FSkipFolders: Boolean;
    FMarkPictureList: IMarkPictureList;
    FAppearanceOfMarkFactory: IAppearanceOfMarkFactory;
    FVectorDataItemMainInfoFactory: IVectorDataItemMainInfoFactory;
    FVectorGeometryLonLatFactory: IGeometryLonLatFactory;
    FVectorDataFactory: IVectorDataFactory;
    FVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
    FFormat: TFormatSettings;

    FKmlGxWhen: TKmlPointWhen;
    FKmlStyleList: TKmlStyleList;
    FKmlStyleMap: TKmlStyleMap;
  private
    procedure Internal_ParseXML_UserProc(
      const AXmlVectorObjects: IXmlVectorObjects;
      const pPX_Result: Pvsagps_XML_ParserResult;
      const pPX_State: Pvsagps_XML_ParserState
    );
  private
    procedure Internal_CloseTRK(
      const AXmlVectorObjects: IXmlVectorObjects;
      const pPX_Result: Pvsagps_XML_ParserResult
    );
    procedure Internal_CloseRTE(
      const AXmlVectorObjects: IXmlVectorObjects;
      const pPX_Result: Pvsagps_XML_ParserResult
    );
    procedure Internal_CloseWPT(
      const AXmlVectorObjects: IXmlVectorObjects;
      const pPX_Result: Pvsagps_XML_ParserResult
    );
    procedure Internal_CloseMark(
      const AXmlVectorObjects: IXmlVectorObjects;
      const pPX_Result: Pvsagps_XML_ParserResult
    );
    procedure Internal_CloseLineString(
      const AXmlVectorObjects: IXmlVectorObjects;
      const pPX_Result: Pvsagps_XML_ParserResult
    );
    procedure Internal_CloseLinearRing(
      const AXmlVectorObjects: IXmlVectorObjects;
      const pPX_Result: Pvsagps_XML_ParserResult
    );
    procedure Internal_ClosePoint(
      const AXmlVectorObjects: IXmlVectorObjects;
      const pPX_Result: Pvsagps_XML_ParserResult
    );
    procedure Internal_CloseFolder(
      const AXmlVectorObjects: IXmlVectorObjects;
      const pPX_Result: Pvsagps_XML_ParserResult
    );
  private
    { IVectorItemTreeImporter }
    function ProcessImport(
      AOperationID: Integer;
      const ACancelNotifier: INotifierOperation;
      const AFileName: string;
      const AConfig: IInterface
    ): IVectorItemTree;
  private
    { IVectorItemTreeImporterXMLInternal }
    function LoadFromStream(
      const AContext: TVectorLoadContext;
      const AStream: TStream
    ): IVectorItemTree;
  public
    constructor Create(
      const ASkipFolders: Boolean;
      const AMarkPictureList: IMarkPictureList;
      const AAppearanceOfMarkFactory: IAppearanceOfMarkFactory;
      const AVectorDataItemMainInfoFactory: IVectorDataItemMainInfoFactory;
      const AVectorGeometryLonLatFactory: IGeometryLonLatFactory;
      const AVectorDataFactory: IVectorDataFactory;
      const AVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory
    );
    destructor Destroy; override;
  end;

implementation

uses
  StrUtils,
  i_AppearanceHelper,
  u_AppearanceHelper,
  u_DoublePointsMetaFunc,
  u_XmlVectorObjects;

procedure rTVSAGPS_ParseXML_UserProc(
  const pUserObjPointer: Pointer;
  const pUserAuxPointer: Pointer;
  const pPX_Options: Pvsagps_XML_ParserOptions;
  const pPX_Result: Pvsagps_XML_ParserResult;
  const pPX_State: Pvsagps_XML_ParserState
); stdcall;
begin
  TVectorItemTreeImporterXML(pUserObjPointer).Internal_ParseXML_UserProc(
    IXmlVectorObjects(pUserAuxPointer),
    pPX_Result,
    pPX_State
  );
end;

function GetPointForGPX(
  const AWptData: Tvsagps_GPX_wpt_data;
  out AWptPoint: TDoublePoint;
  const AWptMeta: PDoublePointsMetaItem = nil
): Boolean;
begin
  with AWptData.fPos do begin
    Result := PositionOK;
    if Result then begin
      AWptPoint.X := PositionLon;
      AWptPoint.Y := PositionLat;
    end;
  end;
  if Result and (AWptMeta <> nil) then begin
    ResetMetaItem(AWptMeta);
    if wpt_ele in AWptData.fAvail_wpt_params then begin
      AWptMeta.IsElevationOk := True;
      AWptMeta.Elevation := AWptData.fPos.Altitude;
    end;
    if wpt_time in AWptData.fAvail_wpt_params then begin
      AWptMeta.IsTimeStampOk := True;
      AWptMeta.TimeStamp := AWptData.fPos.UTCDate + AWptData.fPos.UTCTime;
    end;
  end;
end;

{ TXmlInfoSimpleParser }

constructor TVectorItemTreeImporterXML.Create(
  const ASkipFolders: Boolean;
  const AMarkPictureList: IMarkPictureList;
  const AAppearanceOfMarkFactory: IAppearanceOfMarkFactory;
  const AVectorDataItemMainInfoFactory: IVectorDataItemMainInfoFactory;
  const AVectorGeometryLonLatFactory: IGeometryLonLatFactory;
  const AVectorDataFactory: IVectorDataFactory;
  const AVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory
);
begin
  inherited Create;

  FSkipFolders := ASkipFolders;
  FMarkPictureList := AMarkPictureList;
  FAppearanceOfMarkFactory := AAppearanceOfMarkFactory;
  FVectorDataItemMainInfoFactory := AVectorDataItemMainInfoFactory;
  FVectorGeometryLonLatFactory := AVectorGeometryLonLatFactory;
  FVectorDataFactory := AVectorDataFactory;
  FVectorItemSubsetBuilderFactory := AVectorItemSubsetBuilderFactory;

  VSAGPS_PrepareFormatSettings(FFormat);

  FKmlStyleList := TKmlStyleList.Create;
  FKmlStyleMap := TKmlStyleMap.Create;
end;

destructor TVectorItemTreeImporterXML.Destroy;
begin
  FreeAndNil(FKmlStyleList);
  FreeAndNil(FKmlStyleMap);

  inherited Destroy;
end;

procedure TVectorItemTreeImporterXML.Internal_CloseLinearRing(
  const AXmlVectorObjects: IXmlVectorObjects;
  const pPX_Result: Pvsagps_XML_ParserResult
);
var
  VCoordinates: string;
  VInner: Boolean;
  VPX_Result: Pvsagps_XML_ParserResult;
begin
  with pPX_Result^.kml_data do begin
    if (fParamsStrs[kml_coordinates] <> nil) then begin
      VCoordinates := SafeSetStringP(fParamsStrs[kml_coordinates]);

      // check if inner
      VInner := False;
      VPX_Result := pPX_Result;
      repeat
        // check
        if (nil = VPX_Result) then begin
          break;
        end;

        // check tag
        case VPX_Result^.kml_data.current_tag of
          kml_innerBoundaryIs: begin
            VInner := True;
            break;
          end;
          kml_outerBoundaryIs, kml_Placemark: begin
            break;
          end;
        end;

        // prev level
        VPX_Result := VPX_Result^.prev_data;
      until False;

      // call
      AXmlVectorObjects.CloseKmlLinearRing(VCoordinates, VInner);
    end;
  end;
end;

procedure TVectorItemTreeImporterXML.Internal_CloseLineString(
  const AXmlVectorObjects: IXmlVectorObjects;
  const pPX_Result: Pvsagps_XML_ParserResult
);
var
  VCoordinates: string;
begin
  with pPX_Result^.kml_data do begin
    if (fParamsStrs[kml_coordinates] <> nil) then begin
      VCoordinates := SafeSetStringP(fParamsStrs[kml_coordinates]);
      AXmlVectorObjects.CloseKmlLineString(VCoordinates);
    end;
  end;
end;

procedure TVectorItemTreeImporterXML.Internal_CloseMark(
  const AXmlVectorObjects: IXmlVectorObjects;
  const pPX_Result: Pvsagps_XML_ParserResult
);

  function _TryGetKmlStyle(out AKmlStyle: TKmlStyleItem): Boolean;
  var
    VStyleUrl, VStyleId: string;
  begin
    Result := False;
    if kml_styleUrl in pPX_Result^.kml_data.fAvail_strs then begin
      VStyleUrl := SafeSetStringP(pPX_Result^.kml_data.fParamsStrs[kml_styleUrl]);
      if TryStyleUrlToStyleId(VStyleUrl, VStyleId) then begin
        if FKmlStyleMap.TryGetStyleUrl(VStyleId, VStyleUrl) then begin
          if TryStyleUrlToStyleId(VStyleUrl, VStyleId) then begin
            Result := FKmlStyleList.TryGetStyle(VStyleId, AKmlStyle);
          end;
        end else begin
          Result := FKmlStyleList.TryGetStyle(VStyleId, AKmlStyle);
        end;
      end;
    end;
  end;

var
  VKmlStyle: TKmlStyleItem;
begin
  if _TryGetKmlStyle(VKmlStyle) then begin
    // update Style in kml_data
    VKmlStyle.WriteToKmlData(@pPX_Result^.kml_data);
  end;
  AXmlVectorObjects.CloseMarkObject(
    @(pPX_Result^.kml_data),
    cmom_KML
  );
end;

procedure TVectorItemTreeImporterXML.Internal_ClosePoint(
  const AXmlVectorObjects: IXmlVectorObjects;
  const pPX_Result: Pvsagps_XML_ParserResult
);
var
  VCoordinates: string;
begin
  with pPX_Result^.kml_data do begin
    if (fParamsStrs[kml_coordinates] <> nil) then begin
      VCoordinates := SafeSetStringP(fParamsStrs[kml_coordinates]);
      AXmlVectorObjects.CloseKmlPoint(VCoordinates);
    end;
  end;
end;

procedure TVectorItemTreeImporterXML.Internal_CloseTRK(
  const AXmlVectorObjects: IXmlVectorObjects;
  const pPX_Result: Pvsagps_XML_ParserResult
);
begin
  // do it
  AXmlVectorObjects.CloseMarkObject(
    @(pPX_Result^.gpx_data),
    cmom_GPX_TRK
  );
end;

procedure TVectorItemTreeImporterXML.Internal_CloseRTE(
  const AXmlVectorObjects: IXmlVectorObjects;
  const pPX_Result: Pvsagps_XML_ParserResult
);
begin
  // do it
  AXmlVectorObjects.CloseMarkObject(
    @(pPX_Result^.gpx_data),
    cmom_GPX_RTE
  );
end;

procedure TVectorItemTreeImporterXML.Internal_CloseWPT(
  const AXmlVectorObjects: IXmlVectorObjects;
  const pPX_Result: Pvsagps_XML_ParserResult
);
begin
  // do it
  AXmlVectorObjects.CloseMarkObject(
    @(pPX_Result^.gpx_data),
    cmom_GPX_WPT
  );
end;

procedure TVectorItemTreeImporterXML.Internal_CloseFolder(
  const AXmlVectorObjects: IXmlVectorObjects;
  const pPX_Result: Pvsagps_XML_ParserResult
);
var
  VName: string;
begin
  with pPX_Result^.kml_data do begin
    if (kml_name in fAvail_strs) and (fParamsStrs[kml_name] <> nil) then begin
      VName := SafeSetStringP(fParamsStrs[kml_name]);
    end else begin
      VName := '';
    end;
    AXmlVectorObjects.CloseFolder(VName);
  end;
end;

function TVectorItemTreeImporterXML.LoadFromStream(
  const AContext: TVectorLoadContext;
  const AStream: TStream
): IVectorItemTree;
var
  VAppearanceHelper: IAppearanceHelper;
  VXmlVectorObjects: IXmlVectorObjects;
  VParserOptions: Tvsagps_XML_ParserOptions;
begin
  Result := nil;

  if (Assigned(AContext.PointParams) or Assigned(AContext.LineParams) or Assigned(AContext.PolygonParams)) and Assigned(FAppearanceOfMarkFactory) then begin
    VAppearanceHelper := TAppearanceHelper.Create(
      AContext.PointParams,
      AContext.LineParams,
      AContext.PolygonParams,
      FMarkPictureList,
      FAppearanceOfMarkFactory
    );
  end else begin
    VAppearanceHelper := nil;
  end;

  // init
  VXmlVectorObjects := TXmlVectorObjects.Create(
    False, // use True for wiki
    @FFormat,
    AContext.IdData,
    VAppearanceHelper,
    FVectorItemSubsetBuilderFactory,
    AContext.MainInfoFactory,
    FVectorDataFactory,
    FVectorGeometryLonLatFactory
  );

  // xml parser options
  FillChar(VParserOptions, SizeOf(VParserOptions), 0);

  // for wpt, rte and trk
  Inc(VParserOptions.gpx_options.bParse_trk);
  Inc(VParserOptions.gpx_options.bParse_rte);
  Inc(VParserOptions.gpx_options.bParse_wpt);

  if Assigned(VAppearanceHelper) then begin
    Inc(VParserOptions.gpx_options.bParse_trk_extensions);
    Inc(VParserOptions.gpx_options.bParse_rte_extensions);
    Inc(VParserOptions.gpx_options.bParse_wpt_extensions);
    Inc(VParserOptions.gpx_options.bParse_gpxx_extensions);
    Inc(VParserOptions.gpx_options.bParse_gpxx_appearance);
  end;

  FKmlStyleList.Clear;
  FKmlStyleMap.Clear;

  // parse
  VSAGPS_LoadAndParseXML(
    Self,
    Pointer(VXmlVectorObjects),
    '',
    AStream,
    True,
    @VParserOptions,
    rTVSAGPS_ParseXML_UserProc,
    FFormat
  );

  // output result
  Result := VXmlVectorObjects.VectorDataItemsResult;
end;

procedure TVectorItemTreeImporterXML.Internal_ParseXML_UserProc(
  const AXmlVectorObjects: IXmlVectorObjects;
  const pPX_Result: Pvsagps_XML_ParserResult;
  const pPX_State: Pvsagps_XML_ParserState
);
const
  c_KML_Skipped: set of Tvsagps_KML_main_tag = [
    kml_LookAt,
    kml_NetworkLink,
    kml_NetworkLinkControl,
    kml_Region
  ];
  c_GPX_Skipped: set of Tvsagps_GPX_main_tag = [
    gpx_metadata
  ];
const
  cFilesFolderName = 'files/';
var
  VWptPoint: TDoublePoint;
  VWptMeta: TDoublePointsMetaItem;
  VIconName: string;
begin
  // if aborted
  if pPX_State^.aborted_by_user then begin
    Exit;
  end;

  // kml
  if (xsf_KML = pPX_State^.src_fmt) then begin
    // skip some tags
    if (xtd_BeforeSub = pPX_State^.tag_disposition) then begin
      if (pPX_Result^.kml_data.subitem_tag in c_KML_Skipped) then begin
        pPX_State^.skip_sub := True;
        Exit;
      end;
    end;

    case pPX_Result^.kml_data.current_tag of
      kml_Folder: begin
        if not FSkipFolders then begin
          case pPX_State^.tag_disposition of
            xtd_Open: begin
              AXmlVectorObjects.OpenFolder;
            end;
            xtd_Close: begin
              Internal_CloseFolder(AXmlVectorObjects, pPX_Result);
            end;
          end;
        end;
      end;
      //kml_innerBoundaryIs: begin
        // ������ �������
      //end;
      kml_LinearRing: begin
        // ������ �������
        case pPX_State^.tag_disposition of
          xtd_Close: begin
            Internal_CloseLinearRing(AXmlVectorObjects, pPX_Result);
          end;
        end;
      end;
      kml_LineString: begin
        // ������ ���������, �� � ���� - �������
        case pPX_State^.tag_disposition of
          xtd_Close: begin
            Internal_CloseLineString(AXmlVectorObjects, pPX_Result);
          end;
        end;
      end;
      kml_MultiGeometry: begin
        // ������ ����� ���� ��� ������
        case pPX_State^.tag_disposition of
          xtd_Open: begin
            AXmlVectorObjects.OpenMultiGeometry;
          end;
          xtd_Close: begin
            AXmlVectorObjects.CloseMultiGeometry;
          end;
        end;
      end;
      //kml_outerBoundaryIs: begin
        // ������ �������
      //end;
      kml_Placemark: begin
        // ������ �����
        case pPX_State^.tag_disposition of
          xtd_Open: begin
            AXmlVectorObjects.OpenMarkObject;
          end;
          xtd_Close: begin
            // get info
            Internal_CloseMark(AXmlVectorObjects, pPX_Result);
          end;
        end;
      end;
      kml_Point: begin
        // ����� (����� ���� ������ MultiGeometry)
        case pPX_State^.tag_disposition of
          xtd_Close: begin
            Internal_ClosePoint(AXmlVectorObjects, pPX_Result);
          end;
        end;
      end;
      kml_Polygon: begin
        // ������� (����� ���� ������ MultiGeometry)
        case pPX_State^.tag_disposition of
          xtd_Close: begin
            AXmlVectorObjects.CloseKmlPolygon;
          end;
        end;
      end;

      // gx:
      kml_when_gx: begin
        // <when> subtag under <gx:Track>
        case pPX_State^.tag_disposition of
          xtd_ReadAttributes: begin
            with pPX_Result^.kml_data do begin
              if (FKmlGxWhen <> nil) and (kml_when in fAvail_params) then begin
                FKmlGxWhen.Enqueue(fValues.when);
              end;
            end;
          end;
        end;
      end;
      kml_gx_coord: begin
        // ����� (������)�����
        case pPX_State^.tag_disposition of
          xtd_Close: begin
            with pPX_Result^.kml_data do begin
              if (kml_latitude in fAvail_params) and (kml_longitude in fAvail_params) then begin
                VWptPoint.X := fValues.longitude;
                VWptPoint.Y := fValues.latitude;
                ResetMetaItem(@VWptMeta);
                if kml_altitude in fAvail_params then begin
                  VWptMeta.IsElevationOk := True;
                  VWptMeta.Elevation := fValues.altitude;
                end;
                Assert(FKmlGxWhen <> nil);
                if FKmlGxWhen.Count > 0 then begin
                  VWptMeta.TimeStamp := FKmlGxWhen.Dequeue;
                  VWptMeta.IsTimeStampOk := VWptMeta.TimeStamp <> 0;
                end;
                AXmlVectorObjects.AddTrackPoint(VWptPoint, @VWptMeta);
              end;
            end;
          end;
        end;
      end;
      kml_gx_MultiTrack: begin
        // ����������
        case pPX_State^.tag_disposition of
          xtd_Open: begin
            AXmlVectorObjects.OpenMultiTrack;
            FKmlGxWhen := TKmlPointWhen.Create;
          end;
          xtd_Close: begin
            AXmlVectorObjects.CloseMultiTrack;
            FreeAndNil(FKmlGxWhen);
          end;
        end;
      end;
      kml_gx_Track: begin
        // ��������� ���� ��� ����� �����������
        case pPX_State^.tag_disposition of
          xtd_Open: begin
            // open new track segment or open single track
            AXmlVectorObjects.OpenTrackSegment;
            FKmlGxWhen := TKmlPointWhen.Create;
          end;
          xtd_Close: begin
            // close track segment or close single track
            AXmlVectorObjects.CloseTrackSegment;
            FreeAndNil(FKmlGxWhen);
          end;
        end;
      end;

      // appearance
      kml_LineStyle: begin
        // ��������� ��������� �����
        case pPX_State^.tag_disposition of
          xtd_Close: begin
            // ���������� ������ color � width
            if (pPX_Result^.prev_data <> nil) then begin
              VSAGPS_KML_ShiftParam(pPX_Result, kml_color);
              VSAGPS_KML_ShiftParam(pPX_Result, kml_width);
            end;
          end;
        end;
      end;
      kml_PolyStyle: begin
        // ��������� ��������� ��������
        case pPX_State^.tag_disposition of
          xtd_Close: begin
            // ���������� ������ bgColor � fill
            if (pPX_Result^.prev_data <> nil) then begin
              VSAGPS_KML_ShiftParam(pPX_Result, kml_bgColor);
              VSAGPS_KML_ShiftParam(pPX_Result, kml_fill);
            end;
          end;
        end;
      end;
      kml_LabelStyle: begin
        // ��������� ��������� ��������� �����
        case pPX_State^.tag_disposition of
          xtd_Close: begin
            // ���������� ������ textColor � tileSize (������ scale)
            if (pPX_Result^.prev_data <> nil) then begin
              VSAGPS_KML_ShiftParam(pPX_Result, kml_textColor);
              VSAGPS_KML_ShiftParam(pPX_Result, kml_tileSize);
            end;
          end;
        end;
      end;
      kml_BalloonStyle: begin
        // ��������� ��������� ������
        case pPX_State^.tag_disposition of
          xtd_Close: begin
            // ���������� ������ bgColor
            if (pPX_Result^.prev_data <> nil) then begin
              VSAGPS_KML_ShiftParam(pPX_Result, kml_bgColor);
            end;
          end;
        end;
      end;
      kml_IconStyle: begin
        // ��������� ��������� ������
        case pPX_State^.tag_disposition of
          xtd_Close: begin
            // ���������� ������ scale
            if (pPX_Result^.prev_data <> nil) then begin
              VSAGPS_KML_ShiftParam(pPX_Result, kml_scale_);
            end;
          end;
        end;
      end;
      kml_Icon: begin
        // ��� ����� ������
        case pPX_State^.tag_disposition of
          xtd_Close: begin
            VIconName := SafeSetStringP(pPX_Result^.kml_data.fParamsStrs[kml_href]);
            if StartsStr(cFilesFolderName, VIconName)  then begin
              VIconName := RightStr(VIconName, Length(VIconName) - Length(cFilesFolderName));
            end;
            if Assigned(AXmlVectorObjects.AppearanceHelper) then begin
              VIconName := StringReplace(VIconName, '/', PathDelim, [rfReplaceAll]);
              AXmlVectorObjects.AppearanceHelper.Icon.SetByName(VIconName);
            end;
          end;
        end;
      end;
      kml_Style: begin
        // ��������� ���������
        case pPX_State^.tag_disposition of
          xtd_Close: begin
            if (kml_a_s_id in pPX_Result^.kml_data.fAvail_attrib_strs) then begin
              FKmlStyleList.AddStyle(
                SafeSetStringP(pPX_Result^.kml_data.fAttribStrs[kml_a_s_id]),
                TKmlStyleItem.Create(@pPX_Result^.kml_data)
              );
            end else
            if (pPX_Result^.prev_data <> nil) then begin
              // ���������� ������ ��� ��������� *Style
              VSAGPS_KML_ShiftParam(pPX_Result, kml_color);
              VSAGPS_KML_ShiftParam(pPX_Result, kml_width);
              VSAGPS_KML_ShiftParam(pPX_Result, kml_bgColor);
              VSAGPS_KML_ShiftParam(pPX_Result, kml_fill);
              VSAGPS_KML_ShiftParam(pPX_Result, kml_textColor);
              VSAGPS_KML_ShiftParam(pPX_Result, kml_tileSize);
              VSAGPS_KML_ShiftParam(pPX_Result, kml_scale_);
            end;
          end;
        end;
      end;
      kml_Pair: begin
        case pPX_State^.tag_disposition of
          xtd_Close: begin
            if (pPX_Result^.prev_data <> nil) and
               (pPX_Result^.prev_data.kml_data.current_tag = kml_StyleMap)
            then begin
              with pPX_Result^.kml_data do begin
                if (kml_key in fAvail_strs) and (kml_styleUrl in fAvail_strs) then begin
                  FKmlStyleMap.AddPair(
                    SafeSetStringP(pPX_Result^.prev_data.kml_data.fAttribStrs[kml_a_s_id]),
                    SafeSetStringP(fParamsStrs[kml_key]),
                    SafeSetStringP(fParamsStrs[kml_styleUrl])
                  );
                end;
              end;
            end;
          end;
        end;
      end;
    end;

    // done
    Exit;
  end; { end of kml }

  // gpx
  if (xsf_GPX = pPX_State^.src_fmt) then begin
    // skip some tags
    if (xtd_BeforeSub = pPX_State^.tag_disposition) then begin
      if (pPX_Result^.gpx_data.subitem_tag in c_GPX_Skipped) then begin
        pPX_State^.skip_sub := True;
        Exit;
      end;
    end;

    // switch by tag
    case pPX_Result^.gpx_data.current_tag of
      gpx_trk: begin
        // trk - entire track object
        case pPX_State^.tag_disposition of
          xtd_Open: begin
            // ��� ����� ����� �����
            AXmlVectorObjects.OpenMarkObject;
            // �������� ������������ � �������� KML
            AXmlVectorObjects.OpenMultiGeometry;
          end;
          xtd_Close: begin
            // ����������� ������������ � �������� KML
            AXmlVectorObjects.CloseMultiGeometry;
            // ����������� ������ �����
            Internal_CloseTRK(AXmlVectorObjects, pPX_Result);
          end;
        end;
      end;
      gpx_trkpt: begin
        // single track point - lon/lat as attributes, ele and time as subtags
        case pPX_State^.tag_disposition of
          xtd_Close: begin
            if GetPointForGPX(pPX_Result^.gpx_data.wpt_data, VWptPoint, @VWptMeta) then begin
              // add to array of points
              AXmlVectorObjects.AddTrackPoint(VWptPoint, @VWptMeta);
            end;
          end;
        end;
      end;
      gpx_trkseg: begin
        // track segment
        case pPX_State^.tag_disposition of
          xtd_Open: begin
            AXmlVectorObjects.OpenTrackSegment;
          end;
          xtd_Close: begin
            AXmlVectorObjects.CloseTrackSegment;
          end;
        end;
      end;
      gpx_rte: begin
        // rte - entire route object
        case pPX_State^.tag_disposition of
          xtd_Open: begin
            // ��� ����� ����� �����
            AXmlVectorObjects.OpenMarkObject;
            // �������� ������������ � �������� KML
            AXmlVectorObjects.OpenMultiGeometry;
            AXmlVectorObjects.OpenTrackSegment;
          end;
          xtd_Close: begin
            AXmlVectorObjects.CloseTrackSegment;
            // ����������� ������������ � �������� KML
            AXmlVectorObjects.CloseMultiGeometry;
            // ����������� ������ �����
            Internal_CloseRTE(AXmlVectorObjects, pPX_Result);
          end;
        end;
      end;
      gpx_rtept: begin
        // single route point - lon/lat as attributes, ele and time as subtags
        case pPX_State^.tag_disposition of
          xtd_Close: begin
            if GetPointForGPX(pPX_Result^.gpx_data.wpt_data, VWptPoint, @VWptMeta) then begin
              // add to array of points
              AXmlVectorObjects.AddTrackPoint(VWptPoint, @VWptMeta);
            end;
          end;
        end;
      end;
      gpx_wpt: begin
        // single waypoint
        case pPX_State^.tag_disposition of
          xtd_Open: begin
            // ��� ����� ����� �����
            AXmlVectorObjects.OpenMarkObject;
          end;
          xtd_Close: begin
            // close waypoint
            if GetPointForGPX(pPX_Result^.gpx_data.wpt_data, VWptPoint) then begin
              // add single point object
              AXmlVectorObjects.CloseGPXPoint(VWptPoint);
              // close mark object
              Internal_CloseWPT(AXmlVectorObjects, pPX_Result);
            end;
          end;
        end;
      end;
    end;
  end; { end of gpx }
end;

function TVectorItemTreeImporterXML.ProcessImport(
  AOperationID: Integer;
  const ACancelNotifier: INotifierOperation;
  const AFileName: string;
  const AConfig: IInterface
): IVectorItemTree;
var
  VConfig: IImportConfig;
  VContext: TVectorLoadContext;
  VMemStream: TMemoryStream;
begin
  VMemStream := TMemoryStream.Create;
  try
    VMemStream.LoadFromFile(AFileName);
    VMemStream.Position := 0;
    VContext.Init;
    VContext.MainInfoFactory := FVectorDataItemMainInfoFactory;
    if Supports(AConfig, IImportConfig, VConfig) then begin
      VContext.PointParams := VConfig.PointParams;
      VContext.LineParams := VConfig.LineParams;
      VContext.PolygonParams := VConfig.PolyParams;
    end;

    Result := LoadFromStream(VContext, VMemStream);
  finally
    VMemStream.Free;
  end;
end;

end.
