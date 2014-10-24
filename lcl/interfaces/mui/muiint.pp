{
 *****************************************************************************
 *                                                                           *
 *  This file is part of the Lazarus Component Library (LCL)                 *
 *                                                                           *
 *  See the file COPYING.modifiedLGPL.txt, included in this distribution,    *
 *  for details about the copyright.                                         *
 *                                                                           *
 *  This program is distributed in the hope that it will be useful,          *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     *
 *                                                                           *
 *****************************************************************************
 }

unit MUIInt;

{$mode objfpc}{$H+}

interface

{$ifdef Trace}
{$ASSERTIONS ON}
{$endif}

uses
  {$IFDEF TraceGdiCalls}
  LineInfo,
  {$ENDIF}
  // rtl+fcl
  agraphics, Types, Classes, SysUtils, FPCAdds, Math,
  // interfacebase
  InterfaceBase,
  // LCL
  Dialogs, Controls, Forms, LCLStrConsts, LMessages, stdctrls,
  LCLProc, LCLIntf, LCLType, GraphType, Graphics, Menus, Themes,
  //AROS
  //Aroswinunit,
  MUIBaseUnit, MUIFormsUnit, muidrawing,
  {$ifdef HASAMIGA}
  exec, intuition, gadtools, mui, utility, AmigaDos, tagsarray, cybergraphics,
  {$endif}
  // widgetset
  WSLCLClasses, LCLMessageGlue;

const
  IdButtonTexts: array[idButtonOk..idButtonShield] of string = (
 { idButtonOk       } 'OK',
 { idButtonCancel   } 'Cancel',
 { idButtonHelp     } 'Help',
 { idButtonYes      } 'Yes',
 { idButtonNo       } 'No',
 { idButtonClose    } 'Close',
 { idButtonAbort    } 'Abort',
 { idButtonRetry    } 'Retry',
 { idButtonIgnore   } 'Ignore',
 { idButtonAll      } 'All',
 { idButtonYesToAll } 'YesToAll',
 { idButtonNoToAll  } 'NoToAll',
 { idButtonOpen     } 'Open',
 { idButtonSave     } 'Save',
 { idButtonShield   } 'Shield'
  );
type
  { TMUIWidgetSet }

  TMUIWidgetSet = class(TWidgetSet)
  public
    procedure PassCmdLineOptions; override;
  public
    function LCLPlatform: TLCLPlatform; override;
    function GetLCLCapability(ACapability: TLCLCapability):PtrUInt; override;
    // Application
    procedure AppInit(var ScreenInfo: TScreenInfo); override;
    procedure AppProcessMessages; override;
    procedure AppWaitMessage; override;
    procedure AppTerminate; override;
    procedure AppMinimize; override;
    procedure AppRestore; override;
    procedure AppBringToFront; override;
    procedure AppSetTitle(const ATitle: string); override;
    function EnumFontFamiliesEx(DC: HDC; lpLogFont: PLogFont; Callback: FontEnumExProc; Lparam: LParam; Flags: dword): longint; override;
    //function MessageBox(hWnd: HWND; lpText: PChar; lpCaption: PChar;  uType: Cardinal): Integer; override;
    function PromptUser(const DialogCaption: String; const DialogMessage: String; DialogType: LongInt; Buttons: PLongint; ButtonCount: LongInt; DefaultIndex: LongInt; EscapeResult: LongInt):LongInt; override;
    function RawImage_CreateBitmaps(const ARawImage: TRawImage; out ABitmap: HBITMAP; out AMask: HBITMAP; ASkipMask: Boolean = false):Boolean; override;
    function RawImage_DescriptionFromBitmap(ABitmap: HBITMAP; out ADesc: TRawImageDescription): boolean; override;
    function RawImage_DescriptionFromDevice(ADC: HDC; out ADesc: TRawImageDescription): Boolean; override;
    function RawImage_FromBitmap(out ARawImage: TRawImage; ABitmap, AMask: HBITMAP; ARect: PRect = nil): Boolean; override;
    function RawImage_FromDevice(out ARawImage: TRawImage; ADC: HDC; const ARect: TRect): Boolean; override;
    function RawImage_QueryDescription(AFlags: TRawImageQueryFlags; var ADesc: TRawImageDescription): Boolean; override;

  public
    constructor Create; override;
    destructor Destroy; override;

    // create and destroy
    function CreateTimer(Interval: integer; TimerFunc: TWSTimerProc) : THandle; override;
    function DestroyTimer(TimerHandle: THandle) : boolean; override;
    procedure DestroyLCLComponent(Sender: TObject);virtual;

    {$I muiwinapih.inc}
  public
  end;

