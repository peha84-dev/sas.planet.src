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

unit u_GeometryFunc;

interface

uses
  GR32,
  GR32_Polygons,
  Types,
  t_GeoTypes,
  i_TileRect,
  i_GeometryLonLat,
  i_GeometryProjected,
  i_LocalCoordConverter,
  i_CoordToStringConverter,
  i_Projection;

function GetGeometryLonLatNearestPoint(
  const AGeometry: IGeometryLonLat;
  const AProjection: IProjection;
  const ACurrMapPixel: TDoublePoint;
  const AMaxDistInMapPixel: Double
): TDoublePoint;

function GetProjectedSinglePolygonByProjectedPolygon(
  const AGeometry: IGeometryProjectedPolygon
): IGeometryProjectedSinglePolygon;

procedure AppendArrayOfArrayOfFloatPoint(
  var APoints1: TArrayOfArrayOfFloatPoint;
  const APoints2: TArrayOfArrayOfFloatPoint
); overload;

procedure AppendArrayOfArrayOfFloatPoint(
  var APoints1: TArrayOfArrayOfFloatPoint;
  const APoints2: TArrayOfFloatPoint
); overload;

function ProjectedLine2ArrayOfArray(
  const ALine: IGeometryProjectedLine;
  const AMapRect: TRect;
  var APointArray: TArrayOfFloatPoint
): TArrayOfArrayOfFloatPoint;

function ProjectedPolygon2ArrayOfArray(
  const ALine: IGeometryProjectedSinglePolygon;
  const AMapRect: TRect;
  var APointArray: TArrayOfFloatPoint
): TArrayOfArrayOfFloatPoint;

function IsValidLonLatLine(
  const AGeometry: IGeometryLonLatLine
): Boolean;

function IsValidLonLatPolygon(
  const AGeometry: IGeometryLonLatPolygon
): Boolean;

function CalcTileCountInProjectedPolygon(
  const AProjection: IProjection;
  const AGeometry: IGeometryProjectedPolygon
): Int64;

function CalcTileCountInProjectedSinglePolygon(
  const AProjection: IProjection;
  const AGeometry: IGeometryProjectedSinglePolygon
): Int64;

function IsProjectedPolygonSimpleRect(
  const APolygon: IGeometryProjectedPolygon
): Boolean;

function TryProjectedPolygonToTileRect(
  const AProjection: IProjection;
  const APolygon: IGeometryProjectedPolygon
): ITileRect;

procedure SplitProjectedPolygon(
  const AProjection: IProjection;
  const AGeometry: IGeometryProjectedPolygon;
  const ASplitCount: Integer;
  const ATilesCountInPolygon: Int64;
  out AStartPoints: TArrayOfPoint;
  out ATilesCount: TIntegerDynArray
);

function GeometryLonLatToPlainText(
  const AGeometry: IGeometryLonLat;
  const ACoordToStringConverter: ICoordToStringConverter;
  const APointSeparator: string;
  const AContourSeparator: string;
  const AMultiGeometrySeparator: string
): string;

function GeometryLonLatPointToPlainText(
  const AGeometry: IGeometryLonLatPoint;
  const ACoordToStringConverter: ICoordToStringConverter
): string;

function GeometryLonLatSingleLineToPlainText(
  const AGeometry: IGeometryLonLatSingleLine;
  const ACoordToStringConverter: ICoordToStringConverter;
  const APointSeparator: string
): string;

function GeometryLonLatLineToPlainText(
  const AGeometry: IGeometryLonLatLine;
  const ACoordToStringConverter: ICoordToStringConverter;
  const APointSeparator: string;
  const AMultiGeometrySeparator: string
): string;

function GeometryLonLatContourToPlainText(
  const AGeometry: IGeometryLonLatContour;
  const ACoordToStringConverter: ICoordToStringConverter;
  const APointSeparator: string
): string;

function GeometryLonLatSinglePolygonToPlainText(
  const AGeometry: IGeometryLonLatSinglePolygon;
  const ACoordToStringConverter: ICoordToStringConverter;
  const APointSeparator: string;
  const AContourSeparator: string
): string;

function GeometryLonLatPolygonToPlainText(
  const AGeometry: IGeometryLonLatPolygon;
  const ACoordToStringConverter: ICoordToStringConverter;
  const APointSeparator: string;
  const AContourSeparator: string;
  const AMultiGeometrySeparator: string
): string;

function GeometryLonLatLineToArray(
  const AGeometry: IGeometryLonLatLine
): TArrayOfGeometryLonLatSingleLine;

implementation

uses
  Math,
  SysUtils,
  i_TileIterator,
  i_ProjectionType,
  i_EnumDoublePoint,
  u_EnumDoublePointClosePoly,
  u_EnumDoublePointMapPixelToLocalPixel,
  u_EnumDoublePointWithClip,
  u_EnumDoublePointFilterEqual,
  u_TileRect,
  u_TileIteratorByRect,
  u_TileIteratorByPolygon,
  u_GeoFunc;

function GetGeometryLonLatPointNearestPoint(
  const AGeometry: IGeometryLonLatPoint;
  const AProjection: IProjection;
  const ACurrMapPixel: TDoublePoint;
  out APoint: TDoublePoint;
  out ADist: Double
): Boolean;
var
  VLonLatPoint: TDoublePoint;
  VMapPoint: TDoublePoint;
  VDist: Double;
