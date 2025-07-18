unit UMain;

interface

uses
  winapi.TlHelp32,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  FlexgetConfigDTO, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.FileCtrl, System.UITypes, Vcl.Buttons, System.IOUtils,
  System.IniFiles;

type
  TProcessLineEvent = procedure(const ALine: string) of object;

  TformMain = class(TForm)
    btnLoadConfig: TButton;
    OpenDialog1: TOpenDialog;
    PageControl: TPageControl;
    tabTaskEditor: TTabSheet;
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
    pnlTop: TPanel;
    pnlBottom: TPanel;
    lblTemplateSleep: TLabel;
    edtTemplateSleep: TEdit;
    tabRun: TTabSheet;
    pnlRunTop: TPanel;
    btnRun: TButton;
    pnlOutputs: TPanel;
    pnlAccepted: TPanel;
    lblAccepted: TLabel;
    memoAccepted: TMemo;
    Splitter2: TSplitter;
    pnlRejected: TPanel;
    lblRejected: TLabel;
    memoRejected: TMemo;
    Splitter3: TSplitter;
    pnlOthers: TPanel;
    lblOthers: TLabel;
    memoOthers: TMemo;
    chkAutoLoad: TCheckBox;
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
    procedure btnRunClick(Sender: TObject);
    procedure chkAutoLoadClick(Sender: TObject);
  private
    FConfig: TFlexgetConfigDTO;
    FEditedNodeOldText: string;
    FTasksRootNode: TTreeNode;
    FIniFileName: string;
    procedure LoadSettings;
    procedure SaveSettings;
    function TerminateProcessByName(const AProcessName: string): Boolean;
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
    procedure ProcessCmdLine(const ALine: string);
    function ExecuteCmdAndCaptureOutput(const ACmd, AWorkDir: string;
      AOnLineRead: TProcessLineEvent): Boolean;
  public
  end;

var
  formMain: TformMain;

implementation

uses UAddTask;

{$R *.dfm}

const
  CDefaultDownloadPath = 'D:/Downloads/';

procedure TformMain.ApplyGlobalSettingsToDTO;
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

procedure TformMain.btnAddTaskClick(Sender: TObject);
var
  LFormAddTask: TformAddTask;
  LNewTaskName, LRssUrl, LNewPath: string;
  LNewTask: TTaskDTO;
  LNewNode: TTreeNode;
begin
  LFormAddTask := TformAddTask.Create(Self);
  try
    LFormAddTask.SetInitialPath(FConfig.DefaultPath);
    if LFormAddTask.ShowModal <> mrOk then
      Exit;
    LNewTaskName := LFormAddTask.GetTaskName;
    LRssUrl := LFormAddTask.GetRssUrl;
    LNewPath := LFormAddTask.GetPath;
  finally
    LFormAddTask.Free;
  end;
  if FConfig.Tasks.ContainsKey(LNewTaskName) then
  begin
    ShowMessage('A task with this name already exists. Please choose another');
    Exit;
  end;
  FConfig.DefaultPath := ExtractFilePath(LNewPath);
  LNewTask := TTaskDTO.Create;
  try
    LNewTask.Qbittorrent.Host := edtGlobalHost.Text;
    LNewTask.Qbittorrent.Port := StrToIntDef(edtGlobalPort.Text, 0);
    LNewTask.Qbittorrent.Username := edtGlobalUser.Text;
    LNewTask.Qbittorrent.Password := edtGlobalPass.Text;
    LNewTask.Rss.AllEntries := edtGlobalAllEntries.Text;
    LNewTask.Template.Assign(memGlobalTemplates.Lines);
    LNewTask.Rss.Url := LRssUrl;
    LNewTask.Qbittorrent.Path := LNewPath;
    FConfig.Tasks.Add(LNewTaskName, LNewTask);
  except
    LNewTask.Free;
    raise;
  end;
  if Assigned(FTasksRootNode) then
  begin
    LNewNode := tvConfig.Items.AddChildObject(FTasksRootNode, LNewTaskName, LNewTask);
    LNewNode.Selected := True;
    FTasksRootNode.Expand(False);
  end;
end;

procedure TformMain.btnBrowsePathClick(Sender: TObject);
var
  LDirectory: string;
begin
  LDirectory := edtTaskQbitPath.Text;
  if SelectDirectory('Select the destination folder for the Task', '', LDirectory) then
  begin
    edtTaskQbitPath.Text := LDirectory;
  end;
end;

procedure TformMain.btnLoadConfigClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    LoadConfigFromFile(OpenDialog1.FileName);
end;

