unit MesFUnit;

{Диалог сохранения файла при закрытии}

{$D-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TMessForm = class(TForm)
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
    function AskForSave(const FileName: string): TModalResult;
  end;

var
  MessForm: TMessForm;

implementation

{$R *.DFM}

{ TForm2 }

function TMessForm.AskForSave(const FileName: string): TModalResult;
begin
  Label1.Caption := 'Сохранить изменения в ' + FileName + '?';
  Result := ShowModal;
end;

end.