begin
  Result := False;
  APoint := CEmptyDoublePoint;
  ADist := NaN;
  VLonLatPoint := AGeometry.Point;
  if not PointIsEmpty(VLonLatPoint) then begin
    AProjection.ProjectionType.ValidateLonLatPos(VLonLatPoint);
    VMapPoint := AProjection.LonLat2PixelPosFloat(VLonLatPoint);
    VDist := Sqr(VMapPoint.X - ACurrMapPixel.X) + Sqr(VMapPoint.Y - ACurrMapPixel.Y);
    Result := True;
    APoint := VLonLatPoint;
    ADist := VDist;
  end;
end;

function GetGeometryLonLatLineNearestPoint(
  const AGeometry: IGeometryLonLatSingleLine;
  const AProjection: IProjection;
  const ACurrMapPixel: TDoublePoint;
  out APoint: TDoublePoint;
  out ADist: Double
): Boolean;
var
  VProjectionType: IProjectionType;
  VEnum: IEnumLonLatPoint;
  VLonLatPoint: TDoublePoint;
  VMapPoint: TDoublePoint;
  VDist: Double;
begin
  Result := False;
  APoint := CEmptyDoublePoint;
  ADist := NaN;
  VProjectionType := AProjection.ProjectionType;
  VEnum := AGeometry.GetEnum;
  if VEnum.Next(VLonLatPoint) then begin
    VProjectionType.ValidateLonLatPos(VLonLatPoint);
    VMapPoint := AProjection.LonLat2PixelPosFloat(VLonLatPoint);
    VDist := Sqr(VMapPoint.X - ACurrMapPixel.X) + Sqr(VMapPoint.Y - ACurrMapPixel.Y);
    APoint := VLonLatPoint;
    ADist := VDist;
    Result := True;

    while VEnum.Next(VLonLatPoint) do begin
      VProjectionType.ValidateLonLatPos(VLonLatPoint);
      VMapPoint := AProjection.LonLat2PixelPosFloat(VLonLatPoint);
      VDist := Sqr(VMapPoint.X - ACurrMapPixel.X) + Sqr(VMapPoint.Y - ACurrMapPixel.Y);
      if VDist < ADist then begin
        ADist := VDist;
        APoint := VLonLatPoint;
      end;
    end;
  end;
end;

function GetGeometryLonLatContourNearestPoint(
  const AGeometry: IGeometryLonLatContour;
  const AProjection: IProjection;
  const ACurrMapPixel: TDoublePoint;
  out APoint: TDoublePoint;
  out ADist: Double
): Boolean;
var
  VProjectionType: IProjectionType;
  VEnum: IEnumLonLatPoint;
  VLonLatPoint: TDoublePoint;
  VMapPoint: TDoublePoint;
  VDist: Double;
begin
  Result := False;
  APoint := CEmptyDoublePoint;
  ADist := NaN;
  VProjectionType := AProjection.ProjectionType;
  VEnum := AGeometry.GetEnum;
  if VEnum.Next(VLonLatPoint) then begin
    VProjectionType.ValidateLonLatPos(VLonLatPoint);
    VMapPoint := AProjection.LonLat2PixelPosFloat(VLonLatPoint);
    VDist := Sqr(VMapPoint.X - ACurrMapPixel.X) + Sqr(VMapPoint.Y - ACurrMapPixel.Y);
    APoint := VLonLatPoint;
    ADist := VDist;
    Result := True;

    while VEnum.Next(VLonLatPoint) do begin
      VProjectionType.ValidateLonLatPos(VLonLatPoint);
      VMapPoint := AProjection.LonLat2PixelPosFloat(VLonLatPoint);
      VDist := Sqr(VMapPoint.X - ACurrMapPixel.X) + Sqr(VMapPoint.Y - ACurrMapPixel.Y);
      if VDist < ADist then begin
        ADist := VDist;
        APoint := VLonLatPoint;
      end;
    end;
  end;
end;

function GetGeometryLonLatPolygonNearestPoint(
  const AGeometry: IGeometryLonLatSinglePolygon;
  const AProjection: IProjection;
  const ACurrMapPixel: TDoublePoint;
  out APoint: TDoublePoint;
  out ADist: Double
): Boolean;
var
  VLonLatPoint: TDoublePoint;
  VDist: Double;
  VResult: Boolean;
  i: Integer;
begin
  APoint := CEmptyDoublePoint;
  ADist := NaN;

  Result :=
    GetGeometryLonLatContourNearestPoint(
      AGeometry.OuterBorder,
      AProjection,
      ACurrMapPixel,
      APoint,
      ADist
    );
  for i := 0 to AGeometry.HoleCount - 1 do begin
    VResult :=
      GetGeometryLonLatContourNearestPoint(
        AGeometry.HoleBorder[i],
        AProjection,
        ACurrMapPixel,
        VLonLatPoint,
        VDist
      );
    if VResult then begin
      if Result then begin
        if ADist > VDist then begin
          ADist := VDist;
          APoint := VLonLatPoint;
        end;
      end else begin
        Result := True;
        ADist := VDist;
        APoint := VLonLatPoint;
      end;
    end;
  end;
