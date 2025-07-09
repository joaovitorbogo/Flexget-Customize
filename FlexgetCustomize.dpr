program FlexgetCustomize;

uses
  Vcl.Forms,
  UnitMain in 'Source\Forms\UnitMain.pas' {FlexgetConfigForm},
  FlexgetConfigDTO in 'Source\DTO\FlexgetConfigDTO.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
