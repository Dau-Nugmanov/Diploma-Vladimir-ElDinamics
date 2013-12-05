unit Grapher;

{$D-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Math;

type
  PPoint = ^TPoint;

  TPoint = record
    X, Y: Extended;
  end;

  TPoints = class(TList)
  private
    FPen: TPen;
    FActive: Boolean;
  protected
    function GetValue(Index: Integer): TPoint;
    procedure SetValue(Index: Integer; Value: TPoint);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(X, Y: Extended);
    procedure Insert(Index: Integer; X, Y: Extended);
    procedure Delete(Index, Count: Integer);
    procedure Clear; override;
    procedure Assign(Source: TPoints);
    procedure SortByX;
    procedure SortByY;
    property Values[Index: Integer]: TPoint read GetValue write SetValue;
    property Pen: TPen read FPen;
    property Active: Boolean read FActive write FActive;
  end;

  TPointsList = class(TList)
  protected
    function GetValue(Index: Integer): TPoints;
  public
    procedure Add;
    procedure Insert(Index: Integer);
    procedure Delete(Index: Integer);
    procedure Clear; override;
    property Values[Index: Integer]: TPoints read GetValue; default;
  end;

  TScale = class(TPersistent)
  private
    FPen: TPen;
    FActive: boolean;
    FAuto: boolean;
    FMinValue: Extended;
    FMaxValue: Extended;
    FCount: word;
    FGrid: boolean;
  protected
    procedure SetMinValue(Value: Extended);
    function GetMinValue: Extended;
    procedure SetMaxValue(Value: Extended);
    function GetMaxValue: Extended;
  public
    property MinValue: Extended read GetMinValue write SetMinValue;
    property MaxValue: Extended read GetMaxValue write SetMaxValue;
    constructor Create;
    destructor Destroy; override;
  published
    property Pen: TPen read FPen write FPen;
    property Active: boolean read FActive write FActive;
    property Auto: boolean read FAuto write FAuto;
    property Grid: boolean read FGrid write FGrid;
    property Count: word read FCount write FCount;
  end;

  TGrapherEvent = procedure(Sender: TObject; X, Y: Extended) of object;

  TGrapher = class(TPaintBox)
  private
    FHorScale: TScale;
    FVerScale: TScale;
    FAutoScale: boolean;
    FPen: TPen;
    FPosInf,
    FNegInf: Integer;
{    FHorizActive: Boolean;
    FHorizScale: Boolean;
    FHorizMax: Extended;
    FHorizMin: Extended;
    FHorizGrid: Boolean;
    FHorizCount: Integer;
    FVertActive: Boolean;
    FVertScale: Boolean;
    FVertMax: Extended;
    FVertMin: Extended;
    FVertGrid: Boolean;
    FVertCount: Integer;}
    FPointsList: TPointsList;
    FMainBitm, FExtBitm: TBitmap;
    FOnMouseEnter, FOnMouseLeave: TNotifyEvent;
    FOnGrapher: TGrapherEvent;
    FKx, FKy: Extended;
{    FDegreeX, FDegreeY: Integer;}
    OldWidth, OldHeight: Integer;
    ToGraphAll: Boolean;
{    procedure SetHorizActive(const Value: Boolean);
    procedure SetHorizCount(const Value: Integer);
    procedure SetHorizGrid(const Value: Boolean);
    procedure SetHorizMax(const Value: Extended);
    procedure SetHorizMin(const Value: Extended);
    procedure SetHorizScale(const Value: Boolean);
    procedure SetVertActive(const Value: Boolean);
    procedure SetVertCount(const Value: Integer);
    procedure SetVertGrid(const Value: Boolean);
    procedure SetVertMax(const Value: Extended);
    procedure SetVertMin(const Value: Extended);
    procedure SetVertScale(const Value: Boolean);
    { Private declarations }
  protected
    procedure DrawBitm;
    procedure Paint; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure MouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure SetPosInf(Value: Integer);
    procedure SetNegInf(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpDate; override;
    procedure Graph(Index: integer);
    procedure GraphAll;
    procedure SetScale(XMin, XMax, YMin, YMax: Extended);
    property PointsList: TPointsList read FPointsList;
    property Bitmap: TBitmap read FMainBitm;
    { Public declarations }
  published
    property Pen: TPen read FPen;
{    property HorizActive: Boolean read FHorizActive write SetHorizActive;
    property HorizScale: Boolean read FHorizScale write SetHorizScale;
    property HorizMax: Extended read FHorizMax write SetHorizMax;
    property HorizMin: Extended read FHorizMin write SetHorizMin;
    property HorizGrid: Boolean read FHorizGrid write SetHorizGrid;
    property HorizCount: Integer read FHorizCount write SetHorizCount;
    property VertActive: Boolean read FVertActive write SetVertActive;
    property VertScale: Boolean read FVertScale write SetVertScale;
    property VertMax: Extended read FVertMax write SetVertMax;
    property VertMin: Extended read FVertMin write SetVertMin;
    property VertGrid: Boolean read FVertGrid write SetVertGrid;
    property VertCount: Integer read FVertCount write SetVertCount;}
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnGrapher: TGrapherEvent read FOnGrapher write FOnGrapher;
    property HorScale: TScale read FHorScale write FHorScale;
    property VerScale: TScale read FVerScale write FVerScale;
    property AutoScale: Boolean read FAutoScale write FAutoScale;
    property PosInf: Integer read FPosInf write SetPosInf;
    property NegInf: Integer read FNegInf write SetNegInf;
  end;

function CompareX(Item1, Item2: Pointer): Integer;
function CompareY(Item1, Item2: Pointer): Integer;
procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Own', [TGrapher]);
end;

function CompareX(Item1, Item2: Pointer): Integer;
begin
  Result := 0;
  if PPoint(Item1)^.X > PPoint(Item2)^.X then
  begin
    Result := 1;
    Exit;
  end;
  if PPoint(Item1)^.X < PPoint(Item2)^.X then
  begin
    Result := -1;
    Exit;
  end;
end;

function CompareY(Item1, Item2: Pointer): Integer;
begin
  Result := 0;
  if PPoint(Item1)^.Y > PPoint(Item2)^.Y then
  begin
    Result := 1;
    Exit;
  end;
  if PPoint(Item1)^.Y < PPoint(Item2)^.Y then
  begin
    Result := -1;
    Exit;
  end;
end;

{ TPoints }

procedure TPoints.Add(X, Y: Extended);
var
  P: PPoint;
begin
  GetMem(P, SizeOf(TPoint));
  P^.X := X;
  P^.Y := Y;
  inherited Add(P);
end;

procedure TPoints.Assign(Source: TPoints);
var
  I: Integer;
begin
  if Count<>0 then Clear;
  for I := 0 to Source.Count-1 do
  begin
    Add(Source.Values[I].X, Source.Values[I].Y);
  end;
end;

procedure TPoints.Clear;
var
  I: Integer;
  P: PPoint;
begin
  for I := 0 to Count-1 do
  begin
    P := Items[I];
    FreeMem(P, SizeOf(TPoint));
  end;
  inherited Clear;
end;

constructor TPoints.Create;
begin
  inherited Create;
  FPen := TPen.Create;
  FActive:=True;
end;

procedure TPoints.Delete(Index, Count: Integer);
var
  P: PPoint;
  I: Integer;
begin
  for I := Index to Index+Count-1 do
  begin
    P := Items[I];
    FreeMem(P, SizeOf(TPoint));
    inherited Delete(I);
  end;
end;

destructor TPoints.Destroy;
begin
  FPen.Free;
  inherited Destroy;
end;

function TPoints.GetValue(Index: Integer): TPoint;
begin
  Result := TPoint(Items[Index]^);
end;

procedure TPoints.Insert(Index: Integer; X, Y: Extended);
var
  P: PPoint;
begin
  GetMem(P, SizeOf(TPoint));
  P^.X := X;
  P^.Y := Y;
  inherited Insert(Index, P);
end;

procedure TPoints.SetValue(Index: Integer; Value: TPoint);
var
  P: PPoint;
begin
  P := Items[Index];
  P^.X := Value.X;
  P^.Y := Value.Y;
end;

procedure TPoints.SortByX;
begin
  Sort(CompareX);
end;

procedure TPoints.SortByY;
begin
  Sort(CompareY);
end;

{ TPointsList }

procedure TPointsList.Add;
var
  P: TPoints;
begin
  P := TPoints.Create;
  inherited Add(P);
end;

procedure TPointsList.Clear;
var
  P: TPoints;
  I: Integer;
begin
  for I := 0to Count-1 do
  begin
    P := TPoints(Items[I]);
    P.Free;
  end;
  inherited Clear;
end;

procedure TPointsList.Delete(Index: Integer);
var
  P: TPoints;
begin
  P := TPoints(Items[Index]);
  P.Free;
  inherited Delete(Index);
end;

function TPointsList.GetValue(Index: Integer): TPoints;
begin
  Result := TPoints(Items[Index]);
end;

procedure TPointsList.Insert(Index: Integer);
var
  P: TPoints;
begin
  P := TPoints.Create;
  inherited Insert(Index, P);
end;

{ TScale }

constructor TScale.Create;
begin
  inherited;
  FPen:=TPen.Create;
  FActive:=True;
  FAuto:=False;
  FGrid:=True;
  FCount:=5;
  FMinValue:=-1;
  FMaxValue:=1;
end;

destructor TScale.Destroy;
begin
  FPen.Free;
  inherited;
end;

function TScale.GetMaxValue: Extended;
begin
  Result:=FMaxValue;
end;

function TScale.GetMinValue: Extended;
begin
  Result:=FMinValue;
end;

procedure TScale.SetMaxValue(Value: Extended);
begin
  if not(FAuto) then FMaxValue:=Value;
end;

procedure TScale.SetMinValue(Value: Extended);
begin
  if not(FAuto) then FMinValue:=Value;
end;

{ TGrapher }

constructor TGrapher.Create;
begin
  inherited Create(AOwner);
  FPen := TPen.Create;
  FHorScale := TScale.Create;
  FHorScale.FMinValue := -1;
  FHorScale.FMaxValue := 1;
  FVerScale := TScale.Create;
  FVerScale.FMinValue := -1;
  FVerScale.FMaxValue := 1;
{  FHorizScale := True;
  FVertScale := True;
  FHorizGrid := True;
  FVertGrid := True;
  FHorizActive := True;
  FVertActive := True;
  FHorizMax := 1;
  FHorizMin := -1;
  FHorizCount := 5;
  FVertCount := 5;
  FVertMax := 1;
  FVertMin := -1;}
  FKx := 1;
  FKy := 1;
{  FDegreeX := 0;
  FDegreeY := 0;}
  FPointsList := TPointsList.Create;
  FMainBitm := TBitmap.Create;
  FExtBitm := TBitmap.Create;
  FMainBitm.Transparent := True;
  FMainBitm.TransparentColor := clWhite;
  OldWidth := 0;
  OldHeight := 0;
  ToGraphAll := False;
  FPosInf := 0;
  FNegInf := 0;
end;

destructor TGrapher.Destroy;
begin
  FExtBitm.Free;
  FMainBitm.Free;
  FPointsList.Free;
  FPen.Free;
  inherited Destroy;
end;

{procedure TGrapher.DrawBitm;
var
  MaxX, MaxY, MinX, MinY, X, Y, Kx, Ky, V,
  ExtKx, ExtKy, A: Extended;
  Degree, I, J, Dx, Dy, Cx, Cy, Mx, My: Integer;
  Points: TPoints;
  Flag: Boolean;
  S: String;
begin
  FMainBitm.Width := Width;
  FMainBitm.Height := Height;
  MaxX := 0;
  MinX := 0;
  MaxY := 0;
  MinY := 0;
  if FHorizScale or FVertScale then
  begin
    Flag := True;
    for I := 0 to FPointsList.Count-1 do
    begin
      Points := FPointsList.Values[I];
      for J := 0 to Points.Count-1 do
      begin
      	X := Points.Values[J].X;
        Y := Points.Values[J].Y;
      	if Flag then
        begin
          Flag := False;
          MaxX := X;
          MinX := X;
          MaxY := Y;
          MinY := Y;
        end;
        if MaxX < X then
        MaxX := X;
        if MinX > X then
        MinX := X;
        if MaxY < Y then
        MaxY := Y;
        if MinY > Y then
        MinY := Y;
      end;
    end;
    if FHorizScale then
    begin
      FHorizMax := MaxX;
      FHorizMin := MinX;
    end;
    if FVertScale then
    begin
      FVertMax := MaxY;
      FVertMin := MinY;
    end;
  end;
  MaxX := FHorizMax;
  MinX := FHorizMin;
  MaxY := FVertMax;
  MinY := FVertMin;

  FMainBitm.Canvas.Font.Assign(Font);
  FMainBitm.Canvas.Pen.Assign(FPen);
  FExtBitm.Canvas.Pen.Assign(FPen);
  FMainBitm.Canvas.Brush.Color := Color;
  FExtBitm.Canvas.Brush.Color := Color;
  Dx := 0;
  Dy := 0;
  Kx := (MaxX-MinX)/FHorizCount;
  Degree := Floor(Ln(Kx)/Ln(10));
  A := Ceil(Kx*Exp(-Degree*Ln(10)));
  A := A*Exp(Degree*Ln(10));
  V := Ceil(MinX*Exp(-Degree*Ln(10)));
  V := V*Exp(Degree*Ln(10));
  while V < MaxX do
  begin
    S := FloatToStrF(V, ffNumber, 7, Max(0, -Degree));
    I := FMainBitm.Canvas.TextHeight(S);
    if I > Dy then
      Dy := I;
    V := V+A;
  end;
  if FHorizActive then
    Dy := Dy+4
  else
    Dy := 0;
  Ky := (MaxY-MinY)/FVertCount;
  Degree := Floor(Ln(Ky)/Ln(10));
  A := Ceil(Ky*Exp(-Degree*Ln(10)));
  A := A*Exp(Degree*Ln(10));
  V := Ceil(MinY*Exp(-Degree*Ln(10)));
  V := V*Exp(Degree*Ln(10));
  while V < MaxY do
  begin
    S := FloatToStrF(V, ffNumber, 7, Max(0, -Degree));
    I := FMainBitm.Canvas.TextWidth(S);
    if I > Dx then
      Dx := I;
    V := V+A;
  end;
  if FVertActive then
    Dx := Dx+4
  else
    Dx := 0;
  FExtBitm.Width := FMainBitm.Width-Dx;
  FExtBitm.Height := FMainBitm.Height-Dy;
  FDegreeX := Floor(Ln((MaxX-MinX)/FExtBitm.Width)/Ln(10));
  FDegreey := Floor(Ln((MaxY-MinY)/FExtBitm.Height)/Ln(10));
  FMainBitm.Canvas.FillRect(Rect(0, 0, FMainBitm.Width, FMainBitm.Height));
  FExtBitm.Canvas.FillRect(Rect(0, 0, FExtBitm.Width, FExtBitm.Height));
  if FHorizActive then
  begin
    Kx := (MaxX-MinX)/FHorizCount;
    Degree := Floor(Ln(Kx)/Ln(10));
    A := Ceil(Kx*Exp(-Degree*Ln(10)));
    A := A*Exp(Degree*Ln(10));
    V := Ceil(MinX*Exp(-Degree*Ln(10)));
    V := V*Exp(Degree*Ln(10));
    Mx := Dx+1;
    ExtKx := FExtBitm.Width/(MaxX-MinX);
    while V < MaxX do
    begin
      S := FloatToStrF(V, ffNumber, 7, Max(0, -Degree));
      I := Canvas.TextWidth(S);
      Cx := Dx+Round(ExtKx*(V-MinX))-I div 2;
      Cy := FMainBitm.Height-Dy+4;
      if (Cx >= Mx) and (Cx < FMainBitm.Width-I) then
      begin
	FMainBitm.Canvas.TextOut(Cx, Cy, S);
        FMainBitm.Canvas.MoveTo(Cx+I div 2, Cy-4);
        FMainBitm.Canvas.LineTo(Cx+I div 2, Cy-1);
        Mx := Cx+I;
      end;
      if FHorizGrid then
      begin
      	FExtBitm.Canvas.MoveTo(Cx-Dx+I div 2, 0);
        FExtBitm.Canvas.LineTo(Cx-Dx+I div 2, FExtBitm.Height-1);
      end;
      V := V+A;
    end;
  end;
  if FVertActive then
  begin
    Ky := (MaxY-MinY)/FVertCount;
    Degree := Floor(Ln(Ky)/Ln(10));
    A := Ceil(Ky*Exp(-Degree*Ln(10)));
    A := A*Exp(Degree*Ln(10));
    V := Ceil(MinY*Exp(-Degree*Ln(10)));
    V := V*Exp(Degree*Ln(10));
    My := FMainBitm.Height-Dy-1;
    ExtKy := FExtBitm.Height/(MaxY-MinY);
    while V < MaxY do
    begin
      S := FloatToStrF(V, ffNumber, 7, Max(0, -Degree));
      I := Canvas.TextWidth(S);
      J := Canvas.TextHeight(S);
      Cx := Dx-4-I;
      Cy := FMainBitm.Height-1-Dy-Round(ExtKy*(V-MinY))-J div 2;
      if (Cy+J < My) and (Cy >= 0) then
      begin
	FMainBitm.Canvas.TextOut(Cx, Cy, S);
        FMainBitm.Canvas.MoveTo(Dx, Cy+J div 2);
        FMainBitm.Canvas.LineTo(Dx-3, Cy+J div 2);
        My := Cy;
      end;
      if FHorizGrid then
      begin
      	FExtBitm.Canvas.MoveTo(0, Cy+J div 2);
        FExtBitm.Canvas.LineTo(FExtBitm.Width-1, Cy+J div 2);
      end;
      V := V+A;
    end;
  end;
  Kx := FExtBitm.Width/(MaxX-MinX);
  Ky := FExtBitm.Height/(MaxY-MinY);
  FKx := Kx;
  FKy := Ky;
  for I := 0 to FPointsList.Count-1 do
  begin
    Points := FPointsList.Values[I];
    FExtBitm.Canvas.Pen.Assign(Points.Pen);
    Flag := True;
    for J := 0 to Points.Count-1 do
    begin
      Cx := Round(Kx*(Points.Values[J].X-MinX));
      Cy := FExtBitm.Height-1-Round(Ky*(Points.Values[J].Y-MinY));
      if Flag then
      begin
	FExtBitm.Canvas.MoveTo(Cx, Cy);
        Flag := False;
      end
      else
	FExtBitm.Canvas.LineTo(Cx, Cy);
    end;
  end;
  FMainBitm.Canvas.Draw(Dx, 0, FExtBitm);
end;}

procedure TGrapher.DrawBitm;
var
  i: Integer;
  X, Y: Extended;
  XG, YG: Integer;
begin
  FMainBitm.Canvas.FillRect(Rect(0, 0, FMainBitm.Width,
    FMainBitm.Height));
  with HorScale do
    if Active then
    begin
      for i:=0 to Count-1 do
      begin
        X:=MinValue+(MaxValue-MinValue)/(Count+1)*(i+1);
        XG:=Round((X-MinValue)*FKx);
        if Grid then
        begin
          Canvas.MoveTo(XG, 0);
          Canvas.LineTo(XG, Height);
        end;
        Canvas.TextOut(XG+1, Height+Canvas.Font.Height-1, FloatToStrF(
          X, ffGeneral, 2, 2))
      end;
    end;
  with VerScale do
    if Active then
    begin
      for i:=0 to Count-1 do
      begin
        Y:=MaxValue-(MaxValue-MinValue)/(Count+1)*(i+1);
        YG:=Round((MaxValue-Y)*FKy);
        if Grid then
        begin
          Canvas.MoveTo(0, YG);
          Canvas.LineTo(Width, YG);
        end;
        Canvas.TextOut(0, YG+1, FloatToStrF(
          Y, ffGeneral, 2, 2));
      end;
    end;
end;

procedure TGrapher.Graph(Index: integer);
var
  XG,YG,i: integer;
  LastInf: SmallInt;
begin
  if not ToGraphAll then
    DrawBitm;
  if PointsList.Count = 0 then
    Exit;
  if PointsList[Index].Count = 0 then
    Exit;
  LastInf := 0;
  FMainBitm.Canvas.Pen.Assign(PointsList[Index].Pen);
  with PointsList[Index] do
    for i := 0 to Count - 1 do
    begin
      XG := Round(FKx * (Values[i].X - FHorScale.FMinValue));
      YG := Height - Round(FKy * (Values[i].Y - FVerScale.FMinValue));
      if i = 0 then
        FMainBitm.Canvas.MoveTo(XG,YG);
      if (LastInf > 0) and (Values[i].Y <= FPosInf) then
        FMainBitm.Canvas.MoveTo(XG,YG);
      if (LastInf < 0) and (Values[i].Y >= FNegInf) then
        FMainBitm.Canvas.MoveTo(XG,YG);
      FMainBitm.Canvas.LineTo(XG,YG);
      LastInf := 0;
      if (FPosInf <> FNegInf) then
      begin
        if Values[i].Y >= FPosInf then
          LastInf := 1;
        if Values[i].Y <= FNegInf then
          LastInf := -1;
      end;
    end;
end;

procedure TGrapher.GraphAll;
var
  i: integer;
begin
  DrawBitm;
  ToGraphAll:=True;
  for i:=0 to PointsList.Count-1 do
    if PointsList[i].Active then Graph(i);
  ToGraphAll:=False;
end;

procedure TGrapher.MouseEnter(var Message: TMessage);
begin
  if Assigned(FOnMouseEnter) then
  FOnMouseEnter(Self);
  if Assigned(FOnGrapher) then
{  FOnGrapher(Self, '', '');}
end;

procedure TGrapher.MouseLeave(var Message: TMessage);
begin
  if Assigned(FOnMouseLeave) then
  FOnMouseLeave(Self);
  if Assigned(FOnGrapher) then
{  FOnGrapher(Self, '', '');}
end;

procedure TGrapher.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  XReal, YReal: Extended;
begin
  inherited MouseMove(Shift, X, Y);
  if Assigned(FOnGrapher) then
  begin
{    if (X > FMainBitm.Width-FExtBitm.Width) and (Y < FExtBitm.Height) then
    begin}
    XReal:=HorScale.MinValue+X/FKx;
    YReal:=VerScale.MaxValue-Y/FKy;
{    end;}
    FOnGrapher(Self, XReal, YReal);
  end;
end;

procedure TGrapher.Paint;
begin
{  if (Width<>OldWidth)or(Height<>OldHeight)then}
    SetScale(FHorScale.FMinValue,FHorScale.FMaxValue,
      FVerScale.FMinValue,FVerScale.FMaxValue);
  OldWidth:=Width;
  OldHeight:=Height;
  if Assigned(FMainBitm) then
    Canvas.Draw(0, 0, FMainBitm);
  inherited Paint;
end;

{procedure TGrapher.SetHorizActive(const Value: Boolean);
begin
  FHorizActive := Value;
end;

procedure TGrapher.SetHorizCount(const Value: Integer);
begin
  FHorizCount := Value;
end;

procedure TGrapher.SetHorizGrid(const Value: Boolean);
begin
  FHorizGrid := Value;
end;

procedure TGrapher.SetHorizMax(const Value: Extended);
begin
  if FHorizMax <> Value then
  FHorizMax := Value;
end;

procedure TGrapher.SetHorizMin(const Value: Extended);
begin
  if FHorizMin <> Value then
  FHorizMin := Value;
end;

procedure TGrapher.SetHorizScale(const Value: Boolean);
begin
  FHorizScale := Value;
end;}

procedure TGrapher.SetNegInf(Value: Integer);
begin
  if Value <= FPosInf then
    FNegInf := Value;
end;

procedure TGrapher.SetPosInf(Value: Integer);
begin
  if Value >= FNegInf then
    FPosInf := Value;
end;

procedure TGrapher.SetScale(XMin, XMax, YMin, YMax: Extended);
var
  Min, Max: Extended;
  i, j, AllCount: integer;
begin
  if PointsList.Count=0 then Exit;
  if AutoScale or FHorScale.FAuto then
  begin
    Min:=1e10;
    Max:=-1e10;
    AllCount:=0;
    for i:=0 to PointsList.Count-1 do
    begin
      AllCount:=AllCount+PointsList[i].Count;
      for j:=0 to PointsList[i].Count-1 do
      begin
        if PointsList[i].Count=0 then Break;
        if PointsList[i].Values[j].X>Max then Max:=PointsList[i].Values[j].X;
        if PointsList[i].Values[j].X<Min then Min:=PointsList[i].Values[j].X;
      end;
    end;
    if AllCount=0 then
    begin
      Min:=-1;
      Max:=1;
    end;
    Min:=Min-0.1*(Max-Min);
    Max:=Max+0.1*(Max-Min);
  end
  else
  begin
    Min:=XMin;
    Max:=XMax;
  end;
  FHorScale.FMinValue:=Min;
  FHorScale.FMaxValue:=Max;
  FKx:=Width/(Max-Min);

  if AutoScale or FVerScale.FAuto then
  begin
    Min:=1e10;
    Max:=-1e10;
    AllCount:=0;
    for i:=0 to PointsList.Count-1 do
    begin
      AllCount:=AllCount+PointsList[i].Count;
      for j:=0 to PointsList[i].Count-1 do
      begin
        if PointsList[i].Count=0 then Break;
        if PointsList[i].Values[j].Y>Max then Max:=PointsList[i].Values[j].Y;
        if PointsList[i].Values[j].Y<Min then Min:=PointsList[i].Values[j].Y;
      end;
    end;
    if AllCount=0 then
    begin
      Min:=-1;
      Max:=1;
    end;
    Min:=Min-0.1*(Max-Min);
    Max:=Max+0.1*(Max-Min);
  end
  else
  begin
    Min:=YMin;
    Max:=YMax;
  end;
  if Min=Max then
  begin
    Min:=Min-0.1;
    Max:=Max+0.1;
  end;
  FVerScale.FMinValue:=Min;
  FVerScale.FMaxValue:=Max;
  FKy:=Height/(Max-Min);
  FMainBitm.Width:=Width;
  FMainBitm.Height:=Height;
end;

{procedure TGrapher.SetVertActive(const Value: Boolean);
begin
  FVertActive := Value;
end;

procedure TGrapher.SetVertCount(const Value: Integer);
begin
  if FVertCount <> Value then
  FVertCount := Value;
end;

procedure TGrapher.SetVertGrid(const Value: Boolean);
begin
  FVertGrid := Value;
end;

procedure TGrapher.SetVertMax(const Value: Extended);
begin
  if FVertMax <> Value then
  FVertMax := Value;
end;

procedure TGrapher.SetVertMin(const Value: Extended);
begin
  if FVertMin <> Value then
  FVertMin := Value;
end;

procedure TGrapher.SetVertScale(const Value: Boolean);
begin
  FVertScale := Value;
end;}

procedure TGrapher.UpDate;
begin
{  DrawBitm;}
  Paint;
  inherited UpDate;
end;

end.