end;

function GetGeometryLonLatMultiLineNearestPoint(
  const AGeometry: IGeometryLonLatMultiLine;
  const AProjection: IProjection;
  const ACurrMapPixel: TDoublePoint;
  out APoint: TDoublePoint;
  out ADist: Double
): Boolean;
var
  VLonLatPoint: TDoublePoint;
  VDist: Double;
  i: Integer;
begin
  Result := False;
  APoint := CEmptyDoublePoint;
  ADist := NaN;
  for i := 0 to AGeometry.Count - 1 do begin
    if GetGeometryLonLatLineNearestPoint(AGeometry.Item[i], AProjection, ACurrMapPixel, VLonLatPoint, VDist) then begin
      if Result then begin
        if VDist < ADist then begin
          APoint := VLonLatPoint;
          ADist := VDist;
        end;
      end else begin
        Result := True;
        APoint := VLonLatPoint;
        ADist := VDist;
      end;
    end;
  end;
end;

function GetGeometryLonLatMultiPolygonNearestPoint(
  const AGeometry: IGeometryLonLatMultiPolygon;
  const AProjection: IProjection;
  const ACurrMapPixel: TDoublePoint;
  out APoint: TDoublePoint;
  out ADist: Double
): Boolean;
var
  VLonLatPoint: TDoublePoint;
  VDist: Double;
  i: Integer;
begin
  Result := False;
  APoint := CEmptyDoublePoint;
  ADist := NaN;
  for i := 0 to AGeometry.Count - 1 do begin
    if GetGeometryLonLatPolygonNearestPoint(AGeometry.Item[i], AProjection, ACurrMapPixel, VLonLatPoint, VDist) then begin
      if Result then begin
        if VDist < ADist then begin
          APoint := VLonLatPoint;
          ADist := VDist;
        end;
      end else begin
        Result := True;
        APoint := VLonLatPoint;
        ADist := VDist;
      end;
    end;
  end;
end;

function GetGeometryLonLatNearestPoint(
  const AGeometry: IGeometryLonLat;
  const AProjection: IProjection;
  const ACurrMapPixel: TDoublePoint;
  const AMaxDistInMapPixel: Double
): TDoublePoint;
var
  VPoint: IGeometryLonLatPoint;
  VLine: IGeometryLonLatSingleLine;
  VPolygon: IGeometryLonLatSinglePolygon;
  VMultiLine: IGeometryLonLatMultiLine;
  VMultiPolygon: IGeometryLonLatMultiPolygon;
  VSqDist: Double;
  VDist: Double;
  VLonLatPoint: TDoublePoint;
begin
  VSqDist := Sqr(AMaxDistInMapPixel);
  Result := CEmptyDoublePoint;
  if Supports(AGeometry, IGeometryLonLatPoint, VPoint) then begin
    if GetGeometryLonLatPointNearestPoint(VPoint, AProjection, ACurrMapPixel, VLonLatPoint, VDist) then begin
      if VDist <= VSqDist then begin
        Result := VLonLatPoint;
      end;
    end;
  end else if Supports(AGeometry, IGeometryLonLatMultiLine, VMultiLine) then begin
    if GetGeometryLonLatMultiLineNearestPoint(VMultiLine, AProjection, ACurrMapPixel, VLonLatPoint, VDist) then begin
      if VDist <= VSqDist then begin
        Result := VLonLatPoint;
      end;
    end;
  end else if Supports(AGeometry, IGeometryLonLatMultiPolygon, VMultiPolygon) then begin
    if GetGeometryLonLatMultiPolygonNearestPoint(VMultiPolygon, AProjection, ACurrMapPixel, VLonLatPoint, VDist) then begin
      if VDist <= VSqDist then begin
        Result := VLonLatPoint;
      end;
    end;
  end else if Supports(AGeometry, IGeometryLonLatSingleLine, VLine) then begin
    if GetGeometryLonLatLineNearestPoint(VLine, AProjection, ACurrMapPixel, VLonLatPoint, VDist) then begin
      if VDist <= VSqDist then begin
        Result := VLonLatPoint;
      end;
    end;
  end else if Supports(AGeometry, IGeometryLonLatSinglePolygon, VPolygon) then begin
    if GetGeometryLonLatPolygonNearestPoint(VPolygon, AProjection, ACurrMapPixel, VLonLatPoint, VDist) then begin
      if VDist <= VSqDist then begin
        Result := VLonLatPoint;
      end;
    end;
  end else begin
    Assert(False);
  end;
end;

function GetProjectedSinglePolygonByProjectedPolygon(
  const AGeometry: IGeometryProjectedPolygon
): IGeometryProjectedSinglePolygon;
var
  VMulti: IGeometryProjectedMultiPolygon;
begin
  if not Supports(AGeometry, IGeometryProjectedSinglePolygon, Result) then begin
    if Supports(AGeometry, IGeometryProjectedMultiPolygon, VMulti) then begin
      Result := VMulti.Item[0];
    end else begin
      Result := nil;
    end;
  end;
end;

