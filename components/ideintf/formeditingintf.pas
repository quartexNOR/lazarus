{
 *****************************************************************************
  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************

  Author: Shane Miller, Mattias Gaertner

  Abstract:
    Methods to access the form editing of the IDE.
}
unit FormEditingIntf;

{$mode objfpc}{$H+}

interface

uses
  Math, Classes, SysUtils, LCLProc, TypInfo, types, Forms, Controls,
  LCLClasses, ProjectIntf, ComponentEditors, ObjectInspector, UnitResources;
  
const
  ComponentPaletteImageWidth = 24;
  ComponentPaletteImageHeight = 24;
  ComponentPaletteBtnWidth  = ComponentPaletteImageWidth + 3;
  ComponentPaletteBtnHeight = ComponentPaletteImageHeight + 3;

type
  TDMCompAtPosFlag = (
    dmcapfOnlyVisible,
    dmcapfOnlySelectable
    );
  TDMCompAtPosFlags = set of TDMCompAtPosFlag;

  { TDesignerMediator
    To edit designer forms which do not use the LCL, register a TDesignerMediator,
    which will emulate the painting, handle the mouse and editing bounds. }

  TDesignerMediator = class(TComponent)
  private
    FDesigner: TComponentEditorDesigner;
    FLCLForm: TForm;
    FRoot: TComponent;
  protected
    FCollectedChildren: TFPList;
    procedure SetDesigner(const AValue: TComponentEditorDesigner); virtual;
    procedure SetLCLForm(const AValue: TForm); virtual;
    procedure SetRoot(const AValue: TComponent); virtual;
    procedure CollectChildren(Child: TComponent); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    class function FormClass: TComponentClass; virtual; abstract;
    class function CreateMediator(TheOwner, aForm: TComponent): TDesignerMediator; virtual;
    class procedure InitFormInstance({%H-}aForm: TComponent); virtual; // called after NewInstance, before constructor
  public
    procedure SetBounds(AComponent: TComponent; NewBounds: TRect); virtual;
    procedure GetBounds(AComponent: TComponent; out CurBounds: TRect); virtual;
    procedure SetFormBounds(RootComponent: TComponent; NewBounds, ClientRect: TRect); virtual;
    procedure GetFormBounds(RootComponent: TComponent; out CurBounds, CurClientRect: TRect); virtual;
    procedure GetClientArea(AComponent: TComponent; out CurClientArea: TRect;
                            out ScrollOffset: TPoint); virtual;
    function GetComponentOriginOnForm(AComponent: TComponent): TPoint; virtual;
    function ComponentIsIcon({%H-}AComponent: TComponent): boolean; virtual;
    function ParentAcceptsChild({%H-}Parent: TComponent; {%H-}Child: TComponentClass): boolean; virtual;
    function ComponentIsVisible({%H-}AComponent: TComponent): Boolean; virtual;
    function ComponentIsSelectable({%H-}AComponent: TComponent): Boolean; virtual;
    function ComponentAtPos(p: TPoint; MinClass: TComponentClass;
                            Flags: TDMCompAtPosFlags): TComponent; virtual;
    procedure GetChildComponents(Parent: TComponent; ChildComponents: TFPList); virtual;
    function UseRTTIForMethods({%H-}aComponent: TComponent): boolean; virtual; // false = use sources

    // events
    procedure InitComponent(AComponent, NewParent: TComponent; NewBounds: TRect); virtual;
    procedure Paint; virtual;
    procedure KeyDown(Sender: TControl; var {%H-}Key: word; {%H-}Shift: TShiftState); virtual;
    procedure KeyUp(Sender: TControl; var {%H-}Key: word; {%H-}Shift: TShiftState); virtual;
    procedure MouseDown({%H-}Button: TMouseButton; {%H-}Shift: TShiftState; {%H-}p: TPoint; var {%H-}Handled: boolean); virtual;
    procedure MouseMove({%H-}Shift: TShiftState; {%H-}p: TPoint; var {%H-}Handled: boolean); virtual;
    procedure MouseUp({%H-}Button: TMouseButton; {%H-}Shift: TShiftState; {%H-}p: TPoint; var {%H-}Handled: boolean); virtual;
    procedure GetObjInspNodeImageIndex({%H-}APersistent: TPersistent; var {%H-}AIndex: integer); virtual;

    property LCLForm: TForm read FLCLForm write SetLCLForm;
    property Designer: TComponentEditorDesigner read FDesigner write SetDesigner;
    property Root: TComponent read FRoot write SetRoot;
  end;
  TDesignerMediatorClass = class of TDesignerMediator;


  { TAbstractFormEditor }
  
  TAbstractFormEditor = class
  protected
    function GetDesignerBaseClasses(Index: integer): TComponentClass; virtual; abstract;
    function GetDesigner(Index: integer): TIDesigner; virtual; abstract;
    function GetDesignerMediators(Index: integer): TDesignerMediatorClass; virtual; abstract;
  public
    // persistent
    procedure RegisterDefineProperty(const APersistentClassName,
                                     Identifier: string); virtual; abstract;

    // components
    function FindComponentByName(const Name: ShortString
                                 ): TComponent; virtual; abstract;

    function CreateUniqueComponentName(AComponent: TComponent): string; virtual; abstract;
    function CreateUniqueComponentName(const AClassName: string;
                                       OwnerComponent: TComponent): string; virtual; abstract;
    function GetDefaultComponentParent(TypeClass: TComponentClass
                                       ): TComponent; virtual; abstract;
    function GetDefaultComponentPosition(TypeClass: TComponentClass;
                                         ParentComp: TComponent;
                                         var X,Y: integer): boolean; virtual; abstract;
    function CreateComponent(ParentComp: TComponent;
                             TypeClass: TComponentClass;
                             const AUnitName: shortstring;
                             X,Y,W,H: Integer;
                             DisableAutoSize: boolean): TComponent; virtual; abstract;
    function CreateComponentFromStream(BinStream: TStream;
                      UnitResourcefileFormat: TUnitResourcefileFormatClass;
                      AncestorType: TComponentClass;
                      const NewUnitName: ShortString;
                      Interactive: boolean;
                      Visible: boolean = true;
                      DisableAutoSize: boolean = false;
                      ContextObj: TObject = nil): TComponent; virtual; abstract;
    procedure CreateChildComponentsFromStream(BinStream: TStream;
                       ComponentClass: TComponentClass; Root: TComponent;
                       ParentControl: TWinControl; NewComponents: TFPList); virtual; abstract;

    // ancestors
    function GetAncestorLookupRoot(AComponent: TComponent): TComponent; virtual; abstract;
    function GetAncestorInstance(AComponent: TComponent): TComponent; virtual; abstract;
    function RegisterDesignerBaseClass(AClass: TComponentClass): integer; virtual; abstract;
    function DesignerBaseClassCount: Integer; virtual; abstract;
    property DesignerBaseClasses[Index: integer]: TComponentClass read GetDesignerBaseClasses;
    procedure UnregisterDesignerBaseClass(AClass: TComponentClass); virtual; abstract;
    function IndexOfDesignerBaseClass(AClass: TComponentClass): integer; virtual; abstract;
    function DescendFromDesignerBaseClass(AClass: TComponentClass): integer; virtual; abstract;
    function FindDesignerBaseClassByName(const AClassName: shortstring; WithDefaults: boolean): TComponentClass; virtual; abstract;

    // designers
    function DesignerCount: integer; virtual; abstract;
    property Designer[Index: integer]: TIDesigner read GetDesigner;
    function GetCurrentDesigner: TIDesigner; virtual; abstract;
    function GetDesignerForm(APersistent: TPersistent): TCustomForm; virtual; abstract;
    function GetDesignerByComponent(AComponent: TComponent
                                    ): TIDesigner; virtual; abstract;

    // mediators for non LCL forms
    procedure RegisterDesignerMediator(MediatorClass: TDesignerMediatorClass); virtual; abstract; // auto calls RegisterDesignerBaseClass
    procedure UnregisterDesignerMediator(MediatorClass: TDesignerMediatorClass); virtual; abstract; // auto calls UnregisterDesignerBaseClass
    function DesignerMediatorCount: integer; virtual; abstract;
    property DesignerMediators[Index: integer]: TDesignerMediatorClass read GetDesignerMediators;
    function GetDesignerMediatorByComponent(AComponent: TComponent): TDesignerMediator; virtual; abstract;

    // selection
    function SaveSelectionToStream(s: TStream): Boolean; virtual; abstract;
    function InsertFromStream(s: TStream; Parent: TWinControl;
                              Flags: TComponentPasteSelectionFlags
                              ): Boolean; virtual; abstract;
    function ClearSelection: Boolean; virtual; abstract;
    function DeleteSelection: Boolean; virtual; abstract;
    function CopySelectionToClipboard: Boolean; virtual; abstract;
    function CutSelectionToClipboard: Boolean; virtual; abstract;
    function PasteSelectionFromClipboard(Flags: TComponentPasteSelectionFlags
                                         ): Boolean; virtual; abstract;

    function GetCurrentObjectInspector: TObjectInspectorDlg; virtual; abstract;
  end;

