﻿unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  FlexgetConfigDTO, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.FileCtrl, System.UITypes;

type
  TFormMain = class(TForm)
    btnLoadConfig: TButton;
    OpenDialog1: TOpenDialog;
    PageControl: TPageControl;
    tsAlteracoes: TTabSheet;
    tsDebug: TTabSheet;
    MemoConfigRaw: TMemo;
    MemoParsedInfo: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    tvConfig: TTreeView;
    Splitter1: TSplitter;
    pnlDetails: TScrollBox;
    btnSaveChanges: TButton;
    SaveDialog1: TSaveDialog;
    pnlWelcome: TPanel;
    Label3: TLabel;
    pnlTemplateDetails: TPanel;
    lblAcceptAll: TLabel;
    lblMagnets: TLabel;
    lblContentSize: TLabel;
    lblRegexp: TLabel;
    edtAcceptAll: TEdit;
    edtMagnets: TEdit;
    edtContentSize: TEdit;
    memRegexp: TMemo;
    pnlTaskDetails: TPanel;
    pnlScheduleDetails: TPanel;
    lblScheduleTasks: TLabel;
    lblScheduleInterval: TLabel;
    edtScheduleTasks: TEdit;
    edtScheduleInterval: TEdit;
    pnlGlobalSettings: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblDefaultHost: TLabel;
    lblDefaultPort: TLabel;
    lblDefaultUser: TLabel;
    lblDefaultPass: TLabel;
    lblDefaultAllEntries: TLabel;
    edtGlobalHost: TEdit;
    edtGlobalPort: TEdit;
    edtGlobalUser: TEdit;
    edtGlobalPass: TEdit;
    edtGlobalAllEntries: TEdit;
    memGlobalTemplates: TMemo;
    lblTaskRssUrl: TLabel;
    lblTaskQbitPath: TLabel;
    edtTaskRssUrl: TEdit;
    edtTaskQbitPath: TEdit;
    btnAddTask: TButton;
    btnRemoveTask: TButton;
    btnBrowsePath: TButton;
    btnNewFile: TButton;
    procedure btnLoadConfigClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tvConfigChange(Sender: TObject; Node: TTreeNode);
    procedure btnSaveChangesClick(Sender: TObject);
    procedure tvConfigChanging(Sender: TObject; Node, NewNode: TTreeNode;
      var AllowChange: Boolean);
    procedure btnAddTaskClick(Sender: TObject);
    procedure tvConfigEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure tvConfigEdited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure btnRemoveTaskClick(Sender: TObject);
    procedure btnBrowsePathClick(Sender: TObject);
    procedure btnNewFileClick(Sender: TObject);
  private
    FConfig: TFlexgetConfigDTO;
    FEditedNodeOldText: string;
    procedure LoadConfigFromFile(const AFileName: string);
    procedure PopulateUI;
    procedure ShowDebugInfo;
    procedure PopulateTreeView;
    procedure PopulateGlobalSettingsFromFirstTask;
    procedure ApplyGlobalSettingsToDTO;
    procedure UpdateDTOFromUI(ANode: TTreeNode);
    procedure SaveChangesToFile;
    procedure ShowDetailsForNode(ANode: TTreeNode);
    procedure ShowWelcomePanel;
    procedure ShowGlobalSettingsPanel;
    procedure ShowTemplateDetails(const ATemplate: TTemplateDTO);
    procedure ShowTaskDetails(const ATask: TTaskDTO);
    procedure ShowScheduleDetails(const ASchedule: TScheduleDTO);
  public
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FConfig := TFlexgetConfigDTO.Create;
  ShowWelcomePanel;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FConfig.Free;
end;

procedure TFormMain.LoadConfigFromFile(const AFileName: string);
begin
  try
    FConfig.LoadFromYamlFile(AFileName);
    MemoConfigRaw.Lines.LoadFromFile(AFileName);
    OpenDialog1.FileName := AFileName;
    PopulateUI;
    btnSaveChanges.Enabled := True;
    btnAddTask.Enabled := True;
    PageControl.ActivePage := tsAlteracoes;
    ShowMessage('Arquivo carregado com sucesso!');
  except
    on E: Exception do
      ShowMessage('Erro ao carregar arquivo: ' + E.Message);
  end;