procedure AppendArrayOfArrayOfFloatPoint(
  var APoints1: TArrayOfArrayOfFloatPoint;
  const APoints2: TArrayOfArrayOfFloatPoint
); overload;
var
  i: Integer;
begin
  for i := 0 to Length(APoints2) - 1 do begin
    AppendArrayOfArrayOfFloatPoint(APoints1, APoints2[i]);
  end;
end;

procedure AppendArrayOfArrayOfFloatPoint(
  var APoints1: TArrayOfArrayOfFloatPoint;
  const APoints2: TArrayOfFloatPoint
); overload;
var
  VLen: Integer;
begin
  VLen := Length(APoints1);
  SetLength(APoints1, VLen +1);
  APoints1[VLen] := APoints2;
end;

function SingleLine2ArrayOfArray(
  const ALine: IGeometryProjectedSingleLine;
  const ARectWithDelta: TDoubleRect;
  const AMapRect: TDoubleRect;
  var APointArray: TArrayOfFloatPoint
): TArrayOfArrayOfFloatPoint;
var
  VEnum: IEnumLocalPoint;
  VPoint: TDoublePoint;
  VPointsProcessedCount: Integer;
  VIndex: Integer;
begin
  Result := nil;
  if IsIntersecProjectedRect(AMapRect, ALine.Bounds) then begin
    VEnum :=
      TEnumDoublePointMapPixelToLocalPixelSimple.Create(
        AMapRect.TopLeft,
        ALine.GetEnum
      );
    VEnum :=
      TEnumLocalPointClipByRect.Create(
        False,
        ARectWithDelta,
        VEnum
      );
    VEnum := TEnumLocalPointFilterEqual.Create(VEnum);
    VPointsProcessedCount := 0;
    while VEnum.Next(VPoint) do begin
      if PointIsEmpty(VPoint) then begin
        if VPointsProcessedCount > 0 then begin
          VIndex := Length(Result);
          SetLength(Result, VIndex + 1);
          SetLength(Result[VIndex], VPointsProcessedCount);
          Move(APointArray[0], Result[VIndex][0], VPointsProcessedCount * SizeOf(APointArray[0]));
        end;
      end else begin
        if VPointsProcessedCount + 1 >= Length(APointArray) then begin
          SetLength(APointArray, (VPointsProcessedCount + 1) * 2);
        end;
        APointArray[VPointsProcessedCount] := FloatPoint(VPoint.X, VPoint.Y);
        Inc(VPointsProcessedCount);
      end;
    end;
    if VPointsProcessedCount > 0 then begin
      VIndex := Length(Result);
      SetLength(Result, VIndex + 1);
      SetLength(Result[VIndex], VPointsProcessedCount);
      Move(APointArray[0], Result[VIndex][0], VPointsProcessedCount * SizeOf(APointArray[0]));
    end;
  end;
end;

function ProjectedLine2ArrayOfArray(
  const ALine: IGeometryProjectedLine;
  const AMapRect: TRect;
  var APointArray: TArrayOfFloatPoint
): TArrayOfArrayOfFloatPoint;
var
  VMapRect: TDoubleRect;
  VLocalRect: TDoubleRect;
  VRectWithDelta: TDoubleRect;
  VLineIndex: Integer;
  VSingleLine: IGeometryProjectedSingleLine;
  VMultiLine: IGeometryProjectedMultiLine;
  VLines: TArrayOfArrayOfFloatPoint;
begin
  if Assigned(ALine) then begin
    VMapRect := DoubleRect(AMapRect);
    if IsIntersecProjectedRect(VMapRect, ALine.Bounds) then begin
      VLocalRect := DoubleRect(0, 0, VMapRect.Right - VMapRect.Left, VMapRect.Bottom - VMapRect.Top);
      VRectWithDelta.Left := VLocalRect.Left - 10;
      VRectWithDelta.Top := VLocalRect.Top - 10;
      VRectWithDelta.Right := VLocalRect.Right + 10;
      VRectWithDelta.Bottom := VLocalRect.Bottom + 10;
      if Supports(ALine, IGeometryProjectedSingleLine, VSingleLine) then begin
        Result :=
          SingleLine2ArrayOfArray(
            VSingleLine,
            VRectWithDelta,
            VMapRect,
            APointArray
          );
      end else if Supports(ALine, IGeometryProjectedMultiLine, VMultiLine) then begin
        for VLineIndex := 0 to VMultiLine.Count - 1 do begin
          VSingleLine := VMultiLine.Item[VLineIndex];
          VLines :=
            SingleLine2ArrayOfArray(
              VSingleLine,
              VRectWithDelta,
              VMapRect,
              APointArray
            );
          AppendArrayOfArrayOfFloatPoint(Result, VLines);
        end;
      end;
    end;
  end;
end;

function SingleContour2ArrayOfArray(
  const ALine: IGeometryProjectedContour;
  const ARectWithDelta: TDoubleRect;
  const AMapRect: TDoubleRect;
  var APointArray: TArrayOfFloatPoint
): TArrayOfArrayOfFloatPoint; overload;
var
  VEnum: IEnumLocalPoint;
  VPoint: TDoublePoint;
  VPointsProcessedCount: Integer;
  VIndex: Integer;