var
  MUIWidgetSet: TMUIWidgetSet;

implementation

uses
  MUIWSFactory, MUIWSForms, VInfo;


{$I muiwinapi.inc}

{ TMUIWidgetSet }

procedure TMUIWidgetSet.PassCmdLineOptions;
begin
  inherited PassCmdLineOptions;
end;

function TMUIWidgetSet.LCLPlatform: TLCLPlatform;
begin
  Result:=lpMUI;
end;

function TMUIWidgetSet.GetLCLCapability(ACapability: TLCLCapability): PtrUInt;
begin
  case ACapability of
    lcCanDrawOutsideOnPaint: Result := LCL_CAPABILITY_NO;
    lcDragDockStartOnTitleClick: Result := LCL_CAPABILITY_NO;
    lcNeedMininimizeAppWithMainForm: Result := LCL_CAPABILITY_NO;
    lcAsyncProcess: Result := LCL_CAPABILITY_NO;
    lcApplicationTitle: Result := LCL_CAPABILITY_YES;
    lcApplicationWindow:Result := LCL_CAPABILITY_YES;
    lcFormIcon: Result := LCL_CAPABILITY_NO;
    lcModalWindow: Result := LCL_CAPABILITY_NO;
    lcAntialiasingEnabledByDefault: Result := LCL_CAPABILITY_NO;
    lcLMHelpSupport: Result := LCL_CAPABILITY_NO;
  else
    Result := inherited GetLCLCapability(ACapability);
  end;
end;

var
  AppTitle, FinalVers, Vers, CopyR, Comment, prgName, Author: string;

procedure TMUIWidgetSet.AppInit(var ScreenInfo: TScreenInfo);
type
  TVerArray = array[0..3] of Word;
var
  Info: TVersionInfo;
  i,j: Integer;
  TagList: TTagsList;

  function PV2Str(PV: TVerArray): String;
   begin
     Result := Format('%d.%d.%d.%d', [PV[0],PV[1],PV[2],PV[3]])
   end;

begin
  Vers := '';
  CopyR := '';
  Comment := '';
  prgName := Application.title;
  AppTitle := Application.title;
  try
    Info := TVersionInfo.Create;
    Info.Load(HINSTANCE);
    Vers := PV2Str(Info.FixedInfo.FileVersion);
    for i := 0 to Info.StringFileInfo.Count - 1 do
    begin
      for j := 0 to Info.StringFileInfo.Items[i].Count - 1 do
      begin
        if Info.StringFileInfo.Items[i].Keys[j] = 'LegalCopyright' then
        begin
          CopyR := Info.StringFileInfo.Items[i].Values[j];
        end else
        if Info.StringFileInfo.Items[i].Keys[j] = 'Comments' then
        begin
          Comment := Info.StringFileInfo.Items[i].Values[j];
        end else
        if Info.StringFileInfo.Items[i].Keys[j] = 'CompanyName' then
        begin
          Author := Info.StringFileInfo.Items[i].Values[j];
        end else
        if Info.StringFileInfo.Items[i].Keys[j] = 'ProductName' then
        begin
          if Length(Trim(Info.StringFileInfo.Items[i].Values[j])) > 0  then
            PrgName := Info.StringFileInfo.Items[i].Values[j];
        end;
      end;
    end;
    Info.Free;
  except
  end;
  FinalVers := '$VER: ' + PrgName + ' ' + Vers;
  AddTags(TagList, [
    //LongInt(MUIA_Application_Base), PChar(AppTitle),
    LongInt(MUIA_Application_Title), PChar(AppTitle),
    LongInt(MUIA_Application_Version), PChar(FinalVers),
    LongInt(MUIA_Application_Copyright), PChar(CopyR),
    LongInt(MUIA_Application_Description), PChar(Comment),
    LongInt(MUIA_Application_Author), PChar(Author)
    ]);
  MUIApp := TMuiApplication.create(GetTagPtr(TagList));
end;

procedure TMUIWidgetSet.AppProcessMessages;
begin;
  MuiApp.ProcessMessages;
end;

procedure TMUIWidgetSet.AppWaitMessage;
begin
  MuiApp.WaitMessages;
end;

procedure TMUIWidgetSet.AppTerminate;
begin

end;

procedure TMUIWidgetSet.AppMinimize;
begin
  MuiApp.Iconified := True;
end;

procedure TMUIWidgetSet.AppRestore;
begin
  MuiApp.Iconified := False;
end;

procedure TMUIWidgetSet.AppBringToFront;
begin

