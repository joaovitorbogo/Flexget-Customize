object formMain: TformMain
  Left = 0
  Top = 0
  Caption = 'Flexget Config Editor'
  ClientHeight = 714
  ClientWidth = 1106
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 1106
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 800
    DesignSize = (
      1106
      41)
    object btnNewFile: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'New Config'
      TabOrder = 0
      OnClick = btnNewFileClick
    end
    object btnLoadConfig: TButton
      Left = 90
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Load Config'
      TabOrder = 1
      OnClick = btnLoadConfigClick
    end
    object btnSaveChanges: TButton
      Left = 1023
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Save Config'
      Enabled = False
      TabOrder = 2
      OnClick = btnSaveChangesClick
      ExplicitLeft = 717
    end
    object chkAutoLoad: TCheckBox
      Left = 171
      Top = 11
      Width = 146
      Height = 21
      Caption = 'Auto Load Last Config'
      TabOrder = 3
      OnClick = chkAutoLoadClick
    end
  end
  object PageControl: TPageControl
    Left = 0
    Top = 41
    Width = 1106
    Height = 673
    ActivePage = tabTaskEditor
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 800
    ExplicitHeight = 531
    object tabTaskEditor: TTabSheet
      Caption = 'Task Editor'
      object Splitter1: TSplitter
        Left = 241
        Top = 0
        Width = 8
        Height = 604
        ExplicitLeft = 244
        ExplicitTop = 49
        ExplicitHeight = 487
      end
      object tvConfig: TTreeView
        Left = 0
        Top = 0
        Width = 241
        Height = 604
        Align = alLeft
        Indent = 19
        TabOrder = 0
        OnChange = tvConfigChange
        OnEdited = tvConfigEdited
        OnEditing = tvConfigEditing
        ExplicitHeight = 501
      end
      object pnlDetails: TScrollBox
        Left = 249
        Top = 0
        Width = 849
        Height = 604
        Align = alClient
        TabOrder = 1
        ExplicitWidth = 543
        ExplicitHeight = 501
        object pnlGlobalSettings: TPanel
          Left = 0
          Top = 0
          Width = 845
          Height = 600
          Align = alClient
          BevelOuter = bvNone
          Caption = 'pnlGlobalSettings'
          TabOrder = 1
          Visible = False
          ExplicitWidth = 539
          ExplicitHeight = 497
          object Label5: TLabel
            Left = 16
            Top = 16
            Width = 91
            Height = 17
            Caption = 'Global Configs'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label6: TLabel
            Left = 16
            Top = 47
            Width = 60
            Height = 15
            Caption = 'Qbittorent'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label7: TLabel
            Left = 16
            Top = 164
            Width = 57
            Height = 15
            Caption = 'Templates'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblDefaultHost: TLabel
            Left = 24
            Top = 72
            Width = 25
            Height = 15
            Caption = 'Host'
          end
          object lblDefaultPort: TLabel
            Left = 24
            Top = 96
            Width = 22
            Height = 15
            Caption = 'Port'
          end
          object lblDefaultUser: TLabel
            Left = 264
            Top = 72
            Width = 53
            Height = 15
            Caption = 'Username'
          end
          object lblDefaultPass: TLabel
            Left = 264
            Top = 96
            Width = 50
            Height = 15
            Caption = 'Password'
          end
          object lblDefaultAllEntries: TLabel
            Left = 24
            Top = 120
            Width = 52
            Height = 15
            Caption = 'All Entries'
          end
          object edtGlobalHost: TEdit
            Left = 96
            Top = 69
            Width = 153
            Height = 23
            TabOrder = 0
          end
          object edtGlobalPort: TEdit
            Left = 96
            Top = 93
            Width = 153
            Height = 23
            TabOrder = 1
          end
          object edtGlobalUser: TEdit
            Left = 336
            Top = 69
            Width = 153
            Height = 23
            TabOrder = 2
          end
          object edtGlobalPass: TEdit
            Left = 336
            Top = 93
            Width = 153
            Height = 23
            TabOrder = 3
          end
          object edtGlobalAllEntries: TEdit
            Left = 96
            Top = 117
            Width = 153
            Height = 23
            TabOrder = 4
          end
          object memGlobalTemplates: TMemo
            Left = 16
            Top = 185
            Width = 473
            Height = 135
            ScrollBars = ssVertical
            TabOrder = 5
          end
        end
        object pnlScheduleDetails: TPanel
          Left = 0
          Top = 0
          Width = 845
          Height = 600
          Align = alClient
          BevelOuter = bvNone
          Caption = 'pnlScheduleDetails'
          TabOrder = 4
          Visible = False
          ExplicitWidth = 539
          ExplicitHeight = 497
          object lblScheduleTasks: TLabel
            Left = 16
            Top = 16
            Width = 28
            Height = 15
            Caption = 'Tasks'
          end
          object lblScheduleInterval: TLabel
            Left = 16
            Top = 48
            Width = 85
            Height = 15
            Caption = 'Interval Minutes'
          end
          object edtScheduleTasks: TEdit
            Left = 120
            Top = 13
            Width = 121
            Height = 23
            TabOrder = 0
          end
          object edtScheduleInterval: TEdit
            Left = 120
            Top = 45
            Width = 121
            Height = 23
            TabOrder = 1
          end
        end
        object pnlTemplateDetails: TPanel
          Left = 0
          Top = 0
          Width = 845
          Height = 600
          Align = alClient
          BevelOuter = bvNone
          Caption = 'pnlTemplateDetails'
          TabOrder = 2
          Visible = False
          ExplicitWidth = 539
          ExplicitHeight = 497
          object lblAcceptAll: TLabel
            Left = 16
            Top = 16
            Width = 54
            Height = 15
            Caption = 'Accept All'
          end
          object lblMagnets: TLabel
            Left = 16
            Top = 48
            Width = 46
            Height = 15
            Caption = 'Magnets'
          end
          object lblContentSize: TLabel
            Left = 16
            Top = 80
            Width = 90
            Height = 15
            Caption = 'Content Size Min'
          end
          object lblRegexp: TLabel
            Left = 16
            Top = 144
            Width = 78
            Height = 15
            Caption = 'Regexp Accept'
          end
          object lblTemplateSleep: TLabel
            Left = 16
            Top = 112
            Width = 75
            Height = 15
            Caption = 'Sleep Seconds'
          end
          object edtAcceptAll: TEdit
            Left = 120
            Top = 13
            Width = 121
            Height = 23
            TabOrder = 0
          end
          object edtMagnets: TEdit
            Left = 120
            Top = 45
            Width = 121
            Height = 23
            TabOrder = 1
          end
          object edtContentSize: TEdit
            Left = 120
            Top = 77
            Width = 121
            Height = 23
            TabOrder = 2
          end
          object memRegexp: TMemo
            Left = 16
            Top = 165
            Width = 497
            Height = 132
            ScrollBars = ssVertical
            TabOrder = 4
          end
          object edtTemplateSleep: TEdit
            Left = 120
            Top = 109
            Width = 121
            Height = 23
            TabOrder = 3
            Text = '15'
          end
        end
        object pnlTaskDetails: TPanel
          Left = 0
          Top = 0
          Width = 845
          Height = 600
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 3
          Visible = False
          ExplicitWidth = 539
          ExplicitHeight = 497
          object lblTaskRssUrl: TLabel
            Left = 16
            Top = 16
            Width = 43
            Height = 15
            Caption = 'RSS URL'
          end
          object lblTaskQbitPath: TLabel
            Left = 16
            Top = 48
            Width = 81
            Height = 15
            Caption = 'Download Path'
          end
          object edtTaskRssUrl: TEdit
            Left = 120
            Top = 13
            Width = 393
            Height = 23
            TabOrder = 0
          end
          object edtTaskQbitPath: TEdit
            Left = 120
            Top = 45
            Width = 305
            Height = 23
            TabOrder = 1
          end
          object btnBrowsePath: TButton
            Left = 431
            Top = 44
            Width = 82
            Height = 25
            Caption = 'Search...'
            TabOrder = 2
            OnClick = btnBrowsePathClick
          end
        end
        object pnlWelcome: TPanel
          Left = 0
          Top = 0
          Width = 845
          Height = 600
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitWidth = 539
          ExplicitHeight = 497
          object Label3: TLabel
            Left = 146
            Top = 229
            Width = 204
            Height = 15
            Caption = 'Load or create a new file to get started.'
          end
        end
      end
      object pnlBottom: TPanel
        Left = 0
        Top = 604
        Width = 1098
        Height = 39
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        ExplicitTop = 572
        ExplicitWidth = 800
        object btnAddTask: TButton
          Left = 8
          Top = 6
          Width = 78
          Height = 25
          Caption = 'Add Task'
          Enabled = False
          TabOrder = 0
          OnClick = btnAddTaskClick
        end
        object btnRemoveTask: TButton
          Left = 92
          Top = 6
          Width = 90
          Height = 25
          Caption = 'Remove Task'
          Enabled = False
          TabOrder = 1
          OnClick = btnRemoveTaskClick
        end
      end
    end
    object tsDebug: TTabSheet
      Caption = 'Debug'
      ImageIndex = 1
      object Label1: TLabel
        Left = 0
        Top = -22
        Width = 121
        Height = 15
        Caption = 'Arquivo YAML Original'
      end
      object Label2: TLabel
        Left = 383
        Top = -22
        Width = 138
        Height = 15
        Caption = 'Informa'#231#245'es Interpretadas'
      end
      object MemoConfigRaw: TMemo
        Left = 0
        Top = 0
        Width = 383
        Height = 643
        Align = alLeft
        ScrollBars = ssBoth
        TabOrder = 0
        ExplicitHeight = 540
      end
      object MemoParsedInfo: TMemo
        Left = 383
        Top = 0
        Width = 715
        Height = 643
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 1
        ExplicitWidth = 409
        ExplicitHeight = 540
      end
    end
    object tabRun: TTabSheet
      Caption = 'Run Process'
      ImageIndex = 2
      object pnlRunTop: TPanel
        Left = 0
        Top = 0
        Width = 1098
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 792
        object btnRun: TButton
          Left = 4
          Top = 10
          Width = 75
          Height = 25
          Caption = 'Run'
          TabOrder = 0
          OnClick = btnRunClick
        end
      end
      object pnlOutputs: TPanel
        Left = 0
        Top = 41
        Width = 1098
        Height = 602
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitWidth = 792
        ExplicitHeight = 460
        object Splitter2: TSplitter
          Left = 350
          Top = 0
          Width = 8
          Height = 602
          ResizeStyle = rsLine
          ExplicitLeft = 264
          ExplicitHeight = 460
        end
        object Splitter3: TSplitter
          Left = 708
          Top = 0
          Width = 8
          Height = 602
          ResizeStyle = rsLine
          ExplicitLeft = 536
          ExplicitHeight = 460
        end
        object pnlAccepted: TPanel
          Left = 0
          Top = 0
          Width = 350
          Height = 602
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          object lblAccepted: TLabel
            Left = 0
            Top = 0
            Width = 350
            Height = 17
            Align = alTop
            Caption = 'Accepted'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
            ExplicitWidth = 56
          end
          object memoAccepted: TMemo
            Left = 0
            Top = 17
            Width = 350
            Height = 585
            Align = alClient
            ScrollBars = ssVertical
            TabOrder = 0
            ExplicitWidth = 266
          end
        end
        object pnlRejected: TPanel
          Left = 358
          Top = 0
          Width = 350
          Height = 602
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          object lblRejected: TLabel
            Left = 0
            Top = 0
            Width = 350
            Height = 17
            Align = alTop
            Caption = 'Rejected'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
            ExplicitWidth = 52
          end
          object memoRejected: TMemo
            Left = 0
            Top = 17
            Width = 350
            Height = 585
            Align = alClient
            ScrollBars = ssVertical
            TabOrder = 0
            ExplicitWidth = 264
            ExplicitHeight = 482
          end
        end
        object pnlOthers: TPanel
          Left = 716
          Top = 0
          Width = 382
          Height = 602
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          ExplicitWidth = 407
          object lblOthers: TLabel
            Left = 0
            Top = 0
            Width = 382
            Height = 17
            Align = alTop
            Caption = 'Others'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
            ExplicitWidth = 41
          end
          object memoOthers: TMemo
            Left = 0
            Top = 17
            Width = 382
            Height = 585
            Align = alClient
            ScrollBars = ssVertical
            TabOrder = 0
            ExplicitWidth = 248
            ExplicitHeight = 482
          end
        end
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'YAML Files|*.yml;*.yaml|All files|*.*'
    Left = 472
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'yml'
    Filter = 'YAML File|*.yml'
    Left = 560
    Top = 8
  end
end
