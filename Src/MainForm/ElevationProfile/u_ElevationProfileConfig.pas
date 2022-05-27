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

unit u_ElevationProfileConfig;

interface

uses
  i_ElevationProfileConfig,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  u_ConfigDataElementBase;

type
  TElevationProfileConfig = class(TConfigDataElementBase, IElevationProfileConfig)
  private
    FShowElevation: Boolean;
    FShowSpeed: Boolean;
    FKeepAspectRatio: Boolean;
    FZoomWithMouseWheel: Boolean;
    FUseDataFiltering: Boolean;
    FCenterMap: Boolean;
  private
    { IElevationProfileConfig }
    function GetShowElevation: Boolean;
    procedure SetShowElevation(const AValue: Boolean);

    function GetShowSpeed: Boolean;
    procedure SetShowSpeed(const AValue: Boolean);

    function GetKeepAspectRatio: Boolean;
    procedure SetKeepAspectRatio(const AValue: Boolean);

    function GetZoomWithMouseWheel: Boolean;
    procedure SetZoomWithMouseWheel(const AValue: Boolean);

    function GetUseDataFiltering: Boolean;
    procedure SetUseDataFiltering(const AValue: Boolean);

    function GetCenterMap: Boolean;
    procedure SetCenterMap(const AValue: Boolean);

    function GetStatic: IElevationProfileConfigStatic;
  protected
    procedure DoReadConfig(const AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(const AConfigData: IConfigDataWriteProvider); override;
  public
    constructor Create;
  end;


implementation

uses
  u_BaseInterfacedObject;

type
  TElevationProfileConfigStatic = class(TBaseInterfacedObject, IElevationProfileConfigStatic)
  private
    FShowElevation: Boolean;
    FShowSpeed: Boolean;
    FKeepAspectRatio: Boolean;
    FZoomWithMouseWheel: Boolean;
    FUseDataFiltering: Boolean;
    FCenterMap: Boolean;
  private
    { IElevationProfileConfigStatic }
    function GetShowElevation: Boolean;
    function GetShowSpeed: Boolean;
    function GetKeepAspectRatio: Boolean;
    function GetZoomWithMouseWheel: Boolean;
    function GetUseDataFiltering: Boolean;
    function GetCenterMap: Boolean;
  public
    constructor Create(
      const AShowElevation: Boolean;
      const AShowSpeed: Boolean;
      const AKeepAspectRatio: Boolean;
      const AZoomWithMouseWheel: Boolean;
      const AUseDataFiltering: Boolean;
      const ACenterMap: Boolean
    );
  end;

{ TElevationProfileConfig }

constructor TElevationProfileConfig.Create;
begin
  inherited Create;

  FShowElevation := True;
  FShowSpeed := False;
  FKeepAspectRatio := False;
  FZoomWithMouseWheel := True;
  FUseDataFiltering := False;
  FCenterMap := True;
end;

procedure TElevationProfileConfig.DoReadConfig(const AConfigData: IConfigDataProvider);
begin
  inherited;

  if not Assigned(AConfigData) then begin
    Exit;
  end;

  LockWrite;
  try
    FShowElevation := AConfigData.ReadBool('ShowElevation', FShowElevation);
    FShowSpeed := AConfigData.ReadBool('ShowSpeed', FShowSpeed);
    FKeepAspectRatio := AConfigData.ReadBool('KeepAspectRatio', FKeepAspectRatio);
    FZoomWithMouseWheel := AConfigData.ReadBool('ZoomWithMouseWheel', FZoomWithMouseWheel);
    FUseDataFiltering := AConfigData.ReadBool('UseDataFiltering', FUseDataFiltering);
    FCenterMap := AConfigData.ReadBool('CenterMap', FCenterMap);

    SetChanged;
  finally
    UnlockWrite;
  end;
end;

procedure TElevationProfileConfig.DoWriteConfig(const AConfigData: IConfigDataWriteProvider);
begin
  inherited;

  LockRead;
  try
    AConfigData.WriteBool('ShowElevation', FShowElevation);
    AConfigData.WriteBool('ShowSpeed', FShowSpeed);
    AConfigData.WriteBool('KeepAspectRatio', FKeepAspectRatio);
    AConfigData.WriteBool('ZoomWithMouseWheel', FZoomWithMouseWheel);
    AConfigData.WriteBool('UseDataFiltering', FUseDataFiltering);
    AConfigData.WriteBool('CenterMap', FCenterMap);
  finally
    UnlockRead;
  end;
end;

function TElevationProfileConfig.GetCenterMap: Boolean;
begin
  LockRead;
  try
    Result := FCenterMap;
  finally
    UnlockRead;
  end;
end;

function TElevationProfileConfig.GetKeepAspectRatio: Boolean;
begin
  LockRead;
  try
    Result := FKeepAspectRatio;
  finally
    UnlockRead;
  end;
end;

function TElevationProfileConfig.GetShowElevation: Boolean;
begin
  LockRead;
  try
    Result := FShowElevation;
  finally
    UnlockRead;
  end;
end;

function TElevationProfileConfig.GetShowSpeed: Boolean;
begin
  LockRead;
  try
    Result := FShowSpeed;
  finally
    UnlockRead;
  end;
end;

function TElevationProfileConfig.GetUseDataFiltering: Boolean;
begin
  LockRead;
  try
    Result := FUseDataFiltering;
  finally
    UnlockRead;
  end;
end;

function TElevationProfileConfig.GetZoomWithMouseWheel: Boolean;
begin
  LockRead;
  try
    Result := FZoomWithMouseWheel;
  finally
    UnlockRead;
  end;
end;

procedure TElevationProfileConfig.SetCenterMap(const AValue: Boolean);
begin
  LockWrite;
  try
    if FCenterMap <> AValue then begin
      FCenterMap := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TElevationProfileConfig.SetKeepAspectRatio(const AValue: Boolean);
begin
  LockWrite;
  try
    if FKeepAspectRatio <> AValue then begin
      FKeepAspectRatio := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TElevationProfileConfig.SetShowElevation(const AValue: Boolean);
begin
  LockWrite;
  try
    if FShowElevation <> AValue then begin
      FShowElevation := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TElevationProfileConfig.SetShowSpeed(const AValue: Boolean);
begin
  LockWrite;
  try
    if FShowSpeed <> AValue then begin
      FShowSpeed := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TElevationProfileConfig.SetUseDataFiltering(const AValue: Boolean);
begin
  LockWrite;
  try
    if FUseDataFiltering <> AValue then begin
      FUseDataFiltering := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

procedure TElevationProfileConfig.SetZoomWithMouseWheel(const AValue: Boolean);
begin
  LockWrite;
  try
    if FZoomWithMouseWheel <> AValue then begin
      FZoomWithMouseWheel := AValue;
      SetChanged;
    end;
  finally
    UnlockWrite;
  end;
end;

function TElevationProfileConfig.GetStatic: IElevationProfileConfigStatic;
begin
  LockRead;
  try
    Result := TElevationProfileConfigStatic.Create(
      FShowElevation,
      FShowSpeed,
      FKeepAspectRatio,
      FZoomWithMouseWheel,
      FUseDataFiltering,
      FCenterMap
    );
  finally
    UnlockRead;
  end;
end;

{ TElevationProfileConfigStatic }

constructor TElevationProfileConfigStatic.Create(const AShowElevation, AShowSpeed, AKeepAspectRatio,
  AZoomWithMouseWheel, AUseDataFiltering, ACenterMap: Boolean);
begin
  inherited Create;

  FShowElevation := AShowElevation;
  FShowSpeed := AShowSpeed;
  FKeepAspectRatio := AKeepAspectRatio;
  FZoomWithMouseWheel := AZoomWithMouseWheel;
  FUseDataFiltering := AUseDataFiltering;
  FCenterMap := ACenterMap;
end;

function TElevationProfileConfigStatic.GetCenterMap: Boolean;
begin
  Result := FCenterMap;
end;

function TElevationProfileConfigStatic.GetKeepAspectRatio: Boolean;
begin
  Result := FKeepAspectRatio;
end;

function TElevationProfileConfigStatic.GetShowElevation: Boolean;
begin
  Result := FShowElevation;
end;

function TElevationProfileConfigStatic.GetShowSpeed: Boolean;
begin
  Result := FShowSpeed;
end;

function TElevationProfileConfigStatic.GetUseDataFiltering: Boolean;
begin
  Result := FUseDataFiltering;
end;

function TElevationProfileConfigStatic.GetZoomWithMouseWheel: Boolean;
begin
  Result := FZoomWithMouseWheel;
end;

end.
