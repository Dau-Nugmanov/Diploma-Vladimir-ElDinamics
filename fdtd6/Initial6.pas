unit Initial6;

{������ ��������� ����������
PlaneWaveTE � PlaneWaveTM - ������ �������, Sin-�������� �����
GaussTE � GaussTM - ������� ����� � �������������� ������}

interface

{$D+}

uses
  Common6, Regions, PhisCnst, Graphics,ColorUnit;

procedure PlaneWaveTE;
procedure PlaneWaveTM;
procedure GaussTE;
procedure GaussTM;
procedure WaveFromRegionList;

procedure TestDraw;
function ColorByValue(FieldType: TFieldType; Value: Extended): TColor;
function Tag(FieldType: TFieldType): Byte;
function GetMaxValue(FieldType: TFieldType): Single;

implementation

procedure PlaneWaveTE;
var
  i, j: Integer;
begin
  for i := InitialX1 to InitialX2 do
    for j := InitialY1 to InitialY2 do
//������������� � ������������
      if (i + j + 2) mod 2 = 0 then
      begin
        Ez[i, j] := Ez0
          * Sin(Pi * HalfPX * (i - InitialX1) / (InitialX2 - InitialX1))
          * Sin(Pi * HalfPY * (j - InitialY1) / (InitialY2 - InitialY1));
        Dz[i, j]:=Ez[i, j] * Eps0 * RegionList.Eps;
      end
      else
      begin
        Hy[i, j] := Hz0
          * Sin(Pi * HalfPX * (i - InitialX1) / (InitialX2 - InitialX1))
          * Sin(Pi * HalfPY * (j - InitialY1) / (InitialY2 - InitialY1));
        By[i, j] := Hy[i, j] * Mu0;
      end;
end;

procedure PlaneWaveTM;
var
  i, j: Integer;
begin
  for i := InitialX1 to InitialX2 do
    for j := InitialY1 to InitialY2 do
      if (i + j + 2) mod 2 = 0 then
      begin
        Ey[i, j]:=Ez0
          * Sin(Pi * HalfPX * (i - InitialX1) / (InitialX2 - InitialX1))
          * Cos(Pi * HalfPY * (j - InitialY1) / (InitialY2 - InitialY1));
        Dy[i, j]:=Ez[i, j] * Eps0 * RegionList.Eps;
      end
      else
      begin
        Hz[i, j]:=Hz0
          *Sin(Pi * HalfPX * (i - InitialX1) / (InitialX2 - InitialX1))
          *Cos(Pi * HalfPY * (j - InitialY1) / (InitialY2 - InitialY1));
        Bz[i, j]:=Hy[i, j] * Mu0;
      end;
end;

procedure GaussTE;
var
  i, j: Integer;
begin
  for i := InitialX1 to InitialX2 do
    for j := InitialY1 to InitialY2 do
      if (i + j + 2) mod 2 = 0 then
      begin
        Ez[i, j]:=Ez0
          * Sin(Pi * HalfPX * (i - InitialX1) / (InitialX2 - InitialX1))
          * Sin(Pi * HalfPY * (j - InitialY1) / (InitialY2 - InitialY1))
          * Exp(-Sqr(ExpX * (I - (InitialX1 + InitialX2) / 2))
          -Sqr(ExpY * (j - (InitialY1 + InitialY2) / 2)));
        Dz[i, j]:=Ez[i, j] * Eps0 * RegionList.Eps;
      end
      else
      begin
        Hy[i, j]:=Hz0
          * Sin(Pi * HalfPX * (i - InitialX1) / (InitialX2 - InitialX1))
          * Sin(Pi * HalfPY * (j - InitialY1) / (InitialY2 - InitialY1))
          * Exp(-Sqr(ExpX * (I - (InitialX1 + InitialX2) / 2))
          -Sqr(ExpY * (j - (InitialY1 + InitialY2) / 2)));
        By[i, j]:=Hy[i, j] * Mu0;
      end;
end;

procedure GaussTM;
begin
end;

procedure WaveFromRegionList;
var
  i, j, k: Integer;
  EndX, EndY: Integer;
begin
  with RegionList do
  for i := 0 to FieldList.Count - 1 do
  begin
    FieldList[i].FillEx(Ex);
    FieldList[i].FillEy(Ey);
    FieldList[i].FillEz(Ez);
    FieldList[i].FillDx(Dx);
    FieldList[i].FillDy(Dy);
    FieldList[i].FillDz(Dz);
    FieldList[i].FillBx(Bx);
    FieldList[i].FillBy(By);
    FieldList[i].FillBz(Bz);
    FieldList[i].FillHx(Hx);
    FieldList[i].FillHy(Hy);
    FieldList[i].FillHz(Hz);
  end;
end;

procedure TestDraw;
type
  TIntArray = array[0..32767] of Integer;
  PIntArray = ^TIntArray;
var
  i, j: Integer;
  Line: PIntArray;
  FieldValue: Single;
begin
 for j := 0 to SizeY - 1 do
    begin
      Line := WaveBitmap.ScanLine[j];
      for i := 0 to SizeX - 1 do
        if (i + j + 2) mod 2 = Tag(WaveF.FieldType) then
          Line[i] := ColorByValue(WaveF.FieldType, WaveF.Field^[i, j]);
    end;
end;

function ColorByValue(FieldType: TFieldType;
  Value: Extended): TColor;
var
  Max, Min: Extended;
begin
//���������� ���� �� �������� ����
//����� ��� ���������� ������� ����
  Max := BlackValue * GetMaxValue(FieldType);
  Min := WhiteValue * GetMaxValue(FieldType);
  if Abs(Value) >= Max then
  begin
    Result := clBlack;
    Exit;
  end;
  if Abs(Value) <= Min then
  begin
    Result := clWhite;
    Exit;
  end;
  Result := ColorArray[Round(255 * (Abs(Value) - Min) / (Max - Min))];
end;

function Tag(FieldType: TFieldType): Byte;
begin
//��������� 0 ���� ���������� �������� �������������
//� 1 - ���� ���������
//����� ��� ���������� �������������
  Result := 0;
  if (FieldType = ftBType) or (FieldType = ftHType) then
    Result := 1;
end;

function GetMaxValue(FieldType: TFieldType): Single;
begin
//���������� ������������ ��������� �������� ����������
  Result := 0.1;
  case FieldType of
    ftEType : Result := Ez0;
    ftDType : Result := Ez0 * Eps0 * RegionList.Eps;
    ftHType : Result := Hz0;
    ftBType : Result := Hz0 * Mu0;
  end;
end;

end.
