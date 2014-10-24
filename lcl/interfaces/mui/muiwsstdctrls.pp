{ $Id: Muiwsstdctrls.pp 5319 2004-03-17 20:11:29Z marc $}
{
 *****************************************************************************
 *                              ArosGadWSStdCtrls.pp                              *
 *                              ---------------                              * 
 *                                                                           *
 *                                                                           *
 *****************************************************************************

 *****************************************************************************
 *                                                                           *
 *  This file is part of the Lazarus Component Library (LCL)                 *
 *                                                                           *
 *  See the file COPYING.LCL, included in this distribution,                 *
 *  for details about the copyright.                                         *
 *                                                                           *
 *  This program is distributed in the hope that it will be useful,          *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     *
 *                                                                           *
 *****************************************************************************
}
unit MuiWSStdCtrls;

{$mode objfpc}{$H+}

interface

uses
  // Bindings
  exec, intuition, agraphics, gadtools, utility, tagsarray, mui,
  // LCL
  Classes, StdCtrls, Controls, LCLType, sysutils,
  //
  MUIBaseUnit, MuiStdCtrls,
  // Widgetset
  WSStdCtrls, WSLCLClasses;

type
  { TMUIWSScrollBar }

  TMUIWSScrollBar = class(TWSScrollBar)
  private
  protected
  public
  end;

  { TMUIWSCustomGroupBox }

  TMUIWSCustomGroupBox = class(TWSCustomGroupBox)
  private
  protected
  published
    class function  CreateHandle(const AWinControl: TWinControl;
      const AParams: TCreateParams): TLCLIntfHandle; override;
    class procedure DestroyHandle(const AWinControl: TWinControl); override;
  end;

  { TMUIWSGroupBox }

  TMUIWSGroupBox = class(TWSCustomGroupBox)
  private
  protected
  public
  end;

  { TMUIWSCustomComboBox }

  TMUIWSCustomComboBox = class(TWSCustomComboBox)
  private
  protected
  published
    class function  CreateHandle(const AWinControl: TWinControl;
      const AParams: TCreateParams): TLCLIntfHandle; override;
    class procedure DestroyHandle(const AWinControl: TWinControl); override;

    class function  GetItemIndex(const ACustomComboBox: TCustomComboBox): integer; override;
    class procedure SetItemIndex(const ACustomComboBox: TCustomComboBox; NewIndex: integer); override;
    class function  GetText(const AWinControl: TWinControl; var AText: String): Boolean; override;
    class procedure SetText(const AWinControl: TWinControl; const AText: String); override;

    class function  GetItems(const ACustomComboBox: TCustomComboBox): TStrings; override;
    class procedure FreeItems(var AItems: TStrings); override;
  end;

  { TMUIWSComboBox }

  TMUIWSComboBox = class(TWSComboBox)
  private
  protected
  public
  end;

  { TMUIWSCustomListBox }

  TMUIWSCustomListBox = class(TWSCustomListBox)
  private
  protected
  published
    class function  CreateHandle(const AWinControl: TWinControl;
      const AParams: TCreateParams): TLCLIntfHandle; override;
    class function  GetStrings(const ACustomListBox: TCustomListBox
                            ): TStrings; override;
    class procedure FreeStrings(var AStrings: TStrings); override;
    class procedure SetItemIndex(const ACustomListBox: TCustomListBox; const AIndex: integer); override;
    class function  GetItemIndex(const ACustomListBox: TCustomListBox): integer; override;
  end;

  { TMUIWSListBox }

  TMUIWSListBox = class(TWSListBox)
  private
  protected
  public
  end;

  { TMUIWSCustomEdit }

  TMUIWSCustomEdit = class(TWSCustomEdit)
  private
  protected
  published
    class function CreateHandle(const AWinControl: TWinControl;
          const AParams: TCreateParams): TLCLIntfHandle; override;
    class procedure DestroyHandle(const AWinControl: TWinControl); override;
    class function  GetText(const AWinControl: TWinControl; var AText: String): Boolean; override;
    class procedure SetText(const AWinControl: TWinControl; const AText: String); override;
  public
  end;

  { TMUIWSCustomMemo }

  TMUIWSCustomMemo = class(TWSCustomMemo)
  private
  protected
  published
    class function CreateHandle(const AWinControl: TWinControl;
          const AParams: TCreateParams): TLCLIntfHandle; override;
    class procedure DestroyHandle(const AWinControl: TWinControl); override;
{    class procedure AppendText(const ACustomMemo: TCustomMemo; const AText: string); override;
    class procedure SetAlignment(const ACustomMemo: TCustomMemo; const AAlignment: TAlignment); override;}
    class function GetStrings(const ACustomMemo: TCustomMemo): TStrings; override;
    class procedure FreeStrings(var AStrings: TStrings); override;
    class function  GetText(const AWinControl: TWinControl; var AText: String): Boolean; override;
    class procedure SetText(const AWinControl: TWinControl; const AText: String); override;
  end;

  { TMUIWSEdit }

  TMUIWSEdit = class(TWSEdit)
  private
  protected
  public
  end;

  { TMUIWSMemo }

  TMUIWSMemo = class(TWSMemo)
  private
  protected
  public
  end;

  { TMUIWSButtonControl }

  TMUIWSButtonControl = class(TWSButtonControl)
  private
  protected
  public
  end;

  { TMUIWSButton }

  TMUIWSButton = class(TWSButton)
  private
  protected
  published
    class function  CreateHandle(const AWinControl: TWinControl; const AParams: TCreateParams): TLCLIntfHandle; override;
    class procedure DestroyHandle(const AWinControl: TWinControl); override;
    class procedure Invalidate(const AWinControl: TWinControl); override;
    class function  GetText(const AWinControl: TWinControl; var AText: String): Boolean; override;
    class procedure SetText(const AWinControl: TWinControl; const AText: String); override;
  end;

  { TMUIWSCustomCheckBox }

  TMUIWSCustomCheckBox = class(TWSCustomCheckBox)
  private
  protected
  published
    class function  CreateHandle(const AWinControl: TWinControl;
      const AParams: TCreateParams): TLCLIntfHandle; override;
    class procedure DestroyHandle(const AWinControl: TWinControl); override;

    class function  RetrieveState(const ACustomCheckBox: TCustomCheckBox): TCheckBoxState; override;
    class procedure SetState(const ACustomCheckBox: TCustomCheckBox; const NewState: TCheckBoxState); override;
    class function  GetText(const AWinControl: TWinControl; var AText: String): Boolean; override;
    class procedure SetText(const AWinControl: TWinControl; const AText: String); override;
    class procedure GetPreferredSize(const AWinControl: TWinControl;
                             var PreferredWidth, PreferredHeight: integer;
                             WithThemeSpace: Boolean); override;
  end;

  { TMUIWSCheckBox }

  TMUIWSCheckBox = class(TWSCheckBox)
  private
  protected
  public
  end;

  { TMUIWSToggleBox }

  TMUIWSToggleBox = class(TWSToggleBox)
  private
  protected
  public
  published
    class function  CreateHandle(const AWinControl: TWinControl;
      const AParams: TCreateParams): TLCLIntfHandle; override;
    class procedure DestroyHandle(const AWinControl: TWinControl); override;
  end;

  { TMUIWSRadioButton }

  TMUIWSRadioButton = class(TWSRadioButton)
  private
  protected
  published
    class function  CreateHandle(const AWinControl: TWinControl;
      const AParams: TCreateParams): TLCLIntfHandle; override;
    class procedure DestroyHandle(const AWinControl: TWinControl); override;
  end;

  { TMUIWSCustomStaticText }

  TMUIWSCustomStaticText = class(TWSCustomStaticText)
  private
  protected
  published
    class function  CreateHandle(const AWinControl: TWinControl;
      const AParams: TCreateParams): TLCLIntfHandle; override;
    class procedure DestroyHandle(const AWinControl: TWinControl); override;
    class function  GetText(const AWinControl: TWinControl; var AText: String): Boolean; override;
    class procedure SetText(const AWinControl: TWinControl; const AText: String); override;
  end;

  { TMUIWSStaticText }

  TMUIWSStaticText = class(TWSStaticText)
  private
  protected
  public
  end;


