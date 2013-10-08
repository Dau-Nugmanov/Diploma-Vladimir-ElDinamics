program eds_demo;

uses
  Forms,
  eds_demom in 'eds_demom.pas' {Form1},
  sgr_eds in 'eds\sgr_eds.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
