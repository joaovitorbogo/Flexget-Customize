object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Flexget Config Editor'
  ClientHeight = 562
  ClientWidth = 934
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object btnLoadConfig: TButton
    Left = 164
    Top = 8
    Width = 150
    Height = 33
    Caption = 'Carregar YAML'
    TabOrder = 1
    OnClick = btnLoadConfigClick
  end
  object btnSaveChanges: TButton
    Left = 320
    Top = 8
    Width = 150
    Height = 33
    Caption = 'Salvar'
    Enabled = False
    TabOrder = 2
    OnClick = btnSaveChangesClick
  end
  object btnAddTask: TButton
    Left = 476
    Top = 8
    Width = 150
    Height = 33
    Caption = 'Adicionar Task'
    Enabled = False
    TabOrder = 3
    OnClick = btnAddTaskClick
  end
  object btnRemoveTask: TButton
    Left = 632
    Top = 8
    Width = 150
    Height = 33
    Caption = 'Remover Task Selecionada'
    Enabled = False
    TabOrder = 4
    OnClick = btnRemoveTaskClick
  end
  object btnNewFile: TButton
    Left = 8
    Top = 8
    Width = 150
    Height = 33
    Caption = 'Novo Arquivo'
    TabOrder = 0
    OnClick = btnNewFileClick
  end
  object PageControl: TPageControl
    Left = 8
    Top = 47
    Width = 918
    Height = 507
    ActivePage = tsAlteracoes
    TabOrder = 5
    object tsAlteracoes: TTabSheet
      Caption = 'Alterar Configura'#231#245'es'
      object Splitter1: TSplitter
        Left = 241
        Top = 0
        Width = 8
        Height = 477
      end
      object tvConfig: TTreeView
        Left = 0
        Top = 0
        Width = 241
        Height = 477
        Align = alLeft
        Indent = 19
        TabOrder = 0
        OnChange = tvConfigChange
        OnEdited = tvConfigEdited
        OnEditing = tvConfigEditing
      end
      object pnlDetails: TScrollBox
        Left = 249
        Top = 0
        Width = 661
        Height = 477
        Align = alClient
        TabOrder = 1
        object pnlWelcome: TPanel
          Left = 0
          Top = 0
          Width = 657
          Height = 473
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object Label3: TLabel
            Left = 0
            Top = 0
            Width = 657
            Height = 473
            Align = alClient
            Alignment = taCenter
            Caption = 'Selecione um item '#224' esquerda para ver ou editar os detalhes.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGrayText
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsItalic]
            ParentFont = False
            Layout = tlCenter
            WordWrap = True
            ExplicitWidth = 338
            ExplicitHeight = 17
          end
        end
        object pnlTemplateDetails: TPanel
          Left = 0
          Top = 0
          Width = 657
          Height = 473
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          Visible = False
          object lblAcceptAll: TLabel
            Left = 16
            Top = 16
            Width = 57
            Height = 15
            Caption = 'Accept All:'
          end
          object lblMagnets: TLabel
            Left = 16
            Top = 45
            Width = 49
            Height = 15
            Caption = 'Magnets:'
          end
          object lblContentSize: TLabel
            Left = 16
            Top = 75
            Width = 93
            Height = 15
            Caption = 'Content Size Min:'
          end
          object lblRegexp: TLabel
            Left = 16
            Top = 106
            Width = 81
            Height = 15
            Caption = 'Regexp Accept:'
          end
          object edtAcceptAll: TEdit
            Left = 128
            Top = 13
            Width = 121
            Height = 23
            TabOrder = 0
          end
          object edtMagnets: TEdit
            Left = 128
            Top = 42
            Width = 121
            Height = 23
            TabOrder = 1
          end
          object edtContentSize: TEdit
            Left = 128
            Top = 72
            Width = 121
            Height = 23
            TabOrder = 2
          end
          object memRegexp: TMemo
            Left = 16
            Top = 127
            Width = 233
            Height = 122
            Lines.Strings = (
              '')
            ScrollBars = ssVertical
            TabOrder = 3
          end
        end
        object pnlTaskDetails: TPanel
          Left = 0
          Top = 0
          Width = 657
          Height = 473
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          Visible = False
          object lblTaskRssUrl: TLabel
            Left = 16
            Top = 16
            Width = 46
            Height = 15
            Caption = 'RSS URL:'
          end
          object lblTaskQbitPath: TLabel
            Left = 16
            Top = 47
            Width = 53
            Height = 15
            Caption = 'Qbit Path:'
          end
          object edtTaskRssUrl: TEdit
            Left = 128
            Top = 13
            Width = 401
            Height = 23
            TabOrder = 0
          end
          object edtTaskQbitPath: TEdit
            Left = 128
            Top = 44
            Width = 401
            Height = 23
            TabOrder = 1
          end
          object btnBrowsePath: TButton
            Left = 535
            Top = 43
            Width = 25
            Height = 25
            Caption = '...'
            TabOrder = 2
            OnClick = btnBrowsePathClick
          end
        end
        object pnlScheduleDetails: TPanel
          Left = 0
          Top = 0
          Width = 657
          Height = 473
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 3
          Visible = False
          object lblScheduleTasks: TLabel
            Left = 16
            Top = 16
            Width = 31
            Height = 15
            Caption = 'Tasks:'
          end
          object lblScheduleInterval: TLabel
            Left = 16
            Top = 47
            Width = 88
            Height = 15
            Caption = 'Interval Minutes:'
          end
          object edtScheduleTasks: TEdit
            Left = 128
            Top = 13
            Width = 233
            Height = 23
            TabOrder = 0
          end
          object edtScheduleInterval: TEdit
            Left = 128
            Top = 44
            Width = 121
            Height = 23
            TabOrder = 1
          end
        end
        object pnlGlobalSettings: TPanel
          Left = 0
          Top = 0
          Width = 657
          Height = 473
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 4
          Visible = False
          object Label5: TLabel
            Left = 16
            Top = 8
            Width = 145
            Height = 15
            Caption = 'Qbittorrent (para replicar)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold, fsUnderline]
            ParentFont = False
          end
          object Label6: TLabel
            Left = 328
            Top = 8
            Width = 102
            Height = 15
            Caption = 'RSS (para replicar)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold, fsUnderline]
            ParentFont = False
          end
          object Label7: TLabel
            Left = 16
            Top = 160
            Width = 137
            Height = 15
            Caption = 'Templates (para replicar)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold, fsUnderline]
            ParentFont = False
          end
          object lblDefaultHost: TLabel
            Left = 16
            Top = 37
            Width = 28
            Height = 15
            Caption = 'Host:'
          end
          object lblDefaultPort: TLabel
            Left = 16
            Top = 68
            Width = 25
            Height = 15
            Caption = 'Port:'
          end
          object lblDefaultUser: TLabel
            Left = 16
            Top = 99
            Width = 56
            Height = 15
            Caption = 'Username:'
          end
          object lblDefaultPass: TLabel
            Left = 16
            Top = 130
            Width = 53
            Height = 15
            Caption = 'Password:'
          end
          object lblDefaultAllEntries: TLabel
            Left = 328
            Top = 37
            Width = 55
            Height = 15
            Caption = 'All Entries:'
          end
          object edtGlobalHost: TEdit
            Left = 96
            Top = 34
            Width = 153
            Height = 23
            TabOrder = 0
          end
          object edtGlobalPort: TEdit
            Left = 96
            Top = 65
            Width = 153
            Height = 23
            TabOrder = 1
          end
          object edtGlobalUser: TEdit
            Left = 96
            Top = 96
            Width = 153
            Height = 23
            TabOrder = 2
          end
          object edtGlobalPass: TEdit
            Left = 96
            Top = 127
            Width = 153
            Height = 23
            TabOrder = 3
          end
          object edtGlobalAllEntries: TEdit
            Left = 408
            Top = 34
            Width = 153
            Height = 23
            TabOrder = 4
          end
          object memGlobalTemplates: TMemo
            Left = 16
            Top = 181
            Width = 545
            Height = 124
            ScrollBars = ssVertical
            TabOrder = 5
          end
        end
      end
    end
    object tsDebug: TTabSheet
      Caption = 'Debug'
      ImageIndex = 1
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 116
        Height = 15
        Caption = 'Arquivo YAML Bruto:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 440
        Top = 8
        Width = 154
        Height = 15
        Caption = 'Informa'#231#227'o DTO Carregada:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object MemoConfigRaw: TMemo
        Left = 0
        Top = 0
        Width = 426
        Height = 477
        Align = alLeft
        Lines.Strings = (
          '')
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object MemoParsedInfo: TMemo
        Left = 426
        Top = 0
        Width = 484
        Height = 477
        Align = alClient
        Lines.Strings = (
          '')
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'yaml'
    Filter = 'YAML files (*.yaml;*.yml)|*.yaml;*.yml|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist]
    Left = 248
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'yaml'
    Filter = 'YAML files (*.yaml;*.yml)|*.yaml;*.yml'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist]
    Title = 'Salvar arquivo de configura'#231#227'o'
    Left = 328
    Top = 8
  end
end
