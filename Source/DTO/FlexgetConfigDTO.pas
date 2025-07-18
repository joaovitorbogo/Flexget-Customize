unit FlexgetConfigDTO;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.StrUtils;

type
  TTemplateDTO = class(TPersistent)
  public
    AcceptAll: string;
    RegexpAccept: TStringList;
    ContentSizeMin: Integer;
    Magnets: string;
    SleepSeconds: Integer; // Adicionado
    constructor Create;
    destructor Destroy; override;
  end;

  TRssDTO = class(TPersistent)
  public
    Url: string;
    AllEntries: string;
  end;

  TQbittorrentDTO = class(TPersistent)
  public
    Host: string;
    Port: Integer;
    Username: string;
    Password: string;
    Path: string;
  end;

  TTaskDTO = class(TPersistent)
  public
    Rss: TRssDTO;
    Template: TStringList;
    Qbittorrent: TQbittorrentDTO;
    constructor Create;
    destructor Destroy; override;
  end;

  TScheduleDTO = class(TPersistent)
  public
    Tasks: string;
    IntervalMinutes: Integer;
  end;

  TFlexgetConfigDTO = class(TPersistent)
  private
    FDefaultPath: string;
  public
    Templates: TDictionary<string, TTemplateDTO>;
    Tasks: TDictionary<string, TTaskDTO>;
    Schedules: TObjectList<TScheduleDTO>;

    constructor Create;
    destructor Destroy; override;

    procedure LoadFromYamlFile(const AFileName: string);
    function ToYamlString: string;

    class function CreateDefault: TFlexgetConfigDTO;

    property DefaultPath: string read FDefaultPath write FDefaultPath;
  end;

implementation

{ TTemplateDTO }

constructor TTemplateDTO.Create;
begin
  inherited Create;
  RegexpAccept := TStringList.Create;
  SleepSeconds := 75; // Define o valor padrão ao criar
end;

destructor TTemplateDTO.Destroy;
begin
  RegexpAccept.Free;
  inherited;
end;

{ TTaskDTO }

constructor TTaskDTO.Create;
begin
  inherited Create;
  Rss := TRssDTO.Create;
  Template := TStringList.Create;
  Qbittorrent := TQbittorrentDTO.Create;
end;

destructor TTaskDTO.Destroy;
begin
  Rss.Free;
  Template.Free;
  Qbittorrent.Free;
  inherited;
end;

{ TFlexgetConfigDTO }

constructor TFlexgetConfigDTO.Create;
begin
  inherited Create;
  Templates := TDictionary<string, TTemplateDTO>.Create;
  Tasks := TDictionary<string, TTaskDTO>.Create;
  Schedules := TObjectList<TScheduleDTO>.Create(True);
  FDefaultPath := 'D:/Downloads/'; // Fallback inicial
end;

destructor TFlexgetConfigDTO.Destroy;
var
  LTpl: TTemplateDTO;
  LTask: TTaskDTO;
begin
  for LTpl in Templates.Values do LTpl.Free;
  Templates.Free;
  for LTask in Tasks.Values do LTask.Free;
  Tasks.Free;
  Schedules.Free;
  inherited;
end;

class function TFlexgetConfigDTO.CreateDefault: TFlexgetConfigDTO;
var
  LTemplate: TTemplateDTO;
  LSchedule: TScheduleDTO;
begin
  Result := TFlexgetConfigDTO.Create;
  Result.DefaultPath := 'D:/Downloads/';

  LTemplate := TTemplateDTO.Create; // O construtor já define SleepSeconds = 60
  LTemplate.AcceptAll := 'no';
  LTemplate.RegexpAccept.Add('(?=.*1080p)(?=.*HEVC)(?=.*Magnet)');
  LTemplate.ContentSizeMin := 100;
  LTemplate.Magnets := 'yes';
  Result.Templates.Add('anime_1080p_hevc_magnet', LTemplate);

  LSchedule := TScheduleDTO.Create;
  LSchedule.Tasks := '*';
  LSchedule.IntervalMinutes := 30;
  Result.Schedules.Add(LSchedule);
end;

procedure TFlexgetConfigDTO.LoadFromYamlFile(const AFileName: string);
const
  CDefaultPathKey = '# default_path:';
var
  LLines: TStringList;
  LLine, LLineTrimmed, LLineContent, LKey, LValue: string;
  LLevel, LPos, I: Integer;
  LCurrentSection, LCurrentSubSection, LCurrentSubSubSection: string;
  LCurrentTemplate: TTemplateDTO;
  LCurrentTask: TTaskDTO;
  LCurrentSchedule: TScheduleDTO;
  LIsListItem: Boolean;

  function GetIndentLevel(const ALine: string): Integer;
  var
    LIdx: Integer;
  begin
    Result := 0;
    for LIdx := 1 to Length(ALine) do
      if ALine[LIdx] = ' ' then
        Inc(Result)
      else
        Break;
    Result := Result div 2;
  end;