begin
  Result := nil;
  if IsIntersecProjectedRect(AMapRect, ALine.Bounds) then begin
    VEnum :=
      TEnumDoublePointMapPixelToLocalPixelSimple.Create(
        AMapRect.TopLeft,
        ALine.GetEnum
      );
    VEnum :=
      TEnumLocalPointClipByRect.Create(
        True,
        ARectWithDelta,
        VEnum
      );
    VEnum := TEnumLocalPointFilterEqual.Create(VEnum);
    VEnum := TEnumLocalPointClosePoly.Create(VEnum);
    VPointsProcessedCount := 0;
    while VEnum.Next(VPoint) do begin
      if PointIsEmpty(VPoint) then begin
        if VPointsProcessedCount > 0 then begin
          VIndex := Length(Result);
          SetLength(Result, VIndex + 1);
          SetLength(Result[VIndex], VPointsProcessedCount);
          Move(APointArray[0], Result[VIndex][0], VPointsProcessedCount * SizeOf(APointArray[0]));
        end;
      end else begin
        if VPointsProcessedCount + 1 >= Length(APointArray) then begin
          SetLength(APointArray, (VPointsProcessedCount + 1) * 2);
        end;
        APointArray[VPointsProcessedCount] := FloatPoint(VPoint.X, VPoint.Y);
        Inc(VPointsProcessedCount);
      end;
    end;

    if VPointsProcessedCount > 0 then begin
      VIndex := Length(Result);
      SetLength(Result, VIndex + 1);
      SetLength(Result[VIndex], VPointsProcessedCount);
      Move(APointArray[0], Result[VIndex][0], VPointsProcessedCount * SizeOf(APointArray[0]));
    end;
  end;
end;

function ProjectedPolygon2ArrayOfArray(
  const ALine: IGeometryProjectedSinglePolygon;
  const AMapRect: TRect;
  var APointArray: TArrayOfFloatPoint
): TArrayOfArrayOfFloatPoint;
var
  VMapRect: TDoubleRect;
  VLocalRect: TDoubleRect;
  VRectWithDelta: TDoubleRect;
  VLineIndex: Integer;
  VLines: TArrayOfArrayOfFloatPoint;
begin
  if Assigned(ALine) then begin
    VMapRect := DoubleRect(AMapRect);
    if IsIntersecProjectedRect(VMapRect, ALine.Bounds) then begin
      VLocalRect := DoubleRect(0, 0, VMapRect.Right - VMapRect.Left, VMapRect.Bottom - VMapRect.Top);
      VRectWithDelta.Left := VLocalRect.Left - 10;
      VRectWithDelta.Top := VLocalRect.Top - 10;
      VRectWithDelta.Right := VLocalRect.Right + 10;
      VRectWithDelta.Bottom := VLocalRect.Bottom + 10;
      Result :=
        SingleContour2ArrayOfArray(
          ALine.OuterBorder,
          VRectWithDelta,
          VMapRect,
          APointArray
        );
      for VLineIndex := 0 to ALine.HoleCount - 1 do begin
        VLines :=
          SingleContour2ArrayOfArray(
            ALine.HoleBorder[VLineIndex],
            VRectWithDelta,
            VMapRect,
            APointArray
          );
        AppendArrayOfArrayOfFloatPoint(Result, VLines);
      end;
    end;
  end;
end;

function IsValidLonLatLine(
  const AGeometry: IGeometryLonLatLine
): Boolean;
var
  VSingleLine: IGeometryLonLatSingleLine;
  VMultiLine: IGeometryLonLatMultiLine;
begin
  Result := False;
  if Assigned(AGeometry) then begin
    if Supports(AGeometry, IGeometryLonLatSingleLine, VSingleLine) then begin
      Result := VSingleLine.Count > 1;
    end else if Supports(AGeometry, IGeometryLonLatMultiLine, VMultiLine) then begin
      Result := (VMultiLine.Count > 1) or ((VMultiLine.Count > 0) and (VMultiLine.Item[0].Count > 1));
    end;
  end;
end;

function IsValidLonLatContour(
  const AGeometry: IGeometryLonLatContour
): Boolean; inline;
begin
  Result := AGeometry.Count > 2;
end;

function IsValidLonLatSinglePolygon(
  const AGeometry: IGeometryLonLatSinglePolygon
): Boolean; inline;
begin
  Result := IsValidLonLatContour(AGeometry.OuterBorder);
end;

function IsValidLonLatMultiPolygon(
  const AGeometry: IGeometryLonLatMultiPolygon
): Boolean; inline;
begin
  Result := (AGeometry.Count > 1) or ((AGeometry.Count > 0) and IsValidLonLatSinglePolygon(AGeometry.Item[0]));
end;

function IsValidLonLatPolygon(
  const AGeometry: IGeometryLonLatPolygon
): Boolean;
var
  VSingleLine: IGeometryLonLatSinglePolygon;
  VMultiLine: IGeometryLonLatMultiPolygon;
begin
  Result := False;
  if Assigned(AGeometry) then begin
    if Supports(AGeometry, IGeometryLonLatSinglePolygon, VSingleLine) then begin
      Result := IsValidLonLatSinglePolygon(VSingleLine);
    end else if Supports(AGeometry, IGeometryLonLatMultiPolygon, VMultiLine) then begin
      Result := IsValidLonLatMultiPolygon(VMultiLine);
    end;
  end;