end;

procedure TFormMain.SaveChangesToFile;
var
  LDoSaveAs: Boolean;
begin
  UpdateDTOFromUI(tvConfig.Selected);
  ApplyGlobalSettingsToDTO;
  LDoSaveAs := (OpenDialog1.FileName = '');

  if LDoSaveAs then
  begin
    if not SaveDialog1.Execute then
      Exit;
    OpenDialog1.FileName := SaveDialog1.FileName;
  end;

  try
    MemoConfigRaw.Lines.Text := FConfig.ToYamlString;
    MemoConfigRaw.Lines.SaveToFile(OpenDialog1.FileName);
    ShowMessage('Alterações salvas com sucesso!');
    ShowDebugInfo;
  except
    on E: Exception do
      ShowMessage('Erro ao salvar o arquivo: ' + E.Message);
  end;
end;

procedure TFormMain.PopulateUI;
begin
  ShowDebugInfo;
  PopulateTreeView;
  PopulateGlobalSettingsFromFirstTask;
end;

procedure TFormMain.ShowDebugInfo;
var
  LKey: string;
  LTemplate: TTemplateDTO;
  LTask: TTaskDTO;
  LSchedule: TScheduleDTO;
  LIndex: Integer;
begin
  MemoParsedInfo.Clear;
  MemoParsedInfo.Lines.BeginUpdate;
  try
    MemoParsedInfo.Lines.Add('=== Templates ===');
    for LKey in FConfig.Templates.Keys do
    begin
      LTemplate := FConfig.Templates[LKey];
      MemoParsedInfo.Lines.Add('Template: ' + LKey);
      MemoParsedInfo.Lines.Add('');
    end;
    MemoParsedInfo.Lines.Add('=== Tasks ===');
    for LKey in FConfig.Tasks.Keys do
    begin
      LTask := FConfig.Tasks[LKey];
      MemoParsedInfo.Lines.Add('Task: ' + LKey);
      MemoParsedInfo.Lines.Add('  URL: ' + LTask.Rss.Url);
      MemoParsedInfo.Lines.Add('  All Entries: ' + LTask.Rss.AllEntries);
      MemoParsedInfo.Lines.Add('  Path: ' + LTask.Qbittorrent.Path);
      MemoParsedInfo.Lines.Add('');
    end;
    MemoParsedInfo.Lines.Add('=== Schedules ===');
    LIndex := 0;
    for LSchedule in FConfig.Schedules do
    begin
      MemoParsedInfo.Lines.Add(Format('Schedule [%d]', [LIndex]));
      MemoParsedInfo.Lines.Add('  Tasks: ' + LSchedule.Tasks);
      MemoParsedInfo.Lines.Add('  Interval Minutes: ' + IntToStr(LSchedule.IntervalMinutes));
      MemoParsedInfo.Lines.Add('');
      Inc(LIndex);
    end;
  finally
    MemoParsedInfo.Lines.EndUpdate;
  end;
end;

procedure TFormMain.PopulateTreeView;
var
  LRootNode, LChildNode, LFirstNode: TTreeNode;
  LKey: string;
  LSchedule: TScheduleDTO;
  LIndex: Integer;
