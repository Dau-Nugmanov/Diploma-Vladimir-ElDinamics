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
  Classes, SysUtils, Common6, Proc6;

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
begin
  DrawCount := 0;
  DrawRecord.ReadyToDraw := True;
  repeat;
{$IFDEF WRPROCESS}
  Writeln(PrFile);
  Writeln(PrFile, 'Thread is to begin calculations');
{$ENDIF}
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