end;

function CalcTileCountInProjectedSinglePolygon(
  const AProjection: IProjection;
  const AGeometry: IGeometryProjectedSinglePolygon
): Int64;
  function CalcTileCountInProjectedSinglePolygonRecursive(
    const ATileRect: TRect
  ): Int64;
  var
    VPixelRect: TDoubleRect;
    VRectSize: TPoint;
    VIntersection: TRectWithPolygonIntersection;
    VTileRect1: TRect;
    VTileRect2: TRect;
  begin
    VRectSize := RectSize(ATileRect);
    VPixelRect := DoubleRect(AProjection.TileRect2PixelRect(ATileRect));
    VIntersection := AGeometry.CheckRectIntersection(VPixelRect);
    if VIntersection = rwpNoIntersect  then begin
      Result := 0;
      Exit;
    end;

    if VIntersection = rwpRectInPolygon  then begin
      Result := VRectSize.X * VRectSize.Y;
      Exit;
    end;

    if VRectSize.X > VRectSize.Y then begin
      if VRectSize.X <= 1 then begin
        Result := 1;
        Exit;
      end;
      VTileRect1 := ATileRect;
      VTileRect1.Right := ATileRect.Left + VRectSize.X div 2;
      VTileRect2 := ATileRect;
      VTileRect2.Left := VTileRect1.Right;
    end else begin
      if VRectSize.Y <= 1 then begin
        Result := 1;
        Exit;
      end;
      VTileRect1 := ATileRect;
      VTileRect1.Bottom := ATileRect.Top + VRectSize.Y div 2;
      VTileRect2 := ATileRect;
      VTileRect2.Top := VTileRect1.Bottom;
    end;
    Result :=
      CalcTileCountInProjectedSinglePolygonRecursive(VTileRect1) +
      CalcTileCountInProjectedSinglePolygonRecursive(VTileRect2);
  end;
var
  VRect: TRect;
  VTileRect: ITileRect;
begin
  VTileRect := TryProjectedPolygonToTileRect(AProjection, AGeometry);
  if VTileRect <> nil then begin
    Result := (VTileRect.Right - VTileRect.Left) * (VTileRect.Bottom - VTileRect.Top);
    Exit;
  end;

  VRect :=
    RectFromDoubleRect(
      AProjection.PixelRectFloat2TileRectFloat(AGeometry.Bounds),
      rrOutside
    );
  Result := CalcTileCountInProjectedSinglePolygonRecursive(VRect);
end;

function CalcTileCountInProjectedPolygon(
  const AProjection: IProjection;
  const AGeometry: IGeometryProjectedPolygon
): Int64;
var
  I: Integer;
  VCount: Int64;
  VSingle: IGeometryProjectedSinglePolygon;
  VMulti: IGeometryProjectedMultiPolygon;
begin
  Result := 0;
  if Assigned(AGeometry) then begin
    if Supports(AGeometry, IGeometryProjectedSinglePolygon, VSingle) then begin
      Result := CalcTileCountInProjectedSinglePolygon(AProjection, VSingle);
    end else if Supports(AGeometry, IGeometryProjectedMultiPolygon, VMulti) then begin
      for I := 0 to VMulti.Count - 1 do begin
        VCount := CalcTileCountInProjectedSinglePolygon(AProjection, VMulti.Item[I]);
        Inc(Result, VCount);
      end;
    end;
  end;
end;

function IsProjectedPolygonSimpleRect(
  const APolygon: IGeometryProjectedPolygon
): Boolean;
var
  I: Integer;
  VSingle: IGeometryProjectedSinglePolygon;
  VPoints: PDoublePointArray;
  VCornerPoints: array [0..3] of TPoint;
begin
  Result := False;

  if Supports(APolygon, IGeometryProjectedSinglePolygon, VSingle) then begin
    if (VSingle.OuterBorder.Count = 4) and (VSingle.HoleCount = 0) then begin

      VPoints := VSingle.OuterBorder.Points;

      for I := 0 to 3 do begin
        VCornerPoints[I] := PointFromDoublePoint(VPoints[I], prToTopLeft);
      end;

      Result :=
        (
          (VCornerPoints[0].X = VCornerPoints[3].X) and
          (VCornerPoints[2].X = VCornerPoints[1].X) and
          (VCornerPoints[0].Y = VCornerPoints[1].Y) and
          (VCornerPoints[2].Y = VCornerPoints[3].Y)
        ) or (
          (VCornerPoints[0].X = VCornerPoints[1].X) and
          (VCornerPoints[2].X = VCornerPoints[3].X) and
          (VCornerPoints[3].Y = VCornerPoints[0].Y) and
          (VCornerPoints[1].Y = VCornerPoints[2].Y)
        );
    end;
  end;
end;

function TryProjectedPolygonToTileRect(
  const AProjection: IProjection;
  const APolygon: IGeometryProjectedPolygon
): ITileRect;
var
  I: Integer;
  VIsRect: Boolean;
  VSingle: IGeometryProjectedSinglePolygon;
  VPoints: PDoublePointArray;
  VCornerTiles: array [0..3] of TPoint;
