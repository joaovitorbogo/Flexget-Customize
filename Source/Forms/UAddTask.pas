unit UAddTask;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TformAddTask = class(TForm)
    Label1: TLabel;
    edtTaskName: TEdit;
    Label2: TLabel;
    edtRssUrl: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    Label4: TLabel;
    edtPath: TEdit;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
  public
    procedure SetInitialPath(const APath: string);
    function GetTaskName: string;
    function GetRssUrl: string;
    function GetPath: string;
  end;

implementation

{$R *.dfm}

procedure TformAddTask.SetInitialPath(const APath: string);
begin
  edtPath.Text := APath;
end;

function TformAddTask.GetTaskName: string;
begin
  Result := edtTaskName.Text;
end;

function TformAddTask.GetRssUrl: string;
begin
  Result := edtRssUrl.Text;
end;

function TformAddTask.GetPath: string;
begin
  Result := edtPath.Text;
end;

procedure TformAddTask.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrNone;
end;

procedure TformAddTask.btnOKClick(Sender: TObject);
begin
  if Trim(edtTaskName.Text) = '' then
  begin
    ShowMessage('Task name cannot be empty.');
    edtTaskName.SetFocus;
    ModalResult := mrNone;
  end
  else if Trim(edtRssUrl.Text) = '' then
  begin
    ShowMessage('URL cannot be empty.');
    edtRssUrl.SetFocus;
    ModalResult := mrNone;
  end
  else
  begin
    ModalResult := mrOk;
  end;
end;

end.