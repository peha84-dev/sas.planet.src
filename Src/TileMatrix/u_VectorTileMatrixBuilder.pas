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

unit u_VectorTileMatrixBuilder;

interface

uses
  Types,
  i_TileRect,
  i_VectorItemSubset,
  i_VectorTileMatrix,
  i_VectorTileMatrixBuilder,
  i_InterfaceListSimple,
  i_HashFunction,
  i_VectorItemSubsetBuilder,
  u_BaseInterfacedObject;

type
  TVectorTileMatrixBuilder = class(TBaseInterfacedObject, IVectorTileMatrixBuilder)
  private
    FVectorSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
    FIsReprojectTiles: Boolean;
    FOversize: TRect;
    FHashFunction: IHashFunction;
    FTileRect: ITileRect;
    FItems: IInterfaceListSimple;
  private
    function GetTileRect: ITileRect;

    function GetTile(const ATile: TPoint): IVectorItemSubset;
    procedure SetTile(
      const ATile: TPoint;
      const AValue: IVectorItemSubset
    );

    procedure SetRectWithReset(const ATileRect: ITileRect);
    procedure SetRect(const ATileRect: ITileRect);

    function MakeStatic: IVectorTileMatrix;
  public
    constructor Create(
      const AVectorSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
      const AIsReprojectTiles: Boolean;
      const AOversize: TRect;
      const AHashFunction: IHashFunction
    );
  end;

implementation

uses
  Math,
  t_Hash,
  t_GeoTypes,
  i_VectorTileProvider,
  i_Projection,
  i_InterfaceListStatic,
  u_TileIteratorByRect,
  u_InterfaceListSimple,
  u_GeoFunc,
  u_VectorTileProviderByMatrix,
  u_VectorTileProviderByOtherProjection,
  u_VectorTileMatrix;

function IndexByPos(
  const ARect: TRect;
  const APos: TPoint
): Integer; inline;
begin
  Result := APos.X - ARect.Left + (APos.Y - ARect.Top) * (ARect.Right - ARect.Left);
end;

{ TVectorTileMatrixBuilder }

constructor TVectorTileMatrixBuilder.Create(
  const AVectorSubsetBuilderFactory: IVectorItemSubsetBuilderFactory;
  const AIsReprojectTiles: Boolean;
  const AOversize: TRect;
  const AHashFunction: IHashFunction
);
begin
  Assert(Assigned(AVectorSubsetBuilderFactory));
  Assert(AOversize.Left >= 0);
  Assert(AOversize.Left < 4096);
  Assert(AOversize.Top >= 0);
  Assert(AOversize.Top < 4096);
  Assert(AOversize.Right >= 0);
  Assert(AOversize.Right < 4096);
  Assert(AOversize.Bottom >= 0);
  Assert(AOversize.Bottom < 4096);
  Assert(Assigned(AHashFunction));
  inherited Create;
  FOversize := AOversize;
  FIsReprojectTiles := AIsReprojectTiles;
  FVectorSubsetBuilderFactory := AVectorSubsetBuilderFactory;
  FHashFunction := AHashFunction;
  FTileRect := nil;
  FItems := TInterfaceListSimple.Create;
end;

function TVectorTileMatrixBuilder.GetTileRect: ITileRect;
begin
  Result := FTileRect;
end;

function TVectorTileMatrixBuilder.GetTile(
  const ATile: TPoint
): IVectorItemSubset;
var
  VIndex: Integer;
begin
  Result := nil;
  if Assigned(FTileRect) then begin
    if PtInRect(FTileRect.Rect, ATile) then begin
      VIndex := IndexByPos(FTileRect.Rect, ATile);
      Result := IVectorItemSubset(FItems.Items[VIndex]);
    end;
  end;
end;

function TVectorTileMatrixBuilder.MakeStatic: IVectorTileMatrix;
var
  VHash: THashValue;
  i: Integer;
  VStaticList: IInterfaceListStatic;
  VTile: IVectorItemSubset;
  VIsEmpty: Boolean;
begin
  Result := nil;
  if not Assigned(FTileRect) then begin
    Exit;
  end;
  VStaticList := FItems.MakeStaticCopy;

  VHash := $5f9ef5b5f150c35a;
  VIsEmpty := True;

  for i := 0 to VStaticList.Count - 1 do begin
    VTile := IVectorItemSubset(VStaticList.Items[i]);
    if Assigned(VTile) then begin
      FHashFunction.UpdateHashByHash(VHash, VTile.Hash);
      VIsEmpty := False;
    end;
  end;

  if not VIsEmpty then begin
    Result :=
      TVectorTileMatrix.Create(
        VHash,
        FTileRect,
        VStaticList
      );
  end;
end;

procedure TVectorTileMatrixBuilder.SetTile(
  const ATile: TPoint;
  const AValue: IVectorItemSubset
);
var
  VIndex: Integer;
begin
  if Assigned(FTileRect) then begin
    if PtInRect(FTileRect.Rect, ATile) then begin
      VIndex := IndexByPos(FTileRect.Rect, ATile);
      FItems.Items[VIndex] := AValue;
    end;
  end;
end;