begin
  Result := nil;

  if Supports(APolygon, IGeometryProjectedSinglePolygon, VSingle) then begin
    if (VSingle.OuterBorder.Count = 4) and (VSingle.HoleCount = 0) then begin

      VPoints := VSingle.OuterBorder.Points;

      for I := 0 to 3 do begin
        VCornerTiles[I] :=
          PointFromDoublePoint(
            AProjection.PixelPosFloat2TilePosFloat(VPoints[I]),
            prToTopLeft
          );
      end;

      VIsRect :=
        (
          (VCornerTiles[0].X = VCornerTiles[3].X) and
          (VCornerTiles[2].X = VCornerTiles[1].X) and
          (VCornerTiles[0].Y = VCornerTiles[1].Y) and
          (VCornerTiles[2].Y = VCornerTiles[3].Y)
        ) or (
          (VCornerTiles[0].X = VCornerTiles[1].X) and
          (VCornerTiles[2].X = VCornerTiles[3].X) and
          (VCornerTiles[3].Y = VCornerTiles[0].Y) and
          (VCornerTiles[1].Y = VCornerTiles[2].Y)
        );

      if VIsRect then begin
        Result :=
          TTileRect.Create(
            AProjection,
            RectFromDoubleRect(
              AProjection.PixelRectFloat2TileRectFloat(VSingle.Bounds),
              rrOutside
            )
          );
      end;
    end;
  end;
end;

procedure SplitProjectedPolygon(
  const AProjection: IProjection;
  const AGeometry: IGeometryProjectedPolygon;
  const ASplitCount: Integer;
  const ATilesCountInPolygon: Int64;
  out AStartPoints: TArrayOfPoint;
  out ATilesCount: TIntegerDynArray
);
var
  I: Integer;
  VPoint: TPoint;
  VTileRect: ITileRect;
  VPartTilesCount: Int64;
  VSplitCount: Integer;
  VIterator: ITileIterator;
  VFoundNextPart: Boolean;
begin
  SetLength(AStartPoints, 0);
  SetLength(ATilesCount, 0);

  if (ASplitCount <= 0) or (ATilesCountInPolygon <= 0) then begin
    Assert(False);
    Exit;
  end;

  VSplitCount := ASplitCount;
  repeat
    VPartTilesCount := ATilesCountInPolygon div VSplitCount;
    if VPartTilesCount = 0 then begin
      Dec(VSplitCount);
    end;
  until (VPartTilesCount > 0) or (VSplitCount <= 0);

  if VSplitCount <= 0 then begin
    Exit;
  end;

  SetLength(AStartPoints, VSplitCount);
  SetLength(ATilesCount, VSplitCount);

  VTileRect := TryProjectedPolygonToTileRect(AProjection, AGeometry);
  if VTileRect <> nil then begin
    // ToDo: make calculations faster then Iterator do
    VIterator := TTileIteratorByRect.Create(VTileRect);
  end else begin
    VIterator := TTileIteratorByPolygon.Create(AProjection, AGeometry);
  end;

  I := 0;
  VFoundNextPart := True;

  while VIterator.Next(VPoint) do begin
    Inc(ATilesCount[I]);

    if VFoundNextPart then begin
      AStartPoints[I] := VPoint;
      VFoundNextPart := False;
    end;

    if I < VSplitCount - 1 then begin
      VFoundNextPart := ATilesCount[I] = VPartTilesCount;
      if VFoundNextPart then begin
        Inc(I);
      end;
    end;
  end;
end;

function GeometryLonLatToPlainText(
  const AGeometry: IGeometryLonLat;
  const ACoordToStringConverter: ICoordToStringConverter;
  const APointSeparator: string;
  const AContourSeparator: string;
  const AMultiGeometrySeparator: string
): string;
var
  VPoint: IGeometryLonLatPoint;
  VLine: IGeometryLonLatLine;
  VPoly: IGeometryLonLatPolygon;
begin
  Result := '';
  if Supports(AGeometry, IGeometryLonLatPoint, VPoint) then begin
    Result := GeometryLonLatPointToPlainText(VPoint, ACoordToStringConverter);
  end else if Supports(AGeometry, IGeometryLonLatLine, VLine) then begin
    Result := GeometryLonLatLineToPlainText(VLine, ACoordToStringConverter, APointSeparator, AMultiGeometrySeparator);
  end else if Supports(AGeometry, IGeometryLonLatPolygon, VPoly) then begin
    Result := GeometryLonLatPolygonToPlainText(VPoly, ACoordToStringConverter, APointSeparator, AContourSeparator, AMultiGeometrySeparator);
  end;
end;

function GeometryLonLatPointToPlainText(
  const AGeometry: IGeometryLonLatPoint;
  const ACoordToStringConverter: ICoordToStringConverter
): string;
begin
  Result := ACoordToStringConverter.LonLatConvert(AGeometry.Point);
end;

function GeometryLonLatSingleLineToPlainText(
  const AGeometry: IGeometryLonLatSingleLine;
  const ACoordToStringConverter: ICoordToStringConverter;
  const APointSeparator: string
): string;
var
  i: Integer;
  VPoints: PDoublePointArray;
