{
 *****************************************************************************
 *                             muidrawing.pas                                *
 *                              --------------                               *
 *      Place for wrapper Canvas/Bitmap/pen/Brush/Font and related           *
 *                                                                           *
 *****************************************************************************

 *****************************************************************************
  This file is part of the Lazarus Component Library (LCL)

  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************
}
unit muidrawing;

{$mode objfpc}{$H+}

interface

uses
  // RTL, FCL, LCL
  Classes, SysUtils, types, dos,
  Graphics, Menus, LCLType
  // Widgetset
  // aros
  {$ifdef HASAMIGA}
  ,agraphics, intuition, mui, diskfont, cybergraphics
  {$endif};

const
  FONTREPLACEMENTS: array[0..3] of record
    OldName: string;
    NewName: string;
  end =
    (
     (OldName: 'default';
      NewName: 'Arial';),
      
     (OldName: 'tahoma';
      NewName: 'Arial';),

     (OldName: 'courier';
      NewName: 'ttcourier';),

     (OldName: 'courier new';
      NewName: 'ttcourier';)
      );
  ALLSTYLES = FSF_ITALIC or FSF_BOLD or FSF_UNDERLINED;

type
  TMUICanvas = class;

  TMUIRegionType=(eRegionNULL,eRegionSimple,eRegionComplex,eRegionNotCombinableOrError);
  TMUIRegionCombine=(eRegionCombineAnd,eRegionCombineCopy, eRegionCombineDiff, eRegionCombineOr, eRegionCombineXor);

  TMUIWinAPIElement = class(TObject);

  TMUIWinAPIObject = class(TMUIWinAPIElement);

  TMUIColor = longword;

  type tagTmuiBrush= record
    Color: TMUIColor;
  end;

  type tagTmuiPen= record
    Color: TMUIColor;
    Width: Integer;
  end;

  { TMUIBitmap }

  TMUIBitmap = class(TMUIWinAPIObject)
  public
    FImage: Pointer;
    FWidth: Integer;
    FHeight: Integer;
    FDepth: Integer;
    MUICanvas: TMUICanvas;
    constructor Create(Width, Height, Depth: Integer);
    destructor Destroy; override;
    
    procedure GetFromCanvas;
  end;

  { TMUIFontObj }

  TMUIFontObj = class(TMUIWinAPIObject)
  private
    FFontFace: string;
    FHeight: Integer;
    FontHandle: PTextFont;
    FontStyle: LongWord;
    FIsItalic: Boolean;
    FIsBold: Boolean;
    FIsUnderlined: Boolean;
    procedure OpenFontHandle;
    procedure CloseFontHandle;
  public
    constructor Create(const AFontData: TLogFont); virtual; overload;
    constructor Create(const AFontData: TLogFont; const LongFontName: string); virtual; overload;

    destructor Destroy; override;
    property TextFont: PTextFont read FontHandle;
  end;

  { TMUIColorObj }

  TMUIColorObj = class(TMUIWinAPIObject)
  private
    FLCLColor: TColor;
    function GetIsSystemColor: Boolean;
    function GetLCLColor: TColor;
    function GetPenDesc: Integer;
    procedure SetLCLColor(AValue: TColor);
    function GetColor: LongWord;
  public
    property LCLColor: TColor read GetLCLColor write SetLCLColor;
    property IsSystemColor: Boolean read GetIsSystemColor;
    property PenDesc: Integer read GetPenDesc;
    property Color: LongWord read GetColor;
  end;

  { TMUIPenObj }

  TMUIPenObj = class(TMUIColorObj)
  private
    FWidth: Integer;
    Style: LongWord;
  public
    constructor Create(const APenData: TLogPen);
  end;

  { TMUIBrushObj }

  TMUIBrushObj = class(TMUIColorObj)
  private
    FStyle: LongWord;
  public
    constructor Create(const ABrushData: TLogBrush);
    property Style: LongWord read FStyle;
  end;

 (* { TmuiWinAPIBitmap }

  TmuiWinAPIBitmap = class(TmuiWinAPIObject)
  private
    fpgImage: TfpgImage;
  protected
    SelectedInDC: HDC;
  public
    Constructor Create(const ABitsPerPixel,Width,Height: integer);
    Destructor Destroy; override;
    property Image: TfpgImage read fpgImage;
  end;   *)

  TmuiBasicRegion = class;

  (*
  { TmuiDeviceContext }

  TmuiDeviceContext = class(TmuiWinAPIElement)
  private
    FDCStack: array of TmuiDeviceContext;
    procedure CopyDCToInstance(const ATarget: TmuiDeviceContext);
    procedure SetupFont;
    procedure SetupBrush;
    procedure SetupBitmap;
    procedure SetupClipping;
  public
    fpgCanvas: TfpgCanvas;
    FPrivateWidget: TmuiPrivateWidget;
    FOrg: TPoint;
    FBrush: TmuiWinAPIBrush;
    FPen: TmuiWinAPIPen;
    FFont: TmuiWinAPIFont;
    FTextColor: TMUIColor;
    FBitmap: TmuiWinAPIBitmap;
    FClipping: TmuiBasicRegion;
  public
    constructor Create(AmuiPrivate: TmuiPrivateWidget);
    destructor Destroy; override;
    procedure SetOrigin(const AX,AY: integer);
    function SaveDC: integer;
    function RestoreDC(const Index: SizeInt): Boolean;
    function SelectObject(const AGDIOBJ: HGDIOBJ): HGDIOBJ;
    function SetTextColor(const AColor: TColorRef): TColorRef;
    function PrepareRectOffsets(const ARect: TRect): TfpgRect;
    procedure ClearRectangle(const AfpgRect: TfpgRect);
    procedure ClearDC;
    procedure SetupPen;
  end; *)

  (*
  { TmuiPrivateMenuItem }

  TmuiPrivateMenuItem = class(TObject)
  private
  protected
  public
    MenuItem: TfpgMenuItem;
    LCLMenuItem: TMenuItem;
    procedure HandleOnClick(ASender: TObject);
  end; *)

  { TmuiBasicRegion }

  TMUIBasicRegion=class(TMUIWinAPIObject)
  private
    FRegionType: TmuiRegionType;
    //function GetfpgRectRegion: TfpgRect;
    function GetRegionType: TmuiRegionType;
  protected
    FRectRegion: TRect;
  public
    constructor Create; overload;
    constructor Create(const ARect: TRect); overload;
    destructor Destroy; override;
    procedure CreateRectRegion(const ARect: TRect);
    function CombineWithRegion(const ARegion: TmuiBasicRegion; const ACombineMode: TmuiRegionCombine): TmuiBasicRegion;
    function Debugout: string;
    property RegionType: TmuiRegionType read GetRegionType;

  end;

  { TMUICanvas }

  TMUICanvas = class
  private
    FBrush: TMUIBrushObj;
    FPen: TMUIPenObj;
    FFont: TMUIFontObj;
    FDefaultPen: TMUIPenObj;
    FDefaultBrush: TMUIBrushObj;
    FDefaultFont: TMUIFontObj;
    FClip: Pointer;
    FClipping: TRect;
    OldAPen: LongWord;
    OldBPen: LongWord;
    OldOPen: LongWord;
    OldFont: PTextFont;
    OldDrMd: LongWord;
    OldPat: Word;
    OldStyle: LongWord;
    InitDone: Boolean;
  public
    Drawn: Boolean;
    RastPort: PRastPort;
    DrawRect: TRect;
    Position: TPoint;
    RenderInfo: PMUI_RenderInfo;
    Bitmap: TMUIBitmap;
    //Clipping: TMuiBasicRegion;
    Offset: types.TPoint;
    TextColor: LongWord;
    MUIObject: TObject;
    BKColor: TColor;
    BKMode: Integer;
    function GetOffset: TPoint;
    // Drawing routines
    procedure MoveTo(x, y: integer);
    procedure LineTo(x, y: integer; SkipPenSetting: Boolean = False);
    procedure WriteText(Txt: PChar; Count: integer);
    function TextWidth(Txt: PChar; Count: integer): integer;
    function TextHeight(Txt: PChar; Count: integer): integer;
    procedure FillRect(X1, Y1, X2, Y2: Integer);
    procedure Rectangle(X1, Y1, X2, Y2: Integer);
    procedure Ellipse(X1, Y1, X2, Y2: Integer);
    procedure Polygon(Points: Types.PPoint; NumPoint: Integer);
    procedure SetPixel(X,Y: Integer; Color: TColor);
    function GetPixel(X,Y: Integer): TColor;
    procedure FloodFill(X, Y: Integer; Color: TColor);
    // set a Pen as color
    procedure SetAMUIPen(PenDesc: integer);
    procedure SetBMUIPen(PenDesc: integer);
    procedure SetPenToRP;
    procedure SetBrushToRP(AsPen: Boolean = False);
    procedure SetBKToRP(AsPen: Boolean = False);
    procedure SetFontToRP;
    procedure SetClipping(AClip: TMuiBasicRegion);
    //
    function SelectObject(NewObj: TMUIWinAPIElement): TMUIWinAPIElement;
    procedure ResetPenBrushFont;
    procedure InitCanvas;
    procedure DeInitCanvas;
    constructor Create;
    destructor Destroy; override;

  end;

  //function muiGetDesktopDC(): TmuiDeviceContext;
  function TColorToMUIColor(col: TColor): TMuiColor;
  function MUIColorToTColor(col: TMuiColor): TColor;

