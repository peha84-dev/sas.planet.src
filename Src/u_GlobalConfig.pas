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

unit u_GlobalConfig;

interface

uses
  i_PathConfig,
  i_GlobalAppConfig,
  i_LanguageManager,
  i_AppearanceOfMarkFactory,
  i_InetConfig,
  i_GeoCoderConfig,
  i_BitmapPostProcessingConfig,
  i_ValueToStringConverterConfig,
  i_CoordRepresentationConfig,
  i_ImageResamplerConfig,
  i_MainMemCacheConfig,
  i_MarkFactoryConfig,
  i_MarksGUIConfig,
  i_MarkCategoryFactoryConfig,
  i_MarkPictureConfig,
  i_GPSConfig,
  i_GlobalViewMainConfig,
  i_GlobalDownloadConfig,
  i_ThreadConfig,
  i_StartUpLogoConfig,
  i_TerrainConfig,
  i_PathDetalizeConfig,
  i_ZmpConfig,
  i_WindowPositionConfig,
  i_GlobalConfig,
  i_InternalDebugConfig,
  i_ExportToIMGConfig,
  i_ExportMarks2KMLConfig,
  i_ElevationProfileConfig,
  i_InternalDomainUrlHandlerConfig,
  u_ConfigDataElementComplexBase;

