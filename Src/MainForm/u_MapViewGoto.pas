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

unit u_MapViewGoto;

interface

uses
  Types,
  t_GeoTypes,
  i_Notifier,
  i_ViewPortState,
  i_Projection,
  i_ProjectionSet,
  i_ProjectionSetChangeable,
  i_MapViewGoto,
  u_BaseInterfacedObject;

type
  TGotoPosStatic = class(TBaseInterfacedObject, IGotoPosStatic)
  private
    FLonLat: TDoublePoint;
    FProjection: IProjection;
    FGotoTime: TDateTime;
  private
    function GetLonLat: TDoublePoint;
    function GetProjection: IProjection;
    function GetGotoTime: TDateTime;
  public
    constructor Create(
      const ALonLat: TDoublePoint;
      const AProjection: IProjection;
      const AGotoTime: TDateTime
    );
  end;

  TMapViewGoto = class(TBaseInterfacedObject, IMapViewGoto)
  private
    FViewPortState: IViewPortState;
    FProjectionSet: IProjectionSetChangeable;
    FLastGotoPos: IGotoPosStatic;
    FChangeNotifier: INotifierInternal;
  private
    { IMapViewGoto }
    procedure GotoLonLat(
      const ALonLat: TDoublePoint;
      const AShowMarker: Boolean
    );
    procedure GotoPos(
      const ALonLat: TDoublePoint;
      const AProjection: IProjection;
      const AShowMarker: Boolean
    );
    procedure FitRectToScreen(
      const ALonLatRect: TDoubleRect
    );
    procedure ShowMarker(
      const ALonLat: TDoublePoint
    );
    procedure HideMarker;

    function GetLastGotoPos: IGotoPosStatic;
    function GetChangeNotifier: INotifier;
  public
    constructor Create(
      const AProjectionSet: IProjectionSetChangeable;
      const AViewPortState: IViewPortState
    );
  end;

implementation

uses
  Math,
  SysUtils,
  i_LocalCoordConverter,
  u_Notifier,
  u_Synchronizer,
  u_GeoFunc;

{ TMapViewGoto }

constructor TMapViewGoto.Create(
  const AProjectionSet: IProjectionSetChangeable;
  const AViewPortState: IViewPortState
);
begin
  Assert(Assigned(AProjectionSet));
  Assert(Assigned(AViewPortState));
  inherited Create;
  FViewPortState := AViewPortState;
  FProjectionSet := AProjectionSet;
  FChangeNotifier :=
    TNotifierBase.Create(
      GSync.SyncVariable.Make(Self.ClassName + 'Notifier')
    );
  FLastGotoPos := TGotoPosStatic.Create(CEmptyDoublePoint, nil, NaN);
end;

procedure TMapViewGoto.FitRectToScreen(const ALonLatRect: TDoubleRect);
var
  VCenterLonLat: TDoublePoint;
  VLLRect: TDoubleRect;
  VProjectionSet: IProjectionSet;
  VScreenSize: TDoublePoint;
  VRelativeRect: TDoubleRect;
  VZoom: Byte;
  VMarkMapRect: TDoubleRect;
  VMarkMapSize: TDoublePoint;
  VLocalConverter: ILocalCoordConverter;
  VProjection: IProjection;
  VProjectionPrev: IProjection;
begin
  if PointIsEmpty(ALonLatRect.TopLeft) or PointIsEmpty(ALonLatRect.BottomRight) then begin
    Exit;
  end;
  if DoublePointsEqual(ALonLatRect.TopLeft, ALonLatRect.BottomRight) then begin
    GotoLonLat(ALonLatRect.TopLeft, False);
    Exit;
  end;
  VCenterLonLat.X := (ALonLatRect.Left + ALonLatRect.Right) / 2;
  VCenterLonLat.Y := (ALonLatRect.Top + ALonLatRect.Bottom) / 2;
  VLLRect := ALonLatRect;
  VProjectionSet := FProjectionSet.GetStatic;
  VProjectionPrev := VProjectionSet.Zooms[0];

  VLocalConverter := FViewPortState.View.GetStatic;
  VScreenSize := RectSize(VLocalConverter.GetRectInMapPixelFloat);

  VProjectionPrev.ProjectionType.ValidateLonLatRect(VLLRect);
  VRelativeRect := VProjectionPrev.ProjectionType.LonLatRect2RelativeRect(VLLRect);

  for VZoom := 1 to VProjectionSet.ZoomCount - 1 do begin
    VProjection := VProjectionSet.Zooms[VZoom];
    VMarkMapRect := VProjection.RelativeRect2PixelRectFloat(VRelativeRect);
    VMarkMapSize := RectSize(VMarkMapRect);
    if (VMarkMapSize.X > VScreenSize.X) or (VMarkMapSize.Y > VScreenSize.Y) then begin
      Break;
    end;
    VProjectionPrev := VProjection;
  end;
  VProjectionPrev.ProjectionType.ValidateLonLatPos(VCenterLonLat);
  FViewPortState.ChangeLonLatAndZoom(VProjectionPrev.Zoom, VCenterLonLat);
end;

procedure TMapViewGoto.ShowMarker(const ALonLat: TDoublePoint);
begin
  FLastGotoPos := TGotoPosStatic.Create(ALonLat, FViewPortState.View.GetStatic.Projection, Now);
  FChangeNotifier.Notify(nil);
end;

function TMapViewGoto.GetChangeNotifier: INotifier;
begin
  Result := FChangeNotifier;
end;

function TMapViewGoto.GetLastGotoPos: IGotoPosStatic;
begin
  Result := FLastGotoPos;
end;

procedure TMapViewGoto.GotoLonLat(
  const ALonLat: TDoublePoint;
  const AShowMarker: Boolean
);
begin
  FLastGotoPos := TGotoPosStatic.Create(ALonLat, FViewPortState.View.GetStatic.Projection, Now);
  FViewPortState.ChangeLonLat(ALonLat);
  if AShowMarker then begin
    FChangeNotifier.Notify(nil);
  end;
end;

procedure TMapViewGoto.GotoPos(
  const ALonLat: TDoublePoint;
  const AProjection: IProjection;
  const AShowMarker: Boolean
);
begin
  FLastGotoPos := TGotoPosStatic.Create(ALonLat, AProjection, Now);
  FViewPortState.ChangeLonLatAndZoom(AProjection.Zoom, ALonLat);
  if AShowMarker then begin
    FChangeNotifier.Notify(nil);
  end;
end;

procedure TMapViewGoto.HideMarker;
begin
  FLastGotoPos := nil;
  FChangeNotifier.Notify(nil);
end;

{ TGotoPosStatic }

constructor TGotoPosStatic.Create(
  const ALonLat: TDoublePoint;
  const AProjection: IProjection;
  const AGotoTime: TDateTime
);
begin
  inherited Create;
  FLonLat := ALonLat;
  FProjection := AProjection;
  FGotoTime := AGotoTime;
end;

function TGotoPosStatic.GetGotoTime: TDateTime;
begin
  Result := FGotoTime;
end;

function TGotoPosStatic.GetLonLat: TDoublePoint;
begin
  Result := FLonLat;
end;

function TGotoPosStatic.GetProjection: IProjection;
begin
  Result := FProjection;
end;

end.