implementation

uses
  MuiStringsUnit;

{ TMUIWSCustomStaticText }

class function TMUIWSCustomStaticText.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): TLCLIntfHandle;
var
  MuiLabel: TMuiText;
  TagList: TTagsList;
begin
  //writeln('-->Create Label');

  MuiLabel := TMuiText.Create(TagList);
  With MuiLabel do
  begin
    Left := AParams.X;
    Top := AParams.Y;
    Width := AParams.Width;
    Height := AParams.Height;
    PasObject := AWinControl;
    Caption := PChar(AParams.Caption);
  end;

  if AWinControl.Parent <> NIL then
  begin
    MuiLabel.Parent := TMuiObject(AWinControl.Parent.Handle);
  end;
  //
  Result := TLCLIntfHandle(MuiLabel);
  //
end;

class procedure TMUIWSCustomStaticText.DestroyHandle(const AWinControl: TWinControl
  );
begin
  TMuiObject(AWinControl.Handle).Free;
  AWinControl.Handle := 0;
end;

class function TMUIWSCustomStaticText.GetText(const AWinControl: TWinControl;
  var AText: String): Boolean;
begin
  Result := True;
  AText := TMuiArea(AWinControl.Handle).Caption;
end;

class procedure TMUIWSCustomStaticText.SetText(const AWinControl: TWinControl;
  const AText: String);