begin
  // Limpa os dados existentes
  for var LTemplate in Self.Templates.Values do LTemplate.Free;
  Self.Templates.Clear;
  for var LTask in Self.Tasks.Values do LTask.Free;
  Self.Tasks.Clear;
  Self.Schedules.Clear;

  LLines := TStringList.Create;
  try
    LLines.LoadFromFile(AFileName);

    LCurrentSection := ''; LCurrentSubSection := ''; LCurrentSubSubSection := '';
    LCurrentTemplate := nil; LCurrentTask := nil; LCurrentSchedule := nil;

    for I := 0 to LLines.Count - 1 do
    begin
      LLine := LLines[I];
      LLineTrimmed := Trim(LLine);

      if LLineTrimmed.StartsWith(CDefaultPathKey) then
      begin
        Self.DefaultPath := Trim(LLineTrimmed.Substring(Length(CDefaultPathKey)));
        Continue;
      end;

      if (LLineTrimmed = '') or (LLineTrimmed.StartsWith('#')) then Continue;

      LLevel := GetIndentLevel(LLine);
      LLineContent := Trim(Copy(LLine, (LLevel * 2) + 1, MaxInt));
      if LLevel < 1 then LCurrentSection := '';
      if LLevel < 2 then LCurrentSubSection := '';
      if LLevel < 3 then LCurrentSubSubSection := '';
      if LLevel < 1 then begin LCurrentTemplate := nil; LCurrentTask := nil; LCurrentSchedule := nil; end;

      LPos := Pos(':', LLineContent);
      LIsListItem := LLineContent.StartsWith('-');

      if LIsListItem then
      begin
        LKey := '-'; LValue := Trim(LLineContent.Substring(1));
      end
      else if LPos > 0 then
      begin
        LKey := Trim(Copy(LLineContent, 1, LPos - 1));
        LValue := Trim(Copy(LLineContent, LPos + 1, MaxInt));
      end
      else
      begin
        LKey := LLineContent; LValue := '';
      end;

      case LLevel of
        0: LCurrentSection := LKey;
        1:
          begin
            if LCurrentSection = 'templates' then
            begin
              LCurrentTemplate := TTemplateDTO.Create;
              Self.Templates.Add(LKey, LCurrentTemplate);
            end
            else if LCurrentSection = 'tasks' then
            begin
              LCurrentTask := TTaskDTO.Create;
              Self.Tasks.Add(LKey, LCurrentTask);
            end
            else if (LCurrentSection = 'schedules') and LIsListItem then
            begin
              LCurrentSchedule := TScheduleDTO.Create;
              Self.Schedules.Add(LCurrentSchedule);
              if LKey = 'tasks' then LCurrentSchedule.Tasks := Trim(LValue).DeQuotedString('''');
            end;
          end;
        2:
          begin
            if (LCurrentSection = 'templates') and (LCurrentTemplate <> nil) then
            begin
              if (LKey = 'regexp') or (LKey = 'content_size') or (LKey = 'sleep') then
                LCurrentSubSection := LKey
              else if LKey = 'accept_all' then LCurrentTemplate.AcceptAll := LValue
              else if LKey = 'magnets' then LCurrentTemplate.Magnets := LValue;
            end
            else if (LCurrentSection = 'tasks') and (LCurrentTask <> nil) then
            begin
              LCurrentSubSection := LKey;
            end
            else if (LCurrentSection = 'schedules') and (LCurrentSchedule <> nil) then
            begin
              if LKey = 'interval' then
                 LCurrentSubSection := LKey
              else if LKey = 'tasks' then
                 LCurrentSchedule.Tasks := Trim(LValue).DeQuotedString('''');
            end;
          end;
        3:
          begin
            if (LCurrentSection = 'templates') and (LCurrentTemplate <> nil) then
            begin
              if LCurrentSubSection = 'regexp' then
                LCurrentSubSubSection := LKey
              else if LCurrentSubSection = 'content_size' then
              begin
                if LKey = 'min' then
                  LCurrentTemplate.ContentSizeMin := StrToIntDef(LValue, 0);
              end
              else if LCurrentSubSection = 'sleep' then
              begin
                if LKey = 'seconds' then
                  LCurrentTemplate.SleepSeconds := StrToIntDef(LValue, 0);
              end;
            end
            else if (LCurrentSection = 'tasks') and (LCurrentTask <> nil) then
            begin
              if LCurrentSubSection = 'rss' then
              begin
                if LKey = 'url' then LCurrentTask.Rss.Url := LValue
                else if LKey = 'all_entries' then LCurrentTask.Rss.AllEntries := LValue;
              end
              else if LCurrentSubSection = 'template' then
              begin
                 if LKey = '-' then LCurrentTask.Template.Add(LValue);
              end
              else if LCurrentSubSection = 'qbittorrent' then
              begin
                if LKey = 'host' then LCurrentTask.Qbittorrent.Host := LValue
                else if LKey = 'port' then LCurrentTask.Qbittorrent.Port := StrToIntDef(LValue, 0)
                else if LKey = 'username' then LCurrentTask.Qbittorrent.Username := LValue
                else if LKey = 'password' then LCurrentTask.Qbittorrent.Password := LValue
                else if LKey = 'path' then LCurrentTask.Qbittorrent.Path := Trim(LValue).DeQuotedString('"');
              end;
            end
            else if (LCurrentSection = 'schedules') and (LCurrentSchedule <> nil) then
            begin
                if LCurrentSubSection = 'interval' then
                begin
                    if LKey = 'minutes' then LCurrentSchedule.IntervalMinutes := StrToIntDef(LValue, 0);
                end;
            end;
          end;
        4:
          begin
            if (LCurrentSection = 'templates') and (LCurrentTemplate <> nil) and
               (LCurrentSubSection = 'regexp') and (LCurrentSubSubSection = 'accept') then
            begin
              if LKey = '-' then
                LCurrentTemplate.RegexpAccept.Add(LValue);
            end;
          end;
      end;
    end;
  finally
    LLines.Free;
  end;
end;

function TFlexgetConfigDTO.ToYamlString: string;
var
  LBuilder: TStringBuilder;
  LKey, LItem: string;
  LTemplate: TTemplateDTO;
  LTask: TTaskDTO;
  LSchedule: TScheduleDTO;
begin
  LBuilder := TStringBuilder.Create;
  try
    if not Self.DefaultPath.IsEmpty then
    begin
      LBuilder.AppendLine('# default_path: ' + Self.DefaultPath);
      LBuilder.AppendLine('');
    end;

    if Self.Templates.Count > 0 then
    begin
      LBuilder.AppendLine('templates:');
      for LKey in Self.Templates.Keys do
      begin
        LTemplate := Self.Templates[LKey];
        LBuilder.AppendLine('  ' + LKey + ':');
        LBuilder.AppendLine('    accept_all: ' + LTemplate.AcceptAll);
        if LTemplate.RegexpAccept.Count > 0 then
        begin
          LBuilder.AppendLine('    regexp:');
          LBuilder.AppendLine('      accept:');
          for LItem in LTemplate.RegexpAccept do
            LBuilder.AppendLine('        - ' + LItem);
        end;
        if LTemplate.ContentSizeMin > 0 then
        begin
          LBuilder.AppendLine('    content_size:');
          LBuilder.AppendLine('      min: ' + LTemplate.ContentSizeMin.ToString);
        end;
        LBuilder.AppendLine('    magnets: ' + LTemplate.Magnets);
        if LTemplate.SleepSeconds > 0 then
        begin
          LBuilder.AppendLine('    sleep:');
          LBuilder.AppendLine('      seconds: ' + LTemplate.SleepSeconds.ToString);
        end;
      end;
      LBuilder.AppendLine;
    end;

    if Self.Tasks.Count > 0 then
    begin
      LBuilder.AppendLine('tasks:');
      for LKey in Self.Tasks.Keys do
      begin
        LTask := Self.Tasks[LKey];
        LBuilder.AppendLine('  ' + LKey + ':');
        LBuilder.AppendLine('    rss:');
        LBuilder.AppendLine('      url: ' + LTask.Rss.Url);
        LBuilder.AppendLine('      all_entries: ' + LTask.Rss.AllEntries);
        LBuilder.AppendLine('    template:');
        for LItem in LTask.Template do
          LBuilder.AppendLine('      - ' + LItem);
        LBuilder.AppendLine('    qbittorrent:');
        LBuilder.AppendLine('      host: ' + LTask.Qbittorrent.Host);
        LBuilder.AppendLine('      port: ' + LTask.Qbittorrent.Port.ToString);
        LBuilder.AppendLine('      username: ' + LTask.Qbittorrent.Username);
        LBuilder.AppendLine('      password: ' + LTask.Qbittorrent.Password);
        LBuilder.AppendLine('      path: "' + LTask.Qbittorrent.Path + '"');
      end;
      LBuilder.AppendLine;
    end;

    if Self.Schedules.Count > 0 then
    begin
      LBuilder.AppendLine('schedules:');
      for LSchedule in Self.Schedules do
      begin
        LBuilder.AppendLine('  - tasks: ' + QuotedStr(LSchedule.Tasks));
        LBuilder.AppendLine('    interval:');
        LBuilder.AppendLine('      minutes: ' + LSchedule.IntervalMinutes.ToString);
      end;
    end;

    Result := LBuilder.ToString;
  finally
    LBuilder.Free;
  end;
end;

end.