end;

procedure TMUIWidgetSet.AppSetTitle(const ATitle: string);
begin

end;

function TMUIWidgetSet.EnumFontFamiliesEx(DC: HDC; lpLogFont: PLogFont;
  Callback: FontEnumExProc; Lparam: LParam; Flags: dword): longint;
begin
  Result:=0;
end;

(*
function TMUIWidgetSet.MessageBox(hWnd: HWND; lpText: PChar; lpCaption: PChar;
  uType: Cardinal): Integer;
begin
end;*)

function TMUIWidgetSet.PromptUser(const DialogCaption: String;
  const DialogMessage: String; DialogType: LongInt; Buttons: PLongint;
  ButtonCount: LongInt; DefaultIndex: LongInt; EscapeResult: LongInt): LongInt;
var
  ES: PEasyStruct;
  BtnText: string;
  Res: LongInt;
  BtnIdx : LongInt;
  BtnId: LongInt;
begin
  New(ES);
  ES^.es_StructSize := SizeOf(TEasyStruct);
  ES^.es_Flags := 0;
  ES^.es_Title := PChar(DialogCaption);
  ES^.es_TextFormat := PChar(DialogMessage);
  for BtnIdx := 0 to ButtonCount-1 do
  begin
    BtnID := Buttons[BtnIdx];
    if (BtnID >= Low(IdButtonTexts)) and (BtnID <= High(IdButtonTexts)) then
    begin
      if BtnIdx = 0 then
        BtnText := IdButtonTexts[BtnID]
      else
        BtnText := BtnText + '|'+ IdButtonTexts[BtnID];
    end else
    begin
      if BtnIdx = 0 then
        BtnText := IntToStr(BtnID)
      else
        BtnText := BtnText + '|'+ IntToStr(BtnID);
    end;
  end;
  ES^.es_GadgetFormat := PChar(BtnText);
  Res := EasyRequestArgs(nil, ES, nil, nil);
  Result := EscapeResult;
  if (Res >= 0) and (Res < ButtonCount) then
    Result := Buttons[Res];
  Dispose(ES);
end;

type
  TARGBPixel = packed record
    A: Byte;
    R: Byte;
    G: Byte;
    B: Byte;
  end;
  PARGBPixel = ^TARGBPixel;

  TABGRPixel = packed record
    R: Byte;
    G: Byte;
    B: Byte;
    A: Byte;
  end;
  PABGRPixel = ^TABGRPixel;


function TMUIWidgetSet.RawImage_CreateBitmaps(const ARawImage: TRawImage; out
  ABitmap: HBITMAP; out AMask: HBITMAP; ASkipMask: Boolean): Boolean;
var
  Bit: TMUIBitmap;
  Src: PABGRPixel;
  Dest: PARGBPixel;
  i: Integer;
  D: TABGRPixel;
begin
  Bit := TMUIBitmap.create(ARawImage.Description.Width, ARawImage.Description.Height, ARawImage.Description.Depth);

  if ARawImage.Description.Depth = 1 then
  begin
    Move(ARawImage.Data^, Bit.FImage^, ARawImage.DataSize);
  end;
  if ARawImage.Description.Depth = 32 then
  begin
    Src := Pointer(ARawImage.Data);
    Dest := Pointer(Bit.FImage);
    for i := 0 to (ARawImage.Description.Width * ARawImage.Description.Height) - 1 do
    begin
      Dest^.A := Src^.A;
      Dest^.R := Src^.R;
      Dest^.G := Src^.G;
      Dest^.B := Src^.B;
      Inc(Src);
      Inc(Dest);
    end;
  end;
  ABitmap := HBITMAP(Bit);
  AMask := 0;
  Result := True;
  //writeln(' create image: ', ARawImage.Description.Width,'x', ARawImage.Description.Height,' : ',ARawImage.Description.Depth, ' - ', ARawImage.DataSize, ' $', HexStr(Bit));
end;

function TMUIWidgetSet.RawImage_DescriptionFromBitmap(ABitmap: HBITMAP; out ADesc: TRawImageDescription): boolean;
begin
  //writeln('RawImage_DescriptionFromBitmap');
  Result := False;
end;

function TMUIWidgetSet.RawImage_DescriptionFromDevice(ADC: HDC; out ADesc: TRawImageDescription): Boolean;
begin
  //writeln('RawImage_DescriptionFromDevice ', HexStr(Pointer(ADC)));
  ADesc.Init_BPP32_A8R8G8B8_BIO_TTB(0,0);
  Result := True;
end;