begin
  TMuiArea(AWinControl.Handle).Caption := AText;
end;

{ TMUIWSCustomComboBox }

{------------------------------------------------------------------------------
  Method: TMUIWSCustomComboBox.CreateHandle
  Params:  None
  Returns: Nothing

  Allocates memory and resources for the control and shows it
 ------------------------------------------------------------------------------}
class function TMUIWSCustomComboBox.CreateHandle(
  const AWinControl: TWinControl; const AParams: TCreateParams): TLCLIntfHandle;
var
  MuiCycle: TMuiCycle;
begin
  //writeln('-->Create ComboBox');
  MuiCycle := TMuiCycle.Create(PChar(AWinControl.Caption), TCustomComboBox(AWinControl).items);
  With MuiCycle do
  begin
    Left := AParams.X;
    Top := AParams.Y;
    Width := AParams.Width;
    Height := AParams.Height;
    PasObject := AWinControl;
  end;

  if AWinControl.Parent <> NIL then
  begin
    MuiCycle.Parent := TMuiObject(AWinControl.Parent.Handle);
  end;
  //
  Result := TLCLIntfHandle(MuiCycle);
  //
end;

{------------------------------------------------------------------------------
  Method: TMUIWSCustomComboBox.DestroyHandle
  Params:  None
  Returns: Nothing

  Releases allocated memory and resources
 ------------------------------------------------------------------------------}
class procedure TMUIWSCustomComboBox.DestroyHandle(const AWinControl: TWinControl);
begin
  TMuiCycle(AWinControl.Handle).Free;
  AWinControl.Handle := 0;
end;

{------------------------------------------------------------------------------
  Method: TMUIWSCustomComboBox.GetItemIndex
  Params:  None
  Returns: The state of the control
 ------------------------------------------------------------------------------}
class function TMUIWSCustomComboBox.GetItemIndex(
  const ACustomComboBox: TCustomComboBox): integer;
begin
  Result := TMuiCycle(ACustomComboBox.Handle).Active;
end;

{------------------------------------------------------------------------------
  Method: TMUIWSCustomComboBox.SetItemIndex
  Params:  Item index in combo
  Returns: Nothing
 ------------------------------------------------------------------------------}
class procedure TMUIWSCustomComboBox.SetItemIndex(
  const ACustomComboBox: TCustomComboBox; NewIndex: integer);
begin
   TMuiCycle(ACustomComboBox.Handle).Active := NewIndex;
end;

class function TMUIWSCustomComboBox.GetText(const AWinControl: TWinControl;
  var AText: String): Boolean;
var
  MuiCycle: TMuiCycle;
  ItemIndex: Integer;
begin
  Result := False;
  MuiCycle := TMuiCycle(AWinControl.Handle);
  ItemIndex:= MuiCycle.Active;
  if (ItemIndex >= 0) and (ItemIndex < MuiCycle.Strings.Count) then
  begin
    AText := string(MuiCycle.Strings.strings[ItemIndex]);
    Result := True;
  end;
end;

class procedure TMUIWSCustomComboBox.SetText(const AWinControl: TWinControl;
  const AText: String);
var
  MuiCycle: TMuiCycle;
  idx: LongInt;
