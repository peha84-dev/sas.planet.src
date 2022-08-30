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

unit u_GlobalState;

interface

uses
  Windows,
  {$IFDEF USE_JCL_DEBUG}
  JclDebug,
  {$ENDIF USE_JCL_DEBUG}
  ExtCtrls,
  Classes,
  IniFiles,
  SysUtils,
  i_MapVersionFactoryList,
  i_NotifierOperation,
  i_GPSPositionFactory,
  i_HashFunction,
  i_Timer,
  i_Listener,
  i_AppearanceOfMarkFactory,
  i_BackgroundTask,
  i_ConfigDataWriteProvider,
  i_ConfigDataProvider,
  i_TileFileNameGeneratorsList,
  i_TileFileNameParsersList,
  i_ContentTypeManager,
  i_VectorDataLoader,
  i_ProjectionSetFactory,
  i_ProjectionSetList,
  i_ProjConverter,
  i_BatteryStatus,
  i_InternalBrowserLastContent,
  i_LocalCoordConverterFactorySimpe,
  i_GpsSystem,
  i_GeometryProjectedProvider,
  i_DownloadInfoSimple,
  i_DownloaderFactory,
  i_ImageResamplerConfig,
  i_GeoCoderList,
  i_MarkPicture,
  i_LastSelectionInfo,
  i_InternalPerformanceCounter,
  i_DebugInfoSubSystem,
  i_MarkSystem,
  i_MarkSystemConfig,
  i_ZmpInfoSet,
  i_Datum,
  i_DatumFactory,
  i_GeoCalc,
  i_PathConfig,
  i_NotifierTime,
  i_Bitmap32BufferFactory,
  i_VectorDataFactory,
  i_GeometryProjectedFactory,
  i_VectorItemSubsetBuilder,
  i_GeoCoder,
  i_MapTypeSetBuilder,
  i_MapTypeListBuilder,
  i_MapCalibration,
  i_TreeChangeable,
  i_GPSRecorder,
  i_SatellitesInViewMapDraw,
  i_TerrainProviderList,
  i_GeometryLonLatFactory,
  i_InvisibleBrowser,
  i_InternalBrowser,
  i_DebugInfoWindow,
  i_GlobalInternetState,
  i_GlobalBerkeleyDBHelper,
  i_BitmapPostProcessing,
  i_BitmapTileSaveLoadFactory,
  i_ArchiveReadWriteFactory,
  i_SystemTimeProvider,
  i_MarkCategoryFactory,
  i_MarkFactory,
  i_CoordFromStringParser,
  i_CoordToStringConverter,
  i_ValueToStringConverter,
  i_VectorItemTreeImporterList,
  i_VectorItemTreeExporterList,
  i_TileStorageTypeList,
  i_LastSearchResult,
  i_ImageResamplerFactory,
  i_BuildInfo,
  i_AppEnum,
  i_GlobalConfig,
  i_GlobalCacheConfig,
  i_FavoriteMapSetConfig,
  i_InternalDomainUrlHandler,
  u_GarbageCollectorThread,
  u_MapTypesMainList,
  u_IeEmbeddedProtocolRegistration;