procedure TformMain.btnNewFileClick(Sender: TObject);
begin
  if MessageDlg('Creating a new file will discard any unsaved changes. Do you want to continue?',
    TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrNo then
    Exit;
  FConfig.Free;
  FConfig := TFlexgetConfigDTO.CreateDefault;
  OpenDialog1.FileName := '';
  MemoConfigRaw.Clear;
  PopulateUI;
  btnSaveChanges.Enabled := True;
  btnAddTask.Enabled := True;
  SaveSettings;
end;

procedure TformMain.btnRemoveTaskClick(Sender: TObject);
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
  if MessageDlg(Format('Are you sure you want to remove task "%s"?', [LTaskName]),
    TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrNo then
    Exit;
  FConfig.Tasks.Remove(LTaskName);
  LNode.Delete;
  LGlobalSettingsNode := tvConfig.Items.GetFirstNode;
  if Assigned(LGlobalSettingsNode) then
    LGlobalSettingsNode.Selected := True;
  ShowDebugInfo;
end;

procedure TformMain.btnRunClick(Sender: TObject);
var
  LFilePath, LConfigDir: string;
begin
  TerminateProcessByName('flexget.exe');
  LFilePath := OpenDialog1.FileName;
  if (LFilePath = '') or (not TFile.Exists(LFilePath)) then
  begin
    ShowMessage('Please save the configuration file before running.');
    Exit;
  end;
  memoAccepted.Clear;
  memoRejected.Clear;
  memoOthers.Clear;
  Screen.Cursor := crHourGlass;
  try
    LConfigDir := TPath.GetDirectoryName(LFilePath);
    if not ExecuteCmdAndCaptureOutput('flexget execute', LConfigDir, ProcessCmdLine) then
    begin
      memoOthers.Lines.Add('Error: Failed to execute command. Is "flexget" in your system PATH?');
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TformMain.btnSaveChangesClick(Sender: TObject);
begin
  SaveChangesToFile;
end;

function TformMain.ExecuteCmdAndCaptureOutput(const ACmd, AWorkDir: string;
  AOnLineRead: TProcessLineEvent): Boolean;
var
  LSA: TSecurityAttributes;
  LSI: TStartupInfo;
  LPI: TProcessInformation;
  LStdOutRead, LStdOutWrite: THandle;
  LWasOK: Boolean;
  LBuffer: array[0..1023] of AnsiChar;
  LBytesRead: DWord;
  LFullCmd: string;
  LRemainder: string;
  LLineBreakPos: Integer;
  LBytes: TBytes;
begin
  Result := False;
  if not Assigned(AOnLineRead) then
    Exit;
  LSA.nLength := SizeOf(TSecurityAttributes);
  LSA.bInheritHandle := True;
  LSA.lpSecurityDescriptor := nil;
  if not CreatePipe(LStdOutRead, LStdOutWrite, @LSA, 0) then
    Exit;
  try
    SetHandleInformation(LStdOutRead, HANDLE_FLAG_INHERIT, 0);
    FillChar(LSI, SizeOf(TStartupInfo), 0);
    LSI.cb := SizeOf(TStartupInfo);
    LSI.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
    LSI.wShowWindow := SW_HIDE;
    LSI.hStdInput := GetStdHandle(STD_INPUT_HANDLE);
    LSI.hStdOutput := LStdOutWrite;
    LSI.hStdError := LStdOutWrite;
    LFullCmd := 'cmd.exe /c ' + ACmd;
    LWasOK := CreateProcess(nil, PChar(LFullCmd), nil, nil, True,
      CREATE_NO_WINDOW, nil, PChar(AWorkDir), LSI, LPI);
    CloseHandle(LStdOutWrite);
    LStdOutWrite := 0;
    if LWasOK then
    begin
      LRemainder := '';
      try
        while True do
        begin
          LWasOK := ReadFile(LStdOutRead, LBuffer, SizeOf(LBuffer), LBytesRead, nil);
          if not LWasOK or (LBytesRead = 0) then
            Break;

          SetLength(LBytes, LBytesRead);
          Move(LBuffer, Pointer(LBytes)^, LBytesRead);
          LRemainder := LRemainder + TEncoding.GetEncoding(GetOEMCP).GetString(LBytes);

          LLineBreakPos := Pos(#13#10, LRemainder);
          while LLineBreakPos > 0 do
          begin
            AOnLineRead(Copy(LRemainder, 1, LLineBreakPos - 1));
            Delete(LRemainder, 1, LLineBreakPos + 1);
            LLineBreakPos := Pos(#13#10, LRemainder);
          end;
        end;
        if LRemainder <> '' then
          AOnLineRead(LRemainder);
        Result := True;
      finally
        CloseHandle(LPI.hProcess);
        CloseHandle(LPI.hThread);
      end;
    end;
  finally
    if LStdOutWrite <> 0 then CloseHandle(LStdOutWrite);
    if LStdOutRead <> 0 then CloseHandle(LStdOutRead);
  end;
end;

procedure TformMain.FormCreate(Sender: TObject);
begin
  FConfig := TFlexgetConfigDTO.Create;
  FIniFileName := ChangeFileExt(Application.ExeName, '.ini');
  LoadSettings;
  if not TFile.Exists(OpenDialog1.FileName) then
    ShowWelcomePanel;
end;

procedure TformMain.FormDestroy(Sender: TObject);
begin
  FConfig.Free;
end;

procedure TformMain.LoadConfigFromFile(const AFileName: string);
begin
  try
    FConfig.LoadFromYamlFile(AFileName);
    MemoConfigRaw.Lines.LoadFromFile(AFileName);
    OpenDialog1.FileName := AFileName;
    PopulateUI;
    btnSaveChanges.Enabled := True;
    btnAddTask.Enabled := True;
    PageControl.Visible := True;
    PageControl.ActivePage := tabTaskEditor;
    SaveSettings;
  except
    on E: Exception do
      ShowMessage('Fail loading file: ' + E.Message);
  end;
end;

procedure TformMain.PopulateGlobalSettingsFromFirstTask;
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

procedure TformMain.PopulateTreeView;
var
  LRootNode, LChildNode, LFirstNode: TTreeNode;
  LKey: string;
  LSchedule: TScheduleDTO;
  LIndex: Integer;
begin
  tvConfig.Items.BeginUpdate;
  try
    tvConfig.Items.Clear;
    FTasksRootNode := nil;
    LRootNode := tvConfig.Items.AddObject(nil, 'Global Settings (Replicate)', Self);
    LRootNode := tvConfig.Items.Add(nil, 'Templates');
    for LKey in FConfig.Templates.Keys do
      LChildNode := tvConfig.Items.AddChildObject(LRootNode, LKey, FConfig.Templates[LKey]);
    FTasksRootNode := tvConfig.Items.Add(nil, 'Tasks');
    for LKey in FConfig.Tasks.Keys do
      LChildNode := tvConfig.Items.AddChildObject(FTasksRootNode, LKey, FConfig.Tasks[LKey]);
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
  if tvConfig.Items.Count > 0 then
  begin
    LFirstNode := tvConfig.Items.GetFirstNode;
    tvConfig.Selected := LFirstNode;
  end;
end;

procedure TformMain.PopulateUI;
begin
  ShowDebugInfo;
  PopulateTreeView;
  PopulateGlobalSettingsFromFirstTask;
end;

procedure TformMain.ProcessCmdLine(const ALine: string);
var
  LTargetMemo: TMemo;
begin
  if Pos('ACCEPTED', UpperCase(ALine)) > 0 then
    LTargetMemo := memoAccepted
  else if Pos('REJECTED', UpperCase(ALine)) > 0 then
    LTargetMemo := memoRejected
  else
    LTargetMemo := memoOthers;

  if Assigned(LTargetMemo) then
  begin
    LTargetMemo.Lines.Add(ALine);
    LTargetMemo.Lines.Add('');
  end;

  Application.ProcessMessages;
end;

procedure TformMain.SaveChangesToFile;
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
    ShowMessage('Changes saved successfully!');
    ShowDebugInfo;
    SaveSettings;
  except
    on E: Exception do
      ShowMessage('Error saving file: ' + E.Message);
  end;
end;

procedure TformMain.ShowDebugInfo;
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
      MemoParsedInfo.Lines.Add('  Sleep Seconds: ' + LTemplate.SleepSeconds.ToString);
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

procedure TformMain.ShowDetailsForNode(ANode: TTreeNode);
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

procedure TformMain.ShowGlobalSettingsPanel;
begin
  pnlWelcome.Visible := False;
  pnlTemplateDetails.Visible := False;
  pnlTaskDetails.Visible := False;
  pnlScheduleDetails.Visible := False;
  pnlGlobalSettings.Visible := True;
end;

procedure TformMain.ShowScheduleDetails(const ASchedule: TScheduleDTO);
begin
  pnlWelcome.Visible := False;
  pnlGlobalSettings.Visible := False;
  pnlTemplateDetails.Visible := False;
  pnlTaskDetails.Visible := False;
  pnlScheduleDetails.Visible := True;
  edtScheduleTasks.Text := ASchedule.Tasks;
  edtScheduleInterval.Text := ASchedule.IntervalMinutes.ToString;
end;

procedure TformMain.ShowTaskDetails(const ATask: TTaskDTO);
begin
  pnlWelcome.Visible := False;
  pnlGlobalSettings.Visible := False;
  pnlTemplateDetails.Visible := False;
  pnlScheduleDetails.Visible := False;
  pnlTaskDetails.Visible := True;
  edtTaskRssUrl.Text := ATask.Rss.Url;
  edtTaskQbitPath.Text := ATask.Qbittorrent.Path;
end;

procedure TformMain.ShowTemplateDetails(const ATemplate: TTemplateDTO);
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
  edtTemplateSleep.Text := ATemplate.SleepSeconds.ToString;
end;

procedure TformMain.ShowWelcomePanel;
begin
  pnlGlobalSettings.Visible := False;
  pnlTemplateDetails.Visible := False;
  pnlTaskDetails.Visible := False;
  pnlScheduleDetails.Visible := False;
  pnlWelcome.Visible := True;
end;

procedure TformMain.tvConfigChange(Sender: TObject; Node: TTreeNode);
begin
  ShowDetailsForNode(Node);
  btnRemoveTask.Enabled := (Node <> nil) and (Node.Data <> nil) and (TObject(Node.Data) is TTaskDTO);
end;

procedure TformMain.tvConfigChanging(Sender: TObject; Node, NewNode: TTreeNode;
  var AllowChange: Boolean);
begin
  UpdateDTOFromUI(Node);
  AllowChange := True;
end;

procedure TformMain.tvConfigEdited(Sender: TObject; Node: TTreeNode; var S: string);
var
  LNewTaskName: string;
  LTaskObject: TTaskDTO;
begin
  LNewTaskName := Trim(S);
  if LNewTaskName = '' then
  begin
    ShowMessage('Task name cannot be empty.');
    S := FEditedNodeOldText;
    Exit;
  end;
  if (LNewTaskName <> FEditedNodeOldText) and FConfig.Tasks.ContainsKey(LNewTaskName) then
  begin
    ShowMessage('A task with this name already exists.');
    S := FEditedNodeOldText;
    Exit;
  end;
  if FConfig.Tasks.TryGetValue(FEditedNodeOldText, LTaskObject) then
  begin
    FConfig.Tasks.Remove(FEditedNodeOldText);
    FConfig.Tasks.Add(LNewTaskName, LTaskObject);
  end;
end;

procedure TformMain.tvConfigEditing(Sender: TObject; Node: TTreeNode;
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

procedure TformMain.UpdateDTOFromUI(ANode: TTreeNode);
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
      SleepSeconds := StrToIntDef(edtTemplateSleep.Text, 0);
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

function TformMain.TerminateProcessByName(const AProcessName: string): Boolean;
var
  LSnapshot: THandle;
  LProcessEntry: TProcessEntry32;
  LProcessHandle: THandle;
begin
  Result := False;
  LSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if LSnapshot = INVALID_HANDLE_VALUE then
    Exit;
  try
    LProcessEntry.dwSize := SizeOf(TProcessEntry32);
    if Process32First(LSnapshot, LProcessEntry) then
    begin
      repeat
        if SameText(LProcessEntry.szExeFile, AProcessName) then
        begin
          LProcessHandle := OpenProcess(PROCESS_TERMINATE, False, LProcessEntry.th32ProcessID);
          if LProcessHandle <> 0 then
          begin
            try
              if Winapi.Windows.TerminateProcess(LProcessHandle, 0) then
                Result := True;
            finally
              CloseHandle(LProcessHandle);
            end;
            if Result then
              Break;
          end;
        end;
      until not Process32Next(LSnapshot, LProcessEntry);
    end;
  finally
    CloseHandle(LSnapshot);
  end;
end;

procedure TformMain.chkAutoLoadClick(Sender: TObject);
begin
  SaveSettings;
end;

procedure TformMain.LoadSettings;
var
  LIni: TIniFile;
  LLastFile: string;
begin
  LIni := TIniFile.Create(FIniFileName);
  try
    chkAutoLoad.Checked := LIni.ReadBool('Settings', 'AutoLoad', False);
    LLastFile := LIni.ReadString('Settings', 'LastFile', '');

    if chkAutoLoad.Checked and (LLastFile <> '') and TFile.Exists(LLastFile) then
    begin
      LoadConfigFromFile(LLastFile);
    end;
  finally
    LIni.Free;
  end;
end;

procedure TformMain.SaveSettings;
var
  LIni: TIniFile;
begin
  LIni := TIniFile.Create(FIniFileName);
  try
    LIni.WriteBool('Settings', 'AutoLoad', chkAutoLoad.Checked);
    if chkAutoLoad.Checked then
    begin
      if OpenDialog1.FileName <> EmptyStr then
        LIni.WriteString('Settings', 'LastFile', OpenDialog1.FileName)
    end
    else
      LIni.WriteString('Settings', 'LastFile', '');
  finally
    LIni.Free;
  end;
end;

end.