type
  TDesignerIDECommandForm = class(TCustomForm)
    // dummy form class, used by the IDE commands for keys in the designers
  end;

var
  FormEditingHook: TAbstractFormEditor; // will be set by the IDE

procedure GetComponentLeftTopOrDesignInfo(AComponent: TComponent; out aLeft, aTop: integer); // get properties if exists, otherwise get DesignInfo
procedure SetComponentLeftTopOrDesignInfo(AComponent: TComponent; aLeft, aTop: integer); // set properties if exists, otherwise set DesignInfo
function TrySetOrdProp(Instance: TPersistent; const PropName: string;
                       Value: integer): boolean;
function TryGetOrdProp(Instance: TPersistent; const PropName: string;
                       out Value: integer): boolean;
function LeftFromDesignInfo(ADesignInfo: LongInt): SmallInt; inline;
function TopFromDesignInfo(ADesignInfo: LongInt): SmallInt; inline;
procedure SetDesignInfoLeft(AComponent: TComponent; const aLeft: SmallInt); inline;
procedure SetDesignInfoTop(AComponent: TComponent; const aTop: SmallInt); inline;
function LeftTopToDesignInfo(const ALeft, ATop: SmallInt): LongInt; inline;
procedure DesignInfoToLeftTop(ADesignInfo: LongInt; out ALeft, ATop: SmallInt); inline;

