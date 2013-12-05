unit ExtArr;

{ћодуль описывает двумерный динамический массив (TExtArray)
типа AValuesType размера ASizeX на ASizeY с вырезом размера
AIdleX на AIdleY, смещенным от границ на AShiftX и AShiftY,
индексаци€ начинаетс€ с AStartX и AStartY

     *******************************    ^
     *    *     *   ^       *    * *    |
     *  *     *   SiftY   *    *   *    |
     *      *    *  ^   *    *     *    |
     *    *    * ********* * ^   * *    |
     * <-ShiftX->*       *   | *   *  SizeY
     *     *     *       * IdleY   *    |
     *   *     * *       *   |    **    |
     * *     *   *********   ^  *  *    |
     *     *     <-IdleX->    *    *    |
     *******************************    ^
     <----------SizeX-------------->

ѕри обращении к несуществующему элементу возвращаетс€ 0
ѕам€ти выдел€етс€ только на существующие элементы :
(SizeX * SizeY - IdleX * IdleY) * SizeOf(ValueType)}

{$D-}

interface

uses
  SysUtils;

type
  PSingle = ^Single;
  PDouble = ^Double;
  PExtended = ^Extended;

  TValuesType = (vtSingle, vtDouble, vtExtended);

  TExtArray = class(TObject)
  private
    FSizeX,
    FSizeY,
    FShiftX,
    FShiftY,
    FIdleX,
    FIdleY,
    FStartX,
    FStartY,
    FLength: Integer;
    SizeOfElement: Byte;
    FValues: PByteArray;
    ValuesType: TValuesType;
  protected
    procedure SetValue(X,Y: Integer; Value: Single);
    function GetValue(X,Y: Integer): Single;
  public
    property SizeX: Integer read FSizeX;
    property SizeY: Integer read FSizeY;
    property ShiftX: Integer read FShiftX;
    property ShiftY: Integer read FShiftY;
    property IdleX: Integer read FIdleX;
    property IdleY: Integer read FIdleY;
    property StartX: Integer read FStartX;
    property StartY: Integer read FStartY;
    property Length: Integer read FLength;
    function GetIndex(X, Y: Integer): Integer;
    property Values[X, Y:integer]: Single read GetValue write SetValue;default;
    constructor Create(AValuesType: TValuesType; ASizeX, ASizeY,
      AShiftX,AShiftY, AIdleX, AIdleY, AStartX, AStartY: Integer);
    destructor Destroy; override;
  end;


implementation

{ TExtArray }

function TExtArray.GetIndex(X, Y:integer):integer;
begin
  Result:=-1;

  if (X - FStartX < 0) or (X - FStartX >= FSizeX) then
    Exit;
  if (Y - FStartY < 0) or (Y - FStartY >= FSizeY) then
    Exit;

  if (X - FStartX >= FShiftX) and
    (X - FStartX < FShiftX + FIdleX)and
    (Y - FStartY >= FShiftY) and
    (Y - FStartY < FShiftY + FIdleY) then
    Exit;

  if Y - FStartY < FShiftY then
    Result := (X - FStartX) + (Y - FStartY) * FSizeX;

  if (Y - FStartY >= FShiftY) and
    (Y - FStartY < FShiftY + FIdleY)then
    if X < FShiftX then
      Result := FShiftY * FIdleX + (X - FStartX)
        + (Y - FStartY) * (FSizeX - FIdleX)
    else
      Result:=FShiftY * FIdleX + (X - FStartX)
        + (Y - FStartY) * (FSizeX - FIdleX)-FIdleX;

  if Y - FStartY >= FShiftY + FIdleY then
    Result := (X - FStartX) +
      (Y - FStartY) * FSizeX - FIdleX * FIdleY;
end;

{ TExtArraySng }

constructor TExtArray.Create;
begin
  inherited Create;

  FSizeX := ASizeX;
  FSizeY := ASizeY;
  FStartX := AStartX;
  FStartY := AStartY;
  FIdleX := AIdleX;
  FIdleY := AIdleY;
  FShiftX := AShiftX;
  FShiftY := AShiftY;

  if FIdleX > FSizeX then
  begin
    FShiftX := 0;
    FIdleX := FSizeX;
  end;
  if FIdleY > FSizeY then
  begin
    FShiftY := 0;
    FIdleY := FSizeY;
  end;

  if FShiftX + FIdleX > FSizeX then
    FShiftX := FSizeX - FIdleX;
  if FShiftY + FIdleY > FSizeY then
    FShiftY := FSizeY - FIdleY;

  if FShiftX < 0 then
    FShiftX := 0;
  if FShiftY < 0 then
    FShiftY := 0;

  if FIdleX < 0 then
    FIdleX := 0;
  if FIdleY < 0 then
    FIdleY := 0;

  if FSizeX <= 0 then
    FSizeX := 1;
  if FSizeY <= 0 then
    FSizeY := 1;

  FLength := ASizeX * ASizeY - FIdleX * FIdleY;

  ValuesType := AValuesType;
  case ValuesType of
    vtSingle   : SizeOfElement := SizeOf(Single);
    vtDouble   : SizeOfElement := SizeOf(Double);
    vtExtended : SizeOfElement := SizeOf(Extended);
  end;

  FValues:=AllocMem(FLength * SizeOfElement)
end;

destructor TExtArray.Destroy;
begin
  FreeMem(FValues, FLength * SizeOfElement);
  inherited;
end;

function TExtArray.GetValue(X, Y: integer): single;
var
  Ind: Integer;
begin
  Result := 0;
  Ind := GetIndex(X, Y);
  if Ind >= 0 then
    case ValuesType of
      vtSingle :
        Result := PSingle(Addr(FValues^[Ind * SizeOfElement]))^;
      vtDouble :
        Result := PDouble(Addr(FValues^[Ind * SizeOfElement]))^;
      vtExtended :
        Result := PExtended(Addr(FValues^[Ind * SizeOfElement]))^;
    end;
end;

procedure TExtArray.SetValue(X, Y: integer; Value: single);
var
  Ind: Integer;
begin
  Ind := GetIndex(X, Y);
  if Ind >= 0 then
    case ValuesType of
      vtSingle :
        PSingle(Addr(FValues^[Ind * SizeOfElement]))^ := Value;
      vtDouble :
        PDouble(Addr(FValues^[Ind * SizeOfElement]))^ := Value;
      vtExtended :
        PExtended(Addr(FValues^[Ind * SizeOfElement]))^ := Value;
    end;
end;

end.
