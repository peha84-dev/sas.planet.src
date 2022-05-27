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

unit frm_MarksExplorer;

interface

uses
  Windows,
  Types,
  SysUtils,
  Classes,
  Controls,
  ComCtrls,
  Messages,
  Menus,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  ImgList,
  ImageList,
  UITypes,
  TB2Dock,
  TB2Toolbar,
  TB2Item,
  TBX,
  TBXDkPanels,
  TBXGraphics,
  frm_MarkSystemConfigEdit,
  frm_MarksExportConfig,
  i_Listener,
  i_RegionProcess,
  i_LanguageManager,
  i_InterfaceListStatic,
  i_GeometryLonLatFactory,
  i_LocalCoordConverterChangeable,
  i_NavigationToPoint,
  i_UsedMarksConfig,
  i_MapViewGoto,
  i_WindowPositionConfig,
  i_MarkId,
  i_VectorDataItemSimple,
  i_MarksExplorerConfig,
  i_MarkCategoryList,
  i_MarkCategory,
  i_MarkSystemConfig,
  i_MarkSystemImplFactory,
  i_MergePolygonsPresenter,
  i_ExportMarks2KMLConfig,
  i_ElevationProfilePresenter,
  u_MarkDbGUIHelper,
  u_MarksExplorerHelper,
  u_CommonFormAndFrameParents;

