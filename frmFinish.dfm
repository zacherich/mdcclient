object frm_finish: Tfrm_finish
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = ' '#20135#21697#25253#24037
  ClientHeight = 454
  ClientWidth = 474
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object lbl_tag_doing_qty: TLabel
    Left = 32
    Top = 49
    Width = 64
    Height = 19
    Caption = #24453#25253#24037#65306
  end
  object lbl_tag_good_qty: TLabel
    Left = 32
    Top = 79
    Width = 63
    Height = 19
    Caption = #21512'   '#26684#65306
  end
  object lbl_tag_bad_qty: TLabel
    Left = 175
    Top = 79
    Width = 64
    Height = 19
    Caption = #19981#21512#26684#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl_bad_qty: TLabel
    Left = 245
    Top = 79
    Width = 9
    Height = 19
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl_good_qty: TLabel
    Left = 93
    Top = 79
    Width = 9
    Height = 19
    Caption = '0'
  end
  object lbl_doing_qty: TLabel
    Left = 93
    Top = 49
    Width = 9
    Height = 19
    Caption = '0'
  end
  object lbl_tag_product_code: TLabel
    Left = 32
    Top = 8
    Width = 84
    Height = 25
    Caption = #20135'   '#21697#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl_product_code: TLabel
    Left = 104
    Top = 8
    Width = 22
    Height = 25
    Caption = #26080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuHighlight
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object sbt_submit: TSpeedButton
    Left = 375
    Top = 415
    Width = 81
    Height = 31
    Caption = #30830#23450
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000000000000000
      00000000000000000002000000070000000C0000001000000012000000110000
      000E000000080000000200000000000000000000000000000000000000000000
      000100000004000101120D2A1D79184E36C6216B4BFF216B4BFF216C4BFF1A53
      3AD20F2F21840001011500000005000000010000000000000000000000000000
      0005050F0A351C5B40DC24805CFF29AC7EFF2CC592FF2DC894FF2DC693FF2AAE
      80FF258560FF1A563DD405110C3D00000007000000010000000000000003040E
      0A31206548ED299D74FF2FC896FF2EC996FF56D4ACFF68DAB5FF3BCD9DFF30C9
      96FF32CA99FF2BA479FF227050F805110C3D00000005000000000000000A1A57
      3DD02EA57CFF33CA99FF2EC896FF4CD2A8FF20835CFF00673BFF45BE96FF31CB
      99FF31CB98FF34CC9CFF31AD83FF1B5C41D300010113000000020B23185E2E8A
      66FF3BCD9EFF30CA97FF4BD3A9FF349571FF87AF9DFFB1CFC1FF238A60FF45D3
      A8FF36CF9FFF33CD9BFF3ED0A3FF319470FF0F32237F00000007184D37B63DB3
      8CFF39CD9FFF4BD5A9FF43A382FF699782FFF8F1EEFFF9F3EEFF357F5DFF56C4
      A1FF43D5A8FF3ED3A4FF3CD1A4FF41BC95FF1B5C43CD0000000B1C6446DF4BCA
      A4FF44D2A8FF4FB392FF4E826AFFF0E9E6FFC0C3B5FFEFE3DDFFCEDDD4FF1B75
      4FFF60DCB8FF48D8ACFF47D6AAFF51D4ACFF247A58F80000000E217050F266D9
      B8FF46D3A8FF0B6741FFD2D2CBFF6A8F77FF116B43FF73967EFFF1E8E3FF72A2
      8BFF46A685FF5EDFBAFF4CD9AFFF6BE2C2FF278460FF020604191E684ADC78D9
      BEFF52DAB1FF3DBA92FF096941FF2F9C76FF57DEB8FF2D9973FF73967EFFF0EA
      E7FF4F886CFF5ABB9AFF5BDEB9FF7FE2C7FF27835FF80000000C19523BAB77C8
      B0FF62E0BCFF56DDB7FF59DFBAFF5CE1BDFF5EE2BEFF5FE4C1FF288C67FF698E
      76FFE6E1DCFF176B47FF5FD8B4FF83D5BDFF1E674CC60000000909201747439C
      7BFF95ECD6FF5ADFBAFF5EE2BDFF61E4BFFF64E6C1FF67E6C5FF67E8C7FF39A1
      7EFF1F6D4AFF288B64FF98EFD9FF4DAC8CFF1036286D00000004000000041C5F
      46B578C6ADFF9AEED9FF65E5C0FF64E7C3FF69E7C6FF6BE8C8FF6CE9C9FF6BEA
      C9FF5ED6B6FF97EDD7FF86D3BBFF237759D20102010C0000000100000001030A
      0718247B5BDA70C1A8FFB5F2E3FF98F0DAFF85EDD4FF75EBCEFF88EFD6FF9CF2
      DDFFBAF4E7FF78CDB3FF2A906DEA0615102E0000000200000000000000000000
      0001030A07171E694FB844AB87FF85D2BBFFA8E6D6FFC5F4EBFFABE9D8FF89D8
      C1FF4BB692FF237F60CB05130E27000000030000000000000000000000000000
      000000000001000000030A241B411B60489D258464CF2C9D77EE258867CF1F71
      56B00E3226560000000600000002000000000000000000000000}
    OnClick = sbt_submitClick
  end
  object lbl_tag_container: TLabel
    Left = 32
    Top = 418
    Width = 63
    Height = 25
    Caption = #23481#22120#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl_container: TLabel
    Left = 95
    Top = 418
    Width = 21
    Height = 25
    Caption = #26080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl_tag_submit: TLabel
    Left = 176
    Top = 49
    Width = 63
    Height = 19
    Caption = #25253'   '#24037#65306
  end
  object dbg_badmode: TDBGrid
    Left = 8
    Top = 104
    Width = 448
    Height = 305
    DataSource = data_module.dsc_badmode
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object edt_submit: TEdit
    Left = 245
    Top = 46
    Width = 145
    Height = 27
    NumbersOnly = True
    TabOrder = 1
    OnChange = edt_submitChange
  end
end