begin
  Result := '';
  if AGeometry.Count > 0 then begin
    VPoints := AGeometry.Points;
    Result := ACoordToStringConverter.LonLatConvert(VPoints[0]);
    for i := 1 to AGeometry.Count - 1 do begin
      Result := Result + APointSeparator + ACoordToStringConverter.LonLatConvert(VPoints[i]);
    end;
  end;
end;

function GeometryLonLatLineToPlainText(
  const AGeometry: IGeometryLonLatLine;
  const ACoordToStringConverter: ICoordToStringConverter;
  const APointSeparator: string;
  const AMultiGeometrySeparator: string
): string;
var
  VSingleLine: IGeometryLonLatSingleLine;
  VMultiLine: IGeometryLonLatMultiLine;
  i: Integer;
begin
  Result := '';
  if Supports(AGeometry, IGeometryLonLatMultiLine, VMultiLine) then begin
    if VMultiLine.Count > 0 then begin
      VSingleLine := VMultiLine.Item[0];
      Result := GeometryLonLatSingleLineToPlainText(VSingleLine, ACoordToStringConverter, APointSeparator);
      for i := 1 to VMultiLine.Count - 1 do begin
        Result := Result + AMultiGeometrySeparator + GeometryLonLatSingleLineToPlainText(VMultiLine.Item[i], ACoordToStringConverter, APointSeparator);
      end;
    end;
  end else if Supports(AGeometry, IGeometryLonLatSingleLine, VSingleLine) then begin
    Result := GeometryLonLatSingleLineToPlainText(VSingleLine, ACoordToStringConverter, APointSeparator);
  end;
end;

function GeometryLonLatContourToPlainText(
  const AGeometry: IGeometryLonLatContour;
  const ACoordToStringConverter: ICoordToStringConverter;
  const APointSeparator: string
): string;
var
  i: Integer;
  VPoints: PDoublePointArray;
begin
  Result := '';
  if AGeometry.Count > 0 then begin
    VPoints := AGeometry.Points;
    Result := ACoordToStringConverter.LonLatConvert(VPoints[0]);
    for i := 1 to AGeometry.Count - 1 do begin
      Result := Result + APointSeparator + ACoordToStringConverter.LonLatConvert(VPoints[i]);
    end;
    Result := Result + APointSeparator + ACoordToStringConverter.LonLatConvert(VPoints[0]);
  end;
end;

function GeometryLonLatSinglePolygonToPlainText(
  const AGeometry: IGeometryLonLatSinglePolygon;
  const ACoordToStringConverter: ICoordToStringConverter;
  const APointSeparator: string;
  const AContourSeparator: string
): string;
var
  i: Integer;
begin
  Result := GeometryLonLatContourToPlainText(AGeometry.OuterBorder, ACoordToStringConverter, APointSeparator);
  for i := 0 to AGeometry.HoleCount - 1 do begin
    Result := Result + AContourSeparator + GeometryLonLatContourToPlainText(AGeometry.HoleBorder[i], ACoordToStringConverter, APointSeparator);
  end;
end;

function GeometryLonLatPolygonToPlainText(
  const AGeometry: IGeometryLonLatPolygon;
  const ACoordToStringConverter: ICoordToStringConverter;
  const APointSeparator: string;
  const AContourSeparator: string;
  const AMultiGeometrySeparator: string
): string;
var
  VSingleLine: IGeometryLonLatSinglePolygon;
  VMultiLine: IGeometryLonLatMultiPolygon;
  i: Integer;
begin
  Result := '';
  if Supports(AGeometry, IGeometryLonLatMultiPolygon, VMultiLine) then begin
    if VMultiLine.Count > 0 then begin
      VSingleLine := VMultiLine.Item[0];
      Result := GeometryLonLatSinglePolygonToPlainText(VSingleLine, ACoordToStringConverter, APointSeparator, AContourSeparator);
      for i := 1 to VMultiLine.Count - 1 do begin
        Result := Result + AMultiGeometrySeparator + GeometryLonLatSinglePolygonToPlainText(VMultiLine.Item[i], ACoordToStringConverter, APointSeparator, AContourSeparator);
      end;
    end;
  end else if Supports(AGeometry, IGeometryLonLatSinglePolygon, VSingleLine) then begin
    Result := GeometryLonLatSinglePolygonToPlainText(VSingleLine, ACoordToStringConverter, APointSeparator, AContourSeparator);
  end;
end;

function GeometryLonLatLineToArray(
  const AGeometry: IGeometryLonLatLine
): TArrayOfGeometryLonLatSingleLine;
var
  I: Integer;
  VLine: IGeometryLonLatSingleLine;
  VMultiLine: IGeometryLonLatMultiLine;
begin
  if AGeometry = nil then begin
    Result := nil;
    Exit;
  end else
  if Supports(AGeometry, IGeometryLonLatSingleLine, VLine) then begin
    SetLength(Result, 1);
    Result[0] := VLine;
  end else
  if Supports(AGeometry, IGeometryLonLatMultiLine, VMultiLine) then begin
    SetLength(Result, VMultiLine.Count);
    for I := 0 to VMultiLine.Count - 1 do begin
      Result[I] := VMultiLine.Item[I];
    end;
  end else begin
    raise Exception.Create('Unexpected IGeometryLonLatLine type!');
  end;
end;

end.