implementation
uses
  muibaseunit, tagsarray, interfacebase;

(*
var
  muiDesktopDC: TmuiDeviceContext=nil;

function muiGetDesktopDC(): TmuiDeviceContext;
begin
  if not Assigned(muiDesktopDC) then
   muiDesktopDC:=TmuiDeviceContext.Create(nil);
  Result:=muiDesktopDC;
end;
*)

function TColorToMUIColor(col: TColor): TMuiColor;
var
  c: LongWord;
  r: LongWord;
  g: LongWord;
  b: LongWord;
  i: LongWord;
begin
  c := col;
  i := (c and $FF000000) shr 24;
  b := (c and $00FF0000) shr 16;
  g := (c and $0000FF00);
  r := (c and $000000FF) shl 16;
  if i = $80 then
    Result := WidgetSet.GetSysColor(c and $000000FF)
  else
    Result := r or g or b;
end;

function MUIColorToTColor(col: TMuiColor): TColor;
var
  c: LongWord;
  r: LongWord;
  g: LongWord;
  b: LongWord;
begin
  c := Col;
  r := (c and $00FF0000) shr 16;
  g := (c and $0000FF00);
  b := (c and $000000FF) shl 16;
  Result := r or g or b;
end;

{ TMUIBitmap }

constructor TMUIBitmap.Create(Width, Height, Depth: Integer);
begin
  FWidth := Width;
  FHeight := Height;
  FDepth := Depth;
  FImage := System.AllocMem(Width * Height * SizeOf(LongWord));
  MUICanvas := nil;
end;

destructor TMUIBitmap.Destroy;
begin
  FreeMem(FImage);
  MUICanvas := nil;
  inherited Destroy;
end;

procedure TMUIBitmap.GetFromCanvas;
var
  T: TPoint;
begin
  if Assigned(MUICanvas) and Assigned(FImage) and Assigned(MUICanvas.RastPort) then
  begin
    T := MUICanvas.GetOffset;
    ReadPixelarray(FImage, 0, 0, FWidth * SizeOf(LongWord), MUICanvas.RastPort, T.X, T.Y, FWidth, FHeight, RECTFMT_ARGB);
  end;  
end;

{ TMUIFontObj }

procedure TMUIFontObj.OpenFontHandle;
var
  TextAttr: TTextAttr;
  FontFile: string;
  SFontName: string;
  i: Integer;
begin
  SFontName := LowerCase(FFontFace);
  for i := 0 to High(FONTREPLACEMENTS) do
  begin
    if SFontName = FONTREPLACEMENTS[i].OldName then
    begin
      SFontName := FONTREPLACEMENTS[i].NewName;
      Break;
    end;
  end;
  FontFile := LowerCase(SFontName + '.font');
  TextAttr.ta_Style := FS_NORMAL;
  if FIsItalic then
    TextAttr.ta_Style := TextAttr.ta_Style or FSF_ITALIC;
  if FIsBold then
    TextAttr.ta_Style := TextAttr.ta_Style or FSF_BOLD;
  if FIsUnderlined then
    TextAttr.ta_Style := TextAttr.ta_Style or FSF_UNDERLINED;
  FontStyle := TextAttr.ta_Style;  
  TextAttr.ta_Name := PChar(FontFile);
  TextAttr.ta_YSize := FHeight;
  TextAttr.ta_Flags := FPF_DISKFONT;
  FontHandle := OpenDiskFont(@TextAttr);
  if FontHandle = nil then
  begin
    TextAttr.ta_Name := PChar(SFontName);
    TextAttr.ta_YSize := FHeight;
    TextAttr.ta_Flags := FPF_DISKFONT;
    FontHandle := OpenDiskFont(@TextAttr);
  end;


  //writeln('Create Font ', FFontFace,' -> ', FontFile, ' Res = ', Assigned(FontHandle));
  //writeln('  Bold:', FIsBold, ' Italic:', FIsItalic, ' underlined:', FIsUnderlined);
  //writeln(   ' FontStyle = ', HexStr(Pointer(FontStyle)));
end;

procedure TMUIFontObj.CloseFontHandle;
begin
  if Assigned(FontHandle) then
    CloseFont(FontHandle);
  FontHandle := nil;
end;

{.$define COUNTFONTS}

{$ifdef COUNTFONTS}
var NumFonts: Integer = 0;
{$endif}

