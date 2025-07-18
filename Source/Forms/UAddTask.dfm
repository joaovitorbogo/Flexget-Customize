object formAddTask: TformAddTask
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Add New Task'
  ClientHeight = 183
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 61
    Height = 15
    Caption = 'Task Name:'
  end
  object Label2: TLabel
    Left = 16
    Top = 56
    Width = 46
    Height = 15
    Caption = 'URL RSS:'
  end
  object Label4: TLabel
    Left = 16
    Top = 96
    Width = 84
    Height = 15
    Caption = 'Download Path:'
  end
  object edtTaskName: TEdit
    Left = 16
    Top = 32
    Width = 401
    Height = 23
    TabOrder = 0
  end
  object edtRssUrl: TEdit
    Left = 16
    Top = 72
    Width = 401
    Height = 23
    TabOrder = 1
  end
  object edtPath: TEdit
    Left = 16
    Top = 112
    Width = 401
    Height = 23
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 261
    Top = 146
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 342
    Top = 146
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btnCancelClick
  end
end
