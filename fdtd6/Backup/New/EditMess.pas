unit EditMess;

{Модуль, определяющий сообщения редактора при закрытии

WM_NOCHANGES - если не было изменений
WM_APPLYCHANGES - если изменения приняты (нажата кнопка "Да")
WM_CANCELCHANGES - если изменения отмененны (нажата кнопка "Нет")
процедуры посылают эти сооьщения приложению, определяемом
идентификатором (Handle-ом) Hnd}

{$D-}

interface

uses
  Windows, Messages, Registry;

const
  WM_NOCHANGES = WM_APP + 1537;
  WM_APPLYCHANGES = WM_APP + 1538;
  WM_CANCELCHANGES = WM_APP + 1539;

const
  MainPath: string = '';
  //временный файл для передачи редактору
  TempFile: string = 'Mediums\~temp.mdm';

procedure SendNoChanges(Hnd: THandle);
procedure SendApply(Hnd: THandle);
procedure SendCancel(Hnd: THandle);

implementation

var
  Reg: TRegistry;

procedure SendNoChanges(Hnd: THandle);
begin
  PostMessage(Hnd, WM_NOCHANGES, 0, 0);
end;

procedure SendApply(Hnd: THandle);
begin
  PostMessage(Hnd, WM_APPLYCHANGES, 0, 0);
end;

procedure SendCancel(Hnd: THandle);
begin
  PostMessage(Hnd, WM_CANCELCHANGES, 0, 0);
end;

begin
  Reg := TRegistry.Create;
  with Reg do
    if OpenKey('Software\FDTD', False) then
      MainPath := ReadString('');
  Reg.Free;
  MainPath := MainPath + '\';
  TempFile := MainPath + TempFile;
end.