constructor TMUIFontObj.Create(const AFontData: TLogFont);
begin
  {$ifdef COUNTFONTS}
  writeln('create font ', HexStr(self),' ', NumFonts);
  Inc(NumFonts);
  {$endif}
  inherited Create;
  FontHandle := nil;
  FFontFace := AFontData.lfFaceName;
  FHeight := abs(AFontData.lfHeight);
  if FHeight <= 1 then
    FHeight := 13;
  FIsItalic := AFontData.lfItalic <> 0;
  FIsUnderlined := AFontData.lfUnderline <> 0;
  FIsBold := False;
  case AFontData.lfWeight of
    FW_SEMIBOLD, FW_BOLD: FIsBold := True;
  end;
  OpenFontHandle;
end;

constructor TMUIFontObj.Create(const AFontData: TLogFont; const LongFontName: string);
begin
  {$ifdef COUNTFONTS}
  writeln('create font ', HexStr(self),' ', NumFonts);
  Inc(NumFonts);
  {$endif}
  inherited Create;
  FontHandle := nil;
  FFontFace := LongFontName;
  FHeight := abs(AFontData.lfHeight);
  if FHeight = 0 then
    FHeight := 13;
  FIsItalic := AFontData.lfItalic <> 0;
  FIsUnderlined := AFontData.lfUnderline <> 0;
  FIsBold := False;
  case AFontData.lfWeight of
    FW_SEMIBOLD, FW_BOLD: FIsBold := True;
  end;
  OpenFontHandle;
end;

destructor TMUIFontObj.Destroy;
begin
  {$ifdef COUNTFONTS}
  Dec(NumFonts);
  writeln('Destroy font', HexStr(Self),' ', NumFonts); 
  {$endif} 
  CloseFontHandle;
  inherited Destroy;
end;

{ TMUIBrushObj }

constructor TMUIBrushObj.Create(const ABrushData: TLogBrush);
begin
  inherited Create;
  //writeln(' Create Brush: ', HexStr(Pointer(ABrushData.lbColor)), ' Style: ', ABrushData.lbStyle, ' ', HexStr(Self));
  //writeln('Solid: ', BS_SOLID, ' Hatched: ', BS_HATCHED, ' Hollow: ', BS_HOLLOW);
  FLCLColor := ABrushData.lbColor;
  case ABrushData.lbStyle of
    BS_SOLID, BS_HATCHED: FStyle := JAM2;
    BS_HOLLOW: FStyle := JAM1;
    else
      FStyle := JAM1;
  end;
  //writeln('Brush created: $', HexStr(Pointer(FLCLColor)));
end;

{ TMUIPenObj }

constructor TMUIPenObj.Create(const APenData: TLogPen);
begin
  inherited Create;
  FLCLColor := APenData.lopnColor;
  Style := APenData.lopnStyle;
  FWidth := APenData.lopnWidth.X;
  //writeln('pen created: $', HexStr(Pointer(FLCLColor)), ' Style ', Style);
end;

{ TMUIColorObj }

function TMUIColorObj.GetLCLColor: TColor;
begin
  Result := FLCLColor;
end;

function TMUIColorObj.GetPenDesc: Integer;
var
  nIndex: Integer;
  Pen: Integer;
begin
  Result := 0;
  nIndex := FLCLColor and $FF;
  case nIndex of
    COLOR_SCROLLBAR               : Pen := MPEN_BACKGROUND;
    COLOR_BACKGROUND              : Pen := MPEN_BACKGROUND;
    COLOR_WINDOW                  : Pen := MPEN_BACKGROUND;
    COLOR_WINDOWFRAME             : Pen := MPEN_BACKGROUND;
    COLOR_WINDOWTEXT              : Pen := MPEN_TEXT;
    COLOR_ACTIVEBORDER            : Pen := MPEN_SHADOW;
    COLOR_INACTIVEBORDER          : Pen := MPEN_HALFSHADOW;
    COLOR_APPWORKSPACE            : Pen := MPEN_BACKGROUND;
    COLOR_HIGHLIGHT               : Pen := MPEN_MARK;
    COLOR_HIGHLIGHTTEXT           : Pen := MPEN_SHINE;
    COLOR_BTNFACE                 : Pen := MPEN_BACKGROUND;
    COLOR_BTNSHADOW               : Pen := MPEN_HALFSHADOW;
    COLOR_GRAYTEXT                : Pen := MPEN_HALFSHADOW;
    COLOR_BTNTEXT                 : Pen := MPEN_TEXT;
    COLOR_BTNHIGHLIGHT            : Pen := MPEN_SHINE;
    COLOR_3DDKSHADOW              : Pen := MPEN_SHADOW;
    COLOR_3DLIGHT                 : Pen := MPEN_SHINE;
    COLOR_INFOTEXT                : Pen := MPEN_TEXT;
    COLOR_INFOBK                  : Pen := MPEN_FILL;
    COLOR_HOTLIGHT                : Pen := MPEN_HALFSHINE;
    COLOR_ACTIVECAPTION           : Pen := MPEN_TEXT;
    COLOR_INACTIVECAPTION         : Pen := MPEN_TEXT;
    COLOR_CAPTIONTEXT             : Pen := MPEN_TEXT;
    COLOR_INACTIVECAPTIONTEXT     : Pen := MPEN_TEXT;
    COLOR_GRADIENTACTIVECAPTION   : Pen := MPEN_HALFSHADOW;
    COLOR_GRADIENTINACTIVECAPTION : Pen := MPEN_HALFSHINE;
    COLOR_MENU                    : Pen := MPEN_BACKGROUND;
    COLOR_MENUTEXT                : Pen := MPEN_TEXT;
    COLOR_MENUHILIGHT             : Pen := MPEN_SHINE;
    COLOR_MENUBAR                 : Pen := MPEN_BACKGROUND;
    COLOR_FORM                    : Pen := MPEN_BACKGROUND;
  else
    Exit;
  end;
  Result := Pen;
end;

function TMUIColorObj.GetIsSystemColor: Boolean;
var
  i: Integer;
begin
  i := (FLCLColor and $FF000000) shr 24;
  Result := i = $80;
end;

procedure TMUIColorObj.SetLCLColor(AValue: TColor);
begin
  FLCLColor := AValue;
end;

function TMUIColorObj.GetColor: LongWord;
begin
  Result := TColorToMUIColor(FLCLColor);
end;

