unit u_ExportProviderAbstract;

interface

uses
  Controls,
  Forms,
  i_LanguageManager,
  i_VectorItemLonLat,
  i_MapTypes,
  i_ActiveMapsConfig,
  i_MapTypeGUIConfigList,
  i_RegionProcessParamsFrame;

type
  TExportProviderAbstract = class
  private
    FFrame: TFrame;
    FLanguageManager: ILanguageManager;
    FMainMapsConfig: IMainMapsConfig;
    FFullMapsSet: IMapTypeSet;
    FGUIConfigList: IMapTypeGUIConfigList;
    function GetParamsFrame: IRegionProcessParamsFrameBase;
  protected
    function CreateFrame: TFrame; virtual; abstract;
    property ParamsFrame: IRegionProcessParamsFrameBase read GetParamsFrame;
    property LanguageManager: ILanguageManager read FLanguageManager;
    property MainMapsConfig: IMainMapsConfig read FMainMapsConfig;
    property FullMapsSet: IMapTypeSet read FFullMapsSet;
    property GUIConfigList: IMapTypeGUIConfigList read FGUIConfigList;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AMainMapsConfig: IMainMapsConfig;
      const AFullMapsSet: IMapTypeSet;
      const AGUIConfigList: IMapTypeGUIConfigList
    );
    destructor Destroy; override;
    function GetCaption: string; virtual; abstract;
    procedure Show(
      AParent: TWinControl;
      AZoom: byte;
      const APolygon: ILonLatPolygon
    );
    procedure Hide;
    procedure StartProcess(const APolygon: ILonLatPolygon); virtual; abstract;
  end;

implementation

uses
  SysUtils;

{ TExportProviderAbstract }

constructor TExportProviderAbstract.Create(
  const ALanguageManager: ILanguageManager;
  const AMainMapsConfig: IMainMapsConfig;
  const AFullMapsSet: IMapTypeSet;
  const AGUIConfigList: IMapTypeGUIConfigList
);
begin
  inherited Create;
  FLanguageManager := ALanguageManager;
  FMainMapsConfig := AMainMapsConfig;
  FFullMapsSet := AFullMapsSet;
  FGUIConfigList := AGUIConfigList;
end;

destructor TExportProviderAbstract.Destroy;
begin
  FreeAndNil(FFrame);
  inherited;
end;

function TExportProviderAbstract.GetParamsFrame: IRegionProcessParamsFrameBase;
begin
  if not Supports(FFrame, IRegionProcessParamsFrameBase, Result) then begin
    Result := nil;
  end;
end;

procedure TExportProviderAbstract.Hide;
begin
  if FFrame <> nil then begin
    if FFrame.Visible then begin
      FFrame.Hide;
    end;
  end;
end;

procedure TExportProviderAbstract.Show(
  AParent: TWinControl;
  AZoom: byte;
  const APolygon: ILonLatPolygon
);
var
  VFrame: IRegionProcessParamsFrameBase;
begin
  if FFrame = nil then begin
    FFrame := CreateFrame;
    Assert(Supports(FFrame, IRegionProcessParamsFrameBase));
  end;
  if FFrame <> nil then begin
    FFrame.Parent := AParent;
    if not FFrame.Visible then begin
      FFrame.Show;
    end;
    VFrame := ParamsFrame;
    if VFrame <> nil then begin
      VFrame.Init(AZoom, APolygon);
    end;
  end;
end;

end.