type
  TGlobalState = class
  private
    FGlobalConfig: IGlobalConfig;
    FBaseConfigPath: IPathConfig;
    FBaseDataPath: IPathConfig;
    FBaseCachePath: IPathConfig;
    FBaseApplicationPath: IPathConfig;

    FMainConfigProvider: IConfigDataWriteProvider;
    FZmpInfoSet: IZmpInfoSet;
    FHashFunction: IHashFunction;
    FTimer: ITimer;
    FAppearanceOfMarkFactory: IAppearanceOfMarkFactory;
    FVectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
    FGeoCodePlacemarkFactory: IGeoCodePlacemarkFactory;
    FMapTypeSetBuilderFactory: IMapTypeSetBuilderFactory;
    FMapTypeListBuilderFactory: IMapTypeListBuilderFactory;
    FResourceProvider: IConfigDataProvider;
    FTileNameGenerator: ITileFileNameGeneratorsList;
    FTileNameParser: ITileFileNameParsersList;
    FGCThread: TGarbageCollectorThread;
    FContentTypeManager: IContentTypeManager;
    FMapCalibrationList: IMapCalibrationList;
    FCacheConfig: IGlobalCacheConfig;
    FMarkSystem: IMarkSystem;
    FMarkSystemConfig: IMarkSystemConfigListChangeable;
    FDatumFactory: IDatumFactory;
    FProjectionSetFactory: IProjectionSetFactory;
    FProjectionSetList: IProjectionSetList;
    FProjConverterFactory: IProjConverterFactory;
    FLocalConverterFactory: ILocalCoordConverterFactorySimpe;
    FMainMapsList: TMapTypesMainList;
    FGPSPositionFactory: IGPSPositionFactory;
    FBitmapPostProcessing: IBitmapPostProcessingChangeable;
    FDownloadInfo: IDownloadInfoSimple;
    FDownloaderFactory: IDownloaderFactory;
    FGlobalInternetState: IGlobalInternetState;
    FGlobalBerkeleyDBHelper: IGlobalBerkeleyDBHelper;
    FGeoCoderList: IGeoCoderListStatic;
    FMarkPictureList: IMarkPictureList;
    FMarkPictureListInternal: IMarkPictureListInternal;
    FGpsSystem: IGpsSystem;
    FImporterList: IVectorItemTreeImporterListChangeable;
    FExporterList: IVectorItemTreeExporterListChangeable;
    FGPSDatum: IDatum;
    FGeoCalc: IGeoCalc;
    FGPSRecorder: IGPSRecorder;
    FGPSRecorderInternal: IGPSRecorderInternal;
    FGpsTrackRecorder: IGpsTrackRecorder;
    FGpsTrackRecorderInternal: IGpsTrackRecorderInternal;
    FSkyMapDraw: ISatellitesInViewMapDraw;
    FSystemTime: ISystemTimeProvider;
    FSystemTimeInternal: ISystemTimeProviderInternal;
    FBGTimerNotifier: INotifierTime;
    FBGTimerNotifierInternal: INotifierTimeInternal;
    FGUISyncronizedTimer: TTimer;
    FGUISyncronizedTimerNotifierInternal: INotifierTimeInternal;
    FGUISyncronizedTimerNotifier: INotifierTime;
    FGUISyncronizedTimerCounter: IInternalPerformanceCounter;
    FDebugInfoSubSystem: IDebugInfoSubSystem;
    FProtocol: TIeEmbeddedProtocolRegistration;
    FMapVersionFactoryList: IMapVersionFactoryList;
    FPathDetalizeTree: ITreeChangeable;
    FInvisibleBrowser: IInvisibleBrowser;
    FInternalBrowser: IInternalBrowser;
    FDebugInfoWindow: IDebugInfoWindow;
    FAppStartedNotifier: INotifierOneOperation;
    FAppStartedNotifierInternal: INotifierOneOperationInternal;
    FAppClosingNotifier: INotifierOneOperation;
    FAppClosingNotifierInternal: INotifierOneOperationInternal;
    FVectorGeometryProjectedFactory: IGeometryProjectedFactory;
    FVectorGeometryLonLatFactory: IGeometryLonLatFactory;
    FBufferFactory: IBitmap32BufferFactory;
    FBitmap32StaticFactory: IBitmap32StaticFactory;
    FBatteryStatus: IBatteryStatus;
    FTerrainProviderList: ITerrainProviderList;
    FBitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory;
    FArchiveReadWriteFactory: IArchiveReadWriteFactory;
    FLastSelectionSaver: IBackgroundTask;
    FMainThreadConfigListener: IListener;
    FVectorDataFactory: IVectorDataFactory;
    FVectorDataItemMainInfoFactory: IVectorDataItemMainInfoFactory;
    FProjectedGeometryProvider: IGeometryProjectedProvider;
    FMarkFactory: IMarkFactory;
    FMarkCategoryFactory: IMarkCategoryFactory;
    FBuildInfo: IBuildInfo;
    FInternalBrowserContent: IInternalBrowserLastContent;
    FTileStorageTypeList: ITileStorageTypeListStatic;
    FLastSelectionInfo: ILastSelectionInfo;
    FImageResamplerFactoryList: IImageResamplerFactoryList;
    FLastSearchResult: ILastSearchResult;
    FCoordFromStringParser: ICoordFromStringParser;
    FCoordToStringConverter: ICoordToStringConverterChangeable;
    FValueToStringConverter: IValueToStringConverterChangeable;
    FAppEnum: IAppEnum;
    FFavoriteMapSetConfig: IFavoriteMapSetConfig;
    FInternalDomainUrlHandler: IInternalDomainUrlHandler;

    procedure OnMainThreadConfigChange;
    procedure InitProtocol;

    procedure OnGUISyncronizedTimer(Sender: TObject);
    function GetPerfCounterList: IInternalPerformanceCounterList;
    {$IFDEF USE_JCL_DEBUG}
    procedure DoException(Sender: TObject; E: Exception);
    {$ENDIF USE_JCL_DEBUG}
  public
    property Config: IGlobalConfig read FGlobalConfig;
    property BaseApplicationPath: IPathConfig read FBaseApplicationPath;
    property BaseConfigPath: IPathConfig read FBaseConfigPath;
    property MapType: TMapTypesMainList read FMainMapsList;
    property CacheConfig: IGlobalCacheConfig read FCacheConfig;
    property MarksDb: IMarkSystem read FMarkSystem;
    property MarkSystemConfig: IMarkSystemConfigListChangeable read FMarkSystemConfig;
    property GpsSystem: IGpsSystem read FGpsSystem;
    property GPSDatum: IDatum read FGPSDatum;
    property GeoCalc: IGeoCalc read FGeoCalc;

    // ������ ����������� ���� ������ � �������
    property TileNameGenerator: ITileFileNameGeneratorsList read FTileNameGenerator;
    property TileNameParser: ITileFileNameParsersList read FTileNameParser;
    property ContentTypeManager: IContentTypeManager read FContentTypeManager;
    property DatumFactory: IDatumFactory read FDatumFactory;
    property ProjectionSetFactory: IProjectionSetFactory read FProjectionSetFactory;
    property ProjectionSetList: IProjectionSetList read FProjectionSetList;
    property ProjConverterFactory: IProjConverterFactory read FProjConverterFactory;
    property LocalConverterFactory: ILocalCoordConverterFactorySimpe read FLocalConverterFactory;
    property MapTypeSetBuilderFactory: IMapTypeSetBuilderFactory read FMapTypeSetBuilderFactory;
    property MapTypeListBuilderFactory: IMapTypeListBuilderFactory read FMapTypeListBuilderFactory;
    property MapCalibrationList: IMapCalibrationList read FMapCalibrationList;
    property AppStartedNotifier: INotifierOneOperation read FAppStartedNotifier;
    property AppClosingNotifier: INotifierOneOperation read FAppClosingNotifier;

    property HashFunction: IHashFunction read FHashFunction;
    property Timer: ITimer read FTimer;
    property AppearanceOfMarkFactory: IAppearanceOfMarkFactory read FAppearanceOfMarkFactory;
    property MainConfigProvider: IConfigDataWriteProvider read FMainConfigProvider;
    property ResourceProvider: IConfigDataProvider read FResourceProvider;
    property DownloadInfo: IDownloadInfoSimple read FDownloadInfo;
    property DownloaderFactory: IDownloaderFactory read FDownloaderFactory;
    property GlobalInternetState: IGlobalInternetState read FGlobalInternetState;
    property ImporterList: IVectorItemTreeImporterListChangeable read FImporterList;
    property ExporterList: IVectorItemTreeExporterListChangeable read FExporterList;
    property SkyMapDraw: ISatellitesInViewMapDraw read FSkyMapDraw;
    property GUISyncronizedTimerNotifier: INotifierTime read FGUISyncronizedTimerNotifier;
    property BGTimerNotifier: INotifierTime read FBGTimerNotifier;
    property PerfCounterList: IInternalPerformanceCounterList read GetPerfCounterList;
    property SystemTime: ISystemTimeProvider read FSystemTime;

    property LastSelectionInfo: ILastSelectionInfo read FLastSelectionInfo;
    property BitmapPostProcessing: IBitmapPostProcessingChangeable read FBitmapPostProcessing;
    property GPSRecorder: IGPSRecorder read FGPSRecorder;
    property GpsTrackRecorder: IGpsTrackRecorder read FGpsTrackRecorder;
    property PathDetalizeTree: ITreeChangeable read FPathDetalizeTree;
    property InternalBrowser: IInternalBrowser read FInternalBrowser;
    property DebugInfoWindow: IDebugInfoWindow read FDebugInfoWindow;
    property VectorGeometryLonLatFactory: IGeometryLonLatFactory read FVectorGeometryLonLatFactory;
    property VectorGeometryProjectedFactory: IGeometryProjectedFactory read FVectorGeometryProjectedFactory;
    property BufferFactory: IBitmap32BufferFactory read FBufferFactory;
    property Bitmap32StaticFactory: IBitmap32StaticFactory read FBitmap32StaticFactory;
    property VectorDataFactory: IVectorDataFactory read FVectorDataFactory;
    property VectorDataItemMainInfoFactory: IVectorDataItemMainInfoFactory read FVectorDataItemMainInfoFactory;
    property ProjectedGeometryProvider: IGeometryProjectedProvider read FProjectedGeometryProvider;
    property VectorItemSubsetBuilderFactory: IVectorItemSubsetBuilderFactory read FVectorItemSubsetBuilderFactory;
    property BitmapTileSaveLoadFactory: IBitmapTileSaveLoadFactory read FBitmapTileSaveLoadFactory;
    property GeoCodePlacemarkFactory: IGeoCodePlacemarkFactory read FGeoCodePlacemarkFactory;
    property ArchiveReadWriteFactory: IArchiveReadWriteFactory read FArchiveReadWriteFactory;
    property TerrainProviderList: ITerrainProviderList read FTerrainProviderList;
    property GlobalBerkeleyDBHelper: IGlobalBerkeleyDBHelper read FGlobalBerkeleyDBHelper;
    property MarkPictureList: IMarkPictureList read FMarkPictureList;
    property MapVersionFactoryList: IMapVersionFactoryList read FMapVersionFactoryList;
    property BuildInfo: IBuildInfo read FBuildInfo;
    property TileStorageTypeList: ITileStorageTypeListStatic read FTileStorageTypeList;
    property ImageResamplerFactoryList: IImageResamplerFactoryList read FImageResamplerFactoryList;
    property LastSearchResult: ILastSearchResult read FLastSearchResult;
    property CoordFromStringParser: ICoordFromStringParser read FCoordFromStringParser;
    property CoordToStringConverter: ICoordToStringConverterChangeable read FCoordToStringConverter;
    property ValueToStringConverter: IValueToStringConverterChangeable read FValueToStringConverter;
    property GeoCoderList: IGeoCoderListStatic read FGeoCoderList;
    property DebugInfoSubSystem: IDebugInfoSubSystem read FDebugInfoSubSystem;
    property BatteryStatus: IBatteryStatus read FBatteryStatus;
    property AppEnum: IAppEnum read FAppEnum;
    property FavoriteMapSetConfig: IFavoriteMapSetConfig read FFavoriteMapSetConfig;
    property InternalDomainUrlHandler: IInternalDomainUrlHandler read FInternalDomainUrlHandler;

    constructor Create(const AAppEnum: IAppEnum = nil);
    destructor Destroy; override;
    procedure LoadConfig;
    procedure SaveMainParams;
    procedure StartThreads;
    procedure SendTerminateToThreads;
    procedure SystemTimeChanged;

    procedure StartExceptionTracking;
    procedure StopExceptionTracking;

    function ApplicationCaption: string;
  end;