begin
  MuiCycle := TMuiCycle(AWinControl.Handle);
  idx := MuiCycle.Strings.IndexOf(AText);
  if Idx >= 0 then
    MuiCycle.Active := Idx;
end;

{------------------------------------------------------------------------------
  Method: TMUIWSCustomComboBox.GetItems
  Params:  None
  Returns: Returns a TStrings controlling the combo items
 ------------------------------------------------------------------------------}
class function TMUIWSCustomComboBox.GetItems(
  const ACustomComboBox: TCustomComboBox): TStrings;
begin
  Result := TMuiCycle(ACustomComboBox.Handle).Strings;
end;

class procedure TMUIWSCustomComboBox.FreeItems(var AItems: TStrings);
begin
  // Freed by TMUICycle;
end;

{ TMUIWSCustomEdit }

{------------------------------------------------------------------------------
  Method: TMUIWSCustomEdit.CreateHandle
  Params:  None
  Returns: Nothing
 ------------------------------------------------------------------------------}
class function TMUIWSCustomEdit.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): TLCLIntfHandle;
var
  MuiEdit: TMuiStringEdit;
begin
  //writeln('-->Create StringEdit');
  MuiEdit := TMuiStringEdit.Create([PChar(AParams.Caption), 2048]);
  With MuiEdit do
  begin
    Left := AParams.X;
    Top := AParams.Y;
    Width := AParams.Width;
    Height := AParams.Height;
    PasObject := AWinControl;
  end;

  if AWinControl.Parent <> NIL then
  begin
    MuiEdit.Parent := TMuiObject(AWinControl.Parent.Handle);
  end;
  //
  Result := TLCLIntfHandle(MuiEdit);
  //
end;

class procedure TMUIWSCustomEdit.DestroyHandle(const AWinControl: TWinControl);
begin
  //writeln('-->Free StringEdit');
  TMuiObject(AWinControl.Handle).Free;
  AWinControl.Handle := 0;
end;

class function TMUIWSCustomEdit.GetText(const AWinControl: TWinControl;
  var AText: String): Boolean;
begin
  //writeln('-->GetText');
  Result := True;
  if TObject(AWinControl.Handle) is TMuiStringEdit then
    AText := TMuiStringEdit(AWinControl.Handle).Text;
end;

class procedure TMUIWSCustomEdit.SetText(const AWinControl: TWinControl;
  const AText: String);
begin
  //writeln('-->Set Text');
  if TObject(AWinControl.Handle) is TMuiStringEdit then
    TMuiStringEdit(AWinControl.Handle).Text := AText;
end;

{ TMUIWSButton }

{------------------------------------------------------------------------------
  Method: TMUIWSButton.GetText
  Params:  None
  Returns: Nothing
 ------------------------------------------------------------------------------}
class function TMUIWSButton.GetText(const AWinControl: TWinControl;
  var AText: String): Boolean;
begin
  Result := True;
  AText := TMuiButton(AWinControl.Handle).Caption;
end;

{------------------------------------------------------------------------------
  Method: TMUIWSButton.SetText
  Params:  None
  Returns: Nothing
 ------------------------------------------------------------------------------}
class procedure TMUIWSButton.SetText(const AWinControl: TWinControl;
  const AText: String);
begin
  TMuiButton(AWinControl.Handle).Caption := AText;
end;

{------------------------------------------------------------------------------
  Method: TMUIWSButton.CreateHandle
  Params:  None
  Returns: Nothing

  Allocates memory and resources for the control and shows it
 ------------------------------------------------------------------------------}
class function TMUIWSButton.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): TLCLIntfHandle;

var
  MuiButton: TMuiButton;
begin
  //writeln('-->Create Button');

  MuiButton := TMuiButton.Create([PChar(AParams.Caption)]);
  With MuiButton do
  begin
    Left := AParams.X;
    Top := AParams.Y;
    Width := AParams.Width;
    Height := AParams.Height;
    PasObject := AWinControl;
  end;

  if AWinControl.Parent <> NIL then
  begin
    MuiButton.Parent := TMuiObject(AWinControl.Parent.Handle);
  end;
  //
  Result := TLCLIntfHandle(MuiButton);
  //
end;

class procedure TMUIWSButton.DestroyHandle(const AWinControl: TWinControl);
begin
  //writeln('<--Destroy Button');
  TMuiButton(AWinControl.Handle).Free;
  AWinControl.Handle := 0;