type
  TGlobalConfig = class(TConfigDataElementComplexBase, IGlobalConfig)
  private
    FBaseConfigPath: IPathConfig;
    FBaseCachePath: IPathConfig;
    FLogsPath: IPathConfig;
    FMapsPath: IPathConfig;
    FMapSvcScanPath: IPathConfig;
    FTrackPath: IPathConfig;
    FMarksDbPath: IPathConfig;
    FMarksIconsPath: IPathConfig;
    FMarkPictureConfig: IMarkPictureConfig;
    FExportMarks2KMLConfig: IExportMarks2KMLConfig;
    FMediaDataPath: IPathConfig;
    FTerrainDataPath: IPathConfig;
    FUserDataPath: IPathConfig;
    FUpdatesPath: IPathConfig;
    FLastSelectionFileName: IPathConfig;
    FGpsRecorderFileName: IPathConfig;
    FGpsTrackRecorderFileName: IPathConfig;
    FInternalDebugConfig: IInternalDebugConfig;
    FGlobalAppConfig: IGlobalAppConfig;
    FLanguageManager: ILanguageManager;
    FGeoCoderConfig: IGeoCoderConfig;
    FInetConfig: IInetConfig;
    FInternalBrowserConfig: IWindowPositionConfig;
    FInternalDomainUrlHandlerConfig: IInternalDomainUrlHandlerConfig;
    FMainThreadConfig: IThreadConfig;
    FTileLoadResamplerConfig: IImageResamplerConfig;
    FTileGetPrevResamplerConfig: IImageResamplerConfig;
    FTileReprojectResamplerConfig: IImageResamplerConfig;
    FTileDownloadResamplerConfig: IImageResamplerConfig;
    FBitmapPostProcessingConfig: IBitmapPostProcessingConfig;
    FCoordRepresentationConfig: ICoordRepresentationConfig;
    FValueToStringConverterConfig: IValueToStringConverterConfig;
    FImageResamplerConfig: IImageResamplerConfig;
    FTileMatrixDraftResamplerConfig: IImageResamplerConfig;
    FMainMemCacheConfig: IMainMemCacheConfig;
    FGPSConfig: IGpsConfig;
    FMarksFactoryConfig: IMarkFactoryConfig;
    FMarksCategoryFactoryConfig: IMarkCategoryFactoryConfig;
    FMarksGUIConfig: IMarksGUIConfig;
    FViewConfig: IGlobalViewMainConfig;
    FDownloadConfig: IGlobalDownloadConfig;
    FDownloaderThreadConfig: IThreadConfig;
    FStartUpLogoConfig: IStartUpLogoConfig;
    FTerrainConfig: ITerrainConfig;
    FPathDetalizeConfig: IPathDetalizeConfig;
    FZmpConfig: IZmpConfig;
    FExportToIMGConfig: IExportToIMGConfig;
    FElevationProfileConfig: IElevationProfileConfig;
  private
    function GetBaseConfigPath: IPathConfig;
    function GetBaseCachePath: IPathConfig;
    function GetLogsPath: IPathConfig;
    function GetMapsPath: IPathConfig;
    function GetTrackPath: IPathConfig;
    function GetMarksDbPath: IPathConfig;
    function GetMarksIconsPath: IPathConfig;
    function GetMarkPictureConfig: IMarkPictureConfig;
    function GetExportMarks2KMLConfig: IExportMarks2KMLConfig;
    function GetMediaDataPath: IPathConfig;
    function GetTerrainDataPath: IPathConfig;
    function GetUserDataPath: IPathConfig;
    function GetUpdatesPath: IPathConfig;
    function GetLastSelectionFileName: IPathConfig;
    function GetGpsRecorderFileName: IPathConfig;
    function GetGpsTrackRecorderFileName: IPathConfig;
    function GetInternalDebugConfig: IInternalDebugConfig;
    function GetGlobalAppConfig: IGlobalAppConfig;
    function GetLanguageManager: ILanguageManager;
    function GetGeoCoderConfig: IGeoCoderConfig;
    function GetInetConfig: IInetConfig;
    function GetInternalBrowserConfig: IWindowPositionConfig;
    function GetInternalDomainUrlHandlerConfig: IInternalDomainUrlHandlerConfig;
    function GetMainThreadConfig: IThreadConfig;
    function GetTileLoadResamplerConfig: IImageResamplerConfig;
    function GetTileGetPrevResamplerConfig: IImageResamplerConfig;
    function GetTileReprojectResamplerConfig: IImageResamplerConfig;
    function GetTileDownloadResamplerConfig: IImageResamplerConfig;
    function GetBitmapPostProcessingConfig: IBitmapPostProcessingConfig;
    function GetCoordRepresentationConfig: ICoordRepresentationConfig;
    function GetValueToStringConverterConfig: IValueToStringConverterConfig;
    function GetImageResamplerConfig: IImageResamplerConfig;
    function GetTileMatrixDraftResamplerConfig: IImageResamplerConfig;
    function GetMainMemCacheConfig: IMainMemCacheConfig;
    function GetGPSConfig: IGpsConfig;
    function GetMarksFactoryConfig: IMarkFactoryConfig;
    function GetMarksGUIConfig: IMarksGUIConfig;
    function GetMarksCategoryFactoryConfig: IMarkCategoryFactoryConfig;
    function GetViewConfig: IGlobalViewMainConfig;
    function GetDownloadConfig: IGlobalDownloadConfig;
    function GetDownloaderThreadConfig: IThreadConfig;
    function GetStartUpLogoConfig: IStartUpLogoConfig;
    function GetTerrainConfig: ITerrainConfig;
    function GetPathDetalizeConfig: IPathDetalizeConfig;
    function GetZmpConfig: IZmpConfig;
    function GetExportToIMGConfig: IExportToIMGConfig;
    function GetElevationProfileConfig: IElevationProfileConfig;
  public
    constructor Create(
      const AInternalDebugConfig: IInternalDebugConfig;
      const AAppearanceOfMarkFactory: IAppearanceOfMarkFactory;
      const ABaseCachePath: IPathConfig;
      const ABaseConfigPath: IPathConfig;
      const ABaseDataPath: IPathConfig;
      const ABaseApplicationPath: IPathConfig
    );
  end;

implementation