implementation


procedure GetComponentLeftTopOrDesignInfo(AComponent: TComponent; out aLeft,
  aTop: integer);
var
  Info: LongInt;
begin
  Info:=AComponent.DesignInfo;
  if not TryGetOrdProp(AComponent,'Left',aLeft) then
    aLeft:=LeftFromDesignInfo(Info);
  if not TryGetOrdProp(AComponent,'Top',aTop) then
    aTop:=TopFromDesignInfo(Info);
end;

procedure SetComponentLeftTopOrDesignInfo(AComponent: TComponent;
  aLeft, aTop: integer);
var
  HasLeft: Boolean;
  HasTop: Boolean;
begin
  HasLeft:=TrySetOrdProp(AComponent,'Left',aLeft);
  HasTop:=TrySetOrdProp(AComponent,'Top',aTop);
  if HasLeft and HasTop then exit;
  ALeft := Max(Low(SmallInt), Min(ALeft, High(SmallInt)));
  ATop := Max(Low(SmallInt), Min(ATop, High(SmallInt)));
  AComponent.DesignInfo:=LeftTopToDesignInfo(aLeft,aTop);
end;

function TrySetOrdProp(Instance: TPersistent; const PropName: string;
  Value: integer): boolean;
var
  PropInfo: PPropInfo;