end;

class procedure TMUIWSButton.Invalidate(const AWinControl: TWinControl);
begin
  inherited Invalidate(AWinControl);
end;

{ TMUIWSCustomCheckBox }

class function TMUIWSCustomCheckBox.RetrieveState(
  const ACustomCheckBox: TCustomCheckBox): TCheckBoxState;
begin
  if TMuiArea(ACustomCheckBox.Handle).Checked then
    Result := cbChecked
  else
    Result := cbUnchecked;
end;

class procedure TMUIWSCustomCheckBox.SetState(
  const ACustomCheckBox: TCustomCheckBox; const NewState: TCheckBoxState);
begin
  TMuiArea(ACustomCheckBox.Handle).Checked := (NewState = cbChecked);
end;

class function TMUIWSCustomCheckBox.GetText(const AWinControl: TWinControl;
  var AText: String): Boolean;
begin
  Result := False;
  if AWinControl = nil then
    Exit;
  if AWinControl.Handle = 0 then
    Exit;
  AText := TMuiArea(AWinControl.Handle).Caption;
  Result := True;
end;

class procedure TMUIWSCustomCheckBox.SetText(const AWinControl: TWinControl;
  const AText: String);
begin
  //
  //writeln('checkmark text: ',AText);
  TMuiArea(AWinControl.Handle).Caption := AText;
end;

class procedure TMUIWSCustomCheckBox.GetPreferredSize(
  const AWinControl: TWinControl; var PreferredWidth, PreferredHeight: integer;
  WithThemeSpace: Boolean);
begin
  //
end;

class function TMUIWSCustomCheckBox.CreateHandle(
  const AWinControl: TWinControl; const AParams: TCreateParams
  ): TLCLIntfHandle;
var
  MuiCheckMark : TMuiCheckMark;
begin
  //writeln('create CheckBox');
  MuiCheckMark := TMuiCheckMark.Create(MUIO_Checkmark, [PChar(AParams.Caption)]);
  With MuiCheckMark do
  begin
    Left := AParams.X;
    Top := AParams.Y;
    Width := AParams.Width;
    Height := AParams.Height;
    PasObject := AWinControl;
  end;

  if AWinControl.Parent <> NIL then
  begin
    MuiCheckMark.Parent := TMuiCheckMark(AWinControl.Parent.Handle);
  end;
  //
  Result := TLCLIntfHandle(MuiCheckMark);
end;

class procedure TMUIWSCustomCheckBox.DestroyHandle(
  const AWinControl: TWinControl);
begin
  //writeln('Destroy CheckBox');
  TMuiCheckMark(AWinControl.Handle).Free;
  AWinControl.Handle := 0;
end;

{ TMUIWSRadioButton }

class function TMUIWSRadioButton.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): TLCLIntfHandle;
var
  MUIRadioButton : TMuiRadioButton;
begin
  //writeln('create CheckBox');
  MUIRadioButton := TMuiRadioButton.Create(MUIO_Radio, [PChar(AParams.Caption)]);
  With MUIRadioButton do
  begin
    Left := AParams.X;
    Top := AParams.Y;
    Width := AParams.Width;
    Height := AParams.Height;
    PasObject := AWinControl;
  end;

  if AWinControl.Parent <> NIL then
  begin
    MUIRadioButton.Parent := TMUIRadioButton(AWinControl.Parent.Handle);
  end;
  //
  Result := TLCLIntfHandle(MUIRadioButton);
end;

class procedure TMUIWSRadioButton.DestroyHandle(const AWinControl: TWinControl);
begin
  //writeln('Destroy RadioButton');
  TMuiRadioButton(AWinControl.Handle).Free;
  AWinControl.Handle := 0;
end;

class function TMUIWSToggleBox.CreateHandle(const AWinControl: TWinControl; const AParams: TCreateParams): TLCLIntfHandle;
var
  MUIToggleButton : TMuiToggleButton;
begin
  //writeln('create ToggleBox');
  MUIToggleButton := TMuiToggleButton.Create(MUIO_Button, [PChar(AParams.Caption)]);
  With MUIToggleButton do
  begin
    Left := AParams.X;
    Top := AParams.Y;
    Width := AParams.Width;
    Height := AParams.Height;
    PasObject := AWinControl;
  end;

  if AWinControl.Parent <> NIL then
  begin
    MUIToggleButton.Parent := TMUIToggleButton(AWinControl.Parent.Handle);
  end;
  //
  Result := TLCLIntfHandle(MUIToggleButton);