function TMUIWidgetSet.RawImage_FromBitmap(out ARawImage: TRawImage; ABitmap, AMask: HBITMAP; ARect: PRect = nil): Boolean;
begin
  //writeln('RawImage_FromBitmap');
  Result := False;
end;

function TMUIWidgetSet.RawImage_FromDevice(out ARawImage: TRawImage; ADC: HDC; const ARect: TRect): Boolean;
begin
  //writeln('RawImage_FromDevice ', ARect.Right, ' x ', ARect.Bottom);
  Result := False;
end;

function RawImage_DescriptionFromDrawable(out
  ADesc: TRawImageDescription; ACustomAlpha: Boolean
  ): boolean;
var
  Width, Height, Depth: integer;
  IsBitmap: Boolean;
  AMask: LongWord;
  AShift: Integer;
  APrecision: Integer;
begin
  Width := 0;
  Height := 0;


  ADesc.Init;
  ADesc.Width := cardinal(Width);
  ADesc.Height := cardinal(Height);
  ADesc.BitOrder := riboBitsInOrder;

  if ACustomAlpha then
  begin
    // always give pixbuf description for alpha images
    ADesc.Format:=ricfRGBA;
    ADesc.Depth := 32;
    ADesc.BitsPerPixel := 32;
    ADesc.LineEnd := rileDWordBoundary;
    ADesc.ByteOrder := riboLSBFirst;

    ADesc.RedPrec := 8;
    ADesc.RedShift := 0;
    ADesc.GreenPrec := 8;
    ADesc.GreenShift := 8;
    ADesc.BluePrec := 8;
    ADesc.BlueShift := 16;
    ADesc.AlphaPrec := 8;
    ADesc.AlphaShift := 24;

    ADesc.MaskBitsPerPixel := 1;
    ADesc.MaskShift := 0;
    ADesc.MaskLineEnd := rileByteBoundary;
    ADesc.MaskBitOrder := riboBitsInOrder;

    Exit(True);
  end;

  // Format
  if IsBitmap then
  begin
    ADesc.Format := ricfGray;
  end else
  begin
    ADesc.Format:=ricfRGBA;
  end;

  // Palette
  ADesc.PaletteColorCount:=0;

  // Depth
  if IsBitmap then
    ADesc.Depth := 1
  else
    ADesc.Depth := 32;

  if IsBitmap then
    ADesc.ByteOrder := riboMSBFirst
  else
    ADesc.ByteOrder := riboLSBFirst;

  ADesc.LineOrder := riloTopToBottom;

  case ADesc.Depth of
    0..8:   ADesc.BitsPerPixel := ADesc.Depth;
    9..16:  ADesc.BitsPerPixel := 16;
    17..32: ADesc.BitsPerPixel := 32;
  else
    ADesc.BitsPerPixel := 64;
  end;

  if IsBitmap then
  begin
    ADesc.LineEnd  := rileByteBoundary;
    ADesc.RedPrec  := 1;
    ADesc.RedShift := 0;
  end else
  begin
    // Try retrieving the lineend
    ADesc.LineEnd := rileDWordBoundary;

    {Visual^.get_red_pixel_details(@AMask, @AShift, @APrecision);
    ADesc.RedPrec := APrecision;
    ADesc.RedShift := AShift;
    Visual^.get_green_pixel_details(@AMask, @AShift, @APrecision);
    ADesc.GreenPrec := APrecision;
    ADesc.GreenShift := AShift;
    Visual^.get_blue_pixel_details(@AMask, @AShift, @APrecision);
    ADesc.BluePrec := APrecision;
    ADesc.BlueShift := AShift;
    }
    ADesc.MaskBitsPerPixel := 1;
    ADesc.MaskShift := 0;
    ADesc.MaskLineEnd := rileByteBoundary;
    ADesc.MaskBitOrder := riboBitsInOrder;
  end;

  Result := True;
end;

function TMUIWidgetSet.RawImage_QueryDescription(AFlags: TRawImageQueryFlags; var ADesc: TRawImageDescription): Boolean;
var
  Desc: TRawImageDescription;
