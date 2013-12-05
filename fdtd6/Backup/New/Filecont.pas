unit FileCont;

{$D-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ShellAPI;

type
  TFileContainer = class(TComponent)
  private
    FFiles: TStringList;
    FContainerIsForm: Boolean;
    FControl: TWinControl;
    FOnDroppingFiles: TNotifyEvent;
    FOnAppMessage: TMessageEvent;
  protected
    procedure GettingMessage(var Msg: TMsg; var Handled: Boolean);
    function GetControl: TWinControl;
    procedure SetControl(AControl: TWinControl);
    procedure DroppingFiles;
  public
    property Files: TStringList read FFiles;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RegisterContainer;
  published
    property ContainerIsForm: Boolean read FContainerIsForm write FContainerIsForm;
    property Control: TWinControl read GetControl write SetControl;
    property OnDroppingFiles: TNotifyEvent read FOnDroppingFiles write FOnDroppingFiles;
    property OnAppMessage: TMessageEvent read FOnAppMessage write FOnAppMessage;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Own', [TFileContainer]);
end;

{ TFileContainer }

constructor TFileContainer.Create(AOwner: TComponent);
begin
  inherited;
  FFiles := TStringList.Create;
  FContainerIsForm := True;
//  RegisterContainer;
end;

destructor TFileContainer.Destroy;
begin
  FFiles.Free;
  inherited;
end;

procedure TFileContainer.DroppingFiles;
begin
  if Assigned(FOnDroppingFiles) then
    FOnDroppingFiles(Self);
end;

function TFileContainer.GetControl: TWinControl;
begin
  Result := FControl;
end;

procedure TFileContainer.GettingMessage(var Msg: TMsg;
  var Handled: Boolean);
var
  FilesQuan, Len, i: Integer;
  Name: PChar;
begin
  if Msg.message = WM_DROPFILES then
  begin
    FilesQuan := DragQueryFile(Msg.wParam, $FFFFFFFF, nil, 0);
    FFiles.Clear;
    for i := 0 to FilesQuan - 1 do
    begin
      Len := DragQueryFile(Msg.wParam, i, nil, 0) + 1;
      GetMem(Name, Len + 1);
      DragQueryFile(Msg.wParam, i, Name, Len);
      FFiles.Append(Name);
      FreeMem(Name);
    end;
    DroppingFiles;
    Handled := True;
  end;
  if Assigned(FOnAppMessage) then
    FOnAppMessage(Msg, Handled);
end;

procedure TFileContainer.RegisterContainer;
begin
  if FContainerIsForm then
    DragAcceptFiles(TForm(Owner).Handle, True)
  else
    DragAcceptFiles(FControl.Handle, True);
  TApplication(Owner.Owner).OnMessage := GettingMessage;
end;

procedure TFileContainer.SetControl(AControl: TWinControl);
begin
  FContainerIsForm := AControl = nil;
  FControl := AControl;
end;

end.
