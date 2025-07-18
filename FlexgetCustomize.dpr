program FlexgetCustomize;

uses
  Vcl.Forms,
  FlexgetConfigDTO in 'Source\DTO\FlexgetConfigDTO.pas' {$R *.res},
  UMain in 'Source\Forms\UMain.pas' {formMain},
  UAddTask in 'Source\Forms\UAddTask.pas' {formAddTask},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Ruby Graphite');
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