begin
  if riqfGrey in AFlags then
  begin
    writeln('TMUIWidgetSet.RawImage_QueryDescription: riqfGrey not (yet) supported');
    Exit(False);
  end;

  if riqfPalette in AFlags then
  begin
    writeln('TMUIWidgetSet.RawImage_QueryDescription: riqfPalette not (yet) supported');
    Exit(False);
  end;

  Result := False;

  Desc.Init;
  Result := RawImage_DescriptionFromDrawable(Desc, riqfAlpha in AFlags);
  // RawImage_DescriptionFromPixbuf(Desc, nil);
  // RawImage_DescriptionFromDrawable(Desc, nil, riqfAlpha in AFlags);
  //if not Result then Exit;

  if not (riqfUpdate in AFlags) then
    ADesc.Init;

  // if there's mask gtk2 assumes it's rgba (not XBM format).issue #12362
  if (riqfUpdate in AFlags) and (riqfMono in AFlags) and (riqfMask in AFlags) then
      AFlags := AFlags - [riqfMono] + [riqfRgb];

  if riqfMono in AFlags then
  begin
    ADesc.Format := ricfGray;
    ADesc.Depth := 1;
    ADesc.BitOrder := Desc.MaskBitOrder;
    ADesc.ByteOrder := riboLSBFirst;
    ADesc.LineOrder := Desc.LineOrder;
    ADesc.LineEnd := Desc.MaskLineEnd;
    ADesc.BitsPerPixel := Desc.MaskBitsPerPixel;
    ADesc.RedPrec := 1;
    ADesc.RedShift := Desc.MaskShift;
    // in theory only redshift is used, but if someone reads it as color thsi works too.
    ADesc.GreenPrec := 1;
    ADesc.GreenShift := Desc.MaskShift;
    ADesc.BluePrec := 1;
    ADesc.BlueShift := Desc.MaskShift;
  end
  (*
  //TODO
  else if riqfGrey in AFlags
  then begin
    ADesc.Format := ricfGray;
    ADesc.Depth := 8;
    ADesc.BitOrder := Desc.BitOrder;
    ADesc.ByteOrder := Desc.ByteOrder;
    ADesc.LineOrder := Desc.LineOrder;
    ADesc.LineEnd := Desc.LineEnd;
    ADesc.BitsPerPixel := 8;
    ADesc.RedPrec := 8;
    ADesc.RedShift := 0;
  end
  *)
  else
  if riqfRGB in AFlags then
  begin
    ADesc.Format := ricfRGBA;
    ADesc.Depth := Desc.Depth;
    ADesc.BitOrder := Desc.BitOrder;
    ADesc.ByteOrder := Desc.ByteOrder;
    ADesc.LineOrder := Desc.LineOrder;
    ADesc.LineEnd := Desc.LineEnd;
    ADesc.BitsPerPixel := Desc.BitsPerPixel;
    ADesc.RedPrec := Desc.RedPrec;
    ADesc.RedShift := Desc.RedShift;
    ADesc.GreenPrec := Desc.GreenPrec;
    ADesc.GreenShift := Desc.GreenShift;
    ADesc.BluePrec := Desc.BluePrec;
    ADesc.BlueShift := Desc.BlueShift;
  end;

  if riqfAlpha in AFlags then
  begin
    ADesc.AlphaPrec := Desc.AlphaPrec;
    ADesc.AlphaShift := Desc.AlphaShift;
  end;

  if riqfMask in AFlags then
  begin
    ADesc.MaskBitsPerPixel := Desc.MaskBitsPerPixel;
    ADesc.MaskShift := Desc.MaskShift;
    ADesc.MaskLineEnd := Desc.MaskLineEnd;
    ADesc.MaskBitOrder := Desc.MaskBitOrder;
  end;

(*
  //TODO
  if riqfPalette in AFlags
  then begin
    ADesc.PaletteColorCount := Desc.PaletteColorCount;
    ADesc.PaletteBitsPerIndex := Desc.PaletteBitsPerIndex;
    ADesc.PaletteShift := Desc.PaletteShift;
    ADesc.PaletteLineEnd := Desc.PaletteLineEnd;
    ADesc.PaletteBitOrder := Desc.PaletteBitOrder;
    ADesc.PaletteByteOrder := Desc.PaletteByteOrder;
  end;
*)
end;


constructor TMUIWidgetSet.Create;
begin
  inherited Create;
end;

destructor TMUIWidgetSet.Destroy;
begin
  inherited Destroy;
end;

function TMUIWidgetSet.CreateTimer(Interval: integer; TimerFunc: TWSTimerProc): THandle;
begin
  Result := 0;
  if Assigned(MUIApp) then
  begin
    Result := MUIApp.CreateTimer(Interval, TimerFunc);
  end;
end;

function TMUIWidgetSet.DestroyTimer(TimerHandle: THandle): boolean;
begin
  Result:=false;
  if Assigned(MUIApp) then
  begin
    Result := MUIApp.DestroyTimer(TimerHandle);
  end;
end;

procedure TMUIWidgetSet.DestroyLCLComponent(Sender: TObject);
begin

end;

end.