begin
  PropInfo:=GetPropInfo(Instance.ClassType,PropName);
  if PropInfo=nil then exit(false);
  SetOrdProp(Instance,PropInfo,Value);
  Result:=true;
end;

function TryGetOrdProp(Instance: TPersistent; const PropName: string; out
  Value: integer): boolean;
var
  PropInfo: PPropInfo;
begin
  PropInfo:=GetPropInfo(Instance.ClassType,PropName);
  if PropInfo=nil then exit(false);
  Value:=GetOrdProp(Instance,PropInfo);
  Result:=true;
end;

function LeftFromDesignInfo(ADesignInfo: LongInt): SmallInt;
begin
  Result := LazLongRec(ADesignInfo).Lo;
end;

function TopFromDesignInfo(ADesignInfo: LongInt): SmallInt;
begin
  Result := LazLongRec(ADesignInfo).Hi;
end;

procedure SetDesignInfoLeft(AComponent: TComponent; const aLeft: SmallInt);
var
  DesignInfo: LongInt;
begin
  DesignInfo:=AComponent.DesignInfo;
  LazLongRec(DesignInfo).Lo:=ALeft;
  AComponent.DesignInfo:=DesignInfo;
end;

procedure SetDesignInfoTop(AComponent: TComponent; const aTop: SmallInt);
var
  DesignInfo: LongInt;
begin
  DesignInfo:=AComponent.DesignInfo;
  LazLongRec(DesignInfo).Hi:=aTop;
  AComponent.DesignInfo:=DesignInfo;
end;

function LeftTopToDesignInfo(const ALeft, ATop: SmallInt): LongInt;
begin
  LazLongRec(Result).Lo:=ALeft;
  LazLongRec(Result).Hi:=ATop;
end;

procedure DesignInfoToLeftTop(ADesignInfo: LongInt; out ALeft, ATop: SmallInt);
begin
  ALeft := LazLongRec(ADesignInfo).Lo;
  ATop := LazLongRec(ADesignInfo).Hi;
end;

{ TDesignerMediator }

procedure TDesignerMediator.SetRoot(const AValue: TComponent);
begin
  if FRoot=AValue then exit;
  if FRoot<>nil then
    FRoot.RemoveFreeNotification(Self);
  FRoot:=AValue;
  if FRoot<>nil then
    FRoot.FreeNotification(Self);
end;

procedure TDesignerMediator.CollectChildren(Child: TComponent);
begin
  FCollectedChildren.Add(Child);
end;

procedure TDesignerMediator.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation=opRemove then begin
    if AComponent=FLCLForm then FLCLForm:=nil;
    if AComponent=FRoot then FRoot:=nil;
  end;
end;

class function TDesignerMediator.CreateMediator(TheOwner, aForm: TComponent
  ): TDesignerMediator;
begin
  Result:=Create(TheOwner);
  Result.FRoot:=aForm;
end;

procedure TDesignerMediator.SetDesigner(const AValue: TComponentEditorDesigner);
begin
  if FDesigner=AValue then exit;
  if FDesigner<>nil then begin

  end;
  FDesigner:=AValue;
end;

procedure TDesignerMediator.SetLCLForm(const AValue: TForm);
begin
  if FLCLForm=AValue then exit;
  if FLCLForm<>nil then
    FLCLForm.RemoveFreeNotification(Self);
  FLCLForm:=AValue;
  if FLCLForm<>nil then
    FLCLForm.FreeNotification(Self);
end;

class procedure TDesignerMediator.InitFormInstance(aForm: TComponent);
begin

end;

procedure TDesignerMediator.SetBounds(AComponent: TComponent; NewBounds: TRect);
begin
  SetComponentLeftTopOrDesignInfo(AComponent,NewBounds.Left,NewBounds.Top);