begin
  tvConfig.Items.BeginUpdate;
  try
    tvConfig.Items.Clear;
    LRootNode := tvConfig.Items.AddObject(nil, 'Configurações Globais (Replicar)', Self);
    LRootNode := tvConfig.Items.Add(nil, 'Templates');
    for LKey in FConfig.Templates.Keys do
      LChildNode := tvConfig.Items.AddChildObject(LRootNode, LKey, FConfig.Templates[LKey]);
    LRootNode := tvConfig.Items.Add(nil, 'Tasks');
    for LKey in FConfig.Tasks.Keys do
      LChildNode := tvConfig.Items.AddChildObject(LRootNode, LKey, FConfig.Tasks[LKey]);
    LRootNode := tvConfig.Items.Add(nil, 'Schedules');
    LIndex := 0;
    for LSchedule in FConfig.Schedules do
    begin
      LChildNode := tvConfig.Items.AddChildObject(LRootNode, Format('Schedule [%d]', [LIndex]), LSchedule);
      Inc(LIndex);
    end;
    tvConfig.FullExpand;
  finally
    tvConfig.Items.EndUpdate;
  end;

  LFirstNode := tvConfig.Items.GetFirstNode;
  if Assigned(LFirstNode) then
  begin
    LFirstNode.Selected := True;
  end;
end;

procedure TFormMain.PopulateGlobalSettingsFromFirstTask;
var
  LFirstTask: TTaskDTO;
begin
  if FConfig.Tasks.Count > 0 then
  begin
    LFirstTask := nil;
    for LFirstTask in FConfig.Tasks.Values do
      Break;
    if Assigned(LFirstTask) then
    begin
      edtGlobalHost.Text := LFirstTask.Qbittorrent.Host;
      edtGlobalPort.Text := LFirstTask.Qbittorrent.Port.ToString;
      edtGlobalUser.Text := LFirstTask.Qbittorrent.Username;
      edtGlobalPass.Text := LFirstTask.Qbittorrent.Password;
      edtGlobalAllEntries.Text := LFirstTask.Rss.AllEntries;
      memGlobalTemplates.Lines.Assign(LFirstTask.Template);
    end;
  end;
end;

procedure TFormMain.ApplyGlobalSettingsToDTO;
var
  LTask: TTaskDTO;
begin
  for LTask in FConfig.Tasks.Values do
  begin
    LTask.Qbittorrent.Host := edtGlobalHost.Text;
    LTask.Qbittorrent.Port := StrToIntDef(edtGlobalPort.Text, 0);
    LTask.Qbittorrent.Username := edtGlobalUser.Text;
    LTask.Qbittorrent.Password := edtGlobalPass.Text;
    LTask.Rss.AllEntries := edtGlobalAllEntries.Text;
    LTask.Template.Assign(memGlobalTemplates.Lines);
  end;
end;

procedure TFormMain.ShowWelcomePanel;
begin
  pnlGlobalSettings.Visible := False;
  pnlTemplateDetails.Visible := False;
  pnlTaskDetails.Visible := False;
  pnlScheduleDetails.Visible := False;
  pnlWelcome.Visible := True;
end;

procedure TFormMain.ShowDetailsForNode(ANode: TTreeNode);
var
  LObject: TObject;
begin
  if not Assigned(ANode) or (ANode.Data = nil) then
  begin
    ShowWelcomePanel;
    Exit;
  end;
  LObject := TObject(ANode.Data);
  if LObject = Self then
    ShowGlobalSettingsPanel
  else if LObject is TTemplateDTO then
    ShowTemplateDetails(LObject as TTemplateDTO)
  else if LObject is TTaskDTO then
    ShowTaskDetails(LObject as TTaskDTO)
  else if LObject is TScheduleDTO then
    ShowScheduleDetails(LObject as TScheduleDTO)
  else
    ShowWelcomePanel;
end;

procedure TFormMain.ShowGlobalSettingsPanel;
begin
  pnlWelcome.Visible := False;
  pnlTemplateDetails.Visible := False;
  pnlTaskDetails.Visible := False;
  pnlScheduleDetails.Visible := False;
  pnlGlobalSettings.Visible := True;
end;

procedure TFormMain.ShowTemplateDetails(const ATemplate: TTemplateDTO);
begin
  pnlWelcome.Visible := False;
  pnlGlobalSettings.Visible := False;
  pnlTaskDetails.Visible := False;
  pnlScheduleDetails.Visible := False;
  pnlTemplateDetails.Visible := True;
  edtAcceptAll.Text := ATemplate.AcceptAll;
  edtMagnets.Text := ATemplate.Magnets;
  edtContentSize.Text := ATemplate.ContentSizeMin.ToString;
  memRegexp.Lines.Assign(ATemplate.RegexpAccept);