(*
{ TmuiDeviceContext }

procedure TmuiDeviceContext.CopyDCToInstance(
  const ATarget: TmuiDeviceContext);
begin
  ATarget.fpgCanvas:=fpgCanvas;
  ATarget.FPrivateWidget:=FPrivateWidget;
  ATarget.FBrush:=FBrush;
  ATarget.FPen:=FPen;
  ATarget.FFont:=FFont;
  ATarget.FOrg:=FOrg;
  ATarget.FTextColor:=FTextColor;
  ATarget.FClipping:=FClipping;
end;

procedure TmuiDeviceContext.SetupFont;
begin
  if Assigned(fpgCanvas) then
   if Assigned(FFont) then
    fpgCanvas.Font:=FFont.muiFont;
end;

procedure TmuiDeviceContext.SetupBrush;
begin
  if Assigned(fpgCanvas) then
   if Assigned(FBrush) then
    fpgCanvas.Color:=FBrush.Color;
end;

procedure TmuiDeviceContext.SetupPen;
begin
  if Assigned(fpgCanvas) then
   if Assigned(FPen) then
    fpgCanvas.Color:=FPen.Color;
end;

procedure TmuiDeviceContext.SetupBitmap;
begin
  if Assigned(fpgCanvas) then
    fpgCanvas.DrawImage(0,0,FBitmap.fpgImage);
end;

procedure TmuiDeviceContext.SetupClipping;
var
  r: TfpgRect;
begin
  if Assigned(fpgCanvas) then
    if Assigned(FClipping) then begin
      r:=FClipping.fpgRectRegion;
      AdjustRectToOrg(r,FOrg);
      fpgCanvas.SetClipRect(r);
    end else begin
      fpgCanvas.ClearClipRect;
    end;
end;

constructor TmuiDeviceContext.Create(AmuiPrivate: TmuiPrivateWidget);
begin
  if Assigned(AmuiPrivate) then begin
    fpgCanvas := AmuiPrivate.Widget.Canvas;
    fpgCanvas.BeginDraw(false);
    AmuiPrivate.DC:=HDC(Self);
    FPrivateWidget := AmuiPrivate;
  end else begin
    fpgCanvas := nil;
    FPrivateWidget := nil;
  end;
  with FOrg do begin
    X:=0;
    Y:=0;
  end;
  FBrush:=nil;
  FPen:=nil;
  FFont:=nil;
end;

destructor TmuiDeviceContext.Destroy;
var
  j: integer;
begin
  if Assigned(fpgCanvas) then fpgCanvas.EndDraw;
  for j := 0 to High(FDCStack) do begin
    FDCStack[j].Free;
  end;
  if Assigned(FPrivateWidget) then
    FPrivateWidget.DC:=0;
end;

procedure TmuiDeviceContext.SetOrigin(const AX, AY: integer);
begin
  With FOrg do begin
    X:=AX;
    Y:=AY;
  end;
end;

function TmuiDeviceContext.SaveDC: Integer;
var
  Tmp: TmuiDeviceContext;
begin
  SetLength(FDCStack,Length(FDCStack)+1);
  Tmp:=TmuiDeviceContext.Create(FPrivateWidget);
  FDCStack[High(FDCStack)]:=Tmp;
  Self.CopyDCToInstance(Tmp);
  Result:=High(FDCStack);
end;

function TmuiDeviceContext.RestoreDC(const Index: SizeInt): Boolean;
var
  Tmp: TmuiDeviceContext;
  TargetIndex: SizeInt;
  j: SizeInt;
begin
  Result:=false;
  if Index>=0 then begin
    TargetIndex:=Index;
    if TargetIndex>High(FDCStack) then Exit;
  end else begin
    TargetIndex:=High(FDCStack)-Index+1;
    If TargetIndex<0 then Exit;
  end;
  Tmp:=FDCStack[TargetIndex];
  Tmp.CopyDCToInstance(Self);
  FPrivateWidget.DC:=HDC(Self);
  SetupFont;
  SetupBrush;
  SetupPen;
  SetupClipping;
  for j := TargetIndex to High(FDCStack) do begin
    FDCStack[j].Free;
  end;
  SetLength(FDCStack,TargetIndex);
  Result:=true;
end;

function TmuiDeviceContext.SelectObject(const AGDIOBJ: HGDIOBJ): HGDIOBJ;
var
  gObject: TObject;
begin
  Result:=0;
  gObject:=TObject(AGDIOBJ);
  if AGDIOBJ<5 then begin
    case AGDIOBJ of
      1:  begin
            Result:=HGDIOBJ(FFont);
            FFont:=nil;
          end;
      2:  begin
            Result:=HGDIOBJ(FBrush);
            FBrush:=nil;
          end;
      3:  begin
            Result:=HGDIOBJ(FPen);
            FPen:=nil;
          end;
      4:  begin
            Result:=HGDIOBJ(FBitmap);
            FBitmap:=nil;
          end;
      5:  begin
            Result:=HGDIOBJ(FClipping);
            FClipping:=nil;
          end;
    end;
    Exit;
  end;
  if gObject is TmuiWinAPIFont then begin
    Result:=HGDIOBJ(FFont);
    FFont:=TmuiWinAPIFont(gObject);
    SetupFont;
    if Result=0 then Result:=1;
  end else if gObject is TmuiWinAPIBrush then begin
    Result:=HGDIOBJ(FBrush);
    FBrush:=TmuiWinAPIBrush(gObject);
    SetupBrush;
    if Result=0 then Result:=2;
  end else if gObject is TmuiWinAPIPen then begin
    Result:=HGDIOBJ(FPen);
    FPen:=TmuiWinAPIPen(gObject);
    SetupPen;
    if Result=0 then Result:=3;
  end else if gObject is TmuiWinAPIBitmap then begin
    Result:=HGDIOBJ(FBitmap);
    FBitmap:=TmuiWinAPIBitmap(gObject);
    FBitmap.SelectedInDC:=HDC(Self);
    SetupBitmap;
    if Result=0 then Result:=4;
  end else if gObject is TmuiBasicRegion then begin
    Result:=HGDIOBJ(FClipping);
    FClipping:=TmuiBasicRegion(gObject);
    SetupClipping;
    if Result=0 then Result:=5;
  end;
end;

function TmuiDeviceContext.SetTextColor(const AColor: TColorRef): TColorRef;
begin
  Result:=FTextColor;
  FTextColor:=AColor;
  fpgCanvas.TextColor:=FTextColor;
end;

function TmuiDeviceContext.PrepareRectOffsets(const ARect: TRect): TfpgRect;
begin
  TRectTofpgRect(ARect,Result);
  AdjustRectToOrg(Result,FOrg);
  FPrivateWidget.AdjustRectXY(Result);
end;

procedure TmuiDeviceContext.ClearRectangle(const AfpgRect: TfpgRect);
var
  OldColor: TMUIColor;
begin
  OldColor:=fpgCanvas.Color;
  fpgCanvas.Color:= FPrivateWidget.Widget.BackgroundColor;
  fpgCanvas.FillRectangle(AfpgRect);
  if fpgCanvas.Color=0 then writeln(FPrivateWidget.LCLObject.Name);
  fpgCanvas.Color:=OldColor;
end;

procedure TmuiDeviceContext.ClearDC;
begin
  ClearRectangle(fpgCanvas.GetClipRect);
end;

{ TmuiPrivateMenuItem }

procedure TmuiPrivateMenuItem.HandleOnClick(ASender: TObject);
begin
  if Assigned(LCLMenuItem) and Assigned(LCLMenuItem.OnClick) then
   LCLMenuItem.OnClick(LCLMenuItem);
end;
*)

