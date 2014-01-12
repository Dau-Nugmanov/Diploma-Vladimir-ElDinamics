unit THR6;

{Подзадача основного процесса
в методе Execute происходит вызов процедур рассчета пока подзадача
не будет остановлена, если включены Автостоп или Автосохранение,
то подзадача остановится автоматически
OnCalculate - событие при прохождении очередного шага, используется
  для прорисовки}

{$D+}

interface

uses
  Classes, SysUtils, Common6, Proc6, Math,ExtArr;

type
  TThr = class(TThread)
  private
    FOnCalculate: TNotifyEvent;
  protected
    procedure Execute; override;
    procedure Calculate;
  public
    property OnCalculate: TNotifyEvent read FOnCalculate write FOnCalculate;
  end;

implementation

{ TThr }

procedure TThr.Calculate;
begin
  if Assigned(FOnCalculate) then FOnCalculate(Self);
end;

procedure TThr.Execute;
var
  i, j: Integer;
  DrawCount: Byte;
  oldDzN, oldEzN, oldBxN, oldByN, oldHxN, oldHyN: TExtArray;

newDzN : single;
newEzN : single;
newBxN : single;
newByN : single;
newHxN : single;
newHyN : single;

begin

  DrawCount := 0;
  DrawRecord.ReadyToDraw := True;

oldDzN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
oldEzN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
oldBxN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
oldByN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
oldHxN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);
oldHyN := TExtArray.Create(vtExtended, SizeX + 2, SizeY + 2, 0, 0, 0,
    0, -1, -1);

newDzN := 0;
newEzN := 0;
newBxN := 0;
newByN := 0;
newHxN := 0;
newHyN := 0;
  repeat;
{$IFDEF WRPROCESS}
  Writeln(PrFile);
  Writeln(PrFile, 'Thread is to begin calculations');
{$ENDIF}
  Writeln(TestFile, 'Tn=' + IntToStr(Tn));
    for i := 0 to SizeX - 1 do
      for j := 0 to SizeY - 1 do
      begin
//перешагивание во времени и пространстве
        if ((i + j + 2) mod 2 = 0)and((Tn + 2) mod 2 = 0) then
          case ModeType of
            mtTE : ElectrTE(i, j);
            mtTM : ElectrTM(i, j);
          end;
        if ((i + j + 2) mod 2 = 1)and((Tn + 2) mod 2 = 1) then
          case ModeType of
            mtTE : MagnTE(i, j);
            mtTM : MagnTM(i, j);
          end;

newDzN := RoundTo(DzN[i, j], -15);
newEzN := RoundTo(EzN[i, j], -15);
newBxN := RoundTo(BxN[i, j], -15);
newByN := RoundTo(ByN[i, j], -15);
newHxN := RoundTo(HxN[i, j], -15);
newHyN := RoundTo(HyN[i, j], -15);

if newDzN <> oldDzN[i, j] then
Writeln(TestFile, 'DzN['+IntToStr(i)+ ', ' + IntToStr(j) + '] = ' + FormatFloat('0.###############', newDzN));

if newEzN <> oldEzN[i, j] then
Writeln(TestFile, 'EzN['+IntToStr(i)+ ', ' + IntToStr(j) + '] = ' + FormatFloat('0.###############', newEzN));

if newBxN <> oldBxN[i, j] then
Writeln(TestFile, 'BxN['+IntToStr(i)+ ', ' + IntToStr(j) + '] = ' + FormatFloat('0.###############', newBxN));

if newByN <> oldByN[i, j] then
Writeln(TestFile, 'ByN['+IntToStr(i)+ ', ' + IntToStr(j) + '] = ' + FormatFloat('0.###############', newByN));

if newHxN <> oldHxN[i, j] then
Writeln(TestFile, 'HxN['+IntToStr(i)+ ', ' + IntToStr(j) + '] = ' + FormatFloat('0.###############', newHxN));

if newHyN <> oldHyN[i, j] then
Writeln(TestFile, 'HyN['+IntToStr(i)+ ', ' + IntToStr(j) + '] = ' + FormatFloat('0.###############', newHyN));


oldDzN[i, j] := newDzN;
oldEzN[i, j] := newEzN;
oldBxN[i, j] := newBxN;
oldByN[i, j] := newByN;
oldHxN[i, j] := newHxN;
oldHyN[i, j] := newHyN;

      end;

{$IFDEF WRPROCESS}
    Writeln(PrFile, 'Thread has finished calculations');
{$ENDIF}
    if IntEnable then
      if (Tn + 2) mod 2 = 0 then
        AddIntValues;
    AddValues;
//если рисовать не по времени, то рисование возможно
//иначе - рисование возможно два раза подряд, потом выключить,
//пока таймер снoва не включит
    if DrawRecord.ToDraw <> tdOnTime then
      DrawRecord.ReadyToDraw := True;
    if (DrawRecord.ToDraw = tdOnTime) then
    begin
      if (DrawCount < 2)and(DrawRecord.ReadyToDraw) then
        Inc(DrawCount)
      else
      begin
        DrawCount := 0;
        DrawRecord.ReadyToDraw := False;
      end;
    end;
//нарисовать
{$IFDEF WRPROCESS}
    Writeln(PrFile, 'Calling draw procedure');
{$ENDIF}
    Synchronize(Calculate);
    Next;
    Inc(Tn);
    if ((Tn = AutoStopTime) and (AutoStopTime > 0))
      or ((Tn mod AutoSaveTime = 0) and  AutoSave) then
      Suspend;
{$IFDEF WRPROCESS}
    Writeln(PrFile, 'Thread ends current step (' + IntToStr(Tn) + ')');
{$ENDIF}
  until Terminated;
end;

end.
