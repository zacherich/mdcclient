object data_module: Tdata_module
  OldCreateOrder = False
  Height = 344
  Width = 395
  object cds_mdc: TClientDataSet
    Aggregates = <>
    Params = <>
    OnNewRecord = cds_mdcNewRecord
    Left = 88
    Top = 16
  end
  object dsc_mdc: TDataSource
    DataSet = cds_mdc
    Left = 88
    Top = 80
  end
  object dsc_badmode: TDataSource
    DataSet = cds_badmode
    Left = 160
    Top = 80
  end
  object cds_badmode: TClientDataSet
    PersistDataPacket.Data = {
      620000009619E0BD01000000180000000300000000000300000062000A626164
      6D6F64655F696404000100000000000C6261646D6F64655F6E616D6501004900
      00000100055749445448020002001E000B6261646D6F64655F71747904000100
      000000000000}
    Active = True
    Aggregates = <>
    AggregatesActive = True
    FieldDefs = <
      item
        Name = 'badmode_id'
        DataType = ftInteger
      end
      item
        Name = 'badmode_name'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'badmode_qty'
        DataType = ftInteger
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 160
    Top = 16
  end
end