{ TmuiBasicRegion }

function TmuiBasicRegion.GetRegionType: TmuiRegionType;
begin
  Result:=FRegionType;
end;

constructor TmuiBasicRegion.Create;
var
  ARect: TRect;
begin
  FillByte(ARect,sizeof(ARect),0);
  CreateRectRegion(ARect);
end;

constructor TmuiBasicRegion.Create(const ARect: TRect);
begin
  CreateRectRegion(ARect);
end;

destructor TmuiBasicRegion.Destroy;
begin
  inherited Destroy;
end;

procedure TmuiBasicRegion.CreateRectRegion(const ARect: TRect);
begin
  FRectRegion:=ARect;
  if (FRectRegion.Left=FRectRegion.Top) and (FRectRegion.Right=FRectRegion.Bottom) and
    (FRectRegion.Top=FRectRegion.Bottom) then begin
    FRegionType:=eRegionNULL;
  end else begin
    FRegionType:=eRegionSimple;
  end;
end;

function TmuiBasicRegion.Debugout: string;
begin
  Result := '('+IntToStr(FRectRegion.Left) + ', ' + IntToStr(FRectRegion.Top) + ' ; ' + IntToStr(FRectRegion.Right) + ', ' + IntToStr(FRectRegion.Bottom) + ')';
end;

function TmuiBasicRegion.CombineWithRegion(const ARegion: TmuiBasicRegion;
  const ACombineMode: TmuiRegionCombine): TmuiBasicRegion;
  function Min(const V1,V2: SizeInt): SizeInt;
  begin
    if V1<V2 then Result:=V1 else Result:=V2;
  end;
  function Max(const V1,V2: SizeInt): SizeInt;
  begin
    if V1>V2 then Result:=V1 else Result:=V2;
  end;
  procedure CombineAnd(const TargetRegion: TmuiBasicRegion; const r1,r2: TRect);
  var
    Intersect: Boolean;
  begin
    if (r2.Left>r1.Right) or
       (r2.Right<r1.Left) or
       (r2.Top>r1.Bottom) or
       (r2.Bottom<r1.Top) then begin
      Intersect:=false;
    end else begin
      Intersect:=true;
    end;
  	if Intersect then begin
      TargetRegion.CreateRectRegion(
        classes.Rect(
          Max(r1.Left,r2.Left),
          Max(r1.Top,r2.Top),
          Min(r1.Right,r2.Right),
          Min(r1.Bottom,r2.Bottom)
        )
      );
   	end else begin
      TargetRegion.CreateRectRegion(classes.Rect(0,0,0,0));
    end;
  end;
begin
  Result:=TmuiBasicRegion.Create;
  Case ACombineMode of
    eRegionCombineAnd:  CombineAnd(Result,ARegion.FRectRegion,Self.FRectRegion);
    eRegionCombineCopy,
    eRegionCombineDiff:
      begin
        Result.CreateRectRegion(rect(0,0,0,0));
      end;
    eRegionCombineOr,
    eRegionCombineXor:
      begin
        Raise Exception.CreateFmt('Region mode %d not supported',[integer(ACombineMode)]);
      end;
  end;
end;

{ TMUICanvas }

function TMUICanvas.GetOffset: TPoint;
begin
  Result.X := DrawRect.Left + Offset.X;
  Result.Y := DrawRect.Top + Offset.Y;
  //writeln('  GetOffset: ', Result.X);
  //Result.X := Result.X + FClipping.Left;
  //Result.Y := Result.Y + FClipping.Top;
end;

procedure TMUICanvas.MoveTo(x, y: integer);
begin
  if Assigned(RastPort) then
  begin
    //writeln('MoveTo: ', Assigned(Clipping), ' -> ', GetOffset.X + x,', ', GetOffset.Y + Y);
    GfxMove(RastPort, GetOffset.X + x, GetOffset.Y + y);
    Position.X := X;
    Position.Y := Y;
  end;
end;

procedure TMUICanvas.LineTo(x, y: integer; SkipPenSetting: Boolean = False);
var
  T: TPoint;
  sx, sy, ex, ey: Integer;
begin
  if Assigned(RastPort) then
  begin
    //writeln('LineTo at: ', GetOffset.X + x, ', ', GetOffset.X + Y);
    if not SkipPenSetting then
      SetPenToRP();
    Drawn := True;    
    T := GetOffset;
    Draw(RastPort, T.X + x, T.Y + y);
    if (Position.X = X) and (FPen.FWidth > 1) then
    begin
      sx := x - (FPen.FWidth div 2);
      ex := x + (FPen.FWidth div 2) + (FPen.FWidth mod 2);
      RectFill(RastPort, T.X + SX, T.Y + Position.Y, T.X + ex, T.Y + Y);
      MoveTo(x, y);
    end;
    if (Position.Y = Y) and (FPen.FWidth > 1) then
    begin
      SY := Y - (FPen.FWidth div 2);
      EY := Y + (FPen.FWidth div 2) + (FPen.FWidth mod 2);
      RectFill(RastPort, T.X + Position.X, T.Y + SY, T.X + X, T.Y + EY);
      MoveTo(x, y);
    end;
    Position.X := X;
    Position.Y := Y;
  end;
end;

procedure TMUICanvas.FillRect(X1, Y1, X2, Y2: Integer);
var
  T: TPoint;
begin
  if Assigned(RastPort) then
  begin
    T := GetOffset;
    Drawn := True;
    RectFill(RastPort, T.X + X1, T.Y + Y1, T.X + X2, T.Y + Y2);
    SetPenToRP();
  end;
end;

procedure TMUICanvas.Rectangle(X1, Y1, X2, Y2: Integer);
var
  T: TPoint;
  RX, RY: Integer;
begin
  if Assigned(RastPort) then
  begin
    Drawn := True;
    T := GetOffset;
    if X2 < X1 then
    begin
      RX := X2;
      X2 := X1;
      X1 := RX;
    end;
    if Y2 < Y1 then
    begin
      RY := Y2;
      Y2 := Y1;
      Y1 := RY;
    end;    
    if FBrush.FStyle = JAM2 then
    begin
      SetBrushToRP(True);
      RectFill(RastPort, T.X + X1, T.Y + Y1, T.X + X2, T.Y + Y2);
    end;
    SetPenToRP();
    GfxMove(RastPort, T.x + X1, T.Y + Y1);
    Draw(RastPort, T.X + X2, T.Y + Y1);
    Draw(RastPort, T.X + X2, T.Y + Y2);
    Draw(RastPort, T.X + X1, T.Y + Y2);
    Draw(RastPort, T.X + X1, T.Y + Y1);
  end;
end;