end;

class procedure TMUIWSToggleBox.DestroyHandle(const AWinControl: TWinControl);
begin
  TMuiToggleButton(AWinControl.Handle).Free;
  AWinControl.Handle := 0;
end;

{ TMUIWSCustomMemo }

class function TMUIWSCustomMemo.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): TLCLIntfHandle;
var
  MuiTEdit: TMuiTextEdit;
  TagList: TTagsList;
begin
  //writeln('-->Create TextEdit NOW');
  MuiTEdit := TMuiTextEdit.Create(TCustomMemo(AWinControl).Lines, TagList);
  With MuiTEdit do
  begin
    Left := AParams.X;
    Top := AParams.Y;
    Width := AParams.Width;
    Height := AParams.Height;
    PasObject := AWinControl;
  end;

  if AWinControl.Parent <> NIL then
  begin
    MuiTEdit.Parent := TMuiObject(AWinControl.Parent.Handle);
  end;
  //
  Result := TLCLIntfHandle(MuiTEdit);
  //
end;

class procedure TMUIWSCustomMemo.DestroyHandle(const AWinControl: TWinControl);
begin
  //writeln('free object');
  TMuiObject(AWinControl.Handle).free;
  AWinControl.Handle := 0;
  //writeln('done free object')
end;

class function TMUIWSCustomMemo.GetStrings(const ACustomMemo: TCustomMemo): TStrings;
begin
  Result := TMuiTextEdit(ACustomMemo.Handle).Strings;
end;

class procedure TMUIWSCustomMemo.FreeStrings(var AStrings: TStrings);
begin
  AStrings := NIL;
end;

class function TMUIWSCustomMemo.GetText(const AWinControl: TWinControl;
  var AText: String): Boolean;
begin
  Result := True;
  AText := TMuiTextEdit(AWinControl.Handle).Strings.Text;
end;

class procedure TMUIWSCustomMemo.SetText(const AWinControl: TWinControl;
  const AText: String);
begin
  TMuiTextEdit(AWinControl.Handle).Strings.Text := AText;
end;

{ TMUIWSListBox }

class function TMUIWSCustomListBox.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): TLCLIntfHandle;
var
  MuiList: TMuiListView;
  TagList: TTagsList;
begin
  //writeln('-->Create ListView');
  MuiList := TMuiListView.Create(TCustomListBox(AWinControl).items, TagList);
  With MuiList do
  begin
    Left := AParams.X;
    Top := AParams.Y;    
    Width := AParams.Width;
    Height := AParams.Height;    
    PasObject := AWinControl;
    FloatText.PasObject := AWinControl;
  end;

  if AWinControl.Parent <> NIL then
  begin
    MuiList.Parent := TMuiObject(AWinControl.Parent.Handle);
  end;
  //
  Result := TLCLIntfHandle(MuiList);
  //
end;

class function TMUIWSCustomListBox.GetStrings(
  const ACustomListBox: TCustomListBox): TStrings;
begin
  Result := TMuiListView(ACustomListBox.Handle).Strings;
end;

class procedure TMUIWSCustomListBox.FreeStrings(var AStrings: TStrings);
begin
  //Do nothing, autofree by MUIlistbox
end;

class procedure TMUIWSCustomListBox.SetItemIndex(
  const ACustomListBox: TCustomListBox; const AIndex: integer);
begin
  TMuiListView(ACustomListBox.Handle).Active := AIndex;
end;

class function TMUIWSCustomListBox.GetItemIndex(
  const ACustomListBox: TCustomListBox): integer;
begin
  Result := TMuiListView(ACustomListBox.Handle).Active;
end;

{ TMUIWSCustomGroupBox }

class function TMUIWSCustomGroupBox.CreateHandle(
  const AWinControl: TWinControl; const AParams: TCreateParams
  ): TLCLIntfHandle;
begin
  Result := 0;//TLCLIntfHandle(TMUIPrivateGroupBox.Create(AWinControl, AParams));
end;

class procedure TMUIWSCustomGroupBox.DestroyHandle(
  const AWinControl: TWinControl);
begin
  AWinControl.Handle := 0;
end;

end.