end;

procedure TDesignerMediator.GetBounds(AComponent: TComponent; out
  CurBounds: TRect);
var
  aLeft: integer;
  aTop: integer;
begin
  GetComponentLeftTopOrDesignInfo(AComponent,aLeft,aTop);
  CurBounds:=Rect(aLeft,aTop,aLeft+ComponentPaletteBtnWidth,aTop+ComponentPaletteBtnHeight);
end;

procedure TDesignerMediator.SetFormBounds(RootComponent: TComponent; NewBounds,
  ClientRect: TRect);
// default: use NewBounds as position and the ClientRect as size
var
  r: TRect;
begin
  r:=Bounds(NewBounds.Left,NewBounds.Top,
            ClientRect.Right-ClientRect.Left,ClientRect.Bottom-ClientRect.Top);
  //debugln(['TDesignerMediator.SetFormBounds NewBounds=',dbgs(NewBounds),' ClientRect=',dbgs(ClientRect),' r=',dbgs(r)]);
  SetBounds(RootComponent,r);
end;

procedure TDesignerMediator.GetFormBounds(RootComponent: TComponent; out
  CurBounds, CurClientRect: TRect);
// default: clientarea is whole bounds and CurBounds.Width/Height=0
// The IDE will use the clientarea to determine the size of the form
begin
  GetBounds(RootComponent,CurBounds);
  //debugln(['TDesignerMediator.GetFormBounds ',dbgs(CurBounds)]);
  CurClientRect:=Rect(0,0,CurBounds.Right-CurBounds.Left,
                      CurBounds.Bottom-CurBounds.Top);
  CurBounds.Right:=CurBounds.Left;
  CurBounds.Bottom:=CurBounds.Top;
  //debugln(['TDesignerMediator.GetFormBounds ',dbgs(CurBounds),' ',dbgs(CurClientRect)]);
end;

procedure TDesignerMediator.GetClientArea(AComponent: TComponent; out
  CurClientArea: TRect; out ScrollOffset: TPoint);
// default: no ScrollOffset and client area is whole bounds
begin
  GetBounds(AComponent,CurClientArea);
  OffsetRect(CurClientArea,-CurClientArea.Left,-CurClientArea.Top);
  ScrollOffset:=Point(0,0);
end;

function TDesignerMediator.GetComponentOriginOnForm(AComponent: TComponent): TPoint;
var
  Parent: TComponent;
  ClientArea: TRect;
  ScrollOffset: TPoint;
  CurBounds: TRect;
begin
  if ComponentIsIcon(AComponent) then
  begin
    Result.X := LeftFromDesignInfo(AComponent.DesignInfo);
    Result.Y := TopFromDesignInfo(AComponent.DesignInfo);
    Exit;
  end;
  Result:=Point(0,0);
  while AComponent<>nil do begin
    Parent:=AComponent.GetParentComponent;
    if Parent=nil then break;
    GetBounds(AComponent,CurBounds);
    inc(Result.X,CurBounds.Left);
    inc(Result.Y,CurBounds.Top);
    GetClientArea(Parent,ClientArea,ScrollOffset);
    inc(Result.X,ClientArea.Left+ScrollOffset.X);
    inc(Result.Y,ClientArea.Top+ScrollOffset.Y);
    AComponent:=Parent;
  end;
end;

procedure TDesignerMediator.Paint;
begin

end;

function TDesignerMediator.ComponentIsIcon(AComponent: TComponent): boolean;
begin
  Result:=true;
end;

function TDesignerMediator.ParentAcceptsChild(Parent: TComponent;
  Child: TComponentClass): boolean;
begin
  Result:=false;
end;

function TDesignerMediator.ComponentIsVisible(AComponent: TComponent): Boolean;
begin
  Result:=true;
end;

function TDesignerMediator.ComponentIsSelectable(AComponent: TComponent
  ): Boolean;
begin
  Result:=true;