procedure TMUICanvas.Ellipse(X1, Y1, X2, Y2: Integer);
const
  AREA_BYTES = 1000;
var
  T: TPoint;
  Ras: TPlanePtr;
  TRas: TTmpRas;
  WarBuff: array[0..AREA_BYTES] of Word;
  ari: TAreaInfo;
  ElWi, ElHi: Integer; // ellipse height and width
  Rx, RY: Integer; // Radius
  MX, MY: Integer; // center Point
begin  
  if Assigned(RastPort) then
  begin
    Drawn := True;
    T := GetOffset;
    if X2 < X1 then
    begin
      RX := X2;
      X2 := X1;
      X1 := RX;
    end;
    if Y2 < Y1 then
    begin
      RY := Y2;
      Y2 := Y1;
      Y1 := RY;
    end;
    ElWi := X2 - X1;
    ElHi := Y2 - Y1;
    RX := ElWi div 2;
    RY := ElHi div 2;
    MX := X1 + RX;
    MY := Y1 + RY;
    SetBrushToRP(True);
    if (RX > 0) and (RY > 0) and (FBrush.FStyle = JAM2) then
    begin
      Ras := AllocRaster(ElWi * 2, ElHi * 2);
      InitTmpRas(@TRas, ras, ElWi * 2 * ElHi * 2 * 3);
      InitArea(@ari, @WarBuff[0], AREA_BYTES div 5);
      RastPort^.TmpRas := @TRas;
      RastPort^.AreaInfo := @Ari;
      AreaEllipse(RastPort, T.X + MX, T.Y + MY, RX, RY);
      AreaEnd(RastPort);
      RastPort^.TmpRas := nil;
      RastPort^.AreaInfo := nil;
      FreeRaster(Ras, ElWi * 2, ElHi * 2);
    end;
    SetPenToRP();
    DrawEllipse(RastPort, T.X + MX, T.Y + MY, RX, RY);    
  end;  
end;

procedure TMUICanvas.Polygon(Points: Types.PPoint; NumPoint: Integer);
const
  AREA_BYTES = 1000;
var
  CurPoint: Types.PPoint;
  Ras: TPlanePtr;
  TRas: TTmpRas;
  WarBuff: array[0..AREA_BYTES] of Word;
  ari: TAreaInfo;
  T: TPoint;
  i: Integer;
begin
  if not Assigned(RastPort) then
    Exit;
  //
  Drawn := True;
  T := GetOffset;
  if FBrush.FStyle = JAM2 then
  begin
    SetBrushToRP(True);
    Ras := AllocRaster(DrawRect.Right, DrawRect.Bottom);
    InitTmpRas(@TRas, ras, DrawRect.Right * DrawRect.Bottom * 3);
		InitArea(@ari, @WarBuff[0], AREA_BYTES div 5);
		RastPort^.TmpRas := @TRas;
		RastPort^.AreaInfo := @Ari;
    CurPoint := Points;
    AreaMove(RastPort, T.X + CurPoint^.X, T.Y + CurPoint^.Y);
    for i := 1 to NumPoint - 1 do
    begin
      Inc(CurPoint);
      AreaDraw(RastPort, T.X + CurPoint^.X, T.Y + CurPoint^.Y);
    end;
		AreaEnd(RastPort);
		RastPort^.TmpRas := nil;
		RastPort^.AreaInfo := nil;
    FreeRaster(Ras, DrawRect.Right, DrawRect.Bottom);
  end;
  SetPenToRP();
  CurPoint := Points;
  GfxMove(RastPort, T.X + CurPoint^.X, T.Y + CurPoint^.Y);
  for i := 1 to NumPoint - 1 do
  begin
    Inc(CurPoint);
    Draw(RastPort, T.X + CurPoint^.X, T.Y + CurPoint^.Y);
  end;
  Draw(RastPort, T.X + Points^.X, T.Y + Points^.Y);
end;

procedure TMUICanvas.FloodFill(X, Y: Integer; Color: TColor);
var
  //t1, t2,t3: Int64;
  T: TPoint;
  NewCol, Col: LongWord;
  Index, Width, Height: Integer;
  NX, NY: Integer;
  Checked: array of array of Boolean;
  ToCheck: array of record
    x, y: Integer;
  end;  
  
  procedure AddToCheck(AX, AY: Integer);
  begin
    if (AX >= 0) and (AY >= 0) and (AX < Width) and (AY < Height) then
    begin
      if Checked[AX,AY] then
        Exit;
      Inc(Index);
      if Index > High(ToCheck) then
        SetLength(ToCheck, Length(ToCheck) + 1000);
      ToCheck[Index].X := AX;
      ToCheck[Index].Y := AY;
    end;  
  end;
  
  procedure CheckNeighbours(AX, AY: Integer);
  begin
    if (AX >= 0) and (AY >= 0) and (AX < Width) and (AY < Height) then
    begin
      Checked[AX,AY] := True;
      if ReadRGBPixel(RastPort, T.X + AX, T.Y + AY) = Col then
      begin
        if WriteRGBPixel(RastPort, T.X + AX, T.Y + AY, NewCol) = -1 then
          Exit;
        AddToCheck(AX - 1, AY);          
        AddToCheck(AX, AY - 1);
        AddToCheck(AX + 1, AY);
        AddToCheck(AX, AY + 1);        
      end;
    end;
  end;
     
begin
  if Assigned(RastPort) then
  begin
    //t1 := GetMsCount;
    Drawn := True;
    T := GetOffset;
    Width := DrawRect.Right;
    Height := DrawRect.Bottom;
    SetLength(Checked, Width, Height);
    for NX := 0 to Width - 1 do
      for NY := 0 to Height - 1 do
      begin
        Checked[Nx,Ny] := False;
      end;    
    //t2 := GetMsCount;  
    NewCol := TColorToMUIColor(Color);
    Col := ReadRGBPixel(RastPort, T.X + X, T.Y + Y);
    if NewCol <> Col then
    begin
      Index := -1;
      SetLength(ToCheck, 10);
      CheckNeighbours(X, Y);
      while Index >= 0 do
      begin
        NX := ToCheck[Index].X;
        NY := ToCheck[Index].Y;
        Dec(Index);
        CheckNeighbours(NX, NY);
      end;
    end;
    //t3 := GetMsCount;
    //writeln('Floodfill time: prep: ', t2-t1, ' Fill ', t3-t2, ' all: ', t3-t1);
  end;
end;

procedure TMUICanvas.SetPixel(X, Y: Integer; Color: TColor);
var
  T: TPoint;
begin
  if Assigned(RastPort) then
  begin
    Drawn := True;
    T := GetOffset;
    WriteRGBPixel(RastPort, T.X + X, T.Y + Y, TColorToMUIColor(Color));
  end;
end;

function TMUICanvas.GetPixel(X,Y: Integer): TColor;
var
  T: TPoint;