var
  GState: TGlobalState;

implementation

uses
  {$IFDEF USE_JCL_DEBUG}
  Forms,
  {$ENDIF}
  {$IFNDEF UNICODE}
  Compatibility,
  CompatibilityIniFiles,
  {$ENDIF}
  u_Notifier,
  u_NotifierOperation,
  c_CoordConverter,
  c_InternalBrowser,
  u_SASMainConfigProvider,
  u_ConfigDataProviderByIniFile,
  u_ConfigDataWriteProviderByIniFile,
  u_ConfigDataProviderByPathConfig,
  i_InetConfig,
  i_InternalDomainInfoProvider,
  i_TextByVectorItem,
  i_LocalCoordConverterFactory,
  i_ImageResamplerFactoryChangeable,
  u_MapTypeSetBuilderFactory,
  u_MapTypeListBuilderFactory,
  i_InternalDebugConfig,
  u_TextByVectorItemHTMLByDescription,
  u_NotifierTime,
  i_FileNameIterator,
  u_AppearanceOfMarkFactory,
  u_ContentTypeManagerSimple,
  u_MarkSystem,
  u_MarkSystemConfig,
  u_MapCalibrationListBasic,
  u_XmlInfoSimpleParser,
  u_ProjectionSetFactorySimple,
  u_ProjectionSetListStaticSimple,
  u_DownloadInfoSimple,
  u_DownloaderByCurlFactory,
  u_DownloaderByWinInetFactory,
  u_DatumFactory,
  u_GeoCalc,
  u_HashFunctionCityHash,
  {$IFDEF DEBUG}
  u_HashFunctionWithCounter,
  {$ELSE}
  u_HashFunctionByImpl,
  {$ENDIF}
  u_MapVersionFactoryList,
  u_GeoCoderListSimple,
  u_MarkPictureListSimple,
  u_ImageResamplerFactoryListStaticSimple,
  u_GlobalBerkeleyDBHelper,
  u_GPSRecorder,
  u_GpsTrackRecorder,
  u_SatellitesInViewMapDrawSimple,
  u_GPSModuleFactoryByVSAGPS,
  u_GPSPositionFactory,
  u_GeoCodePlacemark,
  u_LocalCoordConverterFactorySimpe,
  u_TerrainProviderList,
  u_ProjConverterFactory,
  u_PathConfig,
  u_BatteryStatus,
  u_ZmpInfoSet,
  u_ZmpFileNamesIteratorFactory,
  u_HtmlToHintTextConverterStuped,
  u_InvisibleBrowserByFormSynchronize,
  u_InternalBrowserByForm,
  u_DebugInfoWindow,
  u_IeEmbeddedProtocolFactory,
  u_GeometryLonLatFactory,
  u_VectorDataFactorySimple,
  u_GeometryProjectedFactory,
  u_PathDetalizeProviderTreeSimple,
  u_InternalDomainUrlHandler,
  u_InternalDomainInfoProviderList,
  u_InternalDomainInfoProviderByMapTypeList,
  u_InternalDomainInfoProviderByDataProvider,
  u_InternalDomainInfoProviderByMarksSystem,
  u_InternalDomainInfoProviderByMapData,
  u_InternalDomainInfoProviderByLastSearchResults,
  u_InternalDomainInfoProviderByLastContent,
  u_InternalDomainInfoProviderByTileStorageOptions,
  u_Bitmap32StaticFactory,
  u_Bitmap32BufferFactory,
  u_VectorItemSubsetBuilder,
  u_GpsSystem,
  u_LastSelectionInfoSaver,
  u_ListenerByEvent,
  u_Synchronizer,
  u_GlobalConfig,
  u_GlobalInternetState,
  u_GlobalCacheConfig,
  u_InternalDebugConfig,
  u_MarkFactory,
  u_MarkCategoryFactory,
  u_GeometryProjectedProvider,
  u_SystemTimeProvider,
  u_BitmapTileSaveLoadFactory,
  u_ArchiveReadWriteFactory,
  u_DebugInfoSubSystem,
  u_LastSelectionInfo,
  u_LocalCoordConverterFactory,
  u_LastSearchResult,
  u_ImageResamplerFactoryChangeableByConfig,
  u_TimerByQueryPerformanceCounter,
  u_BuildInfo,
  u_AppEnum,
  u_ResStrings,
  u_FavoriteMapSetConfig,
  u_VectorItemTreeExporterListSimple,
  u_VectorItemTreeImporterListSimple,
  u_BitmapPostProcessingChangeableByConfig,
  u_CoordFromStringParser,
  u_CoordToStringConverterChangeable,
  u_ValueToStringConverterChangeable,
  u_InternalBrowserLastContent,
  u_TileStorageTypeListSimple,
  u_TileFileNameParsersSimpleList,
  u_TileFileNameGeneratorsSimpleList;