uses
  SysUtils,
  Classes,
  c_ImageResampler,
  u_ConfigSaveLoadStrategyBasicProviderSubItem,
  u_ConfigSaveLoadStrategyBasicUseProvider,
  u_LanguageManager,
  u_GeoCoderConfig,
  u_InetConfig,
  u_WindowPositionConfig,
  u_ThreadConfig,
  u_ImageResamplerConfig,
  u_CoordRepresentationConfig,
  u_ValueToStringConverterConfig,
  u_MainMemCacheConfig,
  u_GPSConfig,
  u_GlobalViewMainConfig,
  u_GlobalDownloadConfig,
  u_TerrainConfig,
  u_PathDetalizeConfig,
  u_ZmpConfig,
  u_StartUpLogoConfig,
  u_BitmapPostProcessingConfig,
  u_MarkFactoryConfig,
  u_MarksGUIConfig,
  u_MarkCategoryFactoryConfig,
  u_MarkPictureConfig,
  u_GlobalAppConfig,
  u_PathConfig,
  u_InternalDomainUrlHandlerConfig,
  u_ExportMarks2KMLConfig,
  u_ExportToIMGConfig,
  u_ElevationProfileConfig;

{ TGlobalConfig }

constructor TGlobalConfig.Create(
  const AInternalDebugConfig: IInternalDebugConfig;
  const AAppearanceOfMarkFactory: IAppearanceOfMarkFactory;
  const ABaseCachePath: IPathConfig;
  const ABaseConfigPath: IPathConfig;
  const ABaseDataPath: IPathConfig;
  const ABaseApplicationPath: IPathConfig
);
begin
  inherited Create;
  FBaseConfigPath := ABaseConfigPath;

  FBaseCachePath := ABaseCachePath;
  Add(FBaseCachePath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToCache'), False, False, False, False);

  FLogsPath := TPathConfig.Create('PrimaryPath', '.\Logs', ABaseDataPath);
  Add(FLogsPath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToLogs'), False, False, False, False);

  FMapsPath := TPathConfig.Create('PrimaryPath', '.\Maps', ABaseConfigPath);
  Add(FMapsPath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PATHtoMAPS'), False, False, False, False);

  FMapSvcScanPath := TPathConfig.Create('PrimaryPath', '.\MapSvcScan', ABaseDataPath);
  Add(FMapSvcScanPath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PATHtoMapSvcScan'), False, False, False, False);

  FTrackPath := TPathConfig.Create('PrimaryPath', '.\TrackLog', ABaseDataPath);
  Add(FTrackPath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PATHtoTRACKS'), False, False, False, False);

  FMarksDbPath := TPathConfig.Create('PrimaryPath', '.', ABaseDataPath);
  Add(FMarksDbPath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PATHtoMARKS'), False, False, False, False);

  FMarksIconsPath := TPathConfig.Create('PrimaryPath', '.\MarksIcons', ABaseApplicationPath);
  Add(FMarksIconsPath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathToMarksIcons'), False, False, False, False);

  FMarkPictureConfig := TMarkPictureConfig.Create(FMarksIconsPath);
  Add(FMarkPictureConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('MarkPictureConfig'), False, False, False, False);

  FMediaDataPath := TPathConfig.Create('PrimaryPath', '.\MediaData', ABaseDataPath);
  Add(FMediaDataPath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PATHtoMediaData'), False, False, False, False);

  FTerrainDataPath := TPathConfig.Create('PrimaryPath', '.\TerrainData', ABaseDataPath);
  Add(FTerrainDataPath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PATHtoTerrainData'), False, False, False, False);

  FUserDataPath := TPathConfig.Create('PrimaryPath', '.\UserData', ABaseDataPath);
  Add(FUserDataPath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PATHtoUserData'), False, False, False, False);

  FUpdatesPath := TPathConfig.Create('PrimaryPath', '.\Updates', ABaseDataPath);
  Add(FUpdatesPath, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PATHtoUpdates'), False, False, False, False);

  FLastSelectionFileName := TPathConfig.Create('FileName', '.\LastSelection.hlg', ABaseDataPath);
  Add(FLastSelectionFileName, TConfigSaveLoadStrategyBasicProviderSubItem.Create('LastSelection'), False, False, False, False);

  FGpsRecorderFileName := TPathConfig.Create('InfoFileName', '.\GpsInfo.ini', ABaseDataPath);
  Add(FGpsRecorderFileName, TConfigSaveLoadStrategyBasicProviderSubItem.Create('GpsData'), False, False, False, False);

  FGpsTrackRecorderFileName := TPathConfig.Create('TrackFileName', '.\LastPoints.dat', ABaseDataPath);
  Add(FGpsTrackRecorderFileName, TConfigSaveLoadStrategyBasicProviderSubItem.Create('GpsData'), False, False, False, False);

  FInternalDebugConfig := AInternalDebugConfig;

  FGlobalAppConfig := TGlobalAppConfig.Create;
  Add(FGlobalAppConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('VIEW'), False, False, False, False);

  FLanguageManager := TLanguageManager.Create(IncludeTrailingPathDelimiter(ABaseApplicationPath.FullPath) + 'lang');
  Add(FLanguageManager, TConfigSaveLoadStrategyBasicProviderSubItem.Create('View'), False, False, False, False);

  FInetConfig := TInetConfig.Create;
  Add(FInetConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('Internet'), False, False, False, False);

  FInternalBrowserConfig := TWindowPositionConfig.Create;
  Add(FInternalBrowserConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('InternalBrowser'), False, False, False, False);

  FMainThreadConfig := TThreadConfig.Create(tpHigher);
  Add(FMainThreadConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('View'), False, False, False, False);

  FTileLoadResamplerConfig := TImageResamplerConfig.Create(CResamplerLinearGUID);
  Add(FTileLoadResamplerConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('Maps_Load'), False, False, False, False);

  FTileGetPrevResamplerConfig := TImageResamplerConfig.Create(CResamplerLinearGUID);
  Add(FTileGetPrevResamplerConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('Maps_GetPrev'), False, False, False, False);

  FTileReprojectResamplerConfig := TImageResamplerConfig.Create(CResamplerLinearGUID);
  Add(FTileReprojectResamplerConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('Maps_Reproject'), False, False, False, False);

  FTileDownloadResamplerConfig := TImageResamplerConfig.Create(CResamplerLinearGUID);
  Add(FTileDownloadResamplerConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('Maps_Download'), False, False, False, False);

  FCoordRepresentationConfig := TCoordRepresentationConfig.Create;
  Add(FCoordRepresentationConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('CoordFormats'), False, False, False, False);

  FValueToStringConverterConfig := TValueToStringConverterConfig.Create;
  Add(FValueToStringConverterConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('ValueFormats'), False, False, False, False);

  FImageResamplerConfig := TImageResamplerConfig.Create(CResamplerLinearGUID);
  Add(FImageResamplerConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('View'), False, False, False, False);

  FTileMatrixDraftResamplerConfig := TImageResamplerConfig.Create(CResamplerNearestGUID);
  Add(FTileMatrixDraftResamplerConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('View_TilesDrafts'), False, False, False, False);

  FMainMemCacheConfig := TMainMemCacheConfig.Create;
  Add(FMainMemCacheConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('View'), False, False, False, False);

  FGPSConfig := TGPSConfig.Create(FTrackPath);
  Add(FGPSConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('GPS'), False, False, False, False);

  FViewConfig := TGlobalViewMainConfig.Create;
  Add(FViewConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('View'), False, False, False, False);

  FDownloadConfig := TGlobalDownloadConfig.Create;
  Add(FDownloadConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('Internet'), False, False, False, False);

  FDownloaderThreadConfig := TThreadConfig.Create(tpLower);
  Add(FDownloaderThreadConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('Internet'), False, False, False, False);

  FTerrainConfig := TTerrainConfig.Create;
  Add(FTerrainConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('Terrain'), False, False, False, False);

  FPathDetalizeConfig := TPathDetalizeConfig.Create;
  Add(FPathDetalizeConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('PathDetalize'), False, False, False, False);

  FZmpConfig := TZmpConfig.Create;
  Add(FZmpConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('ZmpDefaultParams'), False, False, False, False);

  FStartUpLogoConfig := TStartUpLogoConfig.Create;
  Add(FStartUpLogoConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('StartUpLogo'), False, False, False, False);

  FBitmapPostProcessingConfig := TBitmapPostProcessingConfig.Create;
  Add(FBitmapPostProcessingConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('COLOR_LEVELS'), False, False, False, False);

  FMarksFactoryConfig := TMarkFactoryConfig.Create(AAppearanceOfMarkFactory, FLanguageManager);
  Add(FMarksFactoryConfig, TConfigSaveLoadStrategyBasicUseProvider.Create, False, False, False, False);

  FMarksCategoryFactoryConfig := TMarkCategoryFactoryConfig.Create(FLanguageManager);
  Add(FMarksCategoryFactoryConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('MarkNewCategory'), False, False, False, False);

  FMarksGUIConfig := TMarksGUIConfig.Create;
  Add(FMarksGUIConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('MarksGUI'), False, False, False, False);

  FExportToIMGConfig := TExportToIMGConfig.Create;
  Add(FExportToIMGConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('ExportToIMG'), False, False, False, False);

  FExportMarks2KMLConfig := TExportMarks2KMLConfig.Create;
  Add(FExportMarks2KMLConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('ExportMarks2KML'), False, False, False, False);

  FInternalDomainUrlHandlerConfig := TInternalDomainUrlHandlerConfig.Create;
  Add(FInternalDomainUrlHandlerConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('UrlHandler'), False, False, False, False);

  FGeoCoderConfig := TGeoCoderConfig.Create(FUserDataPath);
  Add(FGeoCoderConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('GeoCoder'), False, False, False, False);

  FElevationProfileConfig := TElevationProfileConfig.Create;
  Add(FElevationProfileConfig, TConfigSaveLoadStrategyBasicProviderSubItem.Create('ElevationProfile'), False, False, False, False);
end;

function TGlobalConfig.GetBaseCachePath: IPathConfig;
begin
  Result := FBaseCachePath;
end;

function TGlobalConfig.GetBaseConfigPath: IPathConfig;
begin
  Result := FBaseConfigPath;
end;

function TGlobalConfig.GetLogsPath: IPathConfig;
begin
  Result := FLogsPath;
end;

function TGlobalConfig.GetBitmapPostProcessingConfig: IBitmapPostProcessingConfig;
begin
  Result := FBitmapPostProcessingConfig;
end;

function TGlobalConfig.GetDownloadConfig: IGlobalDownloadConfig;
begin
  Result := FDownloadConfig;
end;

function TGlobalConfig.GetDownloaderThreadConfig: IThreadConfig;
begin
  Result := FDownloaderThreadConfig;
end;

function TGlobalConfig.GetElevationProfileConfig: IElevationProfileConfig;
begin
  Result := FElevationProfileConfig;
end;

function TGlobalConfig.GetExportMarks2KMLConfig: IExportMarks2KMLConfig;
begin
  Result := FExportMarks2KMLConfig;
end;

function TGlobalConfig.GetExportToIMGConfig: IExportToIMGConfig;
begin
  Result := FExportToIMGConfig;
end;

function TGlobalConfig.GetGeoCoderConfig: IGeoCoderConfig;
begin
  Result := FGeoCoderConfig;
end;

function TGlobalConfig.GetGlobalAppConfig: IGlobalAppConfig;
begin
  Result := FGlobalAppConfig;
end;

function TGlobalConfig.GetGPSConfig: IGpsConfig;
begin
  Result := FGPSConfig;
end;

function TGlobalConfig.GetGpsRecorderFileName: IPathConfig;
begin
  Result := FGpsRecorderFileName;
end;

function TGlobalConfig.GetGpsTrackRecorderFileName: IPathConfig;
begin
  Result := FGpsTrackRecorderFileName;
end;

function TGlobalConfig.GetImageResamplerConfig: IImageResamplerConfig;
begin
  Result := FImageResamplerConfig;
end;

function TGlobalConfig.GetInetConfig: IInetConfig;
begin
  Result := FInetConfig;
end;

function TGlobalConfig.GetInternalBrowserConfig: IWindowPositionConfig;
begin
  Result := FInternalBrowserConfig;
end;

function TGlobalConfig.GetInternalDebugConfig: IInternalDebugConfig;
begin
  Result := FInternalDebugConfig;
end;

function TGlobalConfig.GetInternalDomainUrlHandlerConfig: IInternalDomainUrlHandlerConfig;
begin
  Result := FInternalDomainUrlHandlerConfig;
end;

function TGlobalConfig.GetLanguageManager: ILanguageManager;
begin
  Result := FLanguageManager;
end;

function TGlobalConfig.GetLastSelectionFileName: IPathConfig;
begin
  Result := FLastSelectionFileName;
end;

function TGlobalConfig.GetMainMemCacheConfig: IMainMemCacheConfig;
begin
  Result := FMainMemCacheConfig;
end;

function TGlobalConfig.GetMainThreadConfig: IThreadConfig;
begin
  Result := FMainThreadConfig;
end;

function TGlobalConfig.GetMapsPath: IPathConfig;
begin
  Result := FMapsPath;
end;

function TGlobalConfig.GetMarkPictureConfig: IMarkPictureConfig;
begin
  Result := FMarkPictureConfig;
end;

function TGlobalConfig.GetMarksCategoryFactoryConfig: IMarkCategoryFactoryConfig;
begin
  Result := FMarksCategoryFactoryConfig;
end;

function TGlobalConfig.GetMarksDbPath: IPathConfig;
begin
  Result := FMarksDbPath;
end;

function TGlobalConfig.GetMarksFactoryConfig: IMarkFactoryConfig;
begin
  Result := FMarksFactoryConfig;
end;

function TGlobalConfig.GetMarksGUIConfig: IMarksGUIConfig;
begin
  Result := FMarksGUIConfig;
end;

function TGlobalConfig.GetMarksIconsPath: IPathConfig;
begin
  Result := FMarksIconsPath;
end;

function TGlobalConfig.GetMediaDataPath: IPathConfig;
begin
  Result := FMediaDataPath;
end;

function TGlobalConfig.GetStartUpLogoConfig: IStartUpLogoConfig;
begin
  Result := FStartUpLogoConfig;
end;

function TGlobalConfig.GetPathDetalizeConfig: IPathDetalizeConfig;
begin
  Result := FPathDetalizeConfig;
end;

function TGlobalConfig.GetTerrainConfig: ITerrainConfig;
begin
  Result := FTerrainConfig;
end;

function TGlobalConfig.GetTerrainDataPath: IPathConfig;
begin
  Result := FTerrainDataPath;
end;

function TGlobalConfig.GetUpdatesPath: IPathConfig;
begin
  Result := FUpdatesPath;
end;

function TGlobalConfig.GetUserDataPath: IPathConfig;
begin
  Result := FUserDataPath;
end;

function TGlobalConfig.GetTileDownloadResamplerConfig: IImageResamplerConfig;
begin
  Result := FTileDownloadResamplerConfig;
end;

function TGlobalConfig.GetTileGetPrevResamplerConfig: IImageResamplerConfig;
begin
  Result := FTileGetPrevResamplerConfig;
end;

function TGlobalConfig.GetTileLoadResamplerConfig: IImageResamplerConfig;
begin
  Result := FTileLoadResamplerConfig;
end;

function TGlobalConfig.GetTileMatrixDraftResamplerConfig: IImageResamplerConfig;
begin
  Result := FTileMatrixDraftResamplerConfig;
end;

function TGlobalConfig.GetTileReprojectResamplerConfig: IImageResamplerConfig;
begin
  Result := FTileReprojectResamplerConfig;
end;

function TGlobalConfig.GetTrackPath: IPathConfig;
begin
  Result := FTrackPath;
end;

function TGlobalConfig.GetCoordRepresentationConfig: ICoordRepresentationConfig;
begin
  Result := FCoordRepresentationConfig;
end;

function TGlobalConfig.GetValueToStringConverterConfig: IValueToStringConverterConfig;
begin
  Result := FValueToStringConverterConfig;
end;

function TGlobalConfig.GetViewConfig: IGlobalViewMainConfig;
begin
  Result := FViewConfig;
end;

function TGlobalConfig.GetZmpConfig: IZmpConfig;
begin
  Result := FZmpConfig;
end;

end.