begin
  Result := 0;
  if Assigned(RastPort) then
  begin
    T := GetOffset;
    Result := MUIColorToTColor(ReadRGBPixel(RastPort, T.X + X, T.Y + Y));
  end;
end;

procedure TMUICanvas.WriteText(Txt: PChar; Count: integer);
var
  Tags: TTagsList;
  Col: LongWord;
  Hi: Integer;
begin
  {if Assigned(MUIObject) then
  begin
    writeln('Text1: ', MUIObject.classname, ' ', Txt);
  end else
    writeln('Text2: ', Txt);}
  //writeln('Write Text ', HexStr(Pointer(BKColor)), ' ', HexStr(Pointer(TextColor)));
  if Assigned(RastPort) then
  begin    
    SetPenToRP;
    //SetFontToRP;
    //SetBrushToRP;
    Drawn := True;
    Hi := TextHeight('|', 1);
    MoveTo(Position.X, Position.Y + (Hi div 2) + (Hi div 4));
    Col := TColorToMUIColor(TextColor);
    AddTags(Tags, [LongInt(RPTAG_PenMode), LongInt(False), LongInt(RPTAG_FGColor), LongInt(col), LongInt(TAG_DONE), 0]);
    SetRPAttrsA(RastPort, GetTagPtr(Tags));
    GfxText(RastPort, Txt, Count);
    SetPenToRP;
  end;
end;

function TMUICanvas.TextWidth(Txt: PChar; Count: integer): integer;
begin
  Result := 0;
  if Assigned(RastPort) then
  begin
    Result := TextLength(RastPort, Txt, Count);
  end else
  begin
    //Result := 1;
    // problems with ToolButton, removed for now
    //if Assigned(FFont) and Assigned(FFont.FontHandle) then
    //  Result := FFont.FontHandle^.tf_XSize * (Count + 1);
    //writeln('Textwidth ', Txt, '   ', Result);  
  end;
end;

function TMUICanvas.TextHeight(Txt: PChar; Count: integer): integer;
var
  TE: TTextExtent;
begin
  Result := 0;
  if Assigned(RastPort) then
  begin
    TextExtent(RastPort, Txt, Count, @TE);
    Result := TE.te_Height;
  end else
  begin    
    if Assigned(FFont) and Assigned(FFont.FontHandle) then
      Result := FFont.FontHandle^.tf_YSize;
  end;
end;

procedure TMUICanvas.SetAMUIPen(PenDesc: integer);
begin
  if (PenDesc >= 0) and Assigned(RenderInfo) then
    SetAPen(RastPort, RenderInfo^.mri_Pens[PenDesc]);
end;

procedure TMUICanvas.SetBMUIPen(PenDesc: integer);
begin
  if (PenDesc >= 0) and Assigned(RenderInfo) then
    SetAPen(RastPort, RenderInfo^.mri_Pens[PenDesc]);
end;

constructor TMUICanvas.Create;
var
  APenData: TLogPen;
  ABrushData: TLogBrush;
  AFontData: TLogFont;
begin
  //writeln('-->TCanvas.create ', HexStr(Self));
  Bitmap := nil;
  MUIObject := nil;
  ABrushData.lbColor := LongWord(clBtnFace);
  APenData.lopnColor := clBlack;
  APenData.lopnWidth := Point(1,1);
  APenData.lopnStyle := PS_SOLID;
  AFontData.lfFaceName := 'Arial';
  AFontData.lfHeight := 13;
  FDefaultBrush := TMUIBrushObj.Create(ABrushData);
  FDefaultPen := TMUIPenObj.Create(APenData);
  FDefaultFont := TMUIFontObj.Create(AFontData);
  FBrush := FDefaultBrush;
  FPen := FDefaultPen;
  FFont := FDefaultFont;
  TextColor := 0;
  Drawn := True;
  BKColor := clNone;
  InitDone := False;
  //writeln('<--TCanvas.create ', HexStr(Self));
end;

destructor TMUICanvas.Destroy;
begin
  //writeln('-->TCanvas.destroy ', HexStr(Self));
  if not Assigned(MUIObject) then
  begin
    FreeBitmap(RastPort^.Bitmap);
    FreeRastPort(RastPort);
  end;  
  FDefaultBrush.Free;
  FDefaultPen.Free;
  FDefaultFont.Free;
  inherited;
  //writeln('<--TCanvas.destroy ', HexStr(Self));
end;

procedure TMUICanvas.InitCanvas;
var
  t: TPoint;
begin  
  if InitDone then
    Exit;  
  //DeInitCanvas;
  InitDone := True;
  if Assigned(RastPort) then
  begin
    OldAPen := GetAPen(RastPort);
    OldBPen := GetBPen(RastPort);
    OldOPen := GetOutlinePen(RastPort);
    OldFont := RastPort^.Font;
    OldDrMd := GetDrMd(RastPort);
    OldPat := RastPort^.LinePtrn;
    OldStyle := SetSoftStyle(RastPort, 0,0);    
    if Assigned(RenderInfo) and (FClipping.Right - FClipping.Left <> 0) then
    begin
      T := GetOffset;
      FClip := MUI_AddClipping(RenderInfo, T.X + FClipping.Left, T.Y + FClipping.Top, FClipping.Right - FClipping.Left, FClipping.Bottom - FClipping.Top);
    end;  
  end;
  SetPenToRP;
  SetBrushToRP;
  SetFontToRP;
end;

procedure TMUICanvas.DeInitCanvas;
var
  Tags: TTagsList;
  Col: LongWord;
begin
  if not InitDone then
    Exit;
  InitDone := False;  
  if Assigned(FClip) and Assigned(RenderInfo) then
  begin
    MUI_RemoveClipRegion(RenderInfo, FClip);
  end;
  FClip := nil;
  FClipping.Left := 0;
  FClipping.Top := 0;
  FClipping.Right := 0;
  FClipping.Bottom := 0;
  if Assigned(RastPort) then
  begin
    SetAPen(RastPort, OldAPen);
    SetBPen(RastPort, OldBPen);
    SetOutlinePen(RastPort, OldOPen);
    SetFont(RastPort, OldFont);
    SetDrMd(RastPort, OldDrMd);
    //SetDrPt(RastPort, $FFFF);
    //RastPort^.LinePtrn := OldPat;
    SetSoftStyle(RastPort, OldStyle, ALLSTYLES);
    Col := 0;
    AddTags(Tags, [LongInt(RPTAG_PenMode), LongInt(False), LongInt(RPTAG_FGColor), LongInt(col), LongInt(TAG_DONE), 0]);
    SetRPAttrsA(RastPort, GetTagPtr(Tags));
  end;  
end;

procedure TMUICanvas.SetFontToRP;
begin
  if Assigned(RastPort) then
  begin
    if Assigned(FFont) and Assigned(FFont.FontHandle) then
    begin
      SetFont(RastPort, FFont.FontHandle);   
      SetSoftStyle(RastPort, FFont.FontStyle, ALLSTYLES);
    end else
    begin
      SetFont(RastPort, FDefaultFont.FontHandle);
      SetSoftStyle(RastPort, 0, ALLSTYLES);      
    end;
  end;