end;

function TDesignerMediator.ComponentAtPos(p: TPoint; MinClass: TComponentClass;
  Flags: TDMCompAtPosFlags): TComponent;
var
  i: Integer;
  Child: TComponent;
  ClientArea: TRect;
  ScrollOffset: TPoint;
  ChildBounds: TRect;
  Found: Boolean;
  Children: TFPList;
  Offset: TPoint;
begin
  Result:=Root;
  while Result<>nil do begin
    GetClientArea(Result,ClientArea,ScrollOffset);
    Offset:=GetComponentOriginOnForm(Result);
    //DebugLn(['TDesignerMediator.ComponentAtPos Parent=',DbgSName(Result),' Offset=',dbgs(Offset)]);
    OffsetRect(ClientArea,Offset.X,Offset.Y);
    Children:=TFPList.Create;
    try
      GetChildComponents(Result,Children);
      //DebugLn(['TDesignerMediator.ComponentAtPos Result=',DbgSName(Result),' ChildCount=',children.Count,' ClientArea=',dbgs(ClientArea)]);
      Found:=false;
      // iterate backwards (z-order)
      for i:=Children.Count-1 downto 0 do begin
        Child:=TComponent(Children[i]);
        //DebugLn(['TDesignerMediator.ComponentAtPos Child ',DbgSName(Child)]);
        if (MinClass<>nil) and (not Child.InheritsFrom(MinClass)) then
          continue;
        if (dmcapfOnlyVisible in Flags) and (not ComponentIsVisible(Child)) then
          continue;
        if (dmcapfOnlySelectable in Flags)
        and (not ComponentIsSelectable(Child)) then
          continue;
        GetBounds(Child,ChildBounds);
        if ComponentIsIcon(Child) then
          OffsetRect(ChildBounds,ScrollOffset.X,
                               ScrollOffset.Y)
        else
          OffsetRect(ChildBounds,ClientArea.Left+ScrollOffset.X,
                                 ClientArea.Top+ScrollOffset.Y);
        //DebugLn(['TDesignerMediator.ComponentAtPos ChildBounds=',dbgs(ChildBounds),' p=',dbgs(p)]);
        if PtInRect(ChildBounds,p) then begin
          Found:=true;
          Result:=Child;
          break;
        end;
      end;
      if not Found then exit;
    finally
      Children.Free;
    end;
  end;
end;

procedure TDesignerMediator.GetChildComponents(Parent: TComponent;
  ChildComponents: TFPList);
begin
  FCollectedChildren:=ChildComponents;
  try
    TDesignerMediator(Parent).GetChildren(@CollectChildren,Root);
  finally
    FCollectedChildren:=nil;
  end;
end;

function TDesignerMediator.UseRTTIForMethods(aComponent: TComponent): boolean;
begin
  Result:=false;
end;

procedure TDesignerMediator.InitComponent(AComponent, NewParent: TComponent;
  NewBounds: TRect);
begin
  SetBounds(AComponent,NewBounds);
  TDesignerMediator(AComponent).SetParentComponent(NewParent);
end;

procedure TDesignerMediator.KeyDown(Sender: TControl; var Key: word;
  Shift: TShiftState);
begin

end;

procedure TDesignerMediator.KeyUp(Sender: TControl; var Key: word;
  Shift: TShiftState);
begin

end;

procedure TDesignerMediator.MouseDown(Button: TMouseButton; Shift: TShiftState;
  p: TPoint; var Handled: boolean);
begin

end;

procedure TDesignerMediator.MouseMove(Shift: TShiftState; p: TPoint;
  var Handled: boolean);
begin

end;

procedure TDesignerMediator.MouseUp(Button: TMouseButton; Shift: TShiftState;
  p: TPoint; var Handled: boolean);
begin

end;

procedure TDesignerMediator.GetObjInspNodeImageIndex(APersistent: TPersistent;
  var AIndex: integer);
begin

end;

end.