end;

procedure TFormMain.ShowTaskDetails(const ATask: TTaskDTO);
begin
  pnlWelcome.Visible := False;
  pnlGlobalSettings.Visible := False;
  pnlTemplateDetails.Visible := False;
  pnlScheduleDetails.Visible := False;
  pnlTaskDetails.Visible := True;
  edtTaskRssUrl.Text := ATask.Rss.Url;
  edtTaskQbitPath.Text := ATask.Qbittorrent.Path;
end;

procedure TFormMain.ShowScheduleDetails(const ASchedule: TScheduleDTO);
begin
  pnlWelcome.Visible := False;
  pnlGlobalSettings.Visible := False;
  pnlTemplateDetails.Visible := False;
  pnlTaskDetails.Visible := False;
  pnlScheduleDetails.Visible := True;
  edtScheduleTasks.Text := ASchedule.Tasks;
  edtScheduleInterval.Text := ASchedule.IntervalMinutes.ToString;
end;

procedure TFormMain.UpdateDTOFromUI(ANode: TTreeNode);
var
  LObject: TObject;
begin
  if not Assigned(ANode) or (ANode.Data = nil) then Exit;
  LObject := TObject(ANode.Data);
  if LObject is TTemplateDTO then
    with LObject as TTemplateDTO do
    begin
      AcceptAll := edtAcceptAll.Text;
      Magnets := edtMagnets.Text;
      ContentSizeMin := StrToIntDef(edtContentSize.Text, 0);
      RegexpAccept.Assign(memRegexp.Lines);
    end
  else if LObject is TTaskDTO then
    with LObject as TTaskDTO do
    begin
      Rss.Url := edtTaskRssUrl.Text;
      Qbittorrent.Path := Trim(edtTaskQbitPath.Text).DeQuotedString('"');
    end
  else if LObject is TScheduleDTO then
    with LObject as TScheduleDTO do
    begin
      Tasks := edtScheduleTasks.Text;
      IntervalMinutes := StrToIntDef(edtScheduleInterval.Text, 0);
    end;
end;

procedure TFormMain.btnLoadConfigClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    LoadConfigFromFile(OpenDialog1.FileName);
end;

procedure TFormMain.btnSaveChangesClick(Sender: TObject);
begin
  SaveChangesToFile;
end;

procedure TFormMain.tvConfigChange(Sender: TObject; Node: TTreeNode);
begin
  ShowDetailsForNode(Node);
  btnRemoveTask.Enabled := (Node <> nil) and (Node.Data <> nil) and (TObject(Node.Data) is TTaskDTO);
end;

procedure TFormMain.tvConfigChanging(Sender: TObject; Node, NewNode: TTreeNode;
  var AllowChange: Boolean);
begin
  UpdateDTOFromUI(Node);
  AllowChange := True;
end;

procedure TFormMain.btnAddTaskClick(Sender: TObject);
var
  LNewTaskName: string;
  LNewTask: TTaskDTO;
  LTasksRootNode, LNewNode, LRootNode: TTreeNode;