procedure TVectorTileMatrixBuilder.SetRectWithReset(
  const ATileRect: ITileRect
);
var
  VSize: Integer;
begin
  FItems.Clear;
  FTileRect := ATileRect;
  if Assigned(FTileRect) then begin
    VSize := (FTileRect.Right - FTileRect.Left) * (FTileRect.Bottom - FTileRect.Top);
    FItems.Count := VSize;
  end;
end;

procedure TVectorTileMatrixBuilder.SetRect(
  const ATileRect: ITileRect
);
var
  VTileRect: TRect;
  VIntersectRect: TRect;
  VOldItems: IInterfaceListStatic;
  VOldRect: TRect;
  VIterator: TTileIteratorByRectRecord;
  VTile: TPoint;
  VRelativeRect: TDoubleRect;
  VLonLatRect: TDoubleRect;
  VProjectionNew: IProjection;
  VProjectionOld: IProjection;
  VSourceAtTarget: TRect;
  VTileProvider: IVectorTileProvider;
  VSourceTileMatrix: IVectorTileMatrix;
begin
  Assert(Assigned(ATileRect));
  VProjectionNew := ATileRect.Projection;
  VTileRect := ATileRect.Rect;
  Assert(VProjectionNew.CheckTileRect(VTileRect));
  if Assigned(FTileRect) then begin
    VProjectionOld := FTileRect.Projection;
    if not VProjectionOld.IsSame(VProjectionNew) then begin
      {$REGION 'HotFix'}
      // Do the same thing as THashTileMatrixBuilder does
      SetRectWithReset(ATileRect);
      Exit;
      {$ENDREGION}

      {$REGION 'FixMe-Or-Remove'}
      // The below code cause a bug: http://www.sasgis.org/mantis/view.php?id=3800
      // Updating FItems here, makes invalid linked HashTileMatrix

      if VProjectionNew.ProjectionType.IsSame(VProjectionOld.ProjectionType) then begin
        VOldRect := FTileRect.Rect;
        VRelativeRect := VProjectionOld.TileRect2RelativeRect(VOldRect);
        VSourceAtTarget :=
          RectFromDoubleRect(
            VProjectionNew.RelativeRect2TileRectFloat(VRelativeRect),
            rrOutside
          );
        if not IntersectRect(VIntersectRect, ATileRect.Rect, VSourceAtTarget) then begin
          SetRectWithReset(ATileRect);
        end else begin
          if FIsReprojectTiles then begin
            VSourceTileMatrix := MakeStatic;
          end else begin
            VSourceTileMatrix := nil;
          end;
          SetRectWithReset(ATileRect);

          if Assigned(VSourceTileMatrix) then begin
            VTileProvider :=
              TVectorTileProviderBySameProjection.Create(
                FVectorSubsetBuilderFactory,
                FOversize,
                TVectorTileProviderByMatrix.Create(VSourceTileMatrix),
                ATileRect.Projection
              );
            VIterator.Init(VIntersectRect);
            while VIterator.Next(VTile) do begin
              FItems.Items[IndexByPos(VTileRect, VTile)] := VTileProvider.GetTile(0, nil, VTile);
            end;
          end;
        end;
      end else begin
        VOldRect := FTileRect.Rect;
        VLonLatRect := VProjectionOld.TileRect2LonLatRect(VOldRect);
        VProjectionNew.ProjectionType.ValidateLonLatRect(VLonLatRect);
        VSourceAtTarget :=
          RectFromDoubleRect(
            VProjectionNew.LonLatRect2TileRectFloat(VLonLatRect),
            rrOutside
          );
        if not IntersectRect(VIntersectRect, ATileRect.Rect, VSourceAtTarget) then begin
          SetRectWithReset(ATileRect);
        end else begin
          if FIsReprojectTiles then begin
            VSourceTileMatrix := MakeStatic;
          end else begin
            VSourceTileMatrix := nil;
          end;
          SetRectWithReset(ATileRect);

          if Assigned(VSourceTileMatrix) then begin
            VTileProvider :=
              TVectorTileProviderByOtherProjection.Create(
                FVectorSubsetBuilderFactory,
                FOversize,
                TVectorTileProviderByMatrix.Create(VSourceTileMatrix),
                ATileRect.Projection
              );
            VIterator.Init(VIntersectRect);
            while VIterator.Next(VTile) do begin
              FItems.Items[IndexByPos(VTileRect, VTile)] := VTileProvider.GetTile(0, nil, VTile);
            end;
          end;
        end;
      end;
      {$ENDREGION}
    end else begin
      if not FTileRect.IsEqual(ATileRect) then begin
        if not IntersectRect(VIntersectRect, ATileRect.Rect, FTileRect.Rect) then begin
          SetRectWithReset(ATileRect);
        end else begin
          VOldItems := FItems.MakeStaticAndClear;
          VOldRect := FTileRect.Rect;
          SetRectWithReset(ATileRect);
          VIterator.Init(VIntersectRect);
          while VIterator.Next(VTile) do begin
            FItems.Items[IndexByPos(VTileRect, VTile)] := VOldItems.Items[IndexByPos(VOldRect, VTile)];
          end;
        end;
      end;
    end;
  end else begin
    SetRectWithReset(ATileRect);
  end;
end;

end.