end;

procedure TMUICanvas.SetClipping(AClip: TMuiBasicRegion);
var
  T: TPoint;
begin
  if Assigned(FClip) then
    MUI_RemoveClipRegion(RenderInfo, FClip); 
  FClip := nil;
  FClipping.Left := 0;
  FClipping.Top := 0;
  if Assigned(AClip) and Assigned(RenderInfo) then
  begin
    if AClip.GetRegionType = eRegionNULL then
      Exit;
    T := GetOffset;
    FClip := MUI_AddClipping(RenderInfo, T.X + AClip.FRectRegion.Left, T.Y + AClip.FRectRegion.Top, AClip.FRectRegion.Right - AClip.FRectRegion.Left, AClip.FRectRegion.Bottom - AClip.FRectRegion.Top);
    FClipping := AClip.FRectRegion;
  end;
end;

procedure TMUICanvas.SetPenToRP;
var
  Col: TColor;
  Tags: TTagsList;
  PenDesc: Integer;
  //p: Word;
begin
  if Assigned(RastPort) then
  begin
    if Assigned(FPen) then
    begin
      {p := $FFFF;
      case FPen.Style of
        PS_DOT: p:=1;
        PS_NULL: p := 0;
        PS_DASH: p := $FF00;
        PS_DASHDOT: p := $FF01; 
        PS_DASHDOTDOT: p := $FF11;
        PS_USERSTYLE: p:= 1;
        else
          p := $FF00;
          //p := FPen.Style;
      end;
      //RastPort^.LinePtrn := p;
      //SetDrPt(RastPort, p);}
      if FPen.IsSystemColor then
      begin
        Col := FPen.LCLColor;
        PenDesc := FPen.PenDesc;
        SetAMUIPen(PenDesc);
      end else
      begin
        //writeln('Set color in RastPort: ', HexStr(Pointer(FPen.Color)));
        Col := FPen.Color;
        AddTags(Tags, [LongInt(RPTAG_PenMode), LongInt(False), LongInt(RPTAG_FGColor), LongInt(Col), LongInt(TAG_DONE), 0]);
        SetRPAttrsA(RastPort, GetTagPtr(Tags));
      end;
    end;
  end;
end;

procedure TMUICanvas.SetBrushToRP(AsPen: Boolean = False);
var
  Col: TColor;
  Tags: TTagsList;
  PenDesc: Integer;
begin
  if Assigned(RastPort) then
  begin
    if Assigned(FBrush) then
    begin
      if FBrush.IsSystemColor then
      begin
        Col := FBrush.LCLColor;
        PenDesc := FBrush.PenDesc;
        if AsPen then
          SetAMUIPen(PenDesc)
        else
          SetBMUIPen(PenDesc);
      end else
      begin
        Col := FBrush.Color;
        if AsPen then
        begin
          AddTags(Tags, [LongInt(RPTAG_PenMode), LongInt(False), LongInt(RPTAG_FGColor), LongInt(Col), LongInt(TAG_DONE), 0]);
          SetDrMd(RastPort, JAM1);
        end else
        begin
          AddTags(Tags, [LongInt(RPTAG_PenMode), LongInt(False), LongInt(RPTAG_BGColor), LongInt(Col), LongInt(TAG_DONE), 0]);
          SetDrMd(RastPort, FBrush.Style);
        end;
        SetRPAttrsA(RastPort, GetTagPtr(Tags));
      end;
    end;
  end;
end;

procedure TMUICanvas.SetBKToRP(AsPen: Boolean = False);
var
  Col: TMUIColor;
  Tags: TTagsList;
begin
  //writeln('set BK Color $', HexStr(Pointer(BKColor)));
  if Assigned(RastPort) then
  begin        
    if BKColor = clNone then
    begin
      SetBrushToRP(AsPen);
      //Col := TColorToMUIColor(clBtnFace);
    end else
    begin
      Col := TColorToMUIColor(BKColor);
    end;
    if AsPen then
    begin
      AddTags(Tags, [LongInt(RPTAG_PenMode), LongInt(False), LongInt(RPTAG_FGColor), LongInt(Col), LongInt(TAG_DONE), 0]);      
    end else
    begin
      AddTags(Tags, [LongInt(RPTAG_PenMode), LongInt(False), LongInt(RPTAG_BGColor), LongInt(Col), LongInt(TAG_DONE), 0]);
    end;
    SetRPAttrsA(RastPort, GetTagPtr(Tags));
  end;
end;

function TMUICanvas.SelectObject(NewObj: TMUIWinAPIElement): TMUIWinAPIElement;
begin
  Result := nil;
  if not Assigned(NewObj) then
    Exit;
  //writeln('Select: ', NewObj.classname, ' self: ', HexStr(Self));
  if NewObj is TMUIPenObj then
  begin
    Result := FPen;
    FPen := TMUIPenObj(NewObj);
    SetPenToRP;
  end;
  if NewObj is TMUIBrushObj then
  begin
    Result := FBrush;
    FBrush := TMUIBrushObj(NewObj);
    SetBrushToRP;
  end;
  if NewObj is TMUIFontObj then
  begin
    //writeln('SetNewFont: ', HexStr(NewObj), ' curObj: ', HexStr(FFont));
    Result := FFont;
    //writeln('2');
    FFont := TMUIFontObj(NewObj);
    //writeln('3');
    SetFontToRP;
    //writeln('4');
  end;
  if NewObj is TMUIBitmap then
  begin
    //writeln('new bitmap! ', hexstr(Self), ' Bitmap ', HexStr(Newobj));
    Result := Bitmap;
    if Assigned(Bitmap) then
    begin
      if Bitmap.MUICanvas = self then
        Bitmap.MUICanvas := nil;    
    end;  
    Bitmap := TMUIBitmap(NewObj);
    if not Assigned(MUIObject) then
    begin
      Drawn := False;
      if Bitmap.MUICanvas = nil then
        Bitmap.MUICanvas := Self;
      FreeBitmap(RastPort^.Bitmap);
      RastPort^.Bitmap := AllocBitMap(Bitmap.FWidth, Bitmap.FHeight, 32, BMF_CLEAR or BMF_MINPLANES, IntuitionBase^.ActiveScreen^.RastPort.Bitmap);       
      DrawRect := Rect(0, 0, Bitmap.FWidth, Bitmap.FHeight);
      WritePixelArray(Bitmap.FImage, 0, 0, Bitmap.FWidth * SizeOf(LongWord), RastPort, 0, 0, Bitmap.FWidth, Bitmap.FHeight, RECTFMT_ARGB);
    end;
  end;
end;

procedure TMUICanvas.ResetPenBrushFont;
begin
  SetPenToRP;
  SetBrushToRP;
  SetFontToRP;
end;

initialization
  


finalization

end.