begin
  LNewTaskName := '';
  repeat
    if not InputQuery('Adicionar Nova Task', 'Nome da Task:', LNewTaskName) then
      Exit;
    if LNewTaskName.Trim = '' then
      ShowMessage('O nome da task não pode ser vazio.')
    else if FConfig.Tasks.ContainsKey(LNewTaskName) then
    begin
      ShowMessage('Já existe uma task com este nome. Por favor, escolha outro.');
      LNewTaskName := '';
    end;
  until LNewTaskName.Trim <> '';
  LNewTask := TTaskDTO.Create;
  LNewTask.Qbittorrent.Host := edtGlobalHost.Text;
  LNewTask.Qbittorrent.Port := StrToIntDef(edtGlobalPort.Text, 0);
  LNewTask.Qbittorrent.Username := edtGlobalUser.Text;
  LNewTask.Qbittorrent.Password := edtGlobalPass.Text;
  LNewTask.Rss.AllEntries := edtGlobalAllEntries.Text;
  LNewTask.Template.Assign(memGlobalTemplates.Lines);
  LNewTask.Rss.Url := '';
  LNewTask.Qbittorrent.Path := '';
  FConfig.Tasks.Add(LNewTaskName, LNewTask);
  LTasksRootNode := nil;
  for LRootNode in tvConfig.Items do
  begin
    if LRootNode.Text = 'Tasks' then
    begin
      LTasksRootNode := LRootNode;
      Break;
    end;
  end;
  if Assigned(LTasksRootNode) then
  begin
    LNewNode := tvConfig.Items.AddChildObject(LTasksRootNode, LNewTaskName, LNewTask);
    LNewNode.Selected := True;
    LTasksRootNode.Expand(False);
  end;
end;

procedure TFormMain.tvConfigEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  if Assigned(Node.Parent) and (Node.Parent.Text = 'Tasks') then
  begin
    AllowEdit := True;
    FEditedNodeOldText := Node.Text;
  end
  else
  begin
    AllowEdit := False;
  end;
end;

procedure TFormMain.tvConfigEdited(Sender: TObject; Node: TTreeNode; var S: string);
var
  LNewTaskName: string;
  LTaskObject: TTaskDTO;
begin
  LNewTaskName := Trim(S);
  if LNewTaskName = '' then
  begin
    ShowMessage('O nome da task não pode ser vazio.');
    S := FEditedNodeOldText;
    Exit;
  end;
  if (LNewTaskName <> FEditedNodeOldText) and FConfig.Tasks.ContainsKey(LNewTaskName) then
  begin
    ShowMessage('Já existe uma task com este nome.');
    S := FEditedNodeOldText;
    Exit;
  end;
  if FConfig.Tasks.TryGetValue(FEditedNodeOldText, LTaskObject) then
  begin
    FConfig.Tasks.Remove(FEditedNodeOldText);
    FConfig.Tasks.Add(LNewTaskName, LTaskObject);
  end;
end;

procedure TFormMain.btnRemoveTaskClick(Sender: TObject);
var
  LNode: TTreeNode;
  LTaskName: string;
  LGlobalSettingsNode: TTreeNode;
  LObject: TObject;
begin
  LNode := tvConfig.Selected;
  if (LNode = nil) or (LNode.Data = nil) then
    Exit;
  LObject := TObject(LNode.Data);
  if not (LObject is TTaskDTO) then
    Exit;
  LTaskName := LNode.Text;
  if MessageDlg(Format('Tem certeza que deseja remover a task "%s"?', [LTaskName]),
     TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrNo then
    Exit;
  FConfig.Tasks.Remove(LTaskName);
  LNode.Delete;
  LGlobalSettingsNode := tvConfig.Items.GetFirstNode;
  if Assigned(LGlobalSettingsNode) then
    LGlobalSettingsNode.Selected := True;
  ShowDebugInfo;
end;

procedure TFormMain.btnBrowsePathClick(Sender: TObject);
var
  LDirectory: string;
begin
  LDirectory := edtTaskQbitPath.Text;
  if SelectDirectory('Selecione a pasta de destino para a Task', '', LDirectory) then
  begin
    edtTaskQbitPath.Text := LDirectory;
  end;
end;

procedure TFormMain.btnNewFileClick(Sender: TObject);
begin
  if MessageDlg('Criar um novo arquivo irá descartar quaisquer alterações não salvas. Deseja continuar?',
     TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrNo then
    Exit;

  FConfig.Free;
  FConfig := TFlexgetConfigDTO.CreateDefault;

  OpenDialog1.FileName := '';
  MemoConfigRaw.Clear;

  PopulateUI;

  btnSaveChanges.Enabled := True;
  btnAddTask.Enabled := True;
end;

end.