object frm_login: Tfrm_login
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #23433#36153#35834#23425#24503'MES'#31995#32479#30331#38470
  ClientHeight = 270
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 465
    Height = 270
    ActivePage = tbs_login
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 0
    object tbs_login: TTabSheet
      Caption = 'tbs_login'
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lbl_username: TLabel
        Left = 107
        Top = 101
        Width = 60
        Height = 13
        Caption = #29992#25143#36134#21495#65306
        OnDblClick = lbl_usernameDblClick
      end
      object lbl_password: TLabel
        Left = 107
        Top = 128
        Width = 60
        Height = 13
        Caption = #29992#25143#23494#30721#65306
      end
      object edt_username: TEdit
        Left = 213
        Top = 98
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object edt_password: TEdit
        Left = 213
        Top = 125
        Width = 121
        Height = 21
        PasswordChar = '*'
        TabOrder = 1
      end
      object btn_login: TBitBtn
        Left = 163
        Top = 190
        Width = 153
        Height = 25
        Caption = #30331#24405
        TabOrder = 2
        OnClick = btn_loginClick
      end
      object ckb_savepwd: TCheckBox
        Left = 147
        Top = 152
        Width = 97
        Height = 27
        Caption = #20445#23384#23494#30721
        TabOrder = 3
        OnClick = ckb_savepwdClick
      end
    end
    object tbs_netset: TTabSheet
      Caption = 'tbs_netset'
      ImageIndex = 1
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lbl_port: TLabel
        Left = 250
        Top = 139
        Width = 36
        Height = 13
        Caption = #31471#21475#65306
      end
      object lbl_host: TLabel
        Left = 71
        Top = 139
        Width = 36
        Height = 13
        Caption = #22320#22336#65306
      end
      object lbl_server: TLabel
        Left = 52
        Top = 96
        Width = 60
        Height = 13
        Caption = #30331#24405#26381#21153#22120
      end
      object lbl_net: TLabel
        Left = 52
        Top = 18
        Width = 60
        Height = 13
        Caption = #20195#29702#26381#21153#22120
      end
      object lbl_proxyhost: TLabel
        Left = 71
        Top = 58
        Width = 36
        Height = 13
        Caption = #22320#22336#65306
      end
      object lbl_proxyport: TLabel
        Left = 250
        Top = 58
        Width = 36
        Height = 13
        Caption = #31471#21475#65306
      end
      object lbl_database: TLabel
        Left = 72
        Top = 176
        Width = 36
        Height = 13
        Caption = #36134#22871#65306
      end
      object edt_host: TEdit
        Left = 108
        Top = 136
        Width = 121
        Height = 21
        TabOrder = 0
        Text = 'localhost'
      end
      object edt_proxyhost: TEdit
        Left = 108
        Top = 55
        Width = 121
        Height = 21
        TabOrder = 1
      end
      object btn_confirm: TBitBtn
        Left = 123
        Top = 208
        Width = 75
        Height = 25
        Caption = #30830#23450
        TabOrder = 2
        OnClick = btn_confirmClick
      end
      object btn_cancel: TBitBtn
        Left = 266
        Top = 208
        Width = 75
        Height = 25
        Caption = #21462#28040
        TabOrder = 3
        OnClick = btn_cancelClick
      end
      object ckb_proxy: TCheckBox
        Left = 132
        Top = 17
        Width = 141
        Height = 17
        Caption = #20351#29992#20195#29702#26381#21153#22120
        TabOrder = 4
        OnClick = ckb_proxyClick
      end
      object spn_port: TSpinEdit
        Left = 292
        Top = 136
        Width = 81
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 5
        Value = 8069
      end
      object spn_proxyport: TSpinEdit
        Left = 292
        Top = 55
        Width = 81
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 6
        Value = 0
      end
      object edt_database: TEdit
        Left = 108
        Top = 173
        Width = 265
        Height = 21
        TabOrder = 7
      end
    end
  end
end
