let
    Source = Json.Document(File.Contents("books.json")),
    #"Converted to Table" = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"volumeInfo", "saleInfo", "accessInfo"}, {"Column1.volumeInfo", "Column1.saleInfo", "Column1.accessInfo"}),
    #"Expanded Column1.saleInfo" = Table.ExpandRecordColumn(#"Expanded Column1", "Column1.saleInfo", {"isEbook", "retailPrice"}, {"Column1.saleInfo.isEbook", "Column1.saleInfo.retailPrice"}),
    #"Expanded Column1.saleInfo.retailPrice" = Table.ExpandRecordColumn(#"Expanded Column1.saleInfo", "Column1.saleInfo.retailPrice", {"amount", "currencyCode"}, {"Column1.saleInfo.retailPrice.amount", "Column1.saleInfo.retailPrice.currencyCode"}),
    #"Expanded Column1.volumeInfo" = Table.ExpandRecordColumn(#"Expanded Column1.saleInfo.retailPrice", "Column1.volumeInfo", {"title", "authors", "industryIdentifiers", "imageLinks"}, {"Column1.volumeInfo.title", "Column1.volumeInfo.authors", "Column1.volumeInfo.industryIdentifiers", "Column1.volumeInfo.imageLinks"}),
    #"Extracted Values" = Table.TransformColumns(#"Expanded Column1.volumeInfo", {"Column1.volumeInfo.authors", each Text.Combine(List.Transform(_, Text.From), ","), type text}),
    #"Expanded Column1.volumeInfo.industryIdentifiers" = Table.ExpandListColumn(#"Extracted Values", "Column1.volumeInfo.industryIdentifiers"),
    #"Expanded Column1.volumeInfo.industryIdentifiers1" = Table.ExpandRecordColumn(#"Expanded Column1.volumeInfo.industryIdentifiers", "Column1.volumeInfo.industryIdentifiers", {"type", "identifier"}, {"Column1.volumeInfo.industryIdentifiers.type", "Column1.volumeInfo.industryIdentifiers.identifier"}),
    #"Expanded Column1.volumeInfo.imageLinks" = Table.ExpandRecordColumn(#"Expanded Column1.volumeInfo.industryIdentifiers1", "Column1.volumeInfo.imageLinks", {"smallThumbnail"}, {"Column1.volumeInfo.imageLinks.smallThumbnail"}),
    #"Expanded Column1.accessInfo" = Table.ExpandRecordColumn(#"Expanded Column1.volumeInfo.imageLinks", "Column1.accessInfo", {"publicDomain", "pdf"}, {"Column1.accessInfo.publicDomain", "Column1.accessInfo.pdf"}),
    #"Expanded Column1.accessInfo.pdf" = Table.ExpandRecordColumn(#"Expanded Column1.accessInfo", "Column1.accessInfo.pdf", {"isAvailable"}, {"Column1.accessInfo.pdf.isAvailable"})
in
    #"Expanded Column1.accessInfo.pdf"