type
  TfrmMarksExplorer = class(TFormWitghLanguageManager)
    grpMarks: TGroupBox;
    grpCategory: TGroupBox;
    CheckBox1: TCheckBox;
    CategoryTreeView: TTreeView;
    imlStates: TImageList;
    pnlButtons: TPanel;
    pnlMainWithButtons: TPanel;
    pnlMain: TPanel;
    splCatMarks: TSplitter;
    btnExport: TTBXButton;
    PopupExport: TPopupMenu;
    NExportAll: TMenuItem;
    NExportVisible: TMenuItem;
    btnImport: TTBXButton;
    rgMarksShowMode: TRadioGroup;
    TBXDockMark: TTBXDock;
    TBXToolbar1: TTBXToolbar;
    btnEditMark: TTBXItem;
    btnDelMark: TTBXItem;
    TBXSeparatorItem1: TTBXSeparatorItem;
    btnGoToMark: TTBXItem;
    btnOpSelectMark: TTBXItem;
    btnNavOnMark: TTBXItem;
    TBXSeparatorItem2: TTBXSeparatorItem;
    btnSaveMark: TTBXItem;
    TBXDockCategory: TTBXDock;
    TBXToolbar2: TTBXToolbar;
    BtnAddCategory: TTBXItem;
    BtnDelKat: TTBXItem;
    TBXSeparatorItem3: TTBXSeparatorItem;
    BtnEditCategory: TTBXItem;
    btnExportCategory: TTBXItem;
    lblMarksCount: TStaticText;
    tbpmnCategories: TTBXPopupMenu;
    tbitmAddCategory: TTBXItem;
    tbitmEditCategory: TTBXItem;
    tbitmDeleteCategory: TTBXItem;
    tbsprtCategoriesPopUp: TTBXSeparatorItem;
    tbitmExportCategory: TTBXItem;
    tbpmnMarks: TTBXPopupMenu;
    tbitmAddMark: TTBXItem;
    tbitmEditMark: TTBXItem;
    tbitmDeleteMark: TTBXItem;
    tbsprtMarksPopUp: TTBXSeparatorItem;
    tbitmExportMark: TTBXItem;
    btnAddMark: TTBXItem;
    pnlMarksBottom: TPanel;
    pnlBottom: TPanel;
    lblReadOnly: TLabel;
    MarksListBox: TTreeView;
    tbitmMarkInfo: TTBXItem;
    Panel1: TPanel;
    CheckBox2: TCheckBox;
    chkCascade: TCheckBox;
    tbitmAllVisible: TTBXItem;
    tbxtmAddToMergePolygons: TTBXItem;
    tbxtmCatAddToMergePolygons: TTBXItem;
    tbxtmUngroup: TTBXItem;
    TBXToolbar3: TTBXToolbar;
    tbxConfigList: TTBXSubmenuItem;
    tbxSep1: TTBXSeparatorItem;
    tbxAdd: TTBXItem;
    tbxEdit: TTBXItem;
    tbxDelete: TTBXItem;
    TBXImageList1: TTBXImageList;
    btnExportConfig: TTBXItem;
    TBXSeparatorItem4: TTBXSeparatorItem;
    tbsprtMarksPopUp2: TTBXSeparatorItem;
    tbitmCopy: TTBXItem;
    tbitmPaste: TTBXItem;
    tbitmCut: TTBXItem;
    tbitmCopyAsText: TTBXItem;
    TBXSeparatorItem5: TTBXSeparatorItem;
    tbxShowElevProfile: TTBXItem;
    procedure BtnAddCategoryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnDelKatClick(Sender: TObject);
    procedure BtnEditCategoryClick(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CategoryTreeViewMouseUp(
      Sender: TObject;
      Button: TMouseButton;
      Shift: TShiftState;
      X, Y: Integer
    );
    procedure CategoryTreeViewKeyUp(
      Sender: TObject;
      var Key: Word;
      Shift: TShiftState
    );
    procedure CategoryTreeViewChange(
      Sender: TObject;
      Node: TTreeNode
    );
    procedure btnExportClick(Sender: TObject);
    procedure btnExportCategoryClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnEditMarkClick(Sender: TObject);
    procedure btnDelMarkClick(Sender: TObject);
    procedure btnGoToMarkClick(Sender: TObject);
    procedure btnOpSelectMarkClick(Sender: TObject);
    procedure btnNavOnMarkClick(Sender: TObject);
    procedure btnSaveMarkClick(Sender: TObject);
    procedure CategoryTreeViewContextPopup(
      Sender: TObject;
      MousePos: TPoint;
      var Handled: Boolean
    );
    procedure FormHide(Sender: TObject);
    procedure tbitmAddCategoryClick(Sender: TObject);
    procedure tbitmAddMarkClick(Sender: TObject);
    Procedure FormMove(Var Msg: TWMMove); Message WM_MOVE;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MarksListBoxContextPopup(
      Sender: TObject;
      MousePos: TPoint;
      var Handled: Boolean
    );
    procedure MarksListBoxDblClick(Sender: TObject);
    procedure MarksListBoxKeyDown(
      Sender: TObject;
      var Key: Word;
      Shift: TShiftState
    );
    procedure MarksListBoxMouseUp(
      Sender: TObject;
      Button: TMouseButton;
      Shift: TShiftState;
      X, Y: Integer
    );
    procedure rgMarksShowModeClick(Sender: TObject);
    procedure tbpmnCategoriesPopup(Sender: TObject);
    procedure tbitmMarkInfoClick(Sender: TObject);
    procedure CategoryTreeViewDragOver(
      Sender, Source: TObject;
      X, Y: Integer;
      State: TDragState;
      var Accept: Boolean
    );
    procedure CategoryTreeViewDragDrop(
      Sender, Source: TObject;
      X, Y: Integer
    );
    procedure tbitmAllVisibleClick(Sender: TObject);
    procedure tbxtmAddToMergePolygonsClick(Sender: TObject);
    procedure tbxtmCatAddToMergePolygonsClick(Sender: TObject);
    procedure tbpmnMarksPopup(Sender: TObject);
    procedure tbxtmUngroupClick(Sender: TObject);
    procedure tbxConfigListItemClick(Sender: TObject);
    procedure tbxDeleteClick(Sender: TObject);
    procedure tbxAddClick(Sender: TObject);
    procedure tbxEditClick(Sender: TObject);
    procedure btnExportConfigClick(Sender: TObject);
    procedure tbitmCopyClick(Sender: TObject);
    procedure tbitmCutClick(Sender: TObject);
    procedure tbitmPasteClick(Sender: TObject);
    procedure tbitmCopyAsTextClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure tbxShowElevProfileClick(Sender: TObject);
  private
    type
      TCopyPasteAction = (cpNone, cpCopy, cpCut);
  private
    FfrmMarkSystemConfigEdit: TfrmMarkSystemConfigEdit;
    FfrmMarksExportConfig: TfrmMarksExportConfig;
    FUseAsIndepentWindow: Boolean;
    FMapGoto: IMapViewGoto;
    FCategoryList: IMarkCategoryList;
    FMarksList: IInterfaceListStatic;
    FMarkDBGUI: TMarkDbGUIHelper;
    FMarkSystemConfig: IMarkSystemConfigListChangeable;
    FGeometryLonLatFactory: IGeometryLonLatFactory;
    FMarksShowConfig: IUsedMarksConfig;
    FMarksExplorerConfig: IMarksExplorerConfig;
    FWindowConfig: IWindowPositionConfig;
    FViewPortState: ILocalCoordConverterChangeable;
    FNavToPoint: INavigationToPoint;

    FMarkSystemConfigListener: IListener;
    FCategoryDBListener: IListener;
    FMarksDBListener: IListener;
    FMarksShowConfigListener: IListener;
    FConfigListener: IListener;
    FMarksSystemStateListener: IListener;
    FRegionProcess: IRegionProcess;
    FMergePolygonsPresenter: IMergePolygonsPresenter;
    FSelectedCategoryInfo: TExpandInfo;
    FExpandedCategoriesInfo: TExpandInfo;

    FCopyPasteAction: TCopyPasteAction;
    FCopyPasteBuffer: IInterfaceListStatic;

    FElevationProfilePresenter: IElevationProfilePresenter;

    procedure PrepareCopyPasteBuffer(const AAction: TCopyPasteAction);
    procedure ResetCopyPasteBuffer;

    procedure OnMarkSystemConfigChange;
    procedure OnCategoryDbChanged;
    procedure OnMarksDbChanged;
    procedure OnMarksShowConfigChanged;
    procedure OnConfigChange;
    procedure OnMarkSystemStateChanged;
    procedure UpdateCategoryTree;
    procedure CategoryTreeViewVisible(Node: TTreeNode);
    function GetNodeCategory(const ANode: TTreeNode): IMarkCategory;
    function GetSelectedCategory: IMarkCategory;
    procedure UpdateMarksList;
    function GetSelectedMarkId: IMarkId;
    function GetSelectedMarkFull: IVectorDataItem;
    function GetSelectedMarksIdList: IInterfaceListStatic;
    procedure WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure ToggleVisible;
  public
    constructor Create(
      const AUseAsIndepentWindow: Boolean;
      const ALanguageManager: ILanguageManager;
      const AGeometryLonLatFactory: IGeometryLonLatFactory;
      const AViewPortState: ILocalCoordConverterChangeable;
      const ANavToPoint: INavigationToPoint;
      const AMarksExplorerConfig: IMarksExplorerConfig;
      const AMarksShowConfig: IUsedMarksConfig;
      const AMergePolygonsPresenter: IMergePolygonsPresenter;
      const AMarkDBGUI: TMarkDbGUIHelper;
      const AMarkSystemFactoryList: IMarkSystemImplFactoryListStatic;
      const AMarkSystemConfig: IMarkSystemConfigListChangeable;
      const AExportMarks2KMLConfig: IExportMarks2KMLConfig;
      const AMapGoto: IMapViewGoto;
      const AElevationProfilePresenter: IElevationProfilePresenter;
      const ARegionProcess: IRegionProcess
    ); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  CityHash, // for GetNodeUID inlining
  ExplorerSort,
  gnugettext,
  t_GeoTypes,
  i_InterfaceListSimple,
  i_MarkCategoryTree,
  i_Category,
  i_ImportConfig,
  i_MarkTemplate,
  i_MarkCategoryFactory,
  i_MarkFactoryConfig,
  i_GeometryLonLat,
  u_ClipboardFunc,
  u_MarkCategoryList,
  u_InterfaceListSimple,
  u_ListenerByEvent;

{$R *.dfm}

constructor TfrmMarksExplorer.Create(
  const AUseAsIndepentWindow: Boolean;
  const ALanguageManager: ILanguageManager;
  const AGeometryLonLatFactory: IGeometryLonLatFactory;
  const AViewPortState: ILocalCoordConverterChangeable;
  const ANavToPoint: INavigationToPoint;
  const AMarksExplorerConfig: IMarksExplorerConfig;
  const AMarksShowConfig: IUsedMarksConfig;
  const AMergePolygonsPresenter: IMergePolygonsPresenter;
  const AMarkDBGUI: TMarkDbGUIHelper;
  const AMarkSystemFactoryList: IMarkSystemImplFactoryListStatic;
  const AMarkSystemConfig: IMarkSystemConfigListChangeable;
  const AExportMarks2KMLConfig: IExportMarks2KMLConfig;
  const AMapGoto: IMapViewGoto;
  const AElevationProfilePresenter: IElevationProfilePresenter;
  const ARegionProcess: IRegionProcess
);
begin
  inherited Create(ALanguageManager);

  FUseAsIndepentWindow := AUseAsIndepentWindow;
  FMergePolygonsPresenter := AMergePolygonsPresenter;
  FMarkDBGUI := AMarkDBGUI;
  FMarkSystemConfig := AMarkSystemConfig;
  FGeometryLonLatFactory := AGeometryLonLatFactory;
  FMapGoto := AMapGoto;
  FMarksExplorerConfig := AMarksExplorerConfig;
  FWindowConfig := FMarksExplorerConfig.WindowPositionConfig;
  FMarksShowConfig := AMarksShowConfig;
  FViewPortState := AViewPortState;
  FNavToPoint := ANavToPoint;
  FRegionProcess := ARegionProcess;
  FElevationProfilePresenter := AElevationProfilePresenter;

  MarksListBox.MultiSelect := true;
  FMarkSystemConfigListener := TNotifyNoMmgEventListener.Create(Self.OnMarkSystemConfigChange);
  FCategoryDBListener := TNotifyNoMmgEventListener.Create(Self.OnCategoryDbChanged);
  FMarksDBListener := TNotifyNoMmgEventListener.Create(Self.OnMarksDbChanged);
  FMarksShowConfigListener := TNotifyNoMmgEventListener.Create(Self.OnMarksShowConfigChanged);
  FConfigListener := TNotifyNoMmgEventListener.Create(Self.OnConfigChange);
  FMarksSystemStateListener := TNotifyNoMmgEventListener.Create(Self.OnMarkSystemStateChanged);

  FfrmMarkSystemConfigEdit :=
    TfrmMarkSystemConfigEdit.Create(
      Self,
      AMarkSystemFactoryList,
      FMarkSystemConfig
    );

  FfrmMarksExportConfig :=
    TfrmMarksExportConfig.Create(
      Self,
      AExportMarks2KMLConfig
    );
end;

procedure TfrmMarksExplorer.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if FUseAsIndepentWindow then begin
    // WS_Ex_AppWindow - �������� �� ����������� ������ �� ������ �����
    Params.ExStyle := Params.ExStyle or WS_Ex_AppWindow;
    // �� ��������� ��������������� Application.Handle, ������ ��� ����� ����� ����� ���� ��������
    Params.WndParent := GetDesktopWindow; // ����������� � �������� �����
  end;
end;

procedure TfrmMarksExplorer.FormCreate(Sender: TObject);
begin
  if IsRectEmpty(FWindowConfig.BoundsRect) then begin
    Self.Width := 700;
    Self.Height := 500;
    Self.Position := poMainFormCenter;
    FWindowConfig.SetWindowPosition(Self.BoundsRect);
  end;
  FSelectedCategoryInfo := ExpandInfoFromString(FMarksExplorerConfig.SelectedCategory);
  FExpandedCategoriesInfo := ExpandInfoFromString(FMarksExplorerConfig.ExpandedCategories);
end;

destructor TfrmMarksExplorer.Destroy;
begin
  if Assigned(FWindowConfig) and Assigned(FConfigListener) then begin
    FWindowConfig.ChangeNotifier.Remove(FConfigListener);
    FConfigListener := nil;
  end;
  FreeAndNil(FfrmMarkSystemConfigEdit);
  FreeAndNil(FfrmMarksExportConfig);
  inherited;
end;

procedure TfrmMarksExplorer.BtnAddCategoryClick(Sender: TObject);
var
  VCategory: IMarkCategory;
begin
  VCategory := FMarkDBGUI.MarksDb.CategoryDB.Factory.CreateNew('');
  VCategory := FMarkDBGUI.EditCategoryModal(VCategory, True);
  if VCategory <> nil then begin
    FMarkDBGUI.MarksDb.CategoryDB.UpdateCategory(nil, VCategory);
  end;
end;

procedure TfrmMarksExplorer.UpdateCategoryTree;

  procedure UpdateTreeSubItems(
    const ATree: IMarkCategoryTree;
    const ASelectedCategory: ICategory;
    AParentNode: TTreeNode;
    ATreeItems: TTreeNodes
  );
  var
    i: Integer;
    VTree: IMarkCategoryTree;
    VCategory: IMarkCategory;
    VNode: TTreeNode;
    VNodeToDelete: TTreeNode;
    VName: string;
  begin
    if AParentNode = nil then begin
      VNode := ATreeItems.GetFirstNode;
    end else begin
      VNode := AParentNode.getFirstChild;
    end;
    if Assigned(ATree) then begin
      for i := 0 to ATree.SubItemCount - 1 do begin
        VTree := ATree.SubItem[i];
        VCategory := VTree.MarkCategory;
        VName := VTree.Name;
        if VName = '' then begin
          VName := '(NoName)';
        end;
        if VNode = nil then begin
          VNode := ATreeItems.AddChildObject(AParentNode, VName, nil);
        end else begin
          VNode.Text := VName;
        end;
        if Assigned(VCategory) then begin
          VNode.Data := Pointer(VCategory);
          if VCategory.Visible then begin
            VNode.StateIndex := 1;
          end else begin
            VNode.StateIndex := 2;
          end;
          if VCategory.IsSame(ASelectedCategory) then begin
            VNode.Selected := True;
          end;
        end else begin
          VNode.StateIndex := 0;
          VNode.Data := nil;
        end;
        UpdateTreeSubItems(VTree, ASelectedCategory, VNode, ATreeItems);
        VNode := VNode.getNextSibling;
      end;
    end;
    while VNode <> nil do begin
      VNodeToDelete := VNode;
      VNode := VNode.getNextSibling;
      VNodeToDelete.Delete;
    end;
  end;

var
  I: Integer;
  VTree: IMarkCategoryTree;
  VSelectedCategory: ICategory;
  VNode: TTreeNode;
  VItems: TTreeNodes;
begin
  VSelectedCategory := GetSelectedCategory;
  FCategoryList := FMarkDBGUI.MarksDb.CategoryDB.GetCategoriesList;
  VTree := FMarkDBGUI.MarksDb.CategoryDB.CategoryListToStaticTree(FCategoryList);
  CategoryTreeView.OnChange := nil;
  try
    VItems := CategoryTreeView.Items;
    VItems.BeginUpdate;
    try
      UpdateTreeSubItems(VTree, VSelectedCategory, nil, VItems);
      CategoryTreeView.CustomSort(TreeViewCompare, 0);
      DoExpandNodes(VItems, FExpandedCategoriesInfo, VSelectedCategory);
      
      VSelectedCategory := GetSelectedCategory;
      if not Assigned(VSelectedCategory) then begin
        if Length(FSelectedCategoryInfo) >= 1 then begin
          I := FSelectedCategoryInfo[0].Index;
          if (I < VItems.Count) and (GetNodeUID(VItems[I]) = FSelectedCategoryInfo[0].UID) then begin
            VItems[I].Selected := True;
            VItems[I].MakeVisible;
            VSelectedCategory := GetSelectedCategory;
          end;
        end;
        if not Assigned(VSelectedCategory) then begin
          VNode := VItems.GetFirstNode;
          if Assigned(VNode) then begin
            VNode.Selected := True;
          end;
        end;
      end;
    finally
      VItems.EndUpdate;
    end;
  finally
    CategoryTreeView.OnChange := Self.CategoryTreeViewChange;
  end;
  UpdateMarksList;
end;

procedure TfrmMarksExplorer.UpdateMarksList;
var
  VCategory: IMarkCategory;
  VMarkId: IMarkId;
  I: Integer;
  VNode: TTreeNode;
  VNodeToDelete: TTreeNode;
  VName: string;
  VVisibleCount: Integer;
  VSortedMarksList: TStringList;
begin
  FMarksList := nil;
  VCategory := GetSelectedCategory;
  if (VCategory <> nil) then begin
    FMarksList := FMarkDBGUI.MarksDb.MarkDb.GetMarkIdListByCategory(VCategory);
    VSortedMarksList := TStringList.Create;
    try
      VSortedMarksList.Duplicates := dupAccept;
      VSortedMarksList.BeginUpdate;
      try
        if Assigned(FMarksList) then begin
          for I := 0 to FMarksList.Count - 1 do begin
            VMarkId := IMarkId(FMarksList.Items[I]);
            VName := FMarkDBGUI.GetMarkIdCaption(VMarkId);
            VSortedMarksList.AddObject(VName, Pointer(VMarkId));
          end;
          VSortedMarksList.CustomSort(StringListCompare);
        end;
      finally
        VSortedMarksList.EndUpdate;
      end;
      VVisibleCount := 0;
      MarksListBox.Items.BeginUpdate;
      try
        VNode := MarksListBox.Items.GetFirstNode;
        for I := 0 to VSortedMarksList.Count - 1 do begin
          VMarkId := IMarkId(Pointer(VSortedMarksList.Objects[I]));
          VName := VSortedMarksList.Strings[I];
          if VNode = nil then begin
            VNode := MarksListBox.Items.AddChildObject(nil, VName, nil);
          end else begin
            VNode.Text := VName;
          end;
          VNode.Data := Pointer(VMarkId);
          if FMarkDBGUI.MarksDb.MarkDb.GetMarkVisibleByID(VMarkId) then begin
            VNode.StateIndex := 1;
            Inc(VVisibleCount);
          end else begin
            VNode.StateIndex := 2;
          end;
          VNode := VNode.getNextSibling;
        end;
        while VNode <> nil do begin
          VNodeToDelete := VNode;
          VNode := VNode.getNextSibling;
          VNodeToDelete.Delete;
        end;
        lblMarksCount.Caption := Format('(%d/%d)', [VVisibleCount, MarksListBox.Items.Count]);
      finally
        MarksListBox.Items.EndUpdate;
      end;
    finally
      VSortedMarksList.Free;
    end;
  end else begin
    MarksListBox.Items.Clear;
  end;
end;

function TfrmMarksExplorer.GetNodeCategory(const ANode: TTreeNode): IMarkCategory;
begin
  if ANode <> nil then begin
    Result := IMarkCategory(ANode.Data);
  end else begin
    Result := nil;
  end;
end;

function TfrmMarksExplorer.GetSelectedCategory: IMarkCategory;
begin
  Result := GetNodeCategory(CategoryTreeView.Selected);
end;

function TfrmMarksExplorer.GetSelectedMarkFull: IVectorDataItem;
var
  VMarkId: IMarkId;
begin
  Result := nil;
  VMarkId := GetSelectedMarkId;
  if VMarkId <> nil then begin
    Result := FMarkDBGUI.MarksDb.MarkDb.GetMarkByID(VMarkId);
  end;
end;

function TfrmMarksExplorer.GetSelectedMarksIdList: IInterfaceListStatic;
var
  i: integer;
  VTemp: IInterfaceListSimple;
begin
  Result := nil;
  VTemp := TInterfaceListSimple.Create;
  for i := 0 to MarksListBox.SelectionCount - 1 do begin
    VTemp.Add(IMarkId(MarksListBox.Selections[i].Data));
  end;
  if VTemp.Count > 0 then begin
    Result := VTemp.MakeStaticAndClear;
  end;
end;

function TfrmMarksExplorer.GetSelectedMarkId: IMarkId;
var
  VNode: TTreeNode;
begin
  Result := nil;
  VNode := MarksListBox.Selected;
  if VNode <> nil then begin
    Result := IMarkId(VNode.Data);
  end;
end;

procedure TfrmMarksExplorer.btnImportClick(Sender: TObject);
var
  VList: IInterfaceListStatic;
  VMark: IVectorDataItem;
begin
  VList := FMarkDBGUI.ImportModal(Self.Handle);
  if (Vlist <> nil) and (VList.Count > 0) then begin
    VMark := IVectorDataItem(VList[VList.Count - 1]);
    if VMark <> nil then begin
      FMapGoto.FitRectToScreen(VMark.Geometry.Bounds.Rect);
    end;
  end;
end;

procedure TfrmMarksExplorer.BtnDelKatClick(Sender: TObject);
var
  VCategory: IMarkCategory;
begin
  VCategory := GetSelectedCategory;
  if VCategory <> nil then begin
    FMarkDBGUI.DeleteCategoryModal(VCategory, Self.Handle);
  end;
end;

procedure TfrmMarksExplorer.btnExportClick(Sender: TObject);
var
  VCategoryList: IMarkCategoryList;
  VOnlyVisible: Boolean;
begin
  VOnlyVisible := (TComponent(Sender).tag = 1);
  if VOnlyVisible then begin
    VCategoryList := FMarkDBGUI.MarksDb.CategoryDB.GetVisibleCategoriesIgnoreZoom;
  end else begin
    VCategoryList := FMarkDBGUI.MarksDb.CategoryDB.GetCategoriesList;
  end;
  FMarkDBGUI.ExportCategoryList(VCategoryList, not VOnlyVisible);
end;

procedure TfrmMarksExplorer.btnExportConfigClick(Sender: TObject);
begin
  FfrmMarksExportConfig.ShowModal;
end;

procedure TfrmMarksExplorer.btnDelMarkClick(Sender: TObject);
var
  VMarkIdList: IInterfaceListStatic;
begin
  VMarkIdList := GetSelectedMarksIdList;
  if VMarkIdList <> nil then begin
    if FMarkDBGUI.DeleteMarksModal(VMarkIdList, Self.Handle) then begin
      MarksListBox.ClearSelection(True);
    end;
  end;
end;

procedure TfrmMarksExplorer.btnEditMarkClick(Sender: TObject);
var
  VMarkIdList: IInterfaceListStatic;
  VMarksList: IInterfaceListSimple;
  VMark: IVectorDataItem;
  VMarkNew: IVectorDataItem;
  VImportConfig: IImportConfig;
  VParams: IImportMarkParams;
  VCategory: ICategory;
  VMarkId: IMarkId;
  i: integer;
  VVisible: Boolean;
  VResult: IVectorDataItem;
  VResultList: IInterfaceListStatic;
begin
  VMarkIdList := GetSelectedMarksIdList;
  if VMarkIdList <> nil then begin
    if VMarkIdList.Count = 1 then begin
      VMark := FMarkDBGUI.MarksDb.MarkDb.GetMarkByID(IMarkId(VMarkIdList[0]));
      VVisible := FMarkDBGUI.MarksDb.MarkDb.GetMarkVisible(VMark);
      VMarkNew := FMarkDBGUI.EditMarkModal(VMark, False, VVisible);
      if VMarkNew <> nil then begin
        VResult := FMarkDBGUI.MarksDb.MarkDb.UpdateMark(VMark, VMarkNew);
        if VResult <> nil then begin
          FMarkDBGUI.MarksDb.MarkDb.SetMarkVisible(VResult, VVisible);
        end;
      end;
    end else begin
      VImportConfig := FMarkDBGUI.MarksMultiEditModal(GetSelectedCategory);
      if (VImportConfig <> nil) then begin
        VCategory := VImportConfig.RootCategory;
        VMarksList := TInterfaceListSimple.Create;
        for i := 0 to VMarkIdList.Count - 1 do begin
          VMarkId := IMarkId(VMarkIdList[i]);
          VMark := FMarkDBGUI.MarksDb.MarkDb.GetMarkByID(VMarkId);
          VParams := nil;
          if Supports(VMark.Geometry, IGeometryLonLatPoint) then begin
            VParams := VImportConfig.PointParams;
          end else if Supports(VMark.Geometry, IGeometryLonLatLine) then begin
            VParams := VImportConfig.LineParams;
          end else if Supports(VMark.Geometry, IGeometryLonLatPolygon) then begin
            VParams := VImportConfig.PolyParams;
          end;
          VMarkNew :=
            FMarkDBGUI.MarksDb.MarkDb.Factory.PrepareMark(
              VMark,
              VMark.Name,
              VParams,
              VCategory
            );
          if VMarkNew <> nil then begin
            VMarksList.Add(VMarkNew);
          end else begin
            VMarksList.Add(VMark);
          end;
        end;
        if (VMarksList <> nil) then begin
          VResultList := FMarkDBGUI.MarksDb.MarkDb.UpdateMarkList(VMarkIdList, VMarksList.MakeStaticAndClear);
          if VResultList <> nil then begin
            FMarkDBGUI.MarksDb.MarkDb.SetMarkVisibleByIDList(VResultList, True);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMarksExplorer.btnGoToMarkClick(Sender: TObject);
var
  VMark: IVectorDataItem;
begin
  VMark := GetSelectedMarkFull;
  if Assigned(VMark) and Assigned(VMark.Geometry.Bounds) then begin
    FMapGoto.FitRectToScreen(VMark.Geometry.Bounds.Rect);
    FMapGoto.ShowMarker(VMark.Geometry.GetGoToPoint);
  end;
end;

procedure TfrmMarksExplorer.btnNavOnMarkClick(Sender: TObject);
var
  VMark: IVectorDataItem;
  LL: TDoublePoint;
  VMarkStringId: string;
begin
  if (btnNavOnMark.Checked) then begin
    VMark := GetSelectedMarkFull;
    if VMark <> nil then begin
      LL := VMark.Geometry.GetGoToPoint;
      VMarkStringId := FMarkDBGUI.MarksDb.GetStringIdByMark(VMark);
      FNavToPoint.StartNavToMark(VMarkStringId, LL);
    end else begin
      btnNavOnMark.Checked := not btnNavOnMark.Checked;
    end;
  end else begin
    FNavToPoint.StopNav;
  end;
end;

procedure TfrmMarksExplorer.btnOpSelectMarkClick(Sender: TObject);
var
  VMark: IVectorDataItem;
  Vpolygon: IGeometryLonLatPolygon;
begin
  VMark := GetSelectedMarkFull;
  if VMark <> nil then begin
    Vpolygon := FMarkDBGUI.PolygonForOperation(VMark.Geometry, FViewPortState.GetStatic.Projection);
    if Vpolygon <> nil then begin
      FRegionProcess.ProcessPolygon(Vpolygon);
      ModalResult := mrOk;
    end;
  end;
end;

procedure TfrmMarksExplorer.btnSaveMarkClick(Sender: TObject);
var
  VMark: IVectorDataItem;
begin
  VMark := GetSelectedMarkFull;
  if VMark <> nil then begin
    FMarkDBGUI.ExportMark(VMark);
  end;
end;

procedure TfrmMarksExplorer.CategoryTreeViewChange(
  Sender: TObject;
  Node: TTreeNode
);
begin
  UpdateMarksList;
  FExpandedCategoriesInfo := GetExpandInfo(CategoryTreeView.Items);
end;

procedure TfrmMarksExplorer.CategoryTreeViewVisible(Node: TTreeNode);
var
  I: Integer;
  VVisible: Boolean;
  VTopIndex: Integer;
  VCategoryOld: IMarkCategory;
  VCategoryNew: IMarkCategory;
  VOldList, VNewList: IMarkCategoryList;
  VTempOld, VTempNew: IInterfaceListSimple;
  VFactory: IMarkCategoryFactory;
begin
  VCategoryOld := GetNodeCategory(Node);
  if VCategoryOld <> nil then begin
    CategoryTreeView.Items.BeginUpdate;
    try
      VTopIndex := CategoryTreeView.TopItem.AbsoluteIndex;

      if Node.StateIndex = 1 then begin
        VVisible := False;
      end else begin
        VVisible := True;
      end;

      VTempOld := TInterfaceListSimple.Create;
      VTempNew := TInterfaceListSimple.Create;
      VFactory := FMarkDBGUI.MarksDb.CategoryDB.Factory;

      // ��������� �������� Visible �������� ���� ��������� �����
      if VCategoryOld.Visible <> VVisible then begin
        VCategoryNew := VFactory.ModifyVisible(VCategoryOld, VVisible);
        VTempOld.Add(VCategoryOld);
        VTempNew.Add(VCategoryNew);
      end;

      // ��������� �������� Visible �������� ����� ��������� �����
      if chkCascade.Checked then begin
        VOldList := FMarkDBGUI.MarksDb.CategoryDB.GetSubCategoryListForCategory(VCategoryOld);
        if Assigned(VOldList) then begin
          for I := 0 to VOldList.Count - 1 do begin
            VCategoryOld := VOldList.Items[I];
            if VCategoryOld.Visible <> VVisible then begin
              VCategoryNew := VFactory.ModifyVisible(VCategoryOld, VVisible);
              VTempOld.Add(VCategoryOld);
              VTempNew.Add(VCategoryNew);
            end;
          end;
        end;
      end;

      if VTempOld.Count > 1 then begin
        VOldList := TMarkCategoryList.Build(VTempOld.MakeStaticAndClear);
        VNewList := TMarkCategoryList.Build(VTempNew.MakeStaticAndClear);
        FMarkDBGUI.MarksDb.CategoryDB.UpdateCategoryList(VOldList, VNewList);
      end else if VTempOld.Count = 1 then begin
        FMarkDBGUI.MarksDb.CategoryDB.UpdateCategory(
          IMarkCategory(VTempOld.Items[0]),
          IMarkCategory(VTempNew.Items[0])
        );
      end;

      CategoryTreeView.TopItem := CategoryTreeView.Items[VTopIndex];
    finally
      CategoryTreeView.Items.EndUpdate;
    end;
  end;
end;

procedure TfrmMarksExplorer.CategoryTreeViewKeyUp(
  Sender: TObject;
  var Key: Word;
  Shift: TShiftState
);
var
  VCategoryOld: IMarkCategory;
begin
  if Key = VK_DELETE then begin
    VCategoryOld := GetSelectedCategory;
    if VCategoryOld <> nil then begin
      FMarkDBGUI.DeleteCategoryModal(VCategoryOld, Self.Handle);
    end;
    Key := 0;
  end else if Key = VK_SPACE then begin
    CategoryTreeViewVisible(CategoryTreeView.Selected);
    Key := 0;
  end else  if Key = VK_F2 then begin
    BtnEditCategoryClick(Self);
    Key := 0;
  end;
end;

procedure TfrmMarksExplorer.CategoryTreeViewMouseUp(
  Sender: TObject;
  Button: TMouseButton;
  Shift: TShiftState;
  X, Y: Integer
);
begin
  if htOnStateIcon in CategoryTreeView.GetHitTestInfoAt(X, Y) then begin
    CategoryTreeViewVisible(CategoryTreeView.GetNodeAt(X, Y));
  end;
end;

procedure TfrmMarksExplorer.BtnEditCategoryClick(Sender: TObject);
var
  VCategoryOld: IMarkCategory;
  VCategoryNew: IMarkCategory;
begin
  VCategoryOld := GetSelectedCategory;
  if VCategoryOld <> nil then begin
    VCategoryNew := FMarkDBGUI.EditCategoryModal(VCategoryOld, False);
    if VCategoryNew <> nil then begin
      FMarkDBGUI.MarksDb.CategoryDB.UpdateCategory(VCategoryOld, VCategoryNew);
    end;
  end;
end;

procedure TfrmMarksExplorer.btnExportCategoryClick(Sender: TObject);
var
  VCategory: IMarkCategory;
  VOnlyVisible: Boolean;
begin
  VCategory := GetSelectedCategory;
  if VCategory <> nil then begin
    VOnlyVisible := (TComponent(Sender).tag = 1);
    FMarkDBGUI.ExportCategory(VCategory, not VOnlyVisible);
  end;
end;

procedure TfrmMarksExplorer.CategoryTreeViewContextPopup(
  Sender: TObject;
  MousePos: TPoint;
  var Handled: Boolean
);
var
  VNode: TTreeNode;
begin
  if (MousePos.X >= 0) and (MousePos.Y >= 0) then begin
    VNode := CategoryTreeView.GetNodeAt(MousePos.X, MousePos.Y);
    if VNode <> nil then begin
      CategoryTreeView.Select(VNode);
    end;
  end;
end;

procedure TfrmMarksExplorer.CategoryTreeViewDragDrop(
  Sender, Source: TObject;
  X, Y: Integer
);

  function MoveMarks(
    const ADestNode: TTreeNode;
    const AMarks: IInterfaceListStatic
  ): Boolean;
  var
    I: Integer;
    VMarkIdListNew: IInterfaceListSimple;
    VCategoryNew: ICategory;
    VMark: IVectorDataItem;
  begin
    Result := False;
    if AMarks <> nil then begin
      VCategoryNew := GetNodeCategory(ADestNode);
      if VCategoryNew <> nil then begin
        VMarkIdListNew := TInterfaceListSimple.Create;
        for I := 0 to AMarks.Count - 1 do begin
          VMark := FMarkDBGUI.MarksDb.MarkDb.GetMarkByID(IMarkId(AMarks.Items[I]));
          VMarkIdListNew.Add(FMarkDBGUI.MarksDb.MarkDb.Factory.ReplaceCategory(VMark, VCategoryNew));
        end;
        FMarkDBGUI.MarksDb.MarkDb.UpdateMarkList(AMarks, VMarkIdListNew.MakeStaticAndClear);
        Result := True;
      end;
    end;
  end;

  procedure MoveCategory(const ADestNode, ASourceNode: TTreeNode);
  var
    I: Integer;
    VNewName: string;
    VDestCategory: ICategory;
    VOldCategory, VNewCategory: IMarkCategory;
  begin
    VDestCategory := GetNodeCategory(ADestNode);
    VOldCategory := GetNodeCategory(ASourceNode);
    if (VDestCategory <> nil) and (VOldCategory <> nil) then begin
      // get new name for category
      VNewName := VOldCategory.Name;
      I := LastDelimiter('\', VNewName);
      VNewName := VDestCategory.Name + '\' + Copy(VNewName, I + 1, MaxInt);

      // modify category with all subcategories
      VNewCategory := FMarkDBGUI.MarksDb.CategoryDB.Factory.Modify(
        VOldCategory,
        VNewName,
        VOldCategory.Visible,
        VOldCategory.AfterScale,
        VOldCategory.BeforeScale
      );
      FMarkDBGUI.MarksDb.CategoryDB.UpdateCategory(VOldCategory, VNewCategory);
    end;
  end;

var
  VNode: TTreeNode;
begin
  VNode := CategoryTreeView.GetNodeAt(X, Y);
  if (VNode <> nil) and (VNode <> CategoryTreeView.Selected) then begin
    if Source = MarksListBox then begin
      // replace category for all selected marks in selected category
      if MoveMarks(VNode, GetSelectedMarksIdList) then begin
        MarksListBox.ClearSelection;
      end;
    end else if Source = CategoryTreeView then begin
      // move selected category with all subcategories to new category
      MoveCategory(VNode, CategoryTreeView.Selected);
    end;
  end;
end;

procedure TfrmMarksExplorer.CategoryTreeViewDragOver(
  Sender, Source: TObject;
  X, Y: Integer;
  State: TDragState;
  var Accept: Boolean
);
var
  I: Integer;
  VNode: TTreeNode;
  VList: IMarkCategoryList;
  VNewName: string;
  VOldCategory, VOldSubCategory, VNewCategory: IMarkCategory;
begin
  Accept := (Source = MarksListBox) or (Source = CategoryTreeView);
  if not Accept then begin
    Exit;
  end;

  VNode := CategoryTreeView.GetNodeAt(X, Y);
  Accept := (VNode <> nil) and (VNode <> CategoryTreeView.Selected);
  if not Accept then begin
    Exit;
  end;

  if Source = CategoryTreeView then begin
    VOldCategory := GetNodeCategory(CategoryTreeView.Selected);
    VNewCategory := GetNodeCategory(VNode);
    Accept := (VOldCategory <> nil) and (VNewCategory <> nil);
    if not Accept then begin
      Exit;
    end;

    VNewName := VOldCategory.Name;
    I := LastDelimiter('\', VNewName);
    VNewName := VNewCategory.Name + '\' + Copy(VNewName, I + 1, MaxInt);
    Accept := FMarkDBGUI.MarksDb.CategoryDB.GetFirstCategoryByName(VNewName) = nil;
    if not Accept then begin
      Exit;
    end;

    // forbid the transfer of a category to its own child category
    VList := FMarkDBGUI.MarksDb.CategoryDB.GetSubCategoryListForCategory(VOldCategory);
    if VList <> nil then begin
      for I := 0 to VList.Count - 1 do begin
        VOldSubCategory := IMarkCategory(VList[I]);
        if VNewCategory.IsSame(VOldSubCategory) then begin
          Accept := False;
          Break;
        end;
      end;
    end;
  end;
end;

procedure TfrmMarksExplorer.OnCategoryDbChanged;
begin
  UpdateCategoryTree;
end;

procedure TfrmMarksExplorer.OnConfigChange;
  function UpdateRectByMonitors(ARect: TRect): TRect;
  var
    i: Integer;
    VIntersectRect: TRect;
    VMonitor: TMonitor;
  begin
    Result := ARect;
    for i := 0 to Screen.MonitorCount - 1 do begin
      VMonitor := Screen.Monitors[i];
      if IntersectRect(VIntersectRect, ARect, VMonitor.WorkareaRect) then begin
        Exit;
      end;
    end;
    VMonitor := Screen.MonitorFromRect(ARect, mdNearest);
    Result.TopLeft := VMonitor.WorkareaRect.TopLeft;
    Result.Right := Result.Left + (ARect.Right - ARect.Left);
    Result.Bottom := Result.Top + (ARect.Bottom - ARect.Top);
  end;

var
  VRect: TRect;
begin
  VRect := FWindowConfig.BoundsRect;
  if EqualRect(BoundsRect, VRect) then begin
    Exit;
  end;
  VRect := UpdateRectByMonitors(VRect);
  if EqualRect(BoundsRect, VRect) then begin
    Exit;
  end;
  BoundsRect := VRect;
end;

procedure TfrmMarksExplorer.OnMarksDbChanged;
begin
  UpdateMarksList;
end;

procedure TfrmMarksExplorer.OnMarksShowConfigChanged;
var
  VMarksConfig: IUsedMarksConfigStatic;
begin
  VMarksConfig := FMarksShowConfig.GetStatic;
  if VMarksConfig.IsUseMarks then begin
    if VMarksConfig.IgnoreCategoriesVisible and VMarksConfig.IgnoreMarksVisible then begin
      rgMarksShowMode.ItemIndex := 1;
    end else begin
      rgMarksShowMode.ItemIndex := 0;
    end;
  end else begin
    rgMarksShowMode.ItemIndex := 2;
  end;
end;

procedure TfrmMarksExplorer.OnMarkSystemStateChanged;
begin
  ResetCopyPasteBuffer;
  lblReadOnly.Visible := not FMarkDBGUI.MarksDb.State.GetStatic.WriteAccess;
end;

procedure TfrmMarksExplorer.tbitmAddCategoryClick(Sender: TObject);
var
  VCategory: IMarkCategory;
  VNewName: string;
begin
  VNewName := '';
  VCategory := GetSelectedCategory;
  if VCategory <> nil then begin
    VNewName := VCategory.Name + '\';
  end;

  VCategory := FMarkDBGUI.MarksDb.CategoryDB.Factory.CreateNew(VNewName);
  VCategory := FMarkDBGUI.EditCategoryModal(VCategory, True);
  if VCategory <> nil then begin
    FMarkDBGUI.MarksDb.CategoryDB.UpdateCategory(nil, VCategory);
  end;
end;

procedure TfrmMarksExplorer.tbitmAddMarkClick(Sender: TObject);
var
  VLonLat: TDoublePoint;
  VPointTemplate: IMarkTemplatePoint;
  VTemplateConfig: IMarkPointTemplateConfig;
  VCategory: ICategory;
  VPoint: IGeometryLonLatPoint;
begin
  VLonLat := FViewPortState.GetStatic.GetCenterLonLat;
  VCategory := GetSelectedCategory;
  VPointTemplate := nil;
  if VCategory <> nil then begin
    VTemplateConfig := FMarkDBGUI.MarkFactoryConfig.PointTemplateConfig;
    VPointTemplate := VTemplateConfig.DefaultTemplate;
    VPointTemplate :=
      VTemplateConfig.CreateTemplate(
        VPointTemplate.Appearance,
        VCategory
      );
  end;
  VPoint := FGeometryLonLatFactory.CreateLonLatPoint(VLonLat);
  FMarkDBGUI.SaveMarkModal(nil, VPoint, False, '', VPointTemplate);
end;

procedure TfrmMarksExplorer.tbitmMarkInfoClick(Sender: TObject);
var
  VMark: IVectorDataItem;
begin
  VMark := GetSelectedMarkFull;
  if VMark <> nil then begin
    FMarkDBGUI.ShowMarkInfo(VMark);
  end;
end;

procedure TfrmMarksExplorer.CheckBox2Click(Sender: TObject);
var
  VNewVisible: Boolean;
begin
  if CategoryTreeView.Items.Count > 0 then begin
    VNewVisible := CheckBox2.Checked;
    FMarkDBGUI.MarksDb.CategoryDB.SetAllCategoriesVisible(VNewVisible);
  end;
end;

procedure TfrmMarksExplorer.FormActivate(Sender: TObject);
begin
  OnMarksShowConfigChanged;
end;

procedure TfrmMarksExplorer.FormMove(var Msg: TWMMove);
begin
  Inherited;
  if Assigned(Self.OnResize) then begin
    Self.OnResize(Self);
  end;
end;

procedure TfrmMarksExplorer.CheckBox1Click(Sender: TObject);
var
  VNewVisible: Boolean;
  VCategory: IMarkCategory;
begin
  VCategory := GetSelectedCategory;
  if VCategory <> nil then begin
    VNewVisible := CheckBox1.Checked;
    FMarkDBGUI.MarksDb.MarkDb.SetAllMarksInCategoryVisible(VCategory, VNewVisible);
  end;
end;

procedure TfrmMarksExplorer.FormHide(Sender: TObject);
begin
  Self.OnResize := nil;
  FMarkSystemConfig.ChangeNotifier.Remove(FMarkSystemConfigListener);
  FMarksExplorerConfig.CategoriesWidth := grpCategory.Width;
  FWindowConfig.ChangeNotifier.Remove(FConfigListener);
  FMarkDBGUI.MarksDb.CategoryDB.ChangeNotifier.Remove(FCategoryDBListener);
  FMarkDBGUI.MarksDb.MarkDb.ChangeNotifier.Remove(FMarksDBListener);
  FMarksShowConfig.ChangeNotifier.Remove(FMarksShowConfigListener);
  FMarkDBGUI.MarksDb.State.ChangeNotifier.Remove(FMarksSystemStateListener);
  FSelectedCategoryInfo := GetSelectedNodeInfo(CategoryTreeView);
  FExpandedCategoriesInfo := GetExpandInfo(CategoryTreeView.Items);
  FMarksExplorerConfig.SelectedCategory := ExpandInfoToString(FSelectedCategoryInfo);
  FMarksExplorerConfig.ExpandedCategories := ExpandInfoToString(FExpandedCategoriesInfo);
  CategoryTreeView.OnChange := nil;
  CategoryTreeView.Items.Clear;
  MarksListBox.Items.Clear;
  FCategoryList := nil;
  FMarksList := nil;
  FCopyPasteBuffer := nil;
end;

procedure TfrmMarksExplorer.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 { ESC } then begin
    Close;
  end;
end;

procedure TfrmMarksExplorer.FormResize(Sender: TObject);
begin
  if Self.WindowState = wsNormal then begin
    FWindowConfig.SetWindowPosition(BoundsRect);
  end;
end;

procedure TfrmMarksExplorer.WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
begin
  inherited;
  Msg.MinMaxInfo.ptMinTrackSize.X := 406;
  Msg.MinMaxInfo.ptMinTrackSize.Y := 309;
end;

procedure TfrmMarksExplorer.FormShow(Sender: TObject);
var
  VWidth: Integer;
begin
  UpdateCategoryTree;
  btnNavOnMark.Checked := FNavToPoint.IsActive;
  FMarkSystemConfig.ChangeNotifier.Add(FMarkSystemConfigListener);
  FMarkDBGUI.MarksDb.CategoryDB.ChangeNotifier.Add(FCategoryDBListener);
  FMarkDBGUI.MarksDb.MarkDb.ChangeNotifier.Add(FMarksDBListener);
  FMarksShowConfig.ChangeNotifier.Add(FMarksShowConfigListener);
  FMarkDBGUI.MarksDb.State.ChangeNotifier.Add(FMarksSystemStateListener);
  FWindowConfig.ChangeNotifier.Add(FConfigListener);
  OnConfigChange;
  OnMarkSystemStateChanged;
  OnMarkSystemConfigChange;
  Self.OnResize := FormResize;
  VWidth := FMarksExplorerConfig.CategoriesWidth;
  if VWidth > 0 then begin
    grpCategory.Width := VWidth;
  end;
end;

procedure TfrmMarksExplorer.MarksListBoxContextPopup(
  Sender: TObject;
  MousePos:
  TPoint;
  var Handled: Boolean
);
var
  VNode: TTreeNode;
begin
  if (MousePos.X >= 0) and (MousePos.Y >= 0) then begin
    VNode := MarksListBox.GetNodeAt(MousePos.X, MousePos.Y);
    if VNode <> nil then begin
      MarksListBox.Select(VNode);
    end;
  end;
end;

procedure TfrmMarksExplorer.MarksListBoxDblClick(Sender: TObject);
var
  VMark: IVectorDataItem;
begin
  VMark := GetSelectedMarkFull;
  if Assigned(VMark) and Assigned(VMark.Geometry.Bounds) then begin
    FMapGoto.FitRectToScreen(VMark.Geometry.Bounds.Rect);
    FMapGoto.ShowMarker(VMark.Geometry.GetGoToPoint);
  end;
end;

procedure TfrmMarksExplorer.MarksListBoxKeyDown(
  Sender: TObject;
  var Key: Word;
  Shift: TShiftState
);
var
  VMarkIdList: IInterfaceListStatic;
begin
  if Key = VK_SPACE then begin
    VMarkIdList := GetSelectedMarksIdList;
    if (VMarkIdList <> nil) and (VMarkIdList.Count > 0) then begin
      FMarkDBGUI.MarksDb.MarkDb.ToggleMarkVisibleByIDList(VMarkIdList);
    end;
    Key := 0;
  end else if Key = VK_RETURN then begin
    MarksListBoxDblClick(Sender);
    Key := 0;
  end else if key = VK_DELETE then begin
    VMarkIdList := GetSelectedMarksIdList;
    if VMarkIdList <> nil then begin
      if FMarkDBGUI.DeleteMarksModal(VMarkIdList, Self.Handle) then begin
        MarksListBox.ClearSelection(True);
      end;
    end;
    Key := 0;
  end else if Key = VK_F2 then begin
    btnEditMarkClick(Sender);
    Key := 0;
  end;
end;

procedure TfrmMarksExplorer.MarksListBoxMouseUp(
  Sender: TObject;
  Button: TMouseButton;
  Shift: TShiftState;
  X, Y: Integer
);
var
  VTreeNode: TTreeNode;
  VMarkId: IMarkId;
begin
  if htOnStateIcon in MarksListBox.GetHitTestInfoAt(X, Y) then begin
    VTreeNode := MarksListBox.GetNodeAt(X, Y);
    VMarkId := IMarkId(VTreeNode.Data);
    if VMarkId <> nil then begin
      if VTreeNode.StateIndex = 1 then begin
        FMarkDBGUI.MarksDb.MarkDb.SetMarkVisibleByID(VMarkId, False);
        VTreeNode.StateIndex := 2;
      end else begin
        FMarkDBGUI.MarksDb.MarkDb.SetMarkVisibleByID(VMarkId, True);
        VTreeNode.StateIndex := 1;
      end;
    end;
  end;
end;

procedure TfrmMarksExplorer.rgMarksShowModeClick(Sender: TObject);
begin
  FMarksShowConfig.LockWrite;
  try
    case rgMarksShowMode.ItemIndex of
      0: begin
        FMarksShowConfig.IsUseMarks := True;
        FMarksShowConfig.IgnoreCategoriesVisible := False;
        FMarksShowConfig.IgnoreMarksVisible := False;

      end;
      1: begin
        FMarksShowConfig.IsUseMarks := True;
        FMarksShowConfig.IgnoreCategoriesVisible := True;
        FMarksShowConfig.IgnoreMarksVisible := True;
      end;
    else begin
      FMarksShowConfig.IsUseMarks := False;
    end;
    end;
  finally
    FMarksShowConfig.UnlockWrite;
  end;
end;

procedure TfrmMarksExplorer.tbitmAllVisibleClick(Sender: TObject);
var
  VMarksList: IInterfaceListStatic;
begin
  VMarksList := FMarkDBGUI.MarksDb.MarkDb.GetAllMarkIdList;
  FMarkDBGUI.MarksDb.MarkDb.SetMarkVisibleByIDList(VMarksList, True);
end;

procedure TfrmMarksExplorer.tbpmnCategoriesPopup(Sender: TObject);
begin
  if GetSelectedCategory = nil then begin
    tbitmAddCategory.Caption := _('Add Category');
  end else begin
    tbitmAddCategory.Caption := _('Add SubCategory');
  end;
end;

procedure TfrmMarksExplorer.tbpmnMarksPopup(Sender: TObject);
var
  VMark: IVectorDataItem;
  VLine: IGeometryLonLatMultiLine;
  VPolygon: IGeometryLonLatMultiPolygon;
  VUngroupVisible: Boolean;
  VElevationProfileVisible: Boolean;
  VSelection: IInterfaceListStatic;
begin
  VUngroupVisible := False;
  VElevationProfileVisible := False;

  VSelection := GetSelectedMarksIdList;
  if Assigned(VSelection) and (VSelection.Count = 1) then begin
    VMark := GetSelectedMarkFull;
    if Assigned(VMark) then begin
      if Supports(VMark.Geometry, IGeometryLonLatMultiPolygon, VPolygon) then begin
        VUngroupVisible := (VPolygon.Count > 1);
      end else if Supports(VMark.Geometry, IGeometryLonLatMultiLine, VLine) then begin
        VUngroupVisible := (VLine.Count > 1);
      end;
      VElevationProfileVisible := Supports(VMark.Geometry, IGeometryLonLatLine);
    end;
  end;

  tbxtmUngroup.Visible := VUngroupVisible;
  tbxShowElevProfile.Visible := VElevationProfileVisible;
end;

procedure TfrmMarksExplorer.tbxShowElevProfileClick(Sender: TObject);
var
  VMark: IVectorDataItem;
begin
  VMark := GetSelectedMarkFull;
  if Assigned(VMark) and Supports(VMark.Geometry, IGeometryLonLatLine) then begin
    FMapGoto.FitRectToScreen(VMark.Geometry.Bounds.Rect);
    FElevationProfilePresenter.ShowProfile(VMark);
  end else begin
    Assert(False);
  end;
end;

procedure TfrmMarksExplorer.tbxtmUngroupClick(Sender: TObject);
var
  VMark: IVectorDataItem;
begin
  VMark := GetSelectedMarkFull;
  if Assigned(VMark) then begin
    FMarkDBGUI.SaveMarkUngroupModal(VMark, VMark.Geometry);
  end;
end;

procedure TfrmMarksExplorer.tbxtmAddToMergePolygonsClick(Sender: TObject);
begin
  FMarkDBGUI.AddMarkIdListToMergePolygons(GetSelectedMarksIdList, FMergePolygonsPresenter);
end;

procedure TfrmMarksExplorer.tbxtmCatAddToMergePolygonsClick(Sender: TObject);
begin
  FMarkDBGUI.AddCategoryToMergePolygons(GetSelectedCategory, FMergePolygonsPresenter);
end;

procedure TfrmMarksExplorer.ToggleVisible;
begin
  if (not Self.Visible) or (Self.WindowState = wsMinimized) then begin
    Self.Visible := True;
    Self.WindowState := wsNormal;
  end else begin
    Self.Visible := False;
  end;
end;

procedure TfrmMarksExplorer.tbxConfigListItemClick(Sender: TObject);
var
  VMenuItem: TTBXItem;
  VConfig: IMarkSystemConfigStatic;
begin
  VMenuItem := Sender as TTBXItem;
  if VMenuItem.Checked then begin
    Exit;
  end;
  VConfig := FMarkSystemConfig.GetByID(VMenuItem.Tag);
  FMarkSystemConfig.ActiveConfigID := VConfig.ID;
end;

procedure TfrmMarksExplorer.tbxDeleteClick(Sender: TObject);
var
  VMsg: string;
  VConfig: IMarkSystemConfigStatic;
begin
  VConfig := FMarkSystemConfig.GetActiveConfig;
  VMsg := Format(_('Are you sure you want to delete database "%s"?'), [VConfig.DisplayName]);
  if MessageDlg(VMsg, mtConfirmation, mbYesNo, 0) = mrYes then begin
    FMarkSystemConfig.DeleteByID(VConfig.ID);
  end;
end;

procedure TfrmMarksExplorer.PrepareCopyPasteBuffer(const AAction: TCopyPasteAction);
begin
  FCopyPasteBuffer := GetSelectedMarksIdList;
  if FCopyPasteBuffer <> nil then begin
    tbitmPaste.Visible := True;
    FCopyPasteAction := AAction;
  end else begin
    ResetCopyPasteBuffer;
  end;
end;

procedure TfrmMarksExplorer.ResetCopyPasteBuffer;
begin
  FCopyPasteBuffer := nil;
  tbitmPaste.Visible := False;
  FCopyPasteAction := cpNone;
end;

procedure TfrmMarksExplorer.tbitmCopyAsTextClick(Sender: TObject);
var
  VMarksIdList: IInterfaceListStatic;
begin
  VMarksIdList := GetSelectedMarksIdList;
  if VMarksIdList <> nil then begin
    CopyStringToClipboard(Handle, FMarkDBGUI.MarkIdListToText(VMarksIdList));
  end;
end;

procedure TfrmMarksExplorer.tbitmCopyClick(Sender: TObject);
begin
  PrepareCopyPasteBuffer(cpCopy);
end;

procedure TfrmMarksExplorer.tbitmCutClick(Sender: TObject);
begin
  PrepareCopyPasteBuffer(cpCut);
end;

procedure TfrmMarksExplorer.tbitmPasteClick(Sender: TObject);

  procedure PasteMarks(const AMove: Boolean);
  var
    I: Integer;
    VMarkIdListNew: IInterfaceListSimple;
    VCategoryNew: ICategory;
    VMark: IVectorDataItem;
  begin
    VCategoryNew := GetSelectedCategory;
    if VCategoryNew <> nil then begin
      VMarkIdListNew := TInterfaceListSimple.Create;
      for I := 0 to FCopyPasteBuffer.Count - 1 do begin
        VMark := FMarkDBGUI.MarksDb.MarkDb.GetMarkByID(IMarkId(FCopyPasteBuffer.Items[I]));
        VMarkIdListNew.Add(FMarkDBGUI.MarksDb.MarkDb.Factory.ReplaceCategory(VMark, VCategoryNew));
      end;
      if AMove then begin
        FMarkDBGUI.MarksDb.MarkDb.UpdateMarkList(FCopyPasteBuffer, VMarkIdListNew.MakeStaticAndClear);
      end else begin
        FMarkDBGUI.MarksDb.MarkDb.UpdateMarkList(nil, VMarkIdListNew.MakeStaticAndClear);
      end;
    end;
  end;

begin
  Assert(FCopyPasteBuffer <> nil);

  case FCopyPasteAction of
    cpCopy: PasteMarks(False);
    cpCut: PasteMarks(True);
  else
    Assert(False);
  end;

  ResetCopyPasteBuffer;
  UpdateMarksList;
end;

procedure TfrmMarksExplorer.tbxEditClick(Sender: TObject);
begin
  FfrmMarkSystemConfigEdit.EditActiveDatabaseConfig;
end;

procedure TfrmMarksExplorer.tbxAddClick(Sender: TObject);
begin
  FfrmMarkSystemConfigEdit.AddNewDatabaseConfig;
end;

procedure TfrmMarksExplorer.OnMarkSystemConfigChange;
var
  VIsEnabled: Boolean;
begin
  RefreshConfigListMenu(
    tbxConfigList,
    True,
    Self.tbxConfigListItemClick,
    FMarkSystemConfig
  );

  VIsEnabled := tbxConfigList.Enabled;

  tbxEdit.Enabled := VIsEnabled;
  tbxDelete.Enabled := VIsEnabled;
end;

end.