{ TGlobalState }

constructor TGlobalState.Create(const AAppEnum: IAppEnum);
var
  VViewCnonfig: IConfigDataProvider;
  VKmlLoader: IVectorDataLoader;
  VFilesIteratorFactory: IFileNameIteratorFactory;
  VFilesIterator: IFileNameIterator;
  VProgramPath: string;
  VSleepByClass: IConfigDataProvider;
  VInternalDebugConfig: IInternalDebugConfig;
  VTileLoadResampler: IImageResamplerFactoryChangeable;
  VTileGetPrevResampler: IImageResamplerFactoryChangeable;
  VTileReprojectResampler: IImageResamplerFactoryChangeable;
  VTileDownloadResampler: IImageResamplerFactoryChangeable;
  VNotifierSync: IReadWriteSync;
  VOneOperationSync: IReadWriteSync;
  VLocalCoordConverterFactory: ILocalCoordConverterFactory;
  VContentTypeManagerBitmapInternal: IContentTypeManagerBitmapInternal;
begin
  inherited Create;

  FAppEnum := AAppEnum;
  if not Assigned(FAppEnum) then begin
    FAppEnum := TAppEnum.Create;
  end;

  FTimer := MakeTimerByQueryPerformanceCounter;

  if ModuleIsLib then begin
    // run as DLL or PACKAGE
    VProgramPath := GetModuleName(HInstance);
    VProgramPath := ExtractFilePath(VProgramPath);
  end else begin
    // run as EXE
    VProgramPath := ExtractFilePath(ParamStr(0));
  end;
  FBaseApplicationPath := TPathConfig.Create('', VProgramPath, nil);
  FBaseConfigPath := TPathConfig.Create('', VProgramPath, nil);
  FBaseDataPath := TPathConfig.Create('', VProgramPath, nil);
  FBaseCachePath := TPathConfig.Create('PrimaryPath', '.\', FBaseDataPath);

  FBuildInfo := TBuildInfo.Create;

  VInternalDebugConfig := TInternalDebugConfig.Create;

  FMainConfigProvider :=
    TSASMainConfigProvider.Create(
      FBaseConfigPath.FullPath,
      ExtractFileName(ParamStr(0)),
      HInstance
    );

  VInternalDebugConfig.ReadConfig(FMainConfigProvider.GetSubItem('Debug'));

  FDebugInfoSubSystem := TDebugInfoSubSystem.Create(VInternalDebugConfig);

  FHashFunction :=
    {$IFDEF DEBUG}
    THashFunctionWithCounter.Create(
      THashFunctionCityHash.Create,
      FDebugInfoSubSystem.RootCounterList.CreateAndAddNewSubList('HashFunction')
    );
    {$ELSE}
    THashFunctionByImpl.Create(
      THashFunctionCityHash.Create
    );
    {$ENDIF}

  FImageResamplerFactoryList := TImageResamplerFactoryListStaticSimple.Create;
  FMapVersionFactoryList :=
    TMapVersionFactoryList.Create(
      FDebugInfoSubSystem.RootCounterList.CreateAndAddNewSubList('MapVersion'),
      FHashFunction
    );

  FAppearanceOfMarkFactory :=
    TAppearanceOfMarkFactory.Create(
      FDebugInfoSubSystem.RootCounterList.CreateAndAddNewSubList('AppearanceOfMark'),
      FHashFunction
    );
  FInternalBrowserContent := TInternalBrowserLastContent.Create;


  FGlobalConfig :=
    TGlobalConfig.Create(
      VInternalDebugConfig,
      FAppearanceOfMarkFactory,
      FBaseCachePath,
      FBaseConfigPath,
      FBaseDataPath,
      FBaseApplicationPath
    );

  FGlobalConfig.ReadConfig(FMainConfigProvider);

  FVectorItemSubsetBuilderFactory :=
    TVectorItemSubsetBuilderFactory.Create(
      FHashFunction
    );
  FBGTimerNotifierInternal :=
    TNotifierTime.Create(
      GSync.SyncVariable.Make(Self.ClassName + 'BGTimerNotifier')
    );
  FBGTimerNotifier := FBGTimerNotifierInternal;
  FBufferFactory :=
    TBitmap32BufferFactory.Create(
      FBGTimerNotifier,
      GSync.SyncVariable.Make(Self.ClassName)
    );
  FBitmap32StaticFactory :=
    TBitmap32StaticFactory.Create(
      FHashFunction,
      FBufferFactory
    );
  FSystemTimeInternal := TSystemTimeProvider.Create;
  FSystemTime := FSystemTimeInternal;

  FBitmapTileSaveLoadFactory :=
    TBitmapTileSaveLoadFactory.Create(
      FBitmap32StaticFactory
    );

  VContentTypeManagerBitmapInternal :=
    TContentTypeManagerBitmap.Create(
      FBitmapTileSaveLoadFactory,
      FDebugInfoSubSystem.RootCounterList.CreateAndAddNewSubList('Content')
    );

  FMarkPictureListInternal :=
    TMarkPictureListSimple.Create(
      FHashFunction,
      FGlobalConfig.MarkPictureConfig,
      FGlobalConfig.MarksIconsPath,
      FGlobalConfig.MediaDataPath,
      VContentTypeManagerBitmapInternal
    );
  FMarkPictureList := FMarkPictureListInternal;

  FArchiveReadWriteFactory := TArchiveReadWriteFactory.Create;

  VNotifierSync := GSync.SyncVariable.Make(Self.ClassName + 'Notifiers');
  VOneOperationSync := GSync.SyncVariable.Make(Self.ClassName + 'OneOperation');

  FAppStartedNotifierInternal :=
    TNotifierOneOperation.Create(
      VOneOperationSync,
      TNotifierBase.Create(VNotifierSync)
    );
  FAppStartedNotifier := FAppStartedNotifierInternal;
  FAppClosingNotifierInternal :=
    TNotifierOneOperation.Create(
      VOneOperationSync,
      TNotifierBase.Create(VNotifierSync)
    );
  FAppClosingNotifier := FAppClosingNotifierInternal;

  VSleepByClass := FMainConfigProvider.GetSubItem('SleepByClass');

  FResourceProvider := FMainConfigProvider.GetSubItem('sas:\Resource');
  FVectorGeometryProjectedFactory := TGeometryProjectedFactory.Create;
  FVectorGeometryLonLatFactory :=
    TGeometryLonLatFactory.Create(
      FDebugInfoSubSystem.RootCounterList.CreateAndAddNewSubList('GeometryLonLatFactory'),
      FHashFunction
    );

  FProjConverterFactory := TProjConverterFactory.Create;
  FLastSelectionInfo := TLastSelectionInfo.Create;
  FLastSearchResult := TLastSearchResult.Create;

  FDatumFactory := TDatumFactory.Create(FHashFunction);
  FProjectionSetFactory := TProjectionSetFactorySimple.Create(FHashFunction, FDatumFactory);
  FProjectionSetList := TProjectionSetListStaticSimple.Create(FProjectionSetFactory);
  VLocalCoordConverterFactory :=
    TLocalCoordConverterFactory.Create(
      FDebugInfoSubSystem.RootCounterList.CreateAndAddNewSubList('LocalCoordConverter'),
      FHashFunction
    );
  FLocalConverterFactory :=
    TLocalCoordConverterFactorySimpe.Create(VLocalCoordConverterFactory);

  FCacheConfig := TGlobalCacheConfig.Create(FBaseCachePath);
  FDownloadInfo := TDownloadInfoSimple.Create(nil);
  VViewCnonfig := FMainConfigProvider.GetSubItem('VIEW');

  FGUISyncronizedTimer := TTimer.Create(nil);
  FGUISyncronizedTimer.Enabled := False;
  FGUISyncronizedTimer.Interval := VSleepByClass.ReadInteger('GUISyncronizedTimer', 16);
  FGUISyncronizedTimer.OnTimer := Self.OnGUISyncronizedTimer;

  FGUISyncronizedTimerNotifierInternal :=
    TNotifierTime.Create(
      GSync.SyncVariable.Make(Self.ClassName + 'GUITimerNotifier')
    );
  FGUISyncronizedTimerNotifier := FGUISyncronizedTimerNotifierInternal;
  FGUISyncronizedTimerCounter := FDebugInfoSubSystem.RootCounterList.CreateAndAddNewCounter('GUITimer');

  FGlobalBerkeleyDBHelper := TGlobalBerkeleyDBHelper.Create(FBaseApplicationPath);

  FTerrainProviderList :=
    TTerrainProviderListSimple.Create(
      FProjConverterFactory,
      FProjectionSetFactory,
      FGlobalConfig.TerrainDataPath,
      FCacheConfig.GECachePath,
      FCacheConfig.GCCachePath
    );

  FMainThreadConfigListener := TNotifyEventListenerSync.Create(FGUISyncronizedTimerNotifier, 1000, Self.OnMainThreadConfigChange);
  FGlobalConfig.MainThreadConfig.ChangeNotifier.Add(FMainThreadConfigListener);
  OnMainThreadConfigChange;

  FGPSDatum := FDatumFactory.GetByCode(CYandexDatumEPSG);
  FGeoCalc := TGeoCalc.Create(FGPSDatum);

  FGPSPositionFactory := TGPSPositionFactory.Create;
  FGPSRecorderInternal :=
    TGPSRecorder.Create(
      FGPSDatum,
      FGlobalConfig.GpsRecorderFileName,
      FGPSPositionFactory.BuildPositionEmpty
    );
  FGPSRecorder := FGPSRecorderInternal;

  FGpsTrackRecorderInternal :=
    TGpsTrackRecorder.Create(
      FVectorGeometryLonLatFactory,
      FGlobalConfig.GpsTrackRecorderFileName
    );
  FGpsTrackRecorder := FGpsTrackRecorderInternal;

  FTileNameGenerator := TTileFileNameGeneratorsSimpleList.Create;
  FTileNameParser := TTileFileNameParsersSimpleList.Create;

  FVectorDataItemMainInfoFactory := TVectorDataItemMainInfoFactory.Create(FHashFunction, THtmlToHintTextConverterStuped.Create);
  FVectorDataFactory := TVectorDataFactorySimple.Create(FHashFunction);

  FContentTypeManager :=
    TContentTypeManagerSimple.Create(
      FVectorGeometryLonLatFactory,
      FVectorDataFactory,
      FAppearanceOfMarkFactory,
      FMarkPictureList,
      FVectorItemSubsetBuilderFactory,
      VContentTypeManagerBitmapInternal,
      FArchiveReadWriteFactory
    );

  FGlobalInternetState := TGlobalInternetState.Create;

  case FGlobalConfig.InetConfig.NetworkEngineType of
    neWinInet: begin
      FDownloaderFactory := TDownloaderByWinInetFactory.Create(
        FGlobalConfig.InetConfig.WinInetConfig,
        FContentTypeManager
      );
    end;
    neCurl: begin
      FDownloaderFactory := TDownloaderByCurlFactory.Create(
        FContentTypeManager
      );
    end;
  else
    raise Exception.Create('Unknown NetworkEngineType');
  end;

  FMapCalibrationList := TMapCalibrationListBasic.Create;
  FProjectedGeometryProvider :=
    TGeometryProjectedProvider.Create(
      FDebugInfoSubSystem.RootCounterList.CreateAndAddNewSubList('GeometryProject'),
      FHashFunction,
      FVectorGeometryProjectedFactory
    );

  FCoordFromStringParser :=
    TCoordFromStringParser.Create(
      FGlobalConfig.CoordRepresentationConfig
    );

  FCoordToStringConverter :=
    TCoordToStringConverterChangeable.Create(
      FGlobalConfig.CoordRepresentationConfig,
      FGlobalConfig.LanguageManager.ChangeNotifier
    );

  FValueToStringConverter :=
    TValueToStringConverterChangeable.Create(
      FGlobalConfig.ValueToStringConverterConfig,
      FGlobalConfig.LanguageManager.ChangeNotifier
    );

  FGCThread :=
    TGarbageCollectorThread.Create(
      FAppClosingNotifier,
      FDebugInfoSubSystem.RootCounterList.CreateAndAddNewCounter('GCTimer'),
      FBGTimerNotifierInternal,
      VSleepByClass.ReadInteger(TGarbageCollectorThread.ClassName, 1000)
    );
  FBitmapPostProcessing :=
    TBitmapPostProcessingChangeableByConfig.Create(
      FGlobalConfig.BitmapPostProcessingConfig,
      FBitmap32StaticFactory
    );
  FGpsSystem :=
    TGpsSystem.Create(
      FAppStartedNotifier,
      FAppClosingNotifier,
      TGPSModuleFactoryByVSAGPS.Create(FSystemTime, FGPSPositionFactory),
      FGlobalConfig.GPSConfig,
      FGPSRecorderInternal,
      FGpsTrackRecorderInternal,
      GUISyncronizedTimerNotifier,
      FDebugInfoSubSystem.RootCounterList
    );
  FGeoCodePlacemarkFactory :=
    TGeoCodePlacemarkFactory.Create(
      FVectorGeometryLonLatFactory,
      FHashFunction
    );
  FMarkCategoryFactory :=
    TMarkCategoryFactory.Create(
      FGlobalConfig.MarksCategoryFactoryConfig
    );
  FMarkFactory :=
    TMarkFactory.Create(
      FGlobalConfig.MarksFactoryConfig,
      FMarkPictureList,
      FHashFunction,
      FAppearanceOfMarkFactory,
      THtmlToHintTextConverterStuped.Create
    );
  FMarkSystemConfig := TMarkSystemConfig.Create;
  FMarkSystem :=
    TMarkSystem.Create(
      FGlobalConfig.MarksDbPath,
      FMarkSystemConfig,
      FMarkPictureList,
      FMarkFactory,
      FMarkCategoryFactory,
      FHashFunction,
      FAppearanceOfMarkFactory,
      FVectorGeometryLonLatFactory,
      FVectorItemSubsetBuilderFactory,
      FDebugInfoSubSystem.RootCounterList.CreateAndAddNewSubList('MarksSystem'),
      FAppStartedNotifier,
      FAppClosingNotifier,
      THtmlToHintTextConverterStuped.Create
    );

  FImporterList :=
    TVectorItemTreeImporterListSimple.Create(
      FCoordToStringConverter,
      FVectorDataFactory,
      FVectorDataItemMainInfoFactory,
      FVectorGeometryLonLatFactory,
      FVectorItemSubsetBuilderFactory,
      FArchiveReadWriteFactory,
      FMarkPictureList,
      FHashFunction,
      FAppearanceOfMarkFactory,
      FMarkFactory,
      FMarkCategoryFactory,
      FMarkSystem.ImplFactoryList,
      FGlobalConfig.MediaDataPath,
      FContentTypeManager,
      FDebugInfoSubSystem.RootCounterList.CreateAndAddNewSubList('Import')
    );

  FExporterList :=
    TVectorItemTreeExporterListSimple.Create(
      FGeoCalc,
      FArchiveReadWriteFactory,
      FAppearanceOfMarkFactory,
      FMarkFactory,
      FMarkCategoryFactory,
      FMarkSystem.ImplFactoryList,
      FGlobalConfig.ExportMarks2KmlConfig,
      FBuildInfo
    );

  FGeoCoderList :=
    TGeoCoderListSimple.Create(
      FGlobalConfig.GeoCoderConfig,
      FGlobalConfig.InetConfig,
      BGTimerNotifier,
      FVectorItemSubsetBuilderFactory,
      FGeoCodePlacemarkFactory,
      FDownloaderFactory,
      FCoordToStringConverter,
      FMarkSystem.MarkDb,
      FProjectionSetFactory,
      FVectorGeometryLonLatFactory,
      FVectorDataFactory,
      FVectorDataItemMainInfoFactory
    );

  FMarkPictureListInternal.LoadList;

  VFilesIteratorFactory := TZmpFileNamesIteratorFactory.Create;
  VFilesIterator := VFilesIteratorFactory.CreateIterator(FGlobalConfig.MapsPath.FullPath, '');
  FZmpInfoSet :=
    TZmpInfoSet.Create(
      FGlobalConfig.ZmpConfig,
      FProjectionSetFactory,
      FArchiveReadWriteFactory,
      FContentTypeManager,
      FAppearanceOfMarkFactory,
      FMarkPictureList,
      FBufferFactory,
      FBitmap32StaticFactory,
      FGlobalConfig.LanguageManager,
      VFilesIterator
    );

  FMapTypeSetBuilderFactory := TMapTypeSetBuilderFactory.Create(FHashFunction);
  FMapTypeListBuilderFactory := TMapTypeListBuilderFactory.Create(FHashFunction);
  VTileLoadResampler :=
    TImageResamplerFactoryChangeableByConfig.Create(
      FGlobalConfig.TileLoadResamplerConfig,
      FImageResamplerFactoryList
    );
  VTileGetPrevResampler :=
    TImageResamplerFactoryChangeableByConfig.Create(
      FGlobalConfig.TileGetPrevResamplerConfig,
      FImageResamplerFactoryList
    );
  VTileReprojectResampler :=
    TImageResamplerFactoryChangeableByConfig.Create(
      FGlobalConfig.TileReprojectResamplerConfig,
      FImageResamplerFactoryList
    );
  VTileDownloadResampler :=
    TImageResamplerFactoryChangeableByConfig.Create(
      FGlobalConfig.TileDownloadResamplerConfig,
      FImageResamplerFactoryList
    );

  FMainMapsList :=
    TMapTypesMainList.Create(
      FMapTypeSetBuilderFactory,
      FZmpInfoSet,
      VTileLoadResampler,
      VTileGetPrevResampler,
      VTileReprojectResampler,
      VTileDownloadResampler,
      FDebugInfoSubSystem.RootCounterList.CreateAndAddNewSubList('MapType')
    );
  FSkyMapDraw := TSatellitesInViewMapDrawSimple.Create;

  VKmlLoader :=
    TXmlInfoSimpleParser.Create(
      FMarkPictureList,
      FAppearanceOfMarkFactory,
      FVectorGeometryLonLatFactory,
      FVectorDataFactory,
      FVectorItemSubsetBuilderFactory
    );
  FPathDetalizeTree :=
    TPathDetalizeProviderTreeSimple.Create(
      FGlobalConfig.PathDetalizeConfig,
      FGlobalConfig.LanguageManager,
      FGlobalConfig.InetConfig,
      FBGTimerNotifier,
      FDownloaderFactory,
      FVectorDataItemMainInfoFactory,
      FVectorGeometryLonLatFactory,
      VKmlLoader
    );

  InitProtocol;

  FInternalDomainUrlHandler :=
    TInternalDomainUrlHandler.Create(
      FGlobalConfig.InternalDomainUrlHandlerConfig,
      FGlobalConfig.MediaDataPath
    );

  FInvisibleBrowser :=
    TInvisibleBrowserByFormSynchronize.Create(
      FGlobalConfig.LanguageManager,
      FGlobalConfig.InetConfig
    );
  FInternalBrowser :=
    TInternalBrowserByForm.Create(
      FGlobalConfig.LanguageManager,
      FInternalBrowserContent,
      FGlobalConfig.InternalBrowserConfig,
      FGlobalConfig.InetConfig,
      FInternalDomainUrlHandler
    );
  FDebugInfoWindow :=
    TDebugInfoWindow.Create(
      FGlobalConfig.InternalDebugConfig,
      FDebugInfoSubSystem
    );
  FBatteryStatus := TBatteryStatus.Create;
  FLastSelectionSaver :=
    TLastSelectionInfoSaver.Create(
      FAppClosingNotifier,
      FVectorGeometryLonLatFactory,
      FLastSelectionInfo,
      FGlobalConfig.LastSelectionFileName
    );
  FTileStorageTypeList :=
    TTileStorageTypeListSimple.Create(
      FMapVersionFactoryList,
      FContentTypeManager,
      FArchiveReadWriteFactory,
      FCacheConfig,
      FGlobalBerkeleyDBHelper,
      FBGTimerNotifier
    );
  FFavoriteMapSetConfig := TFavoriteMapSetConfig.Create;
end;

destructor TGlobalState.Destroy;
begin
  FGCThread.Terminate;
  FGCThread.WaitFor;
  FreeAndNil(FGCThread);
  FTileNameGenerator := nil;
  FContentTypeManager := nil;
  FMapCalibrationList := nil;
  FMarkSystem := nil;
  FGPSRecorder := nil;
  FreeAndNil(FMainMapsList);
  FMarkPictureList := nil;
  FSkyMapDraw := nil;
  FreeAndNil(FProtocol);
  FreeAndNil(FGUISyncronizedTimer);
  FGUISyncronizedTimerNotifier := nil;
  FMainConfigProvider := nil;
  FGlobalInternetState := nil;
  FArchiveReadWriteFactory := nil;
  FBitmapTileSaveLoadFactory := nil;
  FTerrainProviderList := nil;
  FProjConverterFactory := nil;
  FGlobalBerkeleyDBHelper := nil;
  FAppEnum := nil;
  FFavoriteMapSetConfig := nil;
  inherited;
end;

function TGlobalState.GetPerfCounterList: IInternalPerformanceCounterList;
begin
  Result := FDebugInfoSubSystem.RootCounterList;
end;

procedure TGlobalState.InitProtocol;
var
  VInternalDomainInfoProviderList: TInternalDomainInfoProviderList;
  VInternalDomainInfoProvider: IInternalDomainInfoProvider;
  VTextProivder: ITextByVectorItem;
  VTextProviderList: TStringList;
begin
  VInternalDomainInfoProviderList := TInternalDomainInfoProviderList.Create;

  VInternalDomainInfoProvider :=
    TInternalDomainInfoProviderByMapTypeList.Create(
      FZmpInfoSet,
      FContentTypeManager
    );

  VInternalDomainInfoProviderList.Add(
    CZmpInfoInternalDomain,
    VInternalDomainInfoProvider
  );

  VInternalDomainInfoProvider :=
    TInternalDomainInfoProviderByDataProvider.Create(
      TConfigDataProviderByPathConfig.Create(FGlobalConfig.MediaDataPath),
      FContentTypeManager
    );
  VInternalDomainInfoProviderList.Add(
    CMediaDataInternalDomain,
    VInternalDomainInfoProvider
  );
  VTextProviderList := TStringList.Create;
  VTextProviderList.Sorted := True;
  VTextProviderList.Duplicates := dupError;
  VTextProivder := TTextByVectorItemHTMLByDescription.Create;

  VTextProviderList.AddObject(CVectorItemInfoSuffix, Pointer(VTextProivder));
  VTextProivder._AddRef;

  VTextProviderList.AddObject(CVectorItemDescriptionSuffix, Pointer(VTextProivder));
  VTextProivder._AddRef;

  VInternalDomainInfoProvider :=
    TInternalDomainInfoProviderByMarksSystem.Create(
      FMarkSystem,
      VTextProivder,
      VTextProviderList
    );
  VInternalDomainInfoProviderList.Add(
    CMarksSystemInternalDomain,
    VInternalDomainInfoProvider
  );

  VInternalDomainInfoProvider :=
    TInternalDomainInfoProviderByLastSearchResults.Create(
      FLastSearchResult,
      VTextProivder,
      nil
    );
  VInternalDomainInfoProviderList.Add(
    CLastSearchResultsInternalDomain,
    VInternalDomainInfoProvider
  );

  VInternalDomainInfoProvider :=
    TInternalDomainInfoProviderByLastContent.Create(
      FInternalBrowserContent
    );
  VInternalDomainInfoProviderList.Add(
    CShowMessageDomain,
    VInternalDomainInfoProvider
  );

  VInternalDomainInfoProvider :=
    TInternalDomainInfoProviderByMapData.Create(
      FMainMapsList.FullMapsSetChangeable,
      VTextProivder,
      CVectorItemDescriptionSuffix
    );

  VInternalDomainInfoProviderList.Add(
    CMapDataInternalDomain,
    VInternalDomainInfoProvider
  );

  VInternalDomainInfoProvider :=
    TInternalDomainInfoProviderByTileStorageOptions.Create(
      FMainMapsList.FullMapsSetChangeable
    );

  VInternalDomainInfoProviderList.Add(
    CTileStorageOptionsInternalDomain,
    VInternalDomainInfoProvider
  );

  FProtocol :=
    TIeEmbeddedProtocolRegistration.Create(
      CSASProtocolName,
      TIeEmbeddedProtocolFactory.Create(VInternalDomainInfoProviderList)
    );
end;

{$IFDEF USE_JCL_DEBUG}
procedure TGlobalState.DoException(Sender: TObject; E: Exception);
var
  VStr: TStringList;
begin
  VStr := TStringList.Create;
  try
    JclLastExceptStackListToStrings(VStr, True, True, True, True);
    VStr.Insert(0, E.Message);
    VStr.Insert(1, '');
    Application.MessageBox(PChar(VStr.Text), 'Error', MB_OK or MB_ICONSTOP);
  finally
    FreeAndNil(VStr);
  end;
end;
{$ENDIF USE_JCL_DEBUG}

procedure TGlobalState.StartExceptionTracking;
begin
  {$IFDEF USE_JCL_DEBUG}
  JclStackTrackingOptions := JclStackTrackingOptions + [stRAWMode];
  JclStartExceptionTracking;
  Application.OnException := DoException;
  {$ENDIF USE_JCL_DEBUG}
end;

procedure TGlobalState.StartThreads;
begin
  FAppStartedNotifierInternal.ExecuteOperation;
  FLastSelectionSaver.Start;
  FGUISyncronizedTimer.Enabled := True;
end;

procedure TGlobalState.StopExceptionTracking;
begin
  {$IFDEF USE_JCL_DEBUG}
  Application.OnException := nil;
  JclStopExceptionTracking;
  {$ENDIF USE_JCL_DEBUG}
end;

procedure TGlobalState.SystemTimeChanged;
begin
  FSystemTimeInternal.SystemTimeChanged;
end;

procedure TGlobalState.LoadConfig;
var
  VConfig: IConfigDataProvider;
  VIniFile: TMeminifile;
  VMapsPath: String;
begin
  VMapsPath := IncludeTrailingPathDelimiter(FGlobalConfig.MapsPath.FullPath);
  ForceDirectories(VMapsPath);

  VIniFile := TMeminiFile.Create(VMapsPath + 'Maps.ini');
  try
    VConfig := TConfigDataProviderByIniFile.CreateWithOwn(VIniFile);
    VIniFile := nil;
  finally
    VIniFile.Free;
  end;

  FMarkSystemConfig.ReadConfig(FMainConfigProvider);
  FCacheConfig.ReadConfig(FMainConfigProvider);

  FMainMapsList.LoadMaps(
    FGlobalConfig.LanguageManager,
    FMapVersionFactoryList,
    FGlobalConfig.MainMemCacheConfig,
    FCacheConfig,
    FTileStorageTypeList,
    FHashFunction,
    FBGTimerNotifier,
    FAppClosingNotifier,
    FGlobalConfig.InetConfig,
    FGlobalConfig.DownloadConfig,
    FGlobalConfig.DownloaderThreadConfig,
    FDownloaderFactory,
    FBitmap32StaticFactory,
    FContentTypeManager,
    FProjectionSetFactory,
    FInvisibleBrowser,
    FProjConverterFactory,
    VConfig,
    FMainConfigProvider.GetOrCreateSubItem('MapsList')
  );

  FGPSRecorderInternal.Load;
  FGpsTrackRecorderInternal.Load;

  if (not ModuleIsLib) then begin
    VIniFile := TMeminiFile.Create(VMapsPath + 'Favorites.ini');
    try
      VConfig := TConfigDataProviderByIniFile.CreateWithOwn(VIniFile);
      VIniFile := nil;
    finally
      VIniFile.Free;
    end;
    FFavoriteMapSetConfig.ReadConfig(VConfig);
  end;
end;

procedure TGlobalState.OnGUISyncronizedTimer(Sender: TObject);
var
  VContext: TInternalPerformanceCounterContext;
  VNow: Cardinal;
begin
  VContext := FGUISyncronizedTimerCounter.StartOperation;
  try
    VNow := GetTickCount;
    FGUISyncronizedTimerNotifierInternal.Notify(VNow);
  finally
    FGUISyncronizedTimerCounter.FinishOperation(VContext);
  end;
end;

procedure TGlobalState.OnMainThreadConfigChange;
const
  Priorities: array [TThreadPriority] of Integer =
    (THREAD_PRIORITY_IDLE, THREAD_PRIORITY_LOWEST, THREAD_PRIORITY_BELOW_NORMAL,
    THREAD_PRIORITY_NORMAL, THREAD_PRIORITY_ABOVE_NORMAL,
    THREAD_PRIORITY_HIGHEST, THREAD_PRIORITY_TIME_CRITICAL);
begin
  SetThreadPriority(GetCurrentThread(), Priorities[FGlobalConfig.MainThreadConfig.Priority]);
end;

procedure TGlobalState.SaveMainParams;
var
  VIniFile: TMeminifile;
  VConfig: IConfigDataWriteProvider;
  VMapsPath: String;
begin
  if ModuleIsLib then begin
    Exit;
  end;

  VMapsPath := IncludeTrailingPathDelimiter(FGlobalConfig.MapsPath.FullPath);

  VIniFile := TMeminiFile.Create(VMapsPath + 'Maps.ini');
  try
    VIniFile.Encoding := TEncoding.UTF8;

    VConfig := TConfigDataWriteProviderByIniFile.CreateWithOwn(VIniFile);
    VIniFile := nil;
  finally
    VIniFile.Free;
  end;
  FMainMapsList.SaveMaps(
    VConfig,
    FMainConfigProvider.GetOrCreateSubItem('MapsList')
  );

  VIniFile := TMeminiFile.Create(VMapsPath + 'Favorites.ini');
  try
    VIniFile.Encoding := TEncoding.UTF8;

    VConfig := TConfigDataWriteProviderByIniFile.CreateWithOwn(VIniFile);
    VIniFile := nil;
  finally
    VIniFile.Free;
  end;
  FFavoriteMapSetConfig.WriteConfig(VConfig);

  FGPSRecorderInternal.Save;
  FGpsTrackRecorderInternal.Save;
  FMarkSystemConfig.WriteConfig(FMainConfigProvider);
  FCacheConfig.WriteConfig(FMainConfigProvider);
  FGlobalConfig.WriteConfig(MainConfigProvider);
end;

procedure TGlobalState.SendTerminateToThreads;
begin
  if FGlobalConfig.MainThreadConfig <> nil then begin
    FGlobalConfig.MainThreadConfig.ChangeNotifier.Remove(FMainThreadConfigListener);
  end;

  FGUISyncronizedTimer.Enabled := False;
  FAppClosingNotifierInternal.ExecuteOperation;
  FGCThread.Terminate;
end;

function TGlobalState.ApplicationCaption: string;
begin
  Result := SAS_STR_ApplicationTitle;
  if Assigned(FBuildInfo) then begin
    Result := Result + ' ' + FBuildInfo.GetVersionDetaled;
  end;
  if Assigned(FAppEnum) and (FAppEnum.CurrentID > 1) then begin
    Result := Format('[%d] %s', [FAppEnum.CurrentID, Result]);
  end;
end;

end